package com.sp.app.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import com.sp.app.model.Payment;
import com.sp.app.model.PointHistory;

@Mapper
public interface PaymentMapper {
   
    public void insertPayment(Payment payment);  
    public void insertPointHistory(PointHistory pointHistory);
    public void updateUserPoint(Map<String, Object> map);
    public int deductPointForEscrow(Map<String, Object> map) throws Exception;
    public void insertTradeTransaction(Map<String, Object> map) throws Exception;
    public void insertPointHistoryForEscrow(Map<String, Object> map) throws Exception;
    public int getCurrentPoint(long userIdx);
    public void updateShippingInfo(Map<String, Object> map) throws Exception;
    public Map<String, Object> getTradeTransactionByProduct(long productIdx) throws Exception;
    public int confirmTradeStatus(long productIdx) throws Exception;
    public void addSellerPoint(Map<String, Object> map) throws Exception;
    public void insertPointHistoryForSeller(Map<String, Object> map) throws Exception;
    public int checkTradeExist(long productIdx) throws Exception;
}
