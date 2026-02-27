package com.sp.app.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.sp.app.common.RequestUtils;
import com.sp.app.domain.dto.UserDto;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.MemberService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping(value = "/member/*")
public class MemberController {
	private final MemberService service;
	
	@Value("${file.upload-root}/trade")
    private String uploadPath;
	
	@RequestMapping(value = "login", method = {RequestMethod.GET, RequestMethod.POST})
	public String loginForm(@RequestParam(name = "error", required = false) String error,
			@AuthenticationPrincipal CustomUserDetails userDetails,
			RedirectAttributes rattr,
			Model model) {
		
		if(userDetails != null) {
			rattr.addFlashAttribute("msg", "이미 로그인된 상태입니다.");
			return "redirect:/";
		}
		
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
    public String joinForm(
    		@AuthenticationPrincipal CustomUserDetails userDetails,
    		RedirectAttributes rattr, Model model) {
		
		if(userDetails != null) {
			rattr.addFlashAttribute("msg", "이미 로그인된 상태입니다.");
			return "redirect:/";
		}

        return "member/join";
    }
	
	@GetMapping("complete")
    public String complete(HttpSession session, Model model) {
		
		String nickname = (String) session.getAttribute("completeNickname");
		String userId = (String) session.getAttribute("completeUserId");
	    if (nickname == null || userId == null) {
	        return "redirect:/";
	    }
	    
	    model.addAttribute("nickname", nickname);
	    model.addAttribute("userId", userId);
	    
	    session.removeAttribute("completeNickname");
	    session.removeAttribute("completeUserId");

        return "member/complete";
    }

}
