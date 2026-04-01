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

    // ==========================================
    // 1. 채팅방 관리 (Room Management)
    // ==========================================

    /**
     * 채팅방 생성
     * POST /api/chat/rooms
     */
    @PostMapping("/rooms")
    public ResponseEntity<Long> createRoom(@RequestBody CrewChatRequest.Create req) {
        Long roomId = chatService.createRoom(req.getCrewIdx(), req.getRoomName(), req.getRoomType());
        return ResponseEntity.ok(roomId);
    }

    /**
     * 내 채팅방 목록 조회
     * GET /api/chat/rooms?userId=1
     * (실무 팁: userId는 보안상 @RequestParam보다 세션/토큰에서 꺼내는 것이 좋습니다)
     */
    @GetMapping("/rooms")
    public ResponseEntity<List<CrewChatRoomResponse>> getMyChatRooms(@AuthenticationPrincipal CustomUserDetails userDetails) {
    	Long userIdx = userDetails.getMember().getUserIdx();
        List<CrewChatRoomResponse> rooms = chatService.getMyChatRooms(userIdx);
        return ResponseEntity.ok(rooms);
    }

    /**
     * 채팅방 단건 상세 조회 (상단바 정보 등)
     * GET /api/chat/rooms/{roomId}
     */
    @GetMapping("/rooms/{roomId}")
    public ResponseEntity<CrewChatRoomDto> getChatRoomDetail(@PathVariable("roomId") Long roomId) {
        CrewChatRoomDto roomDetail = chatService.getChatRoomDetail(roomId);
        return ResponseEntity.ok(roomDetail);
    }

    /**
     * 채팅방 나가기
     * DELETE /api/chat/rooms/{roomId}/leave?userId=1
     */
    @DeleteMapping("/rooms/{roomId}/leave")
    public ResponseEntity<Void> leaveChatRoom(
            @PathVariable("roomId") Long roomId,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
    	Long userIdx = userDetails.getMember().getUserIdx();
        chatService.leaveChatRoom(roomId, userIdx);
        return ResponseEntity.ok().build();
    }

    /**
     * 채팅방 참여자 목록 조회
     * GET /api/chat/rooms/{roomId}/participants
     */
    @GetMapping("/rooms/{roomId}/participants")
    public ResponseEntity<List<CrewChatParticipantDto>> getChatParticipants(@PathVariable("roomId") Long roomId) {
        List<CrewChatParticipantDto> participants = chatService.getChatParticipants(roomId);
        return ResponseEntity.ok(participants);
    }


    // ==========================================
    // 2. 메시지 및 페이징 조회 (Message & Paging)
    // ==========================================

    /**
     * 메시지 전송 (REST API 방식)
     * POST /api/chat/rooms/{roomId}/messages
     * (참고: 실시간 채팅에서는 보통 WebSocket/STOMP 컨트롤러(@MessageMapping)를 사용합니다)
     */
    @PostMapping("/rooms/{roomId}/messages")
    public ResponseEntity<Long> sendMessage(
            @PathVariable("roomId") Long roomId,
            @RequestBody CrewChatRequest.Message req) {
        Long msgId = chatService.sendMessage(roomId, req.getUserIdx(), req.getContent(), req.getMsgType());
        return ResponseEntity.ok(msgId);
    }

    /**
     * [초기 로딩] 채팅방 입장 시 메시지 내역 조회
     * GET /api/chat/rooms/{roomId}/messages?userId=1
     */
    @GetMapping("/rooms/{roomId}/messages")
    public ResponseEntity<List<CrewChatMessageDto>> getChatHistory(
            @PathVariable("roomId") Long roomId,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
    	Long userIdx = userDetails.getMember().getUserIdx();
        List<CrewChatMessageDto> messages = chatService.getChatHistory(roomId, userIdx);
        return ResponseEntity.ok(messages);
    }

    /**
     * [과거 로딩] 위로 스크롤 시 이전 메시지 조회
     * GET /api/chat/rooms/{roomId}/messages/before?userId=1&firstChatIdx=100
     */
    @GetMapping("/rooms/{roomId}/messages/before")
    public ResponseEntity<List<CrewChatMessageDto>> getChatHistoryBefore(
            @PathVariable("roomId") Long roomId,
            @RequestParam("firstChatIdx") Long firstChatIdx,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
    	Long userIdx = userDetails.getMember().getUserIdx();
        List<CrewChatMessageDto> messages = chatService.getChatHistoryBefore(roomId, userIdx, firstChatIdx);
        return ResponseEntity.ok(messages);
    }

    /**
     * [최신 갱신] 새 메시지 조회 (아래로 스크롤 또는 폴링)
     * GET /api/chat/rooms/{roomId}/messages/after?lastChatIdx=150
     */
    @GetMapping("/rooms/{roomId}/messages/after")
    public ResponseEntity<List<CrewChatMessageDto>> getChatHistoryAfter(
            @PathVariable("roomId") Long roomId,
            @RequestParam("lastChatIdx") Long lastChatIdx) {
        List<CrewChatMessageDto> messages = chatService.getChatHistoryAfter(roomId, lastChatIdx);
        return ResponseEntity.ok(messages);
    }


    // ==========================================
    // 3. 읽음 처리 (Read Index)
    // ==========================================

    /**
     * 안 읽은 메시지 총 개수 조회
     * GET /api/chat/rooms/{roomId}/unread?userId=1
     */
    @GetMapping("/rooms/{roomId}/unread")
    public ResponseEntity<Map<String, Long>> getUnreadMessageCount(
            @PathVariable("roomId") Long roomId,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
    	Long userIdx = userDetails.getMember().getUserIdx();
        Long unreadCount = chatService.getUnreadMessageCount(roomId, userIdx);
        return ResponseEntity.ok(Map.of("unreadCount", unreadCount));
    }

    /**
     * 실시간 읽음 위치(인덱스) 수동 갱신
     * PUT /api/chat/rooms/{roomId}/read
     */
    @PutMapping("/rooms/{roomId}/read")
    public ResponseEntity<Void> updateReadIndex(
            @PathVariable("roomId") Long roomId,
            @RequestBody CrewChatRequest.UpdateRead req) {
        chatService.updateReadIndex(roomId, req.getUserIdx(), req.getLastChatIdx());
        return ResponseEntity.ok().build();
    }
}