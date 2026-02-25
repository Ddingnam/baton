package com.sp.app.mapper;

import java.sql.SQLException;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.model.Trade;

@Mapper
public interface TradeMapper {
	public void insertTradePost(Trade dto) throws SQLException;
	public void updateTradePost(Trade dto) throws SQLException;
	public void deleteTradePost(long productIdx) throws SQLException;
	
	public Trade findByIdx(long productIdx);
	public Trade findImagesByIdx(long productIdx);
	public List<String> findTagsByIdx(long productIdx);
	
}
