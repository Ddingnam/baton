package com.sp.app.controller;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.sp.app.domain.dto.CrewChatMessageDto;
import com.sp.app.domain.dto.CrewChatParticipantDto;
import com.sp.app.domain.dto.CrewChatRequest;
import com.sp.app.domain.dto.CrewChatRoomDto;
import com.sp.app.domain.dto.CrewChatRoomResponse;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.CrewChatService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/chat")
@RequiredArgsConstructor
public class CrewChatController {

    private final CrewChatService chatService;

    @PostMapping("/rooms")
    public ResponseEntity<Long> createRoom(@RequestBody CrewChatRequest.Create req) {
        Long roomId = chatService.createRoom(req.getCrewIdx(), req.getRoomName(), req.getRoomType());
        return ResponseEntity.ok(roomId);
    }

    @GetMapping("/rooms")
    public ResponseEntity<List<CrewChatRoomResponse>> getMyChatRooms(@AuthenticationPrincipal CustomUserDetails userDetails) {
    	Long userIdx = userDetails.getMember().getUserIdx();
        List<CrewChatRoomResponse> rooms = chatService.getMyChatRooms(userIdx);
        return ResponseEntity.ok(rooms);
    }

    @GetMapping("/rooms/{roomId}")
    public ResponseEntity<CrewChatRoomDto> getChatRoomDetail(@PathVariable("roomId") Long roomId) {
        CrewChatRoomDto roomDetail = chatService.getChatRoomDetail(roomId);
        return ResponseEntity.ok(roomDetail);
    }

    @DeleteMapping("/rooms/{roomId}/leave")
    public ResponseEntity<Void> leaveChatRoom(
            @PathVariable("roomId") Long roomId,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
    	Long userIdx = userDetails.getMember().getUserIdx();
        chatService.leaveChatRoom(roomId, userIdx);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/rooms/{roomId}/participants")
    public ResponseEntity<List<CrewChatParticipantDto>> getChatParticipants(@PathVariable("roomId") Long roomId) {
        List<CrewChatParticipantDto> participants = chatService.getChatParticipants(roomId);
        return ResponseEntity.ok(participants);
    }

    @PostMapping("/rooms/{roomId}/messages")
    public ResponseEntity<Long> sendMessage(
            @PathVariable("roomId") Long roomId,
            @RequestBody CrewChatRequest.Message req) {
        Long msgId = chatService.sendMessage(roomId, req.getUserIdx(), req.getContent(), req.getMsgType());
        return ResponseEntity.ok(msgId);
    }

    @GetMapping("/rooms/{roomId}/messages")
    public ResponseEntity<List<CrewChatMessageDto>> getChatHistory(
            @PathVariable("roomId") Long roomId,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
    	Long userIdx = userDetails.getMember().getUserIdx();
        List<CrewChatMessageDto> messages = chatService.getChatHistory(roomId, userIdx);
        return ResponseEntity.ok(messages);
    }

    @GetMapping("/rooms/{roomId}/messages/before")
    public ResponseEntity<List<CrewChatMessageDto>> getChatHistoryBefore(
            @PathVariable("roomId") Long roomId,
            @RequestParam("firstChatIdx") Long firstChatIdx,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
    	Long userIdx = userDetails.getMember().getUserIdx();
        List<CrewChatMessageDto> messages = chatService.getChatHistoryBefore(roomId, userIdx, firstChatIdx);
        return ResponseEntity.ok(messages);
    }

    @GetMapping("/rooms/{roomId}/messages/after")
    public ResponseEntity<List<CrewChatMessageDto>> getChatHistoryAfter(
            @PathVariable("roomId") Long roomId,
            @RequestParam("lastChatIdx") Long lastChatIdx) {
        List<CrewChatMessageDto> messages = chatService.getChatHistoryAfter(roomId, lastChatIdx);
        return ResponseEntity.ok(messages);
    }

    @GetMapping("/rooms/{roomId}/unread")
    public ResponseEntity<Map<String, Long>> getUnreadMessageCount(
            @PathVariable("roomId") Long roomId,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
    	Long userIdx = userDetails.getMember().getUserIdx();
        Long unreadCount = chatService.getUnreadMessageCount(roomId, userIdx);
        return ResponseEntity.ok(Map.of("unreadCount", unreadCount));
    }

    @PutMapping("/rooms/{roomId}/read")
    public ResponseEntity<Void> updateReadIndex(
            @PathVariable("roomId") Long roomId,
            @RequestBody CrewChatRequest.UpdateRead req) {
        chatService.updateReadIndex(roomId, req.getUserIdx(), req.getLastChatIdx());
        return ResponseEntity.ok().build();
    }
}