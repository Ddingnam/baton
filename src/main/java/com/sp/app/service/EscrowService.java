package com.sp.app.service;

import java.util.Map;

public interface EscrowService {
	void processEscrowPayment(Map<String, Object> paramMap) throws Exception;
	public void updateShippingInfo(Map<String, Object> paramMap) throws Exception;
	public void confirmPurchase(long productIdx, long buyerIdx) throws Exception;
	public int checkTradeExist(long productIdx) throws Exception;
	public Map<String, Object> getTradeTransaction(long productIdx) throws Exception;
	public void cancelTrade(long productIdx, long userIdx) throws Exception;
	public String getUserAddress(long userIdx) throws Exception;
}