package com.sp.app.controller; // 프로젝트 경로에 맞게 수정해 주세요.

import java.util.HashMap;
import java.util.Map;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.EscrowService;

@RestController
@RequestMapping("/escrow")
public class EscrowController {

    private final EscrowService escrowService;

    public EscrowController(EscrowService escrowService) {
        this.escrowService = escrowService;
    }

    @PostMapping("/pay")
    public Map<String, Object> processPayment(
            @RequestParam Map<String, Object> paramMap,
            @AuthenticationPrincipal CustomUserDetails userDetails) {

        Map<String, Object> resultMap = new HashMap<>();

        if (userDetails == null) {
            resultMap.put("state", "false");
            resultMap.put("msg", "로그인이 필요한 서비스입니다.");
            return resultMap;
        }

        try {

            Long buyerIdx = userDetails.getUserIdx();
            paramMap.put("buyerIdx", buyerIdx);

            escrowService.processEscrowPayment(paramMap);

            resultMap.put("state", "true");
            resultMap.put("msg", "안전결제가 성공적으로 완료되었습니다.");

        } catch (Exception e) {
            resultMap.put("state", "false");
            resultMap.put("msg", e.getMessage()); 
        }

        return resultMap;
    }
}