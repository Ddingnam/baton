package com.sp.app.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sp.app.model.Notification;

@Mapper
public interface NotificationMapper {
	public void insertNotification(Notification notification);
	public List<Notification> listNotification(@Param("userIdx") Long userIdx);
	public void updateNotificationRead(@Param("notifIdx") Long notifIdx);
	public void updateAllNotificationRead(@Param("userIdx") Long userIdx);
	public int unreadNotificationCount(@Param("userIdx") Long userIdx);
	public void deleteAllNotifications(@Param("userIdx") Long userIdx);
	public void deleteNotification(@Param("notifIdx") Long notifIdx);
}