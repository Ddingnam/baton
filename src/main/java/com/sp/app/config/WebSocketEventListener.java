package com.sp.app.config;

import com.sp.app.admin.service.AdminChatService;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionConnectedEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class WebSocketEventListener {

    private final SimpMessagingTemplate messagingTemplate;
    private final AdminChatService adminChatService;

    private static final Map<String, Long> sessionUserMap  = new ConcurrentHashMap<>();
    private static final Map<Long, Integer> userSessionCount = new ConcurrentHashMap<>();

    public WebSocketEventListener(SimpMessagingTemplate messagingTemplate,
                                  AdminChatService adminChatService) {
        this.messagingTemplate = messagingTemplate;
        this.adminChatService  = adminChatService;
    }

    @EventListener
    public void handleConnect(SessionConnectedEvent event) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
        String sessionId = accessor.getSessionId();

        java.security.Principal principal = accessor.getUser();
        if (principal == null || sessionId == null) return;

        try {
            Object details = ((org.springframework.security.authentication.UsernamePasswordAuthenticationToken) principal).getPrincipal();
            if (details instanceof com.sp.app.security.CustomUserDetails) {
                long userIdx = ((com.sp.app.security.CustomUserDetails) details).getUserIdx();
                sessionUserMap.put(sessionId, userIdx);
                int count = userSessionCount.merge(userIdx, 1, Integer::sum);
                if (count == 1) {
                    adminChatService.setOnlineStatus(userIdx, 1);
                    broadcastPresence(userIdx, true);
                }
            }
        } catch (Exception ignored) {}
    }

    @EventListener
    public void handleDisconnect(SessionDisconnectEvent event) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
        String sessionId = accessor.getSessionId();
        if (sessionId == null) return;

        Long userIdx = sessionUserMap.remove(sessionId);
        if (userIdx == null) return;

        int count = userSessionCount.merge(userIdx, -1, Integer::sum);
        if (count <= 0) {
            userSessionCount.remove(userIdx);
            // ★ 모든 탭 닫힘 → DB 오프라인으로 업데이트 후 브로드캐스트
            adminChatService.setOnlineStatus(userIdx, 0);
            broadcastPresence(userIdx, false);
        }
    }

    private void broadcastPresence(long userIdx, boolean online) {
        Map<String, Object> payload = new HashMap<>();
        payload.put("userIdx", userIdx);
        payload.put("online",  online);
        messagingTemplate.convertAndSend("/topic/presence", payload);
    }

    public static boolean isOnline(long userIdx) {
        return userSessionCount.getOrDefault(userIdx, 0) > 0;
    }
}