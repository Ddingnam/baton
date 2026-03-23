package com.sp.app.config;

import com.sp.app.admin.service.AdminChatService;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionConnectedEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;
import java.util.concurrent.ConcurrentHashMap;
import java.util.Map;

@Component
public class WebSocketEventListener {
	private static final Map<String, Long> sessionUserMap  = new ConcurrentHashMap<>();
	private static final Map<Long, Integer> userSessionCount = new ConcurrentHashMap<>();

	private final AdminChatService adminChatService;
	private final SimpMessagingTemplate messagingTemplate;

	public WebSocketEventListener(AdminChatService adminChatService,
								  SimpMessagingTemplate messagingTemplate) {
		this.adminChatService  = adminChatService;
		this.messagingTemplate = messagingTemplate;
	}

	@EventListener
	public void handleConnect(SessionConnectedEvent event) {
		StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
		String sessionId = accessor.getSessionId();
		java.security.Principal principal = accessor.getUser();
		if (principal == null || sessionId == null)
			return;
		try {
			Object details = ((org.springframework.security.authentication.UsernamePasswordAuthenticationToken) principal)
					.getPrincipal();
			if (details instanceof com.sp.app.security.CustomUserDetails) {
				long userIdx = ((com.sp.app.security.CustomUserDetails) details).getUserIdx();
				sessionUserMap.put(sessionId, userIdx);
				int count = userSessionCount.merge(userIdx, 1, Integer::sum);
				// 첫 번째 WebSocket 연결 시 온라인으로 설정
				if (count == 1) {
					try {
						adminChatService.setOnlineStatus(userIdx, 1);
						messagingTemplate.convertAndSend("/topic/presence",
								Map.of("userIdx", userIdx, "status", 1));
					} catch (Exception ignored) {
					}
				}
			}
		} catch (Exception ignored) {
		}
	}

	@EventListener
	public void handleDisconnect(SessionDisconnectEvent event) {
		StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
		String sessionId = accessor.getSessionId();
		if (sessionId == null)
			return;
		Long userIdx = sessionUserMap.remove(sessionId);
		if (userIdx == null)
			return;
		int count = userSessionCount.merge(userIdx, -1, Integer::sum);
		if (count <= 0) {
			userSessionCount.remove(userIdx);
			// 모든 WebSocket 세션이 끊기면 DB에 오프라인으로 업데이트하고 브로드캐스트
			try {
				adminChatService.setOnlineStatus(userIdx, 0);
				messagingTemplate.convertAndSend("/topic/presence",
						Map.of("userIdx", userIdx, "status", 0));
			} catch (Exception ignored) {
			}
		}
	}

	public static boolean isOnline(long userIdx) {
		return userSessionCount.getOrDefault(userIdx, 0) > 0;
	}
}