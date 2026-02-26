package com.sp.app.model;

import java.util.Date;

import lombok.Data;

@Data
public class TradingReviews {
    private int reviewIdx;         
    private String saleReviewType; 
    private String content;       
    private String createdDate;    
    private String updatedDate;    
    private int userIdx;          
    private int productIdx;        
    private double score;          
    private String reviewTags;     
    private String writerNickname; 
    private String profilePhoto;   
    private String writerAddr;    
    private String productTitle;  
    private Date rawCreatedDate;   
    private String timeAgo;
    
}