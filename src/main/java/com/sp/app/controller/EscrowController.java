package com.sp.app.controller; // 프로젝트 경로에 맞게 수정해 주세요.

import java.util.HashMap;
import java.util.Map;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.sp.app.model.Trade;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.EscrowService;
import com.sp.app.service.TradeService;

@RestController
@RequestMapping("/escrow")
public class EscrowController {

    private final EscrowService escrowService;
    private final TradeService tradeService;

    public EscrowController(EscrowService escrowService, TradeService tradeService) {
        this.escrowService = escrowService;
        this.tradeService = tradeService;
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
    
    @GetMapping("/checkout")
    public ModelAndView checkoutForm(
            @RequestParam("productIdx") Long productIdx,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
            
        ModelAndView mav = new ModelAndView();

        if (userDetails == null) {
            mav.setViewName("redirect:/member/login");
            return mav;
        }

        try {
            Trade trade = tradeService.findByIdx(productIdx); 

            int price = trade.getPrice();
            int safetyFee = (int) (price * 0.035);
            int totalPrice = price + safetyFee;

            mav.addObject("product", trade); 
            mav.addObject("safetyFee", safetyFee);
            mav.addObject("totalPrice", totalPrice);

            mav.setViewName("payment/checkout"); 

        } catch (Exception e) {
            mav.setViewName("redirect:/"); 
        }

        return mav;
    }
}