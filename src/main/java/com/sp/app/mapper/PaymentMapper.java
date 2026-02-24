package com.sp.app.mapper;

import org.apache.ibatis.annotations.Mapper;
import com.sp.app.model.Payment;
import com.sp.app.model.PointHistory;

@Mapper
public interface PaymentMapper {
   
    public void insertPayment(Payment payment);  
    public void insertPointHistory(PointHistory pointHistory);
   
}
