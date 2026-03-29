package com.sp.app.domain.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@Builder
@AllArgsConstructor
public class MyCrewListDto {
    private Long crewIdx;
    private String name;
    private int currentMember;
    private String status;
    private String logoImage;
    private LocalDateTime joinedDate;
    private LocalDateTime createdDate;
}
