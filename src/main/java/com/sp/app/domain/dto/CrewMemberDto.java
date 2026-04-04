package com.sp.app.domain.dto;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import com.sp.app.domain.entity.CrewMember;

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
public class CrewMemberDto {
    private Long crewMemberIdx;
    private Long crewIdx;
    private Long userIdx;
    private String role;
    private String status;
    private LocalDateTime joinedDate;
    private String applicationReason;
    
    private String profileImg;
    private String nickname;
    private String formattedDate;

    public static CrewMemberDto fromEntity(CrewMember entity) {
        if (entity == null) return null;
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy년 MM월 dd일");

        return CrewMemberDto.builder()
                .crewMemberIdx(entity.getCrewMemberIdx())
                .crewIdx(entity.getCrew() != null ? entity.getCrew().getCrewIdx() : null) 
                .userIdx(entity.getUser() != null ? entity.getUser().getUserIdx() : null)
                .role(entity.getRole())
                .status(entity.getStatus())
                .joinedDate(entity.getJoinedDate())
                .applicationReason(entity.getApplicationReason())
                .profileImg(entity.getUser().getProfilePhoto())
                .nickname(entity.getUser().getNickname())
                .formattedDate(entity.getJoinedDate() != null ? entity.getJoinedDate().format(formatter) : "미정")
                .build();
    }
}