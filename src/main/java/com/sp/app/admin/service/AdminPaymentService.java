package com.sp.app.admin.service;

import java.util.List;
import java.util.Map;

public interface AdminPaymentService {
	
    int dataCount(Map<String, Object> map);
    List<Map<String, Object>> listPayment(Map<String, Object> map);
    Map<String, Object> findById(String orderId);
    void updatePaymentStatus(Map<String, Object> map) throws Exception;
}