package com.sp.app.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import com.sp.app.model.Payment;
import com.sp.app.model.PointHistory;

@Mapper
public interface PaymentMapper {
   
    public void insertPayment(Payment payment);  
    public void insertPointHistory(PointHistory pointHistory);
    public int getCurrentPoint(long userIdx);
    public void updateUserPoint(Map<String, Object> map);
   
}
