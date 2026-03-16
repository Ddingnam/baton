package com.sp.app.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sp.app.domain.dto.UserDto;
import com.sp.app.domain.entity.User;
import com.sp.app.mapper.PaymentMapper;
import com.sp.app.model.Trade;
import com.sp.app.model.TradeImg;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.FollowService;
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
    private final FollowService followService;

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
            
            Map<String, Object> map = new HashMap<>();
            map.put("userIdx", userIdx);
            List<Trade> tradeList = tradeService.findByUserIdx(map);
            
            for (Trade trade : tradeList) {
                List<TradeImg> images = tradeService.findImgsByIdx(trade.getProductIdx());
                trade.setImageList(images);
            }
            
            model.addAttribute("tradeList", tradeList);
            
        }

        return "mypage/main";
    }
    
    @GetMapping("/tradeUserMain")
    public String tradeUserMain(@RequestParam("userIdx") long userIdx, 
    		@AuthenticationPrincipal CustomUserDetails userDetails,
    		Model model) {
    	Map<String, Object> map = new HashMap<>();
    	try {
    		UserDto userDto = memberService.findById(userIdx);
    		long followerCount = followService.countByFollowing(userIdx);
    		long followingCount = followService.countByFollower(userIdx);
    		boolean isFollowing = false;
    		
            if (userDetails != null) {
                isFollowing = followService.isFollowing(userDetails.getUserIdx(), userIdx);
            }
            
            model.addAttribute("isFollowing", isFollowing);
            model.addAttribute("followerCount", followerCount);
    		model.addAttribute("followingCount", followingCount);
            
    		map.put("userIdx", userIdx);
    		List<Trade> tradeList = tradeService.findByUserIdx(map);
    		
    		model.addAttribute("dto", userDto);
    		model.addAttribute("tradeList", tradeList);
    		
		} catch (Exception e) {
			log.info("tradeUserMain", e);
		}
		return "mypage/tradeUserMain";
	}

    @GetMapping("/followList")
    @ResponseBody
    public Map<String, Object> followList(@RequestParam("userIdx") long userIdx,
                                          @RequestParam("type") String type) {
        Map<String, Object> model = new HashMap<>();
        try {
            List<User> list;
            if (type.equals("follower")) {
                list = followService.getFollowerList(userIdx);
            } else {
                list = followService.getFollowingList(userIdx);
            }

            List<UserDto> result = list.stream().map(u -> {
                UserDto dto = new UserDto();
                dto.setUserIdx(u.getUserIdx());
                dto.setNickname(u.getNickname());
                dto.setProfile_photo(u.getProfilePhoto());
                return dto;
            }).collect(java.util.stream.Collectors.toList());

            model.put("list", result);
            model.put("status", "success");
        } catch (Exception e) {
            log.info("followList error", e);
            model.put("status", "error");
        }
        return model;
    }
    
}