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
            @RequestParam(value = "type", defaultValue = "ALL") String type, 
            Model model) {
        
        int userIdx = 0;
      
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !auth.getPrincipal().equals("anonymousUser")) {
            // ★ TODO: CustomUserDetails 등에서 실제 userIdx 꺼내오는 로직으로 변경하세요.
            userIdx = 1; // 임시 고정
        }
        
        Map<String, Object> map = new HashMap<>();
        map.put("type", type);
        map.put("userIdx", userIdx);

        List<TradingReviews> list = reviewMapper.listReviews(map);
        int reviewCount = reviewMapper.getReviewCount();
 
        long currentTime = System.currentTimeMillis();
        for(TradingReviews dto : list) {
        
            if (dto.getRawCreatedDate() != null) {
                dto.setTimeAgo(calculateTimeAgo(dto.getRawCreatedDate().getTime(), currentTime));
            }

            if(dto.getWriterAddr() != null) {
                String[] addrParts = dto.getWriterAddr().split(" ");
                if(addrParts.length >= 2) {
                    dto.setWriterAddr(addrParts[0] + " " + addrParts[1]); 
                }
            }
        }
 
        model.addAttribute("reviewList", list);
        model.addAttribute("reviewCount", reviewCount);
        model.addAttribute("currentType", type);
        
        return "review/list"; 
    }

    private String calculateTimeAgo(long regTime, long currentTime) {
        long diffTime = (currentTime - regTime) / 1000; // 초 단위
        if (diffTime < 60) return "방금 전";
        else if ((diffTime /= 60) < 60) return diffTime + "분 전";
        else if ((diffTime /= 60) < 24) return diffTime + "시간 전";
        else if ((diffTime /= 24) < 30) return diffTime + "일 전";
        else if ((diffTime /= 30) < 12) return diffTime + "개월 전";
        else return (diffTime / 12) + "년 전";
    }

    @PostMapping("/write")
    @ResponseBody
    public Map<String, Object> writeReview(@RequestBody TradingReviews dto) {
        Map<String, Object> response = new HashMap<>();
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null && auth.isAuthenticated() && !auth.getPrincipal().equals("anonymousUser")) {
               
            	// ★ TODO: 실제 로그인한 회원의 userIdx로 변경
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
        }
        return response;
    }
}