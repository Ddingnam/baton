package com.sp.app.admin.service;

import com.sp.app.model.ChatRoom;
import com.sp.app.domain.dto.UserDto;
import java.util.List;

public interface AdminChatService {
	public List<ChatRoom> listAdminRooms(Long myUserIdx, int myUserLevel);
	public List<UserDto>  listAdminMembers();
	public Long createOrGetDMRoom(Long userIdxA, Long userIdxB);
	public List<ChatRoom> listDMRooms(Long myUserIdx);
	public Long createChannel(String roomName, Long creatorIdx);

    
	public List<ChatRoom> listAllChannels(Long myUserIdx);
	public List<UserDto> listChannelMembers(Long roomIdx);
	public List<UserDto> listNonMembers(Long roomIdx);
	public void addMemberToChannel(Long roomIdx, Long userIdx);
	public void removeMemberFromChannel(Long roomIdx, Long userIdx);
	public void deleteChannel(Long roomIdx);
	public void renameChannel(Long roomIdx, String newName);
}