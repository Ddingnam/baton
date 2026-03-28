package com.sp.app.mapper;
import com.sp.app.model.ChatMessage;
import com.sp.app.model.ChatRoom;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

@Mapper
public interface ChatMapper {
	public void insertMessage(ChatMessage message);
	public List<ChatMessage> listChatMessage(Long roomIdx);
	public void updateLastReadDate(Map<String, Object> map);
	public Long findChatRoom(Map<String, Object> map);
	public void insertChatRoom(Map<String, Object> map);
	public void insertChatMember(Map<String, Object> map);
	public String getCounterpartNickname(Map<String, Object> map);
	public List<ChatRoom> listTradeChatRoom(Map<String, Object> map);
	public Map<String, Object> getTradeInfo(Long tradeIdx);
	public List<ChatRoom> listAllChatRoom(Long myUserIdx);
	public int getUnreadTotalCount(Long myUserIdx);
	public List<Long> getRoomMembers(Long roomIdx);
	public void hideChatRoom(Map<String, Object> map);
	public void updateRoomVisibleTrue(Long roomIdx);
	public Long findAlbaChatRoom(Map<String, Object> map);
	public void insertAlbaChatRoom(Map<String, Object> map);
	public Map<String, Object> getAlbaInfo(Long albaIdx);
	public List<ChatRoom> listAlbaChatRoom(Map<String, Object> map);
	public String getSenderNickname(@Param("userIdx") Long userIdx);
	public String getSenderProfilePhoto(@Param("userIdx") Long userIdx);
	public String getSenderTheme(@Param("userIdx") Long userIdx);
}