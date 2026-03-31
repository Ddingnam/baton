package com.sp.app.domain.dto;

import com.sp.app.domain.entity.User;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class CrewChatParticipantDto {
    private Long userIdx;
    private String nickname;
    private String profilePhoto;
    private int userLevel;
    private int isOnline;
    
    public static CrewChatParticipantDto fromEntity(User entity) {
        if (entity == null) return null;
        
        return CrewChatParticipantDto.builder()
                .userIdx(entity.getUserIdx())
                .nickname(entity.getNickname())
                .profilePhoto(entity.getProfilePhoto())
                .userLevel(entity.getUserLevel())
                .isOnline(entity.getIsOnline())
                .build();
    }
}