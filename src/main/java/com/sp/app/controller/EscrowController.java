package com.sp.app.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
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
 
            if (trade == null || "판매완료".equals(trade.getTradeStatus()) || "예약중".equals(trade.getTradeStatus())) {
                mav.setViewName("redirect:/"); 
                return mav;
            }

            int price = trade.getPrice();
            int safetyFee = 0;
            int totalPrice = price;
            
            String userAddress = "";
            try {
                userAddress = escrowService.getUserAddress(userDetails.getUserIdx());
            } catch(Exception e) {
                userAddress = "주소 미등록";
            }

            mav.addObject("product", trade); 
            mav.addObject("safetyFee", safetyFee);
            mav.addObject("totalPrice", totalPrice);
            mav.addObject("userAddress", userAddress);

            mav.setViewName("payment/checkout"); 

        } catch (Exception e) {
            e.printStackTrace();
            mav.setViewName("redirect:/"); 
        }

        return mav;
    }
    
    @PostMapping("/shipping")
    @ResponseBody
    public Map<String, Object> updateShipping(
            @RequestParam Map<String, Object> paramMap,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        
        Map<String, Object> model = new HashMap<>();

        if (userDetails == null) {
            model.put("state", "false");
            model.put("message", "로그인 시간이 만료되었습니다. 다시 로그인해 주세요.");
            return model;
        }
        
        try {
            paramMap.put("sellerIdx", userDetails.getUserIdx());
            
            escrowService.updateShippingInfo(paramMap);
            
            model.put("state", "true");
            model.put("message", "발송 처리가 완료되었습니다.");
        } catch (Exception e) {
            e.printStackTrace(); 
            
            model.put("state", "false");
            model.put("message", "발송 처리에 실패했습니다. 다시 시도해 주세요.");
        }
        
        return model;
    }
    
    @PostMapping("/confirm")
    @ResponseBody
    public Map<String, Object> confirmPurchase(
            @RequestParam("productIdx") long productIdx,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        
        Map<String, Object> model = new HashMap<>();
        
        if (userDetails == null) {
            model.put("state", "false");
            model.put("message", "로그인이 필요합니다.");
            return model;
        }
        
        try {
            escrowService.confirmPurchase(productIdx, userDetails.getUserIdx());
            model.put("state", "true");
            model.put("message", "구매가 확정되었습니다. 판매자에게 정산이 완료되었습니다!");
        } catch (Exception e) {
            e.printStackTrace();
            model.put("state", "false");
            model.put("message", e.getMessage());
        }
        
        return model;
    }
    
    @PostMapping("/cancel")
    @ResponseBody
    public Map<String, Object> cancelTrade(
            @RequestParam("productIdx") long productIdx,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        
        Map<String, Object> model = new HashMap<>();
        
        if (userDetails == null) {
            model.put("state", "false");
            model.put("message", "로그인이 필요합니다.");
            return model;
        }
        
        try {
            escrowService.cancelTrade(productIdx, userDetails.getUserIdx());
            model.put("state", "true");
            model.put("message", "거래가 성공적으로 취소되었으며 포인트가 환불되었습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            model.put("state", "false");
            model.put("message", e.getMessage());
        }
        
        return model;
    }
}