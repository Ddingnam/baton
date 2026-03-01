package com.sp.app.mapper;

import com.sp.app.model.ChatMessage;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;
import java.util.Map;

@Mapper
public interface ChatMapper {
    void insertMessage(ChatMessage message);
    List<ChatMessage> listChatMessage(Long roomIdx);
    void updateLastReadDate(Map<String, Object> map);
    Long findChatRoom(Map<String, Object> map);
    void insertChatRoom(Map<String, Object> map);
    void insertChatMember(Map<String, Object> map);
    String getCounterpartNickname(Map<String, Object> map);
    
}