package com.sp.app.service;

import com.sp.app.mapper.ChatMapper;
import com.sp.app.model.ChatMessage;
import com.sp.app.model.ChatRoom;
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
		mapper.updateRoomVisibleTrue(message.getRoomIdx());
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

	@Override
	public Long createOrGetRoom(Long tradeIdx, Long sellerIdx, Long buyerIdx) {
		Map<String, Object> map = new HashMap<>();
		map.put("tradeIdx", tradeIdx);
		map.put("sellerIdx", sellerIdx);
		map.put("buyerIdx", buyerIdx);
		Long roomIdx = mapper.findChatRoom(map);
		if (roomIdx == null) {
			mapper.insertChatRoom(map);
			roomIdx = (Long) map.get("roomIdx");
			map.put("roomIdx", roomIdx);
			map.put("userIdx", sellerIdx);
			mapper.insertChatMember(map);
			map.put("userIdx", buyerIdx);
			mapper.insertChatMember(map);
		}
		return roomIdx;
	}

	@Override
	public String getCounterpartNickname(Long roomIdx, Long myUserIdx) {
		Map<String, Object> map = new HashMap<>();
		map.put("roomIdx", roomIdx);
		map.put("myUserIdx", myUserIdx);
		return mapper.getCounterpartNickname(map);
	}

	@Override
	public List<ChatRoom> listTradeChatRoom(Long tradeIdx, Long myUserIdx) {
		Map<String, Object> map = new HashMap<>();
		map.put("tradeIdx", tradeIdx);
		map.put("myUserIdx", myUserIdx);
		return mapper.listTradeChatRoom(map);
	}

	@Override
	public Map<String, Object> getTradeInfo(Long tradeIdx) {
		return mapper.getTradeInfo(tradeIdx);
	}

	@Override
	public List<ChatRoom> listAllChatRoom(Long myUserIdx) {
		return mapper.listAllChatRoom(myUserIdx);
	}

	@Override
	public int getUnreadTotalCount(Long myUserIdx) {
		return mapper.getUnreadTotalCount(myUserIdx);
	}

	@Override
	public List<Long> getRoomMembers(Long roomIdx) {
		return mapper.getRoomMembers(roomIdx);
	}

	@Override
	public void deleteChatRoom(Long roomIdx, Long userIdx) {
		Map<String, Object> map = new HashMap<>();
		map.put("roomIdx", roomIdx);
		map.put("userIdx", userIdx);
		mapper.hideChatRoom(map);
	}

	@Override
	public Map<String, Object> getAlbaInfo(Long albaIdx) {
		return mapper.getAlbaInfo(albaIdx);
	}

	@Override
	public List<ChatRoom> listAlbaChatRoom(Long albaIdx, Long myUserIdx) {
		Map<String, Object> map = new HashMap<>();
		map.put("albaIdx", albaIdx);
		map.put("myUserIdx", myUserIdx);
		return mapper.listAlbaChatRoom(map);
	}

	@Override
	public Long createOrGetAlbaRoom(Long albaIdx, Long sellerIdx, Long buyerIdx) {
		Map<String, Object> map = new HashMap<>();
		map.put("albaIdx", albaIdx);
		map.put("sellerIdx", sellerIdx);
		map.put("buyerIdx", buyerIdx);
		Long roomIdx = mapper.findAlbaChatRoom(map);
		if (roomIdx == null) {
			mapper.insertAlbaChatRoom(map);
			roomIdx = (Long) map.get("roomIdx");
			map.put("roomIdx", roomIdx);
			map.put("userIdx", sellerIdx);
			mapper.insertChatMember(map);
			map.put("userIdx", buyerIdx);
			mapper.insertChatMember(map);
		}
		return roomIdx;
	}

	@Override
	public String getSenderNickname(Long userIdx) {
		return mapper.getSenderNickname(userIdx);
	}

	@Override
	public String getSenderProfilePhoto(Long userIdx) {
		return mapper.getSenderProfilePhoto(userIdx);
	}

	@Override
	public String getSenderTheme(Long userIdx) {
		return mapper.getSenderTheme(userIdx);
	}
}