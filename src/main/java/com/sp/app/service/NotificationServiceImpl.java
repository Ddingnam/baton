package com.sp.app.service;

import java.util.List;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import com.sp.app.mapper.NotificationMapper;
import com.sp.app.model.Notification;

@Service
public class NotificationServiceImpl implements NotificationService {

    private final NotificationMapper mapper;
    private final SimpMessagingTemplate messagingTemplate;

    public NotificationServiceImpl(NotificationMapper mapper, SimpMessagingTemplate messagingTemplate) {
        this.mapper = mapper;
        this.messagingTemplate = messagingTemplate;
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
}