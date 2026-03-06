package com.sp.app.service;

import java.util.Map;

public interface EscrowService {
	void processEscrowPayment(Map<String, Object> paramMap) throws Exception;
	public void updateShippingInfo(Map<String, Object> paramMap) throws Exception;
}