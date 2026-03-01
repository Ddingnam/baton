package com.sp.app.controller;

import java.util.List;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sp.app.model.ChatMessage;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.ChatService;

@Controller
@RequestMapping("/chat")
public class ChatRoomController {

    private final ChatService chatService;

    public ChatRoomController(ChatService chatService) { 
        this.chatService = chatService; 
    }

    @GetMapping("/room")
    public String enterRoomByTrade(@RequestParam("tradeIdx") Long tradeIdx,
                                   @RequestParam("toUserIdx") Long toUserIdx,
                                   @AuthenticationPrincipal CustomUserDetails userDetails,
                                   Model model) {

        if (userDetails == null) {
            return "redirect:/member/login";
        }
        
        Long myUserIdx = userDetails.getUserIdx();

        if (myUserIdx.equals(toUserIdx)) {
            return "redirect:/trade/article?productIdx=" + tradeIdx; 
        }

        Long roomIdx = chatService.createOrGetRoom(tradeIdx, myUserIdx, toUserIdx);

        String counterpartNickname = chatService.getCounterpartNickname(roomIdx, myUserIdx);

        chatService.updateLastReadDate(roomIdx, myUserIdx);

        List<ChatMessage> list = chatService.listChatMessage(roomIdx);

        model.addAttribute("roomIdx", roomIdx);
        model.addAttribute("userIdx", myUserIdx);
        model.addAttribute("chatList", list);
        model.addAttribute("counterpartName", counterpartNickname);

        return "chat/room";
    }
}