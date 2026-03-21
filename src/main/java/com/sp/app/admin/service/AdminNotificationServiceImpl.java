package com.sp.app.admin.service;

import com.sp.app.admin.mapper.AdminNotificationTargetMapper;
import com.sp.app.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AdminNotificationServiceImpl implements AdminNotificationService {

    private final NotificationService notificationService;
    private final AdminNotificationTargetMapper adminTargetMapper;

    @Override
    public void sendToAdmin(Long adminIdx, String type, String content, String url) {
        notificationService.sendNotification(adminIdx, type, content, url);
    }

    @Override
    public void sendToAllAdmins(String type, String content, String url) {
        for (Long adminIdx : adminTargetMapper.findAdminUserIdxList()) {
            notificationService.sendNotification(adminIdx, type, content, url);
        }
    }

    @Override
    public void deleteOne(Long notifIdx) {
        notificationService.deleteNotification(notifIdx);
    }

    @Override
    public void deleteAll(Long adminIdx) {
        notificationService.deleteAllNotifications(adminIdx);
    }
}