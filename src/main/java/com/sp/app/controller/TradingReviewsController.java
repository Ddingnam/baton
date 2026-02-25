package com.sp.app.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sp.app.mapper.TradingReviewsMapper;
import com.sp.app.model.TradingReviews;

@Controller
@RequestMapping("/review")
public class TradingReviewsController {

    private final TradingReviewsMapper reviewMapper;

    public TradingReviewsController(TradingReviewsMapper reviewMapper) {
        this.reviewMapper = reviewMapper;
    }

    @GetMapping("/list")
    public String reviewList(
            @RequestParam(value = "type", defaultValue = "BUYER") String type, 
            Model model) {

        List<TradingReviews> list = reviewMapper.listReviewsByType(type);
        
        model.addAttribute("reviewList", list);
        model.addAttribute("currentType", type); 
        
        return "review/list";
    }
    
    @PostMapping("/write")
    @ResponseBody
    public Map<String, Object> writeReview(@RequestBody TradingReviews dto) {
        Map<String, Object> response = new HashMap<>();
        
        try {
          
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
  
            if (auth != null && auth.isAuthenticated() && !auth.getPrincipal().equals("anonymousUser")) {

                dto.setUserIdx(1); 
            } else {
                response.put("status", "error");
                response.put("message", "로그인이 필요한 서비스입니다.");
                return response;
            }
            
            reviewMapper.insertReview(dto);
            response.put("status", "success");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "후기 등록 중 오류가 발생했습니다.");
        }
        
        return response;
    }
}