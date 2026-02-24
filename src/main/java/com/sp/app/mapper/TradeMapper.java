package com.sp.app.mapper;

import java.sql.SQLException;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.model.Trade;

@Mapper
public interface TradeMapper {
	public void insertTradePost(Trade dto) throws SQLException;
	public void updateTradePost(Trade dto) throws SQLException;
	public void deleteTradePost(long productIdx) throws SQLException;
	
}
