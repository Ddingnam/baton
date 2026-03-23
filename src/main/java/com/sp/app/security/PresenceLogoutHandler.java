package com.sp.app.security;

import com.sp.app.admin.service.AdminChatService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutHandler;

import java.util.Map;

public class PresenceLogoutHandler implements LogoutHandler {

    private final AdminChatService adminChatService;
    private final SimpMessagingTemplate messagingTemplate;

    public PresenceLogoutHandler(AdminChatService adminChatService,
                                 SimpMessagingTemplate messagingTemplate) {
        this.adminChatService  = adminChatService;
        this.messagingTemplate = messagingTemplate;
    }

    @Override
    public void logout(HttpServletRequest request, HttpServletResponse response,
                       Authentication authentication) {
        if (authentication == null) return;
        try {
            Object principal = authentication.getPrincipal();
            if (principal instanceof CustomUserDetails) {
                long userIdx = ((CustomUserDetails) principal).getUserIdx();
                adminChatService.setOnlineStatus(userIdx, 0);
                messagingTemplate.convertAndSend("/topic/presence",
                        Map.of("userIdx", userIdx, "status", 0));
            }
        } catch (Exception ignored) {
        }
    }
}