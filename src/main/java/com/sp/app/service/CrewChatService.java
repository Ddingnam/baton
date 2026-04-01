package com.sp.app.service;

import java.util.List;

import com.sp.app.domain.dto.CrewChatMessageDto;
import com.sp.app.domain.dto.CrewChatParticipantDto;
import com.sp.app.domain.dto.CrewChatRoomDto;
import com.sp.app.domain.dto.CrewChatRoomResponse;

public interface CrewChatService {
	Long createRoom(Long crewId, String roomName, Integer roomType);
	void leaveChatRoom(Long roomId, Long userId);
	
	Long getMainChatRoomId(Long crewIdx);
	List<CrewChatRoomResponse> getMyChatRooms(Long userId);
	CrewChatRoomDto getChatRoomDetail(Long roomId);
	
	Long sendMessage(Long roomId, Long userId, String content, Integer msgType);
	CrewChatMessageDto saveAndGetMessageDto(Long roomId, Long userId, String content, Integer msgType);
	
	List<CrewChatMessageDto> getChatHistory(Long roomId, Long userId);
    List<CrewChatMessageDto> getChatHistoryAfter(Long roomId, Long lastChatIdx);
    List<CrewChatMessageDto> getChatHistoryBefore(Long roomId, Long userId, Long firstChatIdx);
	
	Long getUnreadMessageCount(Long roomId, Long userId);
	void updateReadIndex(Long roomId, Long userId, Long lastChatIdx);
	List<CrewChatParticipantDto> getChatParticipants(Long roomId);
}