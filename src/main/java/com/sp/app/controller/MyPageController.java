package com.sp.app.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sp.app.domain.dto.UserDto;
import com.sp.app.mapper.PaymentMapper;
import com.sp.app.model.Trade;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.MemberService;
import com.sp.app.service.MypageService;
import com.sp.app.service.TradeService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/mypage")
@RequiredArgsConstructor
@Slf4j
public class MyPageController {

    private final PaymentMapper paymentMapper;
    private final MypageService mypageService;
    private final MemberService memberService;
    private final TradeService tradeService;

    @GetMapping({"", "/", "/main"})
    public String main(Model model, Authentication auth) {

        if (auth != null && auth.isAuthenticated() && !auth.getPrincipal().equals("anonymousUser")) {
            CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
            long userIdx = userDetails.getUserIdx();

            int currentPoint = paymentMapper.getCurrentPoint(userIdx);
            model.addAttribute("userPoint", currentPoint);

            model.addAttribute("myPosts",   mypageService.getMyPosts(userIdx));
            model.addAttribute("myReplies", mypageService.getMyReplies(userIdx));
            model.addAttribute("myScraps",  mypageService.getMyScraps(userIdx));
            model.addAttribute("myVotes",   mypageService.getMyVotes(userIdx));
        }

        return "mypage/main";
    }
    
    @GetMapping("/tradeUserMain")
    public String tradeUserMain(@RequestParam("userIdx") long userIdx, Model model) {
    	Map<String, Object> map = new HashMap<>();
    	try {
    		UserDto userDto = memberService.findById(userIdx);
    		
    		map.put("userIdx", userIdx);
    		List<Trade> tradeList = tradeService.findByUserIdx(map);
    		
    		model.addAttribute("dto", userDto);
    		model.addAttribute("tradeList", tradeList);
		} catch (Exception e) {
			log.info("tradeUserMain", e);
		}
		return "mypage/tradeUserMain";
	}
    
}