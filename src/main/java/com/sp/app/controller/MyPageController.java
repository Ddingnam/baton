package com.sp.app.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sp.app.mapper.PaymentMapper;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.MypageService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/mypage")
@RequiredArgsConstructor
public class MyPageController {

    private final PaymentMapper paymentMapper;
    private final MypageService mypageService;

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
}