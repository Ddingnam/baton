package com.sp.app.model;

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

}