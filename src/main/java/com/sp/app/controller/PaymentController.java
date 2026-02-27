package com.sp.app.controller;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sp.app.domain.dto.SessionInfo;
import com.sp.app.security.LoginMemberUtil;
import com.sp.app.service.PaymentService; 

@RestController
@RequestMapping("/api/payment")
public class PaymentController {

    private final PaymentService paymentService;

    public PaymentController(PaymentService paymentService) {
        this.paymentService = paymentService;
    }

    @PostMapping("/verify/{impUid}")
    public ResponseEntity<String> verifyPayment(
            @PathVariable("impUid") String impUid,
            @RequestBody Map<String, Object> paymentData
            ) {
        
        try {
        	SessionInfo info = LoginMemberUtil.getSessionInfo();        	
        	
        	if (info == null) {
                return ResponseEntity.status(401).body("로그인이 필요합니다.");
            }
        	
        	int userIdx = (int) info.getUserIdx();
        	
            String merchantUid = (String) paymentData.get("merchantUid");
            int chargeAmount = Integer.parseInt(paymentData.get("chargeAmount").toString());       
            String payMethod = (String) paymentData.get("payMethod");
            
            System.out.println("=== 결제 정보 서버 수신 완료 ===");
            System.out.println("결제금액: " + chargeAmount);
            System.out.println("적립대상 진짜 회원번호: " + userIdx);

            paymentService.processPointCharge(impUid, merchantUid, chargeAmount, userIdx, payMethod);

            return ResponseEntity.ok("DB 저장 성공");

        } catch (Exception e) {
            e.printStackTrace(); 
            return ResponseEntity.badRequest().body("DB 저장 중 오류 발생");
        }
    }
}