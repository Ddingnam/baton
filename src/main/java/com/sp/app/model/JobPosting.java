package com.sp.app.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class JobPosting {
    private long postingIdx;     
    private long userIdx;         
    private long regionIdx;     
    
    private String title;         
    private String content;       
    private int pay;          
    private String workDays;     
    private String workTime;     
    
    private int hitCount;       
    private int likeCount;      
    private int chatCount;     
    private int applyCount;  
    private int pullCount;   
    
    private String recruitStatus;
    private String isDisplay;   
    
    private String createdDate;  
    private String updatedDate;  
    private String deadlineDate;
    
    private int responseRate; 
    private String responseTime;
}