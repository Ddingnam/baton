package com.sp.app.service;

import java.util.List;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import com.sp.app.admin.mapper.AdminNotificationTargetMapper;
import com.sp.app.mapper.NotificationMapper;
import com.sp.app.model.Notification;

@Service
public class NotificationServiceImpl implements NotificationService {

    private final NotificationMapper mapper;
    private final SimpMessagingTemplate messagingTemplate;
    private final AdminNotificationTargetMapper adminTargetMapper;

    public NotificationServiceImpl(NotificationMapper mapper,
                                   SimpMessagingTemplate messagingTemplate,
                                   AdminNotificationTargetMapper adminTargetMapper) {
        this.mapper = mapper;
        this.messagingTemplate = messagingTemplate;
        this.adminTargetMapper = adminTargetMapper;
    }

    @Override
    public void sendNotification(Long userIdx, String notifType, String content, String url) {
        Notification notif = new Notification();
        notif.setUserIdx(userIdx);
        notif.setNotifType(notifType);
        notif.setContent(content);
        notif.setUrl(url);
        mapper.insertNotification(notif);
        messagingTemplate.convertAndSend("/topic/alarms/" + userIdx, notif);
    }

    /** 모든 관리자에게 특정 타입의 알림 발송 (내부 공통 헬퍼) */
    private void sendToAllAdmins(String notifType, String content, String url) {
        for (Long adminIdx : adminTargetMapper.findAdminUserIdxList()) {
            sendNotification(adminIdx, notifType, content, url);
        }
    }

    @Override
    public void sendInquiryNotification(String content, String url) {
        sendToAllAdmins("INQUIRY", content, url);
    }

    @Override
    public void sendChatNotification(Long userIdx, String content, String url) {
        sendNotification(userIdx, "CHAT", content, url);
    }

    @Override
    public void sendSystemNotification(String content, String url) {
        sendToAllAdmins("SYSTEM", content, url);
    }

    @Override
    public void sendRefundNotification(String content, String url) {
        sendToAllAdmins("REFUND", content, url);
    }

    @Override
    public void sendMemberJoinNotification(String content, String url) {
        sendToAllAdmins("MEMBER", content, url);
    }

    @Override
    public List<Notification> listNotification(Long userIdx) {
        return mapper.listNotification(userIdx);
    }

    @Override
    public void updateNotificationRead(Long notifIdx) {
        mapper.updateNotificationRead(notifIdx);
    }

    @Override
    public void updateAllNotificationRead(Long userIdx) {
        mapper.updateAllNotificationRead(userIdx);
    }

    @Override
    public int unreadNotificationCount(Long userIdx) {
        return mapper.unreadNotificationCount(userIdx);
    }

    @Override
    public void deleteAllNotifications(Long userIdx) {
        mapper.deleteAllNotifications(userIdx);
    }

    @Override
    public void deleteNotification(Long notifIdx) {
        mapper.deleteNotification(notifIdx);
    }
}