package com.sp.app.model;

import lombok.Data;

@Data
public class JobProfile {
    private long   profileIdx; 
    private long   userIdx;   
    private String photoUrl;   
    private String userName;  
    private String phone;    
    private String email;     
    private String gender;  
    private String birth;      
    private String introduce;   
    private String strengths;     
    private String additionalInfo;
    private int    profileStatus; 
    private String title;         
    private String isDefault;    
    private String isPublic;      
    private String createdDate;   
    private String updatedDate;   

}
