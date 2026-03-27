package com.sp.app.domain.dto;

import java.time.LocalDateTime;

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

    public static CrewMemberDto fromEntity(CrewMember entity) {
        if (entity == null) return null;

        return CrewMemberDto.builder()
                .crewMemberIdx(entity.getCrewMemberIdx())
                .crewIdx(entity.getCrew() != null ? entity.getCrew().getCrewIdx() : null) 
                .userIdx(entity.getUser() != null ? entity.getUser().getUserIdx() : null)
                .role(entity.getRole())
                .status(entity.getStatus())
                .joinedDate(entity.getJoinedDate())
                .applicationReason(entity.getApplicationReason())
                .build();
    }
}