package com.sp.app.model;

import lombok.Data;

@Data
public class JobProfile {
    private long profileIdx;
    private long userIdx;

    private String title;
    private String introduce;
    private String userName;
    private String phone;
    private String email;
    private String gender;  
    private String birth;
    private String strengths;
    private String additionalInfo; 
    private String createdDate; 
}