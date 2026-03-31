package com.sp.app.domain.dto;

import java.time.LocalDateTime;

import com.sp.app.domain.entity.CrewChatRead;

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
public class CrewChatReadDto {
    private Long chatRoomId;
    private Long userIdx;
    private Long lastReadChatIdx;
    private LocalDateTime joinedDate;
    
    public static CrewChatReadDto fromEntity(CrewChatRead entity) {
        if (entity == null) return null;

        return CrewChatReadDto.builder()
                .chatRoomId(entity.getChatRoom().getChatRoomId())
                .userIdx(entity.getUser().getUserIdx())
                .lastReadChatIdx(entity.getLastReadChatIdx())
                .joinedDate(entity.getJoinedDate())
                .build();
    }
}