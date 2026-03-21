package com.sp.app.admin.service;

public interface AdminNotificationService {
	public void sendToAdmin(Long adminIdx, String type, String content, String url);
	public void sendToAllAdmins(String type, String content, String url);
	public void deleteOne(Long notifIdx);
	public void deleteAll(Long adminIdx);
}