package com.sp.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.sp.app.service.MemberService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping(value = "/member/*")
public class MemberController {
	private final MemberService service;
	
	@RequestMapping(value = "login", method = {RequestMethod.GET, RequestMethod.POST})
	public String loginForm(@RequestParam(name = "error", required = false) String error, 
			Model model) {
		
		if(error != null) {
			model.addAttribute("message", "아이디 또는 패스워드가 일치하지 않습니다.");
		}
		
		return "member/login";
	}
	
	@GetMapping("townAuth")
	public String townAuth(Model model) {
		model.addAttribute("mode", "account");
		
		return "member/townAuth";
	}
	
	@GetMapping("join")
    public String joinForm(@RequestParam(value = "town", required = false) String town, Model model) {
        
        if (town == null || town.trim().isEmpty()) {
            return "redirect:/member/townAuth"; 
        }

        model.addAttribute("town", town);

        return "member/join";
    }

}
