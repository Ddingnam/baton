package com.sp.app.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sp.app.model.ChatMessage;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.ChatService;

@Controller
public class ChatController {

    private final SimpMessagingTemplate messagingTemplate;
    private final ChatService chatService;

    public ChatController(SimpMessagingTemplate messagingTemplate, ChatService chatService) {
        this.messagingTemplate = messagingTemplate;
        this.chatService = chatService;
    }

    @MessageMapping("/chat/send")
    public void sendMessage(ChatMessage message) {
        chatService.insertMessage(message);
        chatService.updateLastReadDate(message.getRoomIdx(), message.getUserIdx());

        messagingTemplate.convertAndSend("/topic/room/" + message.getRoomIdx(), message);
        
        String senderName = chatService.getCounterpartNickname(message.getRoomIdx(), message.getUserIdx());

        Map<String, String> alarmData = new HashMap<>();
        alarmData.put("type", "CHAT");
        alarmData.put("sender", senderName);
        alarmData.put("content", message.getContent());

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
        messagingTemplate.convertAndSend(
            "/topic/typing/" + message.getRoomIdx(), message
        );
    }
}