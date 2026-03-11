package com.sp.app.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Notification {
    private Long notifIdx;
    private Long userIdx;
    private String notifType;
    private String content;
    private String url;
    private int isRead;
    private String createdAt;
}