package com.sp.app.admin.mapper;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;
import java.util.Map;

@Mapper
public interface AdminPaymentMapper {

    int dataCount(Map<String, Object> map);
    List<Map<String, Object>> listPayment(Map<String, Object> map);
    Map<String, Object> findById(String orderId);
    void updatePaymentStatus(Map<String, Object> map);
}