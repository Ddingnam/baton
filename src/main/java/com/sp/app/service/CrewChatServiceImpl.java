package com.sp.app.service;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sp.app.domain.dto.CrewChatMessageDto;
import com.sp.app.domain.dto.CrewChatParticipantDto;
import com.sp.app.domain.dto.CrewChatRoomDto;
import com.sp.app.domain.dto.CrewChatRoomResponse;
import com.sp.app.domain.entity.Crew;
import com.sp.app.domain.entity.CrewChatMessage;
import com.sp.app.domain.entity.CrewChatRead;
import com.sp.app.domain.entity.CrewChatReadId;
import com.sp.app.domain.entity.CrewChatRoom;
import com.sp.app.domain.entity.User;
import com.sp.app.repository.CrewChatMessageRepository;
import com.sp.app.repository.CrewChatReadRepository;
import com.sp.app.repository.CrewChatRoomRepository;
import com.sp.app.repository.CrewRepository;
import com.sp.app.repository.UserRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class CrewChatServiceImpl implements CrewChatService {
	
	private final CrewChatRoomRepository roomRepository;
    private final CrewChatMessageRepository messageRepository;
    private final CrewChatReadRepository readRepository;
    
    private final UserRepository userRepository; 
    private final CrewRepository crewRepository;

    @Override
    @Transactional
    public Long createRoom(Long crewId, String roomName, Integer roomType) {
        Crew crew = crewRepository.findById(crewId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 크루입니다."));

        CrewChatRoom room = CrewChatRoom.builder()
                .crew(crew)
                .roomName(roomName)
                .roomType(roomType)
                .build();

        return roomRepository.save(room).getChatRoomId();
    }

    @Override
    @Transactional
    public Long sendMessage(Long roomId, Long userId, String content, Integer msgType) {
        CrewChatRoom room = roomRepository.findById(roomId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 채팅방입니다."));
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 사용자입니다."));

        CrewChatMessage message = CrewChatMessage.builder()
                .chatRoom(room)
                .user(user)
                .content(content)
                .msgType(msgType)
                .build();
        
        CrewChatMessage savedMessage = messageRepository.save(message);

        updateLastRead(room, user, savedMessage.getChatIdx());

        return savedMessage.getChatIdx();
    }

    @Override
    public List<CrewChatMessageDto> getChatHistory(Long roomId, Long userId) {
        LocalDateTime joinedDate = getJoinedDate(roomId, userId);

        List<CrewChatMessage> messages = messageRepository
                .findTop50ByChatRoom_ChatRoomIdAndCreatedDateGreaterThanEqualOrderByChatIdxDesc(roomId, joinedDate);

        Collections.reverse(messages);

        return messages.stream()
                .map(CrewChatMessageDto::fromEntity)
                .collect(Collectors.toList());
    }

    @Override
    public List<CrewChatMessageDto> getChatHistoryBefore(Long roomId, Long userId, Long firstChatIdx) {
        LocalDateTime joinedDate = getJoinedDate(roomId, userId);

        List<CrewChatMessage> messages = messageRepository
                .findTop50ByChatRoom_ChatRoomIdAndChatIdxLessThanAndCreatedDateGreaterThanEqualOrderByChatIdxDesc(
                        roomId, firstChatIdx, joinedDate);

        Collections.reverse(messages);

        return messages.stream()
                .map(CrewChatMessageDto::fromEntity)
                .collect(Collectors.toList());
    }

    @Override
    public List<CrewChatMessageDto> getChatHistoryAfter(Long roomId, Long lastChatIdx) {
        List<CrewChatMessage> messages = messageRepository
                .findByChatRoom_ChatRoomIdAndChatIdxGreaterThanOrderByChatIdxAsc(roomId, lastChatIdx);

        return messages.stream()
                .map(CrewChatMessageDto::fromEntity)
                .collect(Collectors.toList());
    }
    
    @Override
    public Long getUnreadMessageCount(Long roomId, Long userIdx) {
        CrewChatReadId readId = new CrewChatReadId(roomId, userIdx);
        Long lastReadIdx = readRepository.findById(readId)
                .map(CrewChatRead::getLastReadChatIdx)
                .orElse(0L);

        return messageRepository.countByChatRoom_ChatRoomIdAndChatIdxGreaterThan(roomId, lastReadIdx);
    }

    @Override
    public List<CrewChatRoomResponse> getMyChatRooms(Long userIdx) {
        
        List<CrewChatRoom> myChatRooms = roomRepository.findChatRoomsByUserIdOrderByLastMessage(userIdx);

        return myChatRooms.stream()
                .map(room -> {
                    Long roomId = room.getChatRoomId();
                    CrewChatMessage lastMessage = messageRepository
                            .findFirstByChatRoom_ChatRoomIdOrderByCreatedDateDesc(roomId)
                            .orElse(null);
                    Long unreadCount = getUnreadMessageCount(roomId, userIdx);
                    return CrewChatRoomResponse.of(room, lastMessage, unreadCount);
                })
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void leaveChatRoom(Long roomId, Long userId) {
        CrewChatReadId readId = new CrewChatReadId(roomId, userId);
        readRepository.deleteById(readId);
    }
    
    @Override
    public CrewChatRoomDto getChatRoomDetail(Long roomId) {
        CrewChatRoom room = roomRepository.findById(roomId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 채팅방입니다."));
        
        return CrewChatRoomDto.fromEntity(room);
    }
    
    @Override
    public List<CrewChatParticipantDto> getChatParticipants(Long roomId) {
        List<CrewChatRead> participants = readRepository.findByChatRoom_ChatRoomId(roomId);

        return participants.stream()
                .map(read -> CrewChatParticipantDto.fromEntity(read.getUser()))
                .collect(Collectors.toList());
    }
    
    @Override
    @Transactional
    public void updateReadIndex(Long roomId, Long userId, Long lastChatIdx) {
        CrewChatRoom room = roomRepository.findById(roomId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 채팅방입니다."));
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 사용자입니다."));

        this.updateLastRead(room, user, lastChatIdx);
    }

    private void updateLastRead(CrewChatRoom room, User user, Long chatIdx) {
        CrewChatReadId readId = new CrewChatReadId(room.getChatRoomId(), user.getUserIdx()); 
        
        CrewChatRead chatRead = readRepository.findById(readId)
                .orElse(CrewChatRead.builder()
                        .chatRoom(room)
                        .user(user)
                        .lastReadChatIdx(0L)
                        .build());

        if (chatRead.getLastReadChatIdx() < chatIdx) {
            chatRead.updateLastReadChatIdx(chatIdx);
        }
        
        readRepository.save(chatRead);
    }
    
    private LocalDateTime getJoinedDate(Long roomId, Long userId) {
        CrewChatReadId readId = new CrewChatReadId(roomId, userId);
        return readRepository.findById(readId)
                .map(CrewChatRead::getJoinedDate)
                .orElseThrow(() -> new IllegalArgumentException("채팅방 참여 정보가 없습니다."));
    }

}