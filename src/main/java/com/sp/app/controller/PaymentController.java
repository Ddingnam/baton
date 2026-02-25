package com.sp.app.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Map;
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
            @RequestBody Map<String, Object> paymentData) {
        
        try {
           
            String merchantUid = (String) paymentData.get("merchantUid");
            int chargeAmount = (Integer) paymentData.get("chargeAmount");
            String payMethod = (String) paymentData.get("payMethod");
            int userIdx = (Integer) paymentData.get("userIdx");

            System.out.println("=== 결제 정보 서버 수신 완료 ===");
            System.out.println("impUid: " + impUid);
            System.out.println("결제금액: " + chargeAmount);

            paymentService.processPointCharge(impUid, merchantUid, chargeAmount, userIdx, payMethod);

            return ResponseEntity.ok("DB 저장 성공");

        } catch (Exception e) {
            e.printStackTrace(); 
            return ResponseEntity.badRequest().body("DB 저장 중 오류 발생");
        }
    }
}