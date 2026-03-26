package com.sp.app.admin.service;

import com.sp.app.admin.mapper.AdminCalendarMapper;
import com.sp.app.admin.model.AdminCalendarEvent;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminCalendarServiceImpl implements AdminCalendarService {

    private final AdminCalendarMapper calendarMapper;

    @Override
    public List<AdminCalendarEvent> listEvents(Long adminIdx, String from, String to) {
        return calendarMapper.listEvents(adminIdx, from, to);
    }

    @Override
    @Transactional
    public AdminCalendarEvent saveEvent(Long adminIdx, AdminCalendarEvent event) {
        event.setAdminIdx(adminIdx);

        if (event.getAllDay() == null) {
            event.setAllDay(Boolean.FALSE);
        }

        if (Boolean.TRUE.equals(event.getAllDay())) {
            event.setStartTime(null);
            event.setEndTime(null);
        }

        if (event.getId() == null) {
            calendarMapper.insertEvent(event);
            return calendarMapper.findById(event.getId(), adminIdx);
        }

        AdminCalendarEvent saved = calendarMapper.findById(event.getId(), adminIdx);
        if (saved == null) {
            event.setId(null);
            calendarMapper.insertEvent(event);
            return calendarMapper.findById(event.getId(), adminIdx);
        }

        calendarMapper.updateEvent(event);
        return calendarMapper.findById(event.getId(), adminIdx);
    }

    @Override
    @Transactional
    public void deleteEvent(Long adminIdx, Long id) {
        if (id == null) {
            return;
        }
        calendarMapper.deleteEvent(id, adminIdx);
    }
}
