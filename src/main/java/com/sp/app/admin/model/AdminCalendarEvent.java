package com.sp.app.admin.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AdminCalendarEvent {
    private Long id;
    private Long adminIdx;
    private String title;
    private String date;
    private String startTime;
    private String endTime;
    private Boolean allDay;
    private String color;
    private String memo;
    private String type;
    private String createdAt;
    private String updatedAt;
}
