package com.sp.app.service;

import com.sp.app.mapper.AdminChatMapper;
import com.sp.app.model.ChatRoom;
import com.sp.app.domain.dto.UserDto;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class AdminChatServiceImpl implements AdminChatService {

    private final AdminChatMapper mapper;

    public AdminChatServiceImpl(AdminChatMapper mapper) {
        this.mapper = mapper;
    }

    @Override
    public List<ChatRoom> listAdminRooms() {
        return mapper.listAdminRooms();
    }

    @Override
    public List<UserDto> listAdminMembers() {
    	return mapper.listAdminMembers();
    }
}