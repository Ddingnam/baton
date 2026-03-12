package com.sp.app.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sp.app.model.Trade;
import com.sp.app.model.TradeImg;

@Mapper
public interface TradeMapper {
	public void insertTradePost(Trade dto) throws SQLException;
	public void insertTradePostImg(TradeImg dto) throws SQLException;
	public void insertTradePostTag(Map<String, Object> map) throws SQLException;
	public void insertTradeTag(Trade dto) throws SQLException;
	
	public void updateTradePost(Trade dto) throws SQLException;
	public void updateTradePostTag(long productIdx) throws SQLException;
	public void updateTradeStatus(Map<String, Object> map) throws SQLException;
	public String findSaveName(@Param("productIdx") long productIdx, @Param("imgOrder") int order);
	public int getLastOrder(long productIdx);
	
	public void deleteTradePost(long productIdx) throws SQLException;
	public void deleteTradePostTag(long productIdx) throws SQLException;
	public void deleteTradePostImg(@Param("productIdx") long productIdx, @Param("imgOrder") int order) throws SQLException;
	public void deleteTradePostImgAll(long productIdx) throws SQLException;
	
	public Trade findByIdx(long productIdx);
	public List<Trade> findByUserIdx(Map<String, Object> map);
	public Trade findTempTradeByUserIdx(long userIdx);
	public List<TradeImg> findImagesByIdx(long productIdx);
	public List<String> findTagsByIdx(long productIdx);
	public Long findTagIdxByName(String tagName);
	public List<Map<String, Object>> CategoryList();
	public String findLastUpDateByProductIdx(long productIdx);
	
	public List<Trade> tradeList(Map<String, Object> map);
	public int dataCount(Map<String, Object> map);
	public void updateHitCount(long productIdx) throws SQLException;
	public void updateLastUpDate(long productIdx) throws SQLException;
	public void updatePullCount(long productIdx) throws SQLException;
}
