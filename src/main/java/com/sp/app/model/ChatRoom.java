package com.sp.app.model;
import lombok.Data;

@Data
public class ChatRoom {
    private Long roomIdx;
    private Long tradeIdx;
    private Long userIdx;        
    private String nickname;     
    private String profilePhoto;  
    private String recentMessage; 
    private String recentDate;    
    private int unreadCount;
    private String tradeTitle;     
    private String tradeSaveName;
    private String roomName;
    private int roomType;
    private int isOnline;
}