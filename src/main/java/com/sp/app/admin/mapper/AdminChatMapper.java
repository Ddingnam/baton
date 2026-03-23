package com.sp.app.admin.mapper;

import com.sp.app.model.ChatRoom;
import com.sp.app.domain.dto.UserDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

@Mapper
public interface AdminChatMapper {
	public List<ChatRoom> listMyChannels(@Param("myUserIdx") Long myUserIdx);
	public List<ChatRoom> listAllChannels(@Param("myUserIdx") Long myUserIdx);

	public List<UserDto>  listAdminMembers();
	public Long findDMRoom(@Param("userIdxA") Long userIdxA, @Param("userIdxB") Long userIdxB);
	public void insertDMRoom(Map<String, Object> map);
	public void insertDMRoomMember(Map<String, Object> map);
	public List<ChatRoom> listDMRooms(@Param("myUserIdx") Long myUserIdx);
	public void insertChannel(Map<String, Object> map);
	public void insertChannelMember(Map<String, Object> map);

	public List<UserDto> listChannelMembers(@Param("roomIdx") Long roomIdx);
	public List<UserDto> listNonMembers(@Param("roomIdx") Long roomIdx);
	public void addMemberToChannel(Map<String, Object> map);
	public void removeMemberFromChannel(@Param("roomIdx") Long roomIdx, @Param("userIdx") Long userIdx);
	public void deleteChannelMessages(@Param("roomIdx") Long roomIdx);
	public void deleteChannelMembers(@Param("roomIdx") Long roomIdx);
	public void deleteChannelRoom(@Param("roomIdx") Long roomIdx);
	public void renameChannel(@Param("roomIdx") Long roomIdx, @Param("roomName") String roomName);

	public Long getChannelCreator(@Param("roomIdx") Long roomIdx);

	public void leaveChannel(@Param("roomIdx") Long roomIdx, @Param("userIdx") Long userIdx);

	public void setMuted(@Param("roomIdx") Long roomIdx, @Param("userIdx") Long userIdx, @Param("isMuted") int isMuted);
	public int getMuted(@Param("roomIdx") Long roomIdx, @Param("userIdx") Long userIdx);
	public void transferOwnership(@Param("roomIdx") Long roomIdx, @Param("newOwnerIdx") Long newOwnerIdx);
	
	public void setOnlineStatus(@Param("userIdx") Long userIdx, @Param("isOnline") int isOnline);
	public int  getOnlineStatus(@Param("userIdx") Long userIdx);
}
