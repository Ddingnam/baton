package com.sp.app.admin.domain.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ReportDto {
    private Long reportIdx;
    private Long reporterIdx;
    private Long reportedUserIdx;
    private String domainType;
    private Long targetIdx;
    private String reportType;
    private String reportContent;
    private String reportDate;
    private int processStatus;
    private String processDate;
    private String adminMemo;

    private String reporterId; 
    private String reporterName;
    private String reportedUserId;
    private String reportedUserName;
    @JsonProperty("isDeleted")
    private boolean isDeleted;
    
}