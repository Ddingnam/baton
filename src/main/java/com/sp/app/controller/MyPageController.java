package com.sp.app.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
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
import com.sp.app.service.JobPostingService;
import com.sp.app.service.MemberService;
import com.sp.app.service.MypageService;
import com.sp.app.service.TradeService;
import com.sp.app.service.WishListService;

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
    private final WishListService wishListService;
    private final JobPostingService jobPostingService;

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

            Map<String, Object> rMap = new HashMap<>();
            rMap.put("userIdx", userIdx);
            rMap.put("regionType", 1);

            model.addAttribute("userDto",      memberService.findById(userIdx));
            model.addAttribute("region",       memberService.findUserRegionbyType(rMap));
            model.addAttribute("tradeList",    tradeList);
            model.addAttribute("buyList",      tradeService.findBuyList(userIdx));
            model.addAttribute("wishList",     wishListService.findWishList(userIdx));
            model.addAttribute("albaPostList", jobPostingService.postListByUserId(userIdx));
        }

        return "mypage/main";
    }

    @GetMapping("/tradeUserMain")
    public String tradeUserMain(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @RequestParam(name = "userIdx") long userIdx,
            Model model) {

        try {
            Map<String, Object> map = new HashMap<>();
            map.put("userIdx", userIdx);
            if (userDetails != null) {
                map.put("loginUserIdx", userDetails.getUserIdx());
            }

            List<Trade> tradeList = tradeService.findByUserIdx(map);
            for (Trade trade : tradeList) {
                List<TradeImg> images = tradeService.findImgsByIdx(trade.getProductIdx());
                trade.setImageList(images);
            }

            UserDto userDto = memberService.findById(userIdx);
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

            model.put("list",   result);
            model.put("status", "success");
        } catch (Exception e) {
            log.info("followList error", e);
            model.put("status", "error");
        }
        return model;
    }

    // ── 탈퇴 요청 페이지 ────────────────────────────────────────
    @GetMapping("/withdraw")
    public String withdrawPage(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            Model model) {

        long   userIdx   = userDetails.getUserIdx();
        String authority = memberService.findByAuthority(userDetails.getUsername());

        // 직원·관리자는 탈퇴 불가
        boolean blocked = "ADMIN".equals(authority) || "EMP".equals(authority);
        if (blocked) {
            model.addAttribute("blockedByRole", true);
            return "mypage/withdraw";
        }

        boolean alreadyRequested = memberService.hasPendingWithdraw(userIdx);
        // 진행 중인 거래 건수만 정보 제공 (막지 않음 - 관리자가 최종 판단)
        int activeTrades = memberService.countActiveTrades(userIdx);

        model.addAttribute("alreadyRequested", alreadyRequested);
        model.addAttribute("activeTrades",     activeTrades);
        model.addAttribute("userDto",          memberService.findById(userIdx));

        return "mypage/withdraw";
    }

    // ── 탈퇴 요청 제출 (REST) ────────────────────────────────────
    @PostMapping("/withdraw/request")
    @ResponseBody
    public Map<String, Object> withdrawRequest(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @RequestBody Map<String, Object> param) {

        Map<String, Object> result = new HashMap<>();
        try {
            long   userIdx   = userDetails.getUserIdx();
            String authority = memberService.findByAuthority(userDetails.getUsername());

            if ("ADMIN".equals(authority) || "EMP".equals(authority)) {
                result.put("success", false);
                result.put("msg", "관리자·직원 계정은 탈퇴 요청이 불가합니다. 운영팀에 문의해주세요.");
                return result;
            }

            if (memberService.hasPendingWithdraw(userIdx)) {
                result.put("success", false);
                result.put("msg", "이미 탈퇴 요청이 진행 중입니다.");
                return result;
            }

            Map<String, Object> map = new HashMap<>();
            map.put("userIdx", userIdx);
            map.put("reason",  param.get("reason"));
            memberService.requestWithdraw(map);

            result.put("success", true);
        } catch (Exception e) {
            log.info("withdrawRequest error", e);
            result.put("success", false);
            result.put("msg", "오류가 발생했습니다. 다시 시도해주세요.");
        }
        return result;
    }
    
    @GetMapping("/api/tradeHistory")
    @ResponseBody
    public org.springframework.http.ResponseEntity<List<Map<String, Object>>> getTradeHistory(@AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null) {
            return org.springframework.http.ResponseEntity.status(401).build();
        }
        List<Map<String, Object>> list = mypageService.getMyTradeHistory(userDetails.getUserIdx());
        return org.springframework.http.ResponseEntity.ok(list);
    }
}