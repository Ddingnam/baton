package com.sp.app.domain.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class JobApplyDto {
    private long applyIdx;
    private long postingIdx;
    private long userIdx;
    private long resumeIdx;
    private String status;
    private String employer;
    private String title;
    private String payType;
    private int pay;
    private LocalDateTime applyDate;
}