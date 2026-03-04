package com.sp.app.controller;

import com.sp.app.model.ChatMessage;
import com.sp.app.service.ChatService;

import java.util.List;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

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

        List<Long> members = chatService.getRoomMembers(message.getRoomIdx());
        for (Long memberIdx : members) {
            if (!memberIdx.equals(message.getUserIdx())) {
                messagingTemplate.convertAndSend("/topic/alarms/" + memberIdx, "new_chat");
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
    
   
}