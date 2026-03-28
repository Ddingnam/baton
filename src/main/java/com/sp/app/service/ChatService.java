package com.sp.app.service;
import com.sp.app.model.ChatMessage;
import com.sp.app.model.ChatRoom;
import java.util.List;
import java.util.Map;

public interface ChatService {
	public void insertMessage(ChatMessage message);
	public List<ChatMessage> listChatMessage(Long roomIdx);
	public void updateLastReadDate(Long roomIdx, Long userIdx);
	public Long createOrGetRoom(Long tradeIdx, Long sellerIdx, Long buyerIdx);
	public String getCounterpartNickname(Long roomIdx, Long myUserIdx);
	public List<ChatRoom> listTradeChatRoom(Long tradeIdx, Long myUserIdx);
	public Map<String, Object> getTradeInfo(Long tradeIdx);
	public List<ChatRoom> listAllChatRoom(Long myUserIdx);
	public int getUnreadTotalCount(Long myUserIdx);
	public List<Long> getRoomMembers(Long roomIdx);
	public void deleteChatRoom(Long roomIdx, Long userIdx);
	public Long createOrGetAlbaRoom(Long albaIdx, Long sellerIdx, Long buyerIdx);
	public Map<String, Object> getAlbaInfo(Long albaIdx);
	public List<ChatRoom> listAlbaChatRoom(Long albaIdx, Long myUserIdx);
	public String getSenderNickname(Long userIdx);
	public String getSenderProfilePhoto(Long userIdx);
	public String getSenderTheme(Long userIdx);
}