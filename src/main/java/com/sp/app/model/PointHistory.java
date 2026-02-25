package com.sp.app.model;

import lombok.Data;

@Data
public class PointHistory {
    private int historyIdx;       
    private Integer tradeIdx;    
    private int paymentIdx;      
    private int amount;          
    private String historyType; 
    private Integer refId;      
    private String createdAt; 
    private int userIdx;
    private int totalPoint;
}