package com.sp.app.domain.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BadgeDto {
    private int badgeId;
    private String badgeName;
    private String description;
    private String iconImage;
    private boolean acquired;      
    private int currentCount;     
    private int targetCount;       
    private int progressPercent;    
}