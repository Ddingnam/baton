package com.sp.app.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.sp.app.model.Notification;

@Mapper
public interface NotificationMapper {
    void insertNotification(Notification notification);
    List<Notification> listNotification(Long userIdx);
    void updateNotificationRead(Long notifIdx);
    void updateAllNotificationRead(Long userIdx);
    int unreadNotificationCount(Long userIdx);
    void deleteAllNotifications(Long userIdx);
}