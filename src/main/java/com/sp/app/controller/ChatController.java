package com.sp.app.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.sp.app.common.StorageService;
import com.sp.app.model.ChatMessage;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.ChatService;

@Controller
public class ChatController {
    
    private final SimpMessagingTemplate messagingTemplate;
    private final ChatService chatService;
    private final StorageService storageService;

    @Value("${file.upload-root}")
    private String uploadRoot; 

    public ChatController(SimpMessagingTemplate messagingTemplate, ChatService chatService, StorageService storageService) {
        this.messagingTemplate = messagingTemplate;
        this.chatService = chatService;
        this.storageService = storageService;
    }

    @MessageMapping("/chat/send")
    public void sendMessage(ChatMessage message) {
        String dbNickname = chatService.getSenderNickname(message.getUserIdx());
        if (dbNickname != null) message.setNickname(dbNickname);
        chatService.insertMessage(message);
        chatService.updateLastReadDate(message.getRoomIdx(), message.getUserIdx());
        messagingTemplate.convertAndSend("/topic/room/" + message.getRoomIdx(), message);
        
        String senderName = chatService.getCounterpartNickname(message.getRoomIdx(), message.getUserIdx());
        Map<String, Object> alarmData = new HashMap<>();
        alarmData.put("type", "CHAT");
        alarmData.put("roomIdx", message.getRoomIdx());
        alarmData.put("sender", senderName);
        
        if (message.getMsgType() != null && message.getMsgType() == 5) {
            alarmData.put("content", "(사진)");
        } else {
            alarmData.put("content", message.getContent());
        }

        List<Long> members = chatService.getRoomMembers(message.getRoomIdx());
        for (Long memberIdx : members) {
            if (!memberIdx.equals(message.getUserIdx())) {
                messagingTemplate.convertAndSend("/topic/alarms/" + memberIdx, alarmData);
            }
        }
    }

    @MessageMapping("/chat/read")
    public void readMessage(ChatMessage message) {
        chatService.updateLastReadDate(message.getRoomIdx(), message.getUserIdx());
        message.setMsgType(4);
        messagingTemplate.convertAndSend("/topic/room/" + message.getRoomIdx(), message);
        messagingTemplate.convertAndSend("/topic/alarms/" + message.getUserIdx(), "read_chat");
    }

    @PostMapping("/chat/delete")
    @ResponseBody
    public Map<String, Object> deleteChatRoom(@RequestParam("roomIdx") Long roomIdx,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        Map<String, Object> model = new HashMap<>();
        try {
            chatService.deleteChatRoom(roomIdx, userDetails.getUserIdx());
            model.put("state", "true");
            messagingTemplate.convertAndSend("/topic/alarms/" + userDetails.getUserIdx(), "room_deleted:" + roomIdx);
        } catch (Exception e) {
            model.put("state", "false");
        }
        return model;
    }

    @MessageMapping("/chat/typing")
    public void typingSignal(ChatMessage message) {
        messagingTemplate.convertAndSend("/topic/typing/" + message.getRoomIdx(), message);
    }
    
    @PostMapping("/chat/imageUpload")
    @ResponseBody
    public Map<String, Object> imageUpload(@RequestParam("file") MultipartFile file) {
        Map<String, Object> model = new HashMap<>();
        try {
            String pathname = uploadRoot + File.separator + "chat";
            String saveFilename = storageService.uploadFileToServer(file, pathname);
            
            model.put("state", "true");
            model.put("saveFilename", saveFilename);
        } catch (Exception e) {
            model.put("state", "false");
        }
        return model;
    }
}