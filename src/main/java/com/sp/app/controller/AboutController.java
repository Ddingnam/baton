package com.sp.app.controller;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sp.app.security.CustomUserDetails;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/about/*")
public class AboutController {

    @GetMapping("intro")
    public String intro(Model model) {
        model.addAttribute("menu", "intro");
        return "about/intro";
    }

    @GetMapping("service")
    public String service(Model model) {
    	model.addAttribute("menu", "service");
    	return "about/service";
    }

    @GetMapping("terms")
    public String terms(Model model) {
        model.addAttribute("menu", "terms");
        model.addAttribute("title", "서비스 이용약관");
        return "about/intro";
    }

    @GetMapping("privacy")
    public String privacy(Model model) {
        model.addAttribute("menu", "privacy");
        model.addAttribute("title", "개인정보처리방침");
        return "about/intro";
    }
    
    @GetMapping("support")
    public String support(Model model, 
    		@AuthenticationPrincipal CustomUserDetails userDetails) {
    	
    	model.addAttribute("userId", "");
        model.addAttribute("userName", "");
        model.addAttribute("userMail", "");
    	
        if (userDetails != null) {
            try {
                model.addAttribute("userId", userDetails.getMember().getUserId());
                model.addAttribute("userName", userDetails.getMember().getName());
                model.addAttribute("userMail", userDetails.getMember().getEmail());
            } catch (Exception e) {
            	log.info("support : ", e);
            }
        }
    	
        return "about/support";
    }
}