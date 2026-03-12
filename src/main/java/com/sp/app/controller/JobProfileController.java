package com.sp.app.controller;


import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sp.app.domain.dto.SessionInfo;
import com.sp.app.model.JobProfile;
import com.sp.app.service.JobProfileService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/resume/*")
@RequiredArgsConstructor
public class JobProfileController {

    private final JobProfileService jobProfileService;

    @GetMapping("/write")
    public String writeForm(HttpSession session, Model model) {
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        
        if (info == null) {
            return "redirect:/member/login";
        }

        model.addAttribute("name", info.getName());

        return "resume/write";
    }

    @PostMapping("write")
    public String writeSubmit(JobProfile dto, HttpSession session) throws Exception {
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        if (info == null) return "redirect:/member/login";
        
        try {
            dto.setUserIdx(info.getUserIdx());
            jobProfileService.insertJobProfile(dto);
        } catch (Exception e) {
            return "redirect:/resume/write?error=true";
        }

        return "redirect:/alba/list";
    }
}