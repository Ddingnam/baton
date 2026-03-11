package com.sp.app.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.sp.app.model.Notification;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.NotificationService;

@RestController
@RequestMapping("/api/notification")
public class NotificationController {

    private final NotificationService service;

    public NotificationController(NotificationService service) {
        this.service = service;
    }

    @GetMapping("/list")
    public List<Notification> getList(@AuthenticationPrincipal CustomUserDetails userDetails) {
        if(userDetails == null) return null;
        return service.listNotification(userDetails.getUserIdx());
    }

    @GetMapping("/unreadCount")
    public int getUnreadCount(@AuthenticationPrincipal CustomUserDetails userDetails) {
        if(userDetails == null) return 0;
        return service.unreadNotificationCount(userDetails.getUserIdx());
    }

    @PostMapping("/read")
    public Map<String, Object> readNotif(@RequestParam("notifIdx") Long notifIdx) {
        Map<String, Object> map = new HashMap<>();
        try {
            service.updateNotificationRead(notifIdx);
            map.put("state", "true");
        } catch(Exception e) {
            map.put("state", "false");
        }
        return map;
    }

    @PostMapping("/readAll")
    public Map<String, Object> readAllNotif(@AuthenticationPrincipal CustomUserDetails userDetails) {
        Map<String, Object> map = new HashMap<>();
        try {
            if(userDetails != null) {
                service.updateAllNotificationRead(userDetails.getUserIdx());
                map.put("state", "true");
            }
        } catch(Exception e) {
            map.put("state", "false");
        }
        return map;
    }
}