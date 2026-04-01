package com.sp.app.controller;

import java.security.Principal;

import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;

import com.sp.app.domain.dto.CrewChatMessageDto;
import com.sp.app.domain.dto.CrewChatRequest;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.CrewChatService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class CrewChatStompController {

    private final SimpMessagingTemplate messagingTemplate;
    private final CrewChatService chatService;

    /**
     * 채팅 메시지 전송 및 실시간 전파
     * 클라이언트 전송 경로: /app/chat/rooms/{roomId}/send
     */
    @MessageMapping("/chat/rooms/{roomId}/send")
    public void sendMessage(
            @DestinationVariable("roomId") Long roomId,
            CrewChatRequest.Message req,
            Principal principal) {
    	
    	UsernamePasswordAuthenticationToken token = (UsernamePasswordAuthenticationToken) principal;
        CustomUserDetails userDetails = (CustomUserDetails) token.getPrincipal();
        
    	Long userIdx = userDetails.getMember().getUserIdx();
    	CrewChatMessageDto response = chatService.saveAndGetMessageDto(roomId, userIdx, req.getContent(), req.getMsgType());
        messagingTemplate.convertAndSend("/topic/chat/rooms/" + roomId, response);
    }

    /**
     * 실시간 읽음 알림 (선택 사항)
     * 누군가 읽었을 때 "1"을 실시간으로 지우기 위한 신호탄
     */
    @MessageMapping("/chat/rooms/{roomId}/read")
    public void updateReadStatus(
            @DestinationVariable("roomId") Long roomId,
            CrewChatRequest.UpdateRead req,
            Principal principal) {
    	
    	UsernamePasswordAuthenticationToken token = (UsernamePasswordAuthenticationToken) principal;
        CustomUserDetails userDetails = (CustomUserDetails) token.getPrincipal();
        
        Long userIdx = userDetails.getMember().getUserIdx();
        chatService.updateReadIndex(roomId, userIdx, req.getLastChatIdx());
        messagingTemplate.convertAndSend("/topic/chat/rooms/" + roomId + "/read", req);
    }
}