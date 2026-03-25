package com.sp.app.service;

import java.util.List;
import com.sp.app.model.Notification;

public interface NotificationService {
	public void sendNotification(Long userIdx, String notifType, String content, String url);
	public void sendInquiryNotification(String content, String url);
	public void sendChatNotification(Long userIdx, String content, String url);
	public void sendSystemNotification(String content, String url);
	public void sendRefundNotification(String content, String url);
	public void sendMemberJoinNotification(String content, String url);
	
	public void sendTradeNotification(Long userIdx, String content, String url);
	public void sendAlbaNotification(Long userIdx, String content, String url);
	public void sendCommunityNotification(Long userIdx, String content, String url);
	
	public List<Notification> listNotification(Long userIdx);
	public void updateNotificationRead(Long notifIdx);
	public void updateAllNotificationRead(Long userIdx);
	public int unreadNotificationCount(Long userIdx);
	public void deleteAllNotifications(Long userIdx);
	public void deleteNotification(Long notifIdx);
}