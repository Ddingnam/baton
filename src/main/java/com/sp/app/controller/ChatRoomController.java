package com.sp.app.controller;

import com.sp.app.model.ChatMessage;
import com.sp.app.security.CustomUserDetails; 
import com.sp.app.service.ChatService;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/chat")
public class ChatRoomController {

    private final ChatService chatService;

    public ChatRoomController(ChatService chatService) {
        this.chatService = chatService;
    }

    @GetMapping("/room/{roomIdx}")
    public String enterRoom(@PathVariable("roomIdx") Long roomIdx, 
                            @AuthenticationPrincipal CustomUserDetails userDetails, 
                            Model model) {
       
        if (userDetails == null) {
            return "redirect:/member/login";
        }

        Long userIdx = userDetails.getUserIdx();

        chatService.updateLastReadDate(roomIdx, userIdx);

        List<ChatMessage> list = chatService.listChatMessage(roomIdx);

        model.addAttribute("roomIdx", roomIdx);
        model.addAttribute("userIdx", userIdx);
        model.addAttribute("chatList", list);

        return "chat/room";
    }
}