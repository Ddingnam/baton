package com.sp.app.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class JobProfile {
    private long profileIdx;
    private long userIdx;
    
    private String title;
    private String careerType;
    private String careerDesc;
    private String desiredCategory;
    private String desiredLocation;
    private String introduce;
    private String createdDate;
    
    private String userName;
    private String phone;
}