package com.sp.app.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.model.Trade;

@Mapper
public interface TradeMapper {
	public void insertTradePost(Trade dto) throws SQLException;
	public void updateTradePost(Trade dto) throws SQLException;
	
	public void deleteTradePost(long productIdx) throws SQLException;
	public void deleteTradePostTag(long productIdx) throws SQLException;
	public void deleteTragePostImg(long productIdx) throws SQLException;
	
	public Trade findByIdx(long productIdx);
	public Trade findImagesByIdx(long productIdx);
	public List<String> findTagsByIdx(long productIdx);
	
	public List<Trade> tradeList(Map<String, Object> map);
	public int dataCount(Map<String, Object> map);
	
}
