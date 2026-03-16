package com.sp.app.admin.service;

import com.sp.app.model.ChatRoom;
import com.sp.app.domain.dto.UserDto;
import java.util.List;

public interface AdminChatService {
	public List<ChatRoom> listAdminRooms();
	public List<UserDto> listAdminMembers();
}