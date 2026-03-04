package com.sp.app.service;

import java.util.List;
import java.util.Map;

import com.sp.app.model.Trade;
import com.sp.app.model.TradeImg;

public interface TradeService {
	public void insertTradePost(Trade dto, String uploadPath) throws Exception;
	public void updateTradePost(Trade dto, String uploadPath) throws Exception;
	public void deleteTradePost(long productIdx, String uploadPath) throws Exception;
	public void updateHitCount(long productIdx) throws Exception;
	
	public Trade findByIdx(long productIdx);
	public List<TradeImg> findImgsByIdx(long productIdx);
	public List<String> findTagsByIdx(long productIdx);
	
	public List<Trade> tradeList(Map<String, Object> map);
	public List<Map<String, Object>> categoryList();
	public int dataCount(Map<String, Object> map);
	
}
