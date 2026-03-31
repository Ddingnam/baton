package com.sp.app.domain.dto;

import java.time.LocalDateTime;

import com.sp.app.domain.entity.CrewChatMessage;

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
public class CrewChatMessageDto {
    private Long chatIdx;
    private Long chatRoomId;
    private Long userIdx;
    private String content;
    private Integer msgType;
    private LocalDateTime createdDate;
    
    public static CrewChatMessageDto fromEntity(CrewChatMessage entity) {
        if (entity == null) return null;

        return CrewChatMessageDto.builder()
                .chatIdx(entity.getChatIdx())
                .chatRoomId(entity.getChatRoom().getChatRoomId())
                .userIdx(entity.getUser().getUserIdx())
                .content(entity.getContent())
                .msgType(entity.getMsgType())
                .createdDate(entity.getCreatedDate())
                .build();
    }
}