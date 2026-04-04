package com.sp.app.domain.dto;

import java.time.format.DateTimeFormatter;

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
public class CrewHistoryDto {
    private Long historyIdx;
    private String nickname;
    private String profileImg;
    private String changedStatus;
    private String logDate;
    private String reason;
    private String actorNickname;

    public static CrewHistoryDto fromEntity(CrewMemberHistory entity) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        return CrewHistoryDto.builder()
                .historyIdx(entity.getCrewmemberHistoryIdx())
                .nickname(entity.getCrewMember().getUser().getNickname())
                .profileImg(entity.getCrewMember().getUser().getProfilePhoto())
                .changedStatus(entity.getChangedStatus())
                .logDate(entity.getLogDate().format(formatter))
                .reason(entity.getReason())
                .actorNickname(entity.getActor() != null ? entity.getActor().getNickname() : "시스템")
                .build();
    }
}