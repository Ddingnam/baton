package com.sp.app.controller;

import java.util.List;
import java.util.Map;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sp.app.model.ChatMessage;
import com.sp.app.model.ChatRoom;
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
        model.addAttribute("counterpartIdx", toUserIdx);
        model.addAttribute("chatList", list);
        model.addAttribute("counterpartName", counterpartNickname);
        
        Map<String, Object> tradeInfo = chatService.getTradeInfo(tradeIdx);
        
        model.addAttribute("tradeInfo", tradeInfo);
        
        return "chat/room";
    }
    
    @GetMapping("/tradeList")
    public String tradeChatList(@RequestParam("tradeIdx") Long tradeIdx,
                                @AuthenticationPrincipal CustomUserDetails userDetails,
                                Model model) {
        if (userDetails == null) return "redirect:/member/login";
        
        Long myUserIdx = userDetails.getUserIdx();
        List<ChatRoom> list = chatService.listTradeChatRoom(tradeIdx, myUserIdx);
        
        model.addAttribute("list", list);
        model.addAttribute("tradeIdx", tradeIdx);
        model.addAttribute("myUserIdx", myUserIdx);
        
        return "chat/tradeList"; 
    }
    
    @GetMapping("/list")
    public String chatList(@AuthenticationPrincipal CustomUserDetails userDetails, Model model) {
        if (userDetails == null) {
            return "redirect:/member/login";
        }

        Long myUserIdx = userDetails.getUserIdx();

        List<ChatRoom> list = chatService.listAllChatRoom(myUserIdx);

        model.addAttribute("list", list);
        model.addAttribute("myUserIdx", myUserIdx);

        return "chat/list";
    }
    
    @GetMapping("/api/unread")
    @ResponseBody
    public int getUnreadCount(@AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null) {
            return 0;
        }

        return chatService.getUnreadTotalCount(userDetails.getUserIdx());
    }
    
    @GetMapping("/albaRoom")
    public String enterRoomByAlba(@RequestParam("albaIdx") Long albaIdx,
                                  @RequestParam("toUserIdx") Long toUserIdx,
                                  @AuthenticationPrincipal CustomUserDetails userDetails,
                                  Model model) {
        if (userDetails == null) return "redirect:/member/login";
        
        Long myUserIdx = userDetails.getUserIdx();

        if (myUserIdx.equals(toUserIdx)) {
        	return "redirect:/alba/article/" + albaIdx;
        }

        // 알바 전용 방 생성 메서드 호출
        Long roomIdx = chatService.createOrGetAlbaRoom(albaIdx, toUserIdx, myUserIdx);

        String counterpartNickname = chatService.getCounterpartNickname(roomIdx, myUserIdx);
        chatService.updateLastReadDate(roomIdx, myUserIdx);
        List<ChatMessage> list = chatService.listChatMessage(roomIdx);

        model.addAttribute("roomIdx", roomIdx);
        model.addAttribute("userIdx", myUserIdx);
        model.addAttribute("counterpartIdx", toUserIdx);
        model.addAttribute("chatList", list);
        model.addAttribute("counterpartName", counterpartNickname);
        
        Map<String, Object> albaInfo = chatService.getAlbaInfo(albaIdx);
        model.addAttribute("albaInfo", albaInfo);
        
        return "chat/room";
    }
    
    @GetMapping("/albaList")
    public String albaChatList(@RequestParam("albaIdx") Long albaIdx,
                               @AuthenticationPrincipal CustomUserDetails userDetails,
                               Model model) {
        if (userDetails == null) return "redirect:/member/login";
        
        Long myUserIdx = userDetails.getUserIdx();
        List<ChatRoom> list = chatService.listAlbaChatRoom(albaIdx, myUserIdx);
        
        model.addAttribute("list", list);
        model.addAttribute("albaIdx", albaIdx);
        model.addAttribute("myUserIdx", myUserIdx);
        model.addAttribute("isAlba", true);
        
        return "chat/albaList"; 
    }
}