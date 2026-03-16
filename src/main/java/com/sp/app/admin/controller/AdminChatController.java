package com.sp.app.admin.controller;

import com.sp.app.domain.dto.UserDto;
import com.sp.app.model.ChatMessage;
import com.sp.app.model.ChatRoom;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.ChatService;
import com.sp.app.service.AdminChatService;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminChatController {

    private final ChatService chatService;
    private final AdminChatService adminChatService;

    public AdminChatController(ChatService chatService, AdminChatService adminChatService) {
        this.chatService = chatService;
        this.adminChatService = adminChatService;
    }

    @GetMapping("/chat")
    public String adminChat(
            @RequestParam(value = "roomIdx", required = false) Long roomIdx,
            @AuthenticationPrincipal CustomUserDetails userDetails,
            Model model) {

        if (userDetails == null) return "redirect:/member/login";

        Long myUserIdx = userDetails.getUserIdx();
        String myNickname = userDetails.getNickname(); 

        List<ChatRoom> roomList = adminChatService.listAdminRooms();
        List<UserDto> memberList = adminChatService.listAdminMembers();

        if (roomList.isEmpty()) {
            model.addAttribute("roomList", roomList);
            model.addAttribute("chatList", List.of());
            model.addAttribute("myUserIdx", myUserIdx);
            model.addAttribute("myNickname", myNickname);
            model.addAttribute("currentRoomIdx", -1L);
            model.addAttribute("currentRoomName", "");
            model.addAttribute("memberList", memberList);
            return "admin/chat/chat";
        }

        if (roomIdx == null) {
            roomIdx = roomList.get(0).getRoomIdx();
        }

        final Long finalRoomIdx = roomIdx;
        String currentRoomName = roomList.stream()
                .filter(r -> r.getRoomIdx().equals(finalRoomIdx))
                .map(ChatRoom::getRoomName)
                .findFirst()
                .orElse("관리자 그룹 채팅방");

        chatService.updateLastReadDate(roomIdx, myUserIdx);
        List<ChatMessage> chatList = chatService.listChatMessage(roomIdx);

        model.addAttribute("roomList", roomList);
        model.addAttribute("chatList", chatList);
        model.addAttribute("myUserIdx", myUserIdx);
        model.addAttribute("myNickname", myNickname);
        model.addAttribute("currentRoomIdx", roomIdx);
        model.addAttribute("currentRoomName", currentRoomName);
        model.addAttribute("memberList", memberList);

        return "admin/chat/chat";
    }
}