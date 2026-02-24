package com.sp.app.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sp.app.mapper.PaymentMapper;
import com.sp.app.model.Payment;
import com.sp.app.model.PointHistory;

@Service
public class PaymentService {

    private final PaymentMapper paymentMapper;

    public PaymentService(PaymentMapper paymentMapper) {
        this.paymentMapper = paymentMapper;
    }

    @Transactional 
    public void processPointCharge(String impUid, String merchantUid, int chargeAmount, int userIdx, String payMethod) {
   
        double feeRate = 0.02; // 2%
        int fee = (int) Math.round(chargeAmount * feeRate); 
        int accumulatedPoint = chargeAmount - fee; 

        Payment payment = new Payment();
        payment.setImpUid(impUid);
        payment.setMerchantUid(merchantUid);
        payment.setChargeAmount(chargeAmount); 
        payment.setPayMethod(payMethod);
        payment.setUserIdx(userIdx);
        payment.setPayStatus("PAID");

        paymentMapper.insertPayment(payment);

        PointHistory pointHistory = new PointHistory();
        pointHistory.setPaymentIdx(payment.getPaymentIdx()); 
        pointHistory.setAmount(accumulatedPoint);           
        pointHistory.setHistoryType("CHARGE");

        paymentMapper.insertPointHistory(pointHistory);
     
    }
}
