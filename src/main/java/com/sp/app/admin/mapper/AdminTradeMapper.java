package com.sp.app.admin.mapper;

import com.sp.app.model.Trade;
import com.sp.app.model.TradeImg;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface AdminTradeMapper {
	public List<Trade> listTrade(Map<String, Object> map);
	public int dataCount(Map<String, Object> map);
	public Trade findById(@Param("productIdx") long productIdx);
	public List<TradeImg> findImages(@Param("productIdx") long productIdx);
	public List<String> findTags(@Param("productIdx") long productIdx);
	public void deleteTradePost(@Param("productIdx") long productIdx);
	public void deleteTradeImages(@Param("productIdx") long productIdx);
	public void deleteTradePostTags(@Param("productIdx") long productIdx);
}