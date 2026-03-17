package com.sp.app.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import com.sp.app.mapper.PaymentMapper;
import com.sp.app.model.Payment;
import com.sp.app.model.PointHistory;

@Service
public class PaymentService {

    private final PaymentMapper paymentMapper;

    @Value("${portone.api-key}")
    private String impKey;

    @Value("${portone.api-secret}")
    private String impSecret;
    
    public PaymentService(PaymentMapper paymentMapper) {
        this.paymentMapper = paymentMapper;
    }

    @Transactional 
    public void processPointCharge(String impUid, String merchantUid, int chargeAmount, int userIdx, String payMethod) {
   
        double feeRate = 0.02; 
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
        
        int currentPoint = paymentMapper.getCurrentPoint(userIdx);
        int newTotalPoint = currentPoint + accumulatedPoint;

        PointHistory pointHistory = new PointHistory();
        pointHistory.setPaymentIdx(payment.getPaymentIdx()); 
        pointHistory.setAmount(accumulatedPoint);           
        pointHistory.setHistoryType("CHARGE");
        pointHistory.setUserIdx(userIdx);
        pointHistory.setTotalPoint(newTotalPoint);
        paymentMapper.insertPointHistory(pointHistory);
     
        Map<String, Object> paramMap = new java.util.HashMap<>();
        paramMap.put("userIdx", userIdx);
        paramMap.put("point", accumulatedPoint); 
        paymentMapper.updateUserPoint(paramMap);
    }
    
    public List<PointHistory> getPointHistoryByUser(long userIdx) {
        return paymentMapper.getPointHistoryByUser(userIdx);
    }

    @Transactional
    public String refundLatestCharge(long userIdx) throws Exception {

        Payment payment = paymentMapper.getLatestChargePayment(userIdx);
        if (payment == null) {
            return "최근 3일 이내에 충전된 내역이 없습니다.";
        }

        double feeRate = 0.02;
        int fee = (int) Math.round(payment.getChargeAmount() * feeRate);
        int accumulatedPoint = payment.getChargeAmount() - fee;

        int currentPoint = paymentMapper.getCurrentPoint(userIdx);
        if (currentPoint < accumulatedPoint) {
            return "이미 포인트를 사용하여 결제를 취소할 수 없습니다.";
        }

        RestTemplate restTemplate = new RestTemplate();

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        Map<String, String> tokenReq = new java.util.HashMap<>();

        tokenReq.put("imp_key", impKey);
        tokenReq.put("imp_secret", impSecret);
        
        ResponseEntity<Map> tokenRes = restTemplate.postForEntity("https://api.iamport.kr/users/getToken", new HttpEntity<>(tokenReq, headers), Map.class);
        Map<String, Object> tokenBody = tokenRes.getBody();
        if (tokenBody == null || (Integer) tokenBody.get("code") != 0) {
            return "결제 취소 인증 서버 연동 실패";
        }
        String accessToken = (String) ((Map<String, Object>) tokenBody.get("response")).get("access_token");

        HttpHeaders cancelHeaders = new HttpHeaders();
        cancelHeaders.setContentType(MediaType.APPLICATION_JSON);
        cancelHeaders.setBearerAuth(accessToken);
        
        Map<String, Object> cancelReq = new java.util.HashMap<>();
        cancelReq.put("imp_uid", payment.getImpUid());
        cancelReq.put("reason", "사용자 요청 (3일 이내 미사용 전액 취소)");
        
        ResponseEntity<Map> cancelRes = restTemplate.postForEntity("https://api.iamport.kr/payments/cancel", new HttpEntity<>(cancelReq, cancelHeaders), Map.class);
        Map<String, Object> cancelBody = cancelRes.getBody();
        
        if (cancelBody == null || (Integer) cancelBody.get("code") != 0) {
            return "포트원 결제 취소 실패: " + cancelBody.get("message");
        }

        paymentMapper.updatePaymentCancel(payment.getPaymentIdx());
        
        Map<String, Object> deductMap = new java.util.HashMap<>();
        deductMap.put("userIdx", userIdx);
        deductMap.put("refundAmount", accumulatedPoint);
        paymentMapper.deductUserPointForRefund(deductMap);
        
        int newTotalPoint = currentPoint - accumulatedPoint;
        PointHistory history = new PointHistory();
        history.setPaymentIdx(payment.getPaymentIdx());
        history.setAmount(-accumulatedPoint); 
        history.setHistoryType("REFUND"); 
        history.setUserIdx((int) userIdx);
        history.setTotalPoint(newTotalPoint);
        paymentMapper.insertPointHistory(history);

        return "SUCCESS";
    }
    
}
