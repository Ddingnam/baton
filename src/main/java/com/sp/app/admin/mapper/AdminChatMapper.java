package com.sp.app.admin.mapper;

import com.sp.app.model.ChatRoom;
import com.sp.app.domain.dto.UserDto;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface AdminChatMapper {
	public List<ChatRoom> listAdminRooms();
	public List<UserDto> listAdminMembers();
}