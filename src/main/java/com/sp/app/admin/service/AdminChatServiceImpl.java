package com.sp.app.admin.service;

import com.sp.app.model.ChatRoom;
import com.sp.app.admin.mapper.AdminChatMapper;
import com.sp.app.domain.dto.UserDto;
import org.springframework.stereotype.Service;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AdminChatServiceImpl implements AdminChatService {

	private final AdminChatMapper mapper;

	public AdminChatServiceImpl(AdminChatMapper mapper) {
		this.mapper = mapper;
	}

	@Override
	public List<ChatRoom> listAdminRooms(Long myUserIdx, int myUserLevel) {
		if (myUserLevel >= 99)
			return mapper.listAllChannels(myUserIdx);
		return mapper.listMyChannels(myUserIdx);
	}

	@Override
	public List<UserDto> listAdminMembers() {
		return mapper.listAdminMembers();
	}

	@Override
	public Long createOrGetDMRoom(Long userIdxA, Long userIdxB) {
		Long roomIdx = mapper.findDMRoom(userIdxA, userIdxB);
		if (roomIdx == null) {
			Map<String, Object> map = new HashMap<>();
			mapper.insertDMRoom(map);
			roomIdx = (Long) map.get("roomIdx");
			Map<String, Object> m1 = new HashMap<>();
			m1.put("roomIdx", roomIdx);
			m1.put("userIdx", userIdxA);
			mapper.insertDMRoomMember(m1);
			Map<String, Object> m2 = new HashMap<>();
			m2.put("roomIdx", roomIdx);
			m2.put("userIdx", userIdxB);
			mapper.insertDMRoomMember(m2);
		}
		return roomIdx;
	}

	@Override
	public List<ChatRoom> listDMRooms(Long myUserIdx) {
		return mapper.listDMRooms(myUserIdx);
	}

	@Override
	public Long createChannel(String roomName, Long creatorIdx) {
		Map<String, Object> map = new HashMap<>();
		map.put("roomName", roomName);
		map.put("creatorIdx", creatorIdx);
		mapper.insertChannel(map);
		Long roomIdx = (Long) map.get("roomIdx");
		Map<String, Object> m = new HashMap<>();
		m.put("roomIdx", roomIdx);
		m.put("userIdx", creatorIdx);
		mapper.insertChannelMember(m);
		return roomIdx;
	}

	@Override
	public List<ChatRoom> listAllChannels(Long myUserIdx) {
		return mapper.listAllChannels(myUserIdx);
	}

	@Override
	public List<UserDto> listChannelMembers(Long roomIdx) {
		return mapper.listChannelMembers(roomIdx);
	}

	@Override
	public List<UserDto> listNonMembers(Long roomIdx) {
		return mapper.listNonMembers(roomIdx);
	}

	@Override
	public void addMemberToChannel(Long roomIdx, Long userIdx) {
		Map<String, Object> map = new HashMap<>();
		map.put("roomIdx", roomIdx);
		map.put("userIdx", userIdx);
		mapper.addMemberToChannel(map);
	}

	@Override
	public void removeMemberFromChannel(Long roomIdx, Long userIdx) {
		mapper.removeMemberFromChannel(roomIdx, userIdx);
	}

	@Override
	public void deleteChannel(Long roomIdx) {
		mapper.deleteChannelMessages(roomIdx);
		mapper.deleteChannelMembers(roomIdx);
		mapper.deleteChannelRoom(roomIdx);
	}

	@Override
	public void renameChannel(Long roomIdx, String newName) {
		mapper.renameChannel(roomIdx, newName);
	}

	@Override
	public Long getChannelCreator(Long roomIdx) {
		return mapper.getChannelCreator(roomIdx);
	}

	@Override
	public void leaveChannel(Long roomIdx, Long userIdx) {
		mapper.leaveChannel(roomIdx, userIdx);
	}

	@Override
	public int toggleMute(Long roomIdx, Long userIdx) {
		int current = mapper.getMuted(roomIdx, userIdx);
		int next = (current == 0) ? 1 : 0;
		mapper.setMuted(roomIdx, userIdx, next);
		return next;
	}

	@Override
	public void transferOwnership(Long roomIdx, Long newOwnerIdx) {
		mapper.transferOwnership(roomIdx, newOwnerIdx);
	}

	@Override
	public void setOnlineStatus(Long userIdx, int isOnline) {
		mapper.setOnlineStatus(userIdx, isOnline);
	}

	@Override
	public int getOnlineStatus(Long userIdx) {
		return mapper.getOnlineStatus(userIdx);
	}
}