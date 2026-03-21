package com.sp.app.admin.controller;

import com.sp.app.admin.service.AdminNotificationService;
import com.sp.app.security.CustomUserDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/admin/notifications")
@RequiredArgsConstructor
public class AdminNotificationController {

    private final AdminNotificationService adminNotificationService;

    @GetMapping
    public String notificationsPage() {
        return "admin/notifications/list";
    }

    @PostMapping("/delete")
    @ResponseBody
    public Map<String, Object> deleteOne(
            @RequestBody Map<String, Object> body,
            @AuthenticationPrincipal CustomUserDetails u) {
        Map<String, Object> result = new HashMap<>();
        try {
            Long notifIdx = Long.valueOf(body.get("notifIdx").toString());
            adminNotificationService.deleteOne(notifIdx);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
        }
        return result;
    }

    @PostMapping("/deleteAll")
    @ResponseBody
    public Map<String, Object> deleteAll(@AuthenticationPrincipal CustomUserDetails u) {
        Map<String, Object> result = new HashMap<>();
        try {
            if (u != null) {
                adminNotificationService.deleteAll(u.getUserIdx());
                result.put("success", true);
            } else {
                result.put("success", false);
            }
        } catch (Exception e) {
            result.put("success", false);
        }
        return result;
    }
}