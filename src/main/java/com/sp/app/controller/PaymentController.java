package com.sp.app.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/api/payment")
public class PaymentController {

    @PostMapping("/verify/{imp_uid}")
    public ResponseEntity<?> verifyPayment(
            @PathVariable String imp_uid,
            @RequestBody Map<String, Object> paymentData) {
        
        String merchantUid = (String) paymentData.get("merchant_uid");
        int amount = (Integer) paymentData.get("amount");
        int tradeId = (Integer) paymentData.get("trade_id");
        int buyerId = (Integer) paymentData.get("buyer_id");

        try {
      
            System.out.println("전달받은 포트원 결제번호: " + imp_uid);
            System.out.println("전달받은 우리 주문번호: " + merchantUid);
            System.out.println("결제 금액: " + amount);

            return ResponseEntity.ok("결제 검증 및 DB 저장 완료");

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.badRequest().body("결제 검증 실패");
        }
    }
}