package com.sp.app.service;

import com.sp.app.model.ChatMessage;
import com.sp.app.model.ChatRoom;

import java.util.List;
import java.util.Map;

public interface ChatService {
    void insertMessage(ChatMessage message);
    List<ChatMessage> listChatMessage(Long roomIdx);
    void updateLastReadDate(Long roomIdx, Long userIdx);
    Long createOrGetRoom(Long tradeIdx, Long sellerIdx, Long buyerIdx);
    String getCounterpartNickname(Long roomIdx, Long myUserIdx);
    List<ChatRoom> listTradeChatRoom(Long tradeIdx, Long myUserIdx);
    Map<String, Object> getTradeInfo(Long tradeIdx);
    List<ChatRoom> listAllChatRoom(Long myUserIdx);
}