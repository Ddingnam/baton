package com.sp.app.domain.dto;

import java.time.LocalDateTime;

import com.sp.app.domain.entity.CrewChatMessage;
import com.sp.app.domain.entity.CrewChatRoom;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CrewChatRoomResponse {
    private Long chatRoomId;
    private String roomName;
    private Integer roomType;
    private Long crewIdx;
    
    private String lastMessage;
    private LocalDateTime lastChatTime;
    private Long unreadCount;
    
    public static CrewChatRoomResponse of(CrewChatRoom room, CrewChatMessage lastMessage, Long unreadCount) {
        
        return CrewChatRoomResponse.builder()
                .chatRoomId(room.getChatRoomId())
                .roomName(room.getRoomName())
                .roomType(room.getRoomType())
                .crewIdx(room.getCrew() != null ? room.getCrew().getCrewIdx() : null)
                .lastMessage(lastMessage != null ? lastMessage.getContent() : "")
                .lastChatTime(lastMessage != null ? lastMessage.getCreatedDate() : room.getCreatedDate())
                .unreadCount(unreadCount != null ? unreadCount : 0L)
                .build();
    }
}