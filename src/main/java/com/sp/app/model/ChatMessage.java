package com.sp.app.model;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@Getter
@Setter
public class ChatMessage {
    private Long msgIdx;
    private Long roomIdx;
    private Long userIdx;       
    private String content;
    private Integer msgType;
    private String sendDate;
    private String nickname;
    private String profilePhoto;
    private Integer unreadCount;
    private Long tradeIdx;
    private String theme;
}