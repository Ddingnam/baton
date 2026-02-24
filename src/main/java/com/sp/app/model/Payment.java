package com.sp.app.model;

import lombok.Data;

@Data
public class Payment {
    private int paymentIdx;     
    private String impUid;      
    private String merchantUid;   
    private int chargeAmount;    
    private String payMethod;    
    private Integer orderId;     
    private String payStatus;   
    private String paidAt;        
    private int userIdx;       
}