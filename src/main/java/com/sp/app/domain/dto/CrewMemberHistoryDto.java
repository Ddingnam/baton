package com.sp.app.domain.dto;

import java.time.LocalDateTime;

import com.sp.app.domain.entity.CrewMemberHistory;

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
public class CrewMemberHistoryDto {
    private Long crewmemberHistoryIdx;
    private Long crewMemberIdx;
    private String changedStatus;
    private LocalDateTime logDate;
    private String reason;
    private Long actorIdx;

    public static CrewMemberHistoryDto fromEntity(CrewMemberHistory entity) {
        if (entity == null) return null;

        return CrewMemberHistoryDto.builder()
                .crewmemberHistoryIdx(entity.getCrewmemberHistoryIdx())
                .crewMemberIdx(entity.getCrewMember() != null ? entity.getCrewMember().getCrewMemberIdx() : null)
                .changedStatus(entity.getChangedStatus())
                .logDate(entity.getLogDate())
                .reason(entity.getReason())
                .actorIdx(entity.getActor().getUserIdx())
                .build();
    }
}
