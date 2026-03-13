package com.sp.app.service;

import java.util.List;
import com.sp.app.model.Notification;

public interface NotificationService {
    void sendNotification(Long userIdx, String notifType, String content, String url);
    List<Notification> listNotification(Long userIdx);
    void updateNotificationRead(Long notifIdx);
    void updateAllNotificationRead(Long userIdx);
    int unreadNotificationCount(Long userIdx);
    void deleteAllNotifications(Long userIdx);
}