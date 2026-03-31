package com.sp.app.domain.dto;

import java.time.LocalDateTime;

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
public class CrewChatRoomDto {
    private Long chatRoomId;
    private Integer roomType;
    private String roomName;
    private Long crewIdx;
    private LocalDateTime createdDate;
    
    public static CrewChatRoomDto fromEntity(CrewChatRoom entity) {
        if (entity == null) return null;
        
        return CrewChatRoomDto.builder()
	            .chatRoomId(entity.getChatRoomId())
	            .roomType(entity.getRoomType())
	            .roomName(entity.getRoomName())
	            .crewIdx(entity.getCrew() != null ? entity.getCrew().getCrewIdx() : null) 
	            .createdDate(entity.getCreatedDate())
	            .build();
    }
}