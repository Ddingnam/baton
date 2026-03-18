package com.sp.app.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class JobPosting {
    private long postingIdx;     
    private long userIdx;         
    private long regionIdx;     
    
    private String title;         
    private String employer;
    private String category;
    private String description;
    
    private String payType;
    private int pay;          
    private String workPeriod;
    private String workDays;
    private String startTime;
    private String endTime;
    private String timeNegotiable;
    private String workTime;
    private String startDate;
    private String endDate;
    private String subwayInfo;
    
    private String location;
    private String locationDetail;
    private String locationLat;
    private String locationLng;
    
    private String deadline;
    private String contact;
    private String benefits;
    
    private List<MultipartFile> images; 
    
    private int hitCount;       
    private int likeCount;      
    private int chatCount;     
    private int applyCount;  
    private int pullCount;   
    private String recruitStatus;
    private String isDisplay;   
    private String createdDate;  
    private String updatedDate;  
    private int responseRate; 
    private String responseTime;
    
    private String thumbUrl;
   
    private List<JobPostingImage> imageList; 
}