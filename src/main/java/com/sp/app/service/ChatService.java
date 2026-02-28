package com.sp.app.service;

import com.sp.app.model.ChatMessage;
import java.util.List;

public interface ChatService {
    void insertMessage(ChatMessage message);
    List<ChatMessage> listChatMessage(Long roomIdx);
    void updateLastReadDate(Long roomIdx, Long userIdx);
}