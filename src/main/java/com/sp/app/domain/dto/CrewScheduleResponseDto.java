package com.sp.app.domain.dto;

import java.time.LocalDateTime;
import java.util.List;

import com.sp.app.domain.entity.CrewSchedule;

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
public class CrewScheduleResponseDto {
    private Long scheduleIdx;
    private Long crewIdx;
    private Long userIdx;
    private String title;
    private String content;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private String locationName;
    private Double lat;
    private Double lng;
    private Integer maxPeople;
    
    private String userNickname;
    private boolean isAttending;
    
    private int currentCount; 
    
    private List<AttendeeDto> attendees;

    public static CrewScheduleResponseDto fromEntity(CrewSchedule entity, int currentCount, boolean isAttending, List<AttendeeDto> attendees) {
    	
        return CrewScheduleResponseDto.builder()
                .scheduleIdx(entity.getScheduleIdx())
                .crewIdx(entity.getCrew().getCrewIdx())
                .userIdx(entity.getUser() != null ? entity.getUser().getUserIdx() : null)
                .title(entity.getTitle())
                .content(entity.getContent())
                .startDate(entity.getStartDate())
                .endDate(entity.getEndDate())
                .locationName(entity.getLocationName())
                .lat(entity.getLat())
                .lng(entity.getLng())
                .maxPeople(entity.getMaxPeople())
                .userNickname(entity.getUser().getNickname())
                .isAttending(isAttending)
                .currentCount(currentCount)
                .attendees(attendees)
                .build();
    }
    
    public static CrewScheduleResponseDto fromEntity(CrewSchedule entity) {
        return fromEntity(entity, 0, false, null);
    }
}
