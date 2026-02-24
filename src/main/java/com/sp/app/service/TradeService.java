package com.sp.app.service;

import com.sp.app.model.Trade;

public interface TradeService {
	public void insertTradePost(Trade dto) throws Exception;
	public void upodateTradePost(Trade dto) throws Exception;
	public void deleteTradePost(long productIdx) throws Exception;
}
