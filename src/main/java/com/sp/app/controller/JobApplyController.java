package com.sp.app.controller;

import com.sp.app.domain.dto.JobApplyDto;
import com.sp.app.service.JobApplyService;
import com.sp.app.security.CustomUserDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/alba")
public class JobApplyController {

    private final JobApplyService applyService;

    @GetMapping("/mypage/alba-apply")
    @ResponseBody
    public List<JobApplyDto> listApply(@AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null) return List.of();

        List<JobApplyDto> albaApplyList = applyService.listApplyByUser(userDetails.getUserIdx());
        System.out.println("DB에서 가져온 리스트 크기: " + albaApplyList.size()); // 디버그용
        return albaApplyList;
    }

    @GetMapping("/mypage/alba-apply-page")
    public String myAlbaApplyPage(@AuthenticationPrincipal CustomUserDetails userDetails, Model model) {
        if (userDetails == null) return "redirect:/login";

        List<JobApplyDto> albaApplyList = applyService.listApplyByUser(userDetails.getUserIdx());
        System.out.println("albaApplyList = " + albaApplyList); // ✅ 여기에 데이터 찍기
        model.addAttribute("albaApplyList", albaApplyList);

        return "mypage/alba-apply";
    }
    
    
}