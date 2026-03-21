package com.sp.app.controller;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sp.app.admin.service.AdminNotificationService;
import com.sp.app.domain.dto.SessionInfo;
import com.sp.app.security.LoginMemberUtil;
import com.sp.app.service.PaymentService;

@RestController
@RequestMapping("/api/payment")
public class PaymentController {

    private final PaymentService paymentService;
    private final AdminNotificationService adminNotificationService;

    public PaymentController(PaymentService paymentService,
                             AdminNotificationService adminNotificationService) {
        this.paymentService = paymentService;
        this.adminNotificationService = adminNotificationService;
    }

    @PostMapping("/verify/{impUid}")
    public ResponseEntity<String> verifyPayment(
            @PathVariable("impUid") String impUid,
            @RequestBody Map<String, Object> paymentData) {
        try {
            SessionInfo info = LoginMemberUtil.getSessionInfo();
            if (info == null) return ResponseEntity.status(401).body("로그인이 필요합니다.");

            int userIdx = (int) info.getUserIdx();
            String merchantUid = (String) paymentData.get("merchantUid");
            int chargeAmount = Integer.parseInt(paymentData.get("chargeAmount").toString());
            String payMethod = (String) paymentData.get("payMethod");

            paymentService.processPointCharge(impUid, merchantUid, chargeAmount, userIdx, payMethod);

            try {
                String content = info.getNickname() + " 님이 " + String.format("%,d", chargeAmount) + "원 포인트를 충전했습니다.";
                adminNotificationService.sendToAllAdmins("PAYMENT", content, "/admin/payment/list");
            } catch (Exception ignored) {}

            return ResponseEntity.ok("DB 저장 성공");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.badRequest().body("DB 저장 중 오류 발생");
        }
    }

    @GetMapping("/history")
    public ResponseEntity<java.util.List<com.sp.app.model.PointHistory>> getPointHistory() {
        try {
            SessionInfo info = LoginMemberUtil.getSessionInfo();
            if (info == null) return ResponseEntity.status(401).build();
            return ResponseEntity.ok(paymentService.getPointHistoryByUser(info.getUserIdx()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @PostMapping("/refund")
    public ResponseEntity<Map<String, Object>> refundPoint() {
        Map<String, Object> result = new java.util.HashMap<>();
        try {
            SessionInfo info = LoginMemberUtil.getSessionInfo();
            if (info == null) {
                result.put("state", "false");
                result.put("msg", "로그인이 필요합니다.");
                return ResponseEntity.ok(result);
            }

            String msg = paymentService.refundLatestCharge(info.getUserIdx());
            if ("SUCCESS".equals(msg)) {
                result.put("state", "true");
                result.put("msg", "정상적으로 환불(결제 취소) 처리되어 금액이 반환되었습니다.");
                try {
                    String content = info.getNickname() + " 님이 환불을 요청했습니다.";
                    adminNotificationService.sendToAllAdmins("REFUND", content, "/admin/payment/list");
                } catch (Exception ignored) {}
            } else {
                result.put("state", "false");
                result.put("msg", msg);
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("state", "false");
            result.put("msg", "환불 처리 중 서버 오류가 발생했습니다.");
        }
        return ResponseEntity.ok(result);
    }
}