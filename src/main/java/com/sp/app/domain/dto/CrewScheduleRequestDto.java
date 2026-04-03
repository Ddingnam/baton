package com.sp.app.domain.dto;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class CrewScheduleRequestDto {
    private String title;
    private String content;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private String locationName;
    private Double lat;
    private Double lng;
    private Integer maxPeople = 0; 
}
