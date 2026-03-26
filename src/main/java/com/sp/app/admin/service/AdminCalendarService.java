package com.sp.app.admin.service;

import com.sp.app.admin.model.AdminCalendarEvent;

import java.util.List;

public interface AdminCalendarService {
    List<AdminCalendarEvent> listEvents(Long adminIdx, String from, String to);
    AdminCalendarEvent saveEvent(Long adminIdx, AdminCalendarEvent event);
    void deleteEvent(Long adminIdx, Long id);
}
