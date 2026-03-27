package com.sp.app.admin.controller;

import com.sp.app.admin.model.AdminCalendarEvent;
import com.sp.app.admin.service.AdminCalendarService;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/admin/calendar")
@RequiredArgsConstructor
public class AdminCalendarController {

    private final AdminCalendarService calendarService;
    private final NotificationService notificationService;

    private Long getAdminIdx(CustomUserDetails u) {
        return u == null ? null : u.getUserIdx();
    }

    @GetMapping("/events")
    public List<AdminCalendarEvent> listEvents(@RequestParam("from") String from, @RequestParam("to") String to,
            @AuthenticationPrincipal CustomUserDetails u) {
        Long adminIdx = getAdminIdx(u);
        if (adminIdx == null) return List.of();
        return calendarService.listEvents(adminIdx, from, to);
    }

    @PostMapping("/save")
    public Map<String, Object> save(@RequestBody Map<String, Object> body,
            @AuthenticationPrincipal CustomUserDetails u) {
        Map<String, Object> result = new HashMap<>();
        try {
            Long adminIdx = getAdminIdx(u);
            if (adminIdx == null) { result.put("success", false); return result; }

            AdminCalendarEvent event = new AdminCalendarEvent();
            event.setId(parseLong(body.get("id")));
            event.setTitle(stringValue(body.get("title")));
            event.setDate(stringValue(body.get("date")));
            event.setStartTime(stringValue(body.get("startTime")));
            event.setEndTime(stringValue(body.get("endTime")));
            event.setAllDay(parseIntAllDay(body.get("allDay")));
            event.setColor(stringValue(body.get("color")));
            event.setMemo(stringValue(body.get("memo")));
            event.setType(stringValue(body.get("type")));

            AdminCalendarEvent saved = calendarService.saveEvent(adminIdx, event);

            try {
                notificationService.sendNotification(adminIdx, "CALENDAR",
                        (saved.getDate() == null ? "일정" : saved.getDate() + " 일정") + "이 저장되었습니다.",
                        "/admin/calendar");
            } catch (Exception ignore) {}

            result.put("success", true);
            result.put("id", saved.getId());
            result.put("event", saved);
            return result;
        } catch (Exception e) {
            result.put("success", false);
            result.put("msg", e.getMessage());
            return result;
        }
    }

    @PostMapping("/delete")
    public Map<String, Object> delete(@RequestBody Map<String, Object> body,
            @AuthenticationPrincipal CustomUserDetails u) {
        Map<String, Object> result = new HashMap<>();
        try {
            Long adminIdx = getAdminIdx(u);
            if (adminIdx == null) { result.put("success", false); return result; }
            calendarService.deleteEvent(adminIdx, parseLong(body.get("id")));
            result.put("success", true);
            return result;
        } catch (Exception e) {
            result.put("success", false);
            result.put("msg", e.getMessage());
            return result;
        }
    }

    private Long parseLong(Object value) {
        if (value == null) return null;
        try {
            String str = String.valueOf(value).trim();
            return str.isEmpty() ? null : Long.valueOf(str);
        } catch (Exception e) { return null; }
    }

    private Integer parseIntAllDay(Object value) {
        if (value == null) return 0;
        if (value instanceof Boolean b) return b ? 1 : 0;
        if (value instanceof Number n) return n.intValue() == 1 ? 1 : 0;
        String str = String.valueOf(value).trim();
        return ("true".equalsIgnoreCase(str) || "1".equals(str) || "Y".equalsIgnoreCase(str)) ? 1 : 0;
    }

    private String stringValue(Object value) {
        if (value == null) return null;
        String str = String.valueOf(value).trim();
        return str.isEmpty() ? null : str;
    }
}