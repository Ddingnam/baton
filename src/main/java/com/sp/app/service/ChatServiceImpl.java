package com.sp.app.service;

import com.sp.app.mapper.ChatMapper;
import com.sp.app.model.ChatMessage;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ChatServiceImpl implements ChatService {
    
    private final ChatMapper mapper;

    public ChatServiceImpl(ChatMapper mapper) {
        this.mapper = mapper;
    }

    @Override
    public void insertMessage(ChatMessage message) {
        mapper.insertMessage(message);
    }

    @Override
    public List<ChatMessage> listChatMessage(Long roomIdx) {
        return mapper.listChatMessage(roomIdx);
    }

    @Override
    public void updateLastReadDate(Long roomIdx, Long userIdx) {
        Map<String, Object> map = new HashMap<>();
        map.put("roomIdx", roomIdx);
        map.put("userIdx", userIdx);
        mapper.updateLastReadDate(map);
    }
}