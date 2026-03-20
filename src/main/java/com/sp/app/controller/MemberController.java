package com.sp.app.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.sp.app.domain.dto.GuestSessionInfo;
import com.sp.app.domain.dto.SnsUserDto;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.MemberService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping(value = "/member/*")
@SessionAttributes("guestInfo")
public class MemberController {
	private final MemberService service;
	
	@Value("${file.upload-root}/trade")
    private String uploadPath;
	
	@RequestMapping(value = "login", method = {RequestMethod.GET, RequestMethod.POST})
	public String loginForm(@RequestParam(name = "error", required = false) String error,
			@AuthenticationPrincipal CustomUserDetails userDetails,
			RedirectAttributes rattr,
			HttpSession session,
			Model model) {
		
		if(userDetails != null) {
			rattr.addFlashAttribute("msg", "이미 로그인된 상태입니다.");
			return "redirect:/";
		}
		
		if(error != null) {
			model.addAttribute("loginErrMsg", "아이디 또는 패스워드가 일치하지 않습니다.");
		}
		
		GuestSessionInfo guestInfo = (GuestSessionInfo) session.getAttribute("guestInfo");
	    if (guestInfo != null) {
	        guestInfo.clearAll(); 
	        model.addAttribute("guestInfo", guestInfo);
	    }
	    
		return "member/login";
	}
	
	@GetMapping("townAuth")
	public String townAuth(Model model) {
		model.addAttribute("mode", "account");
		
		return "member/townAuth";
	}
	
	@GetMapping("/regionAuth/{type}")
	public String regionAuth(
			@AuthenticationPrincipal CustomUserDetails userDetails,
			@PathVariable(name = "type") String type,
			RedirectAttributes rattr,
			Model model) {
		
		if(userDetails == null) {
			rattr.addFlashAttribute("msg", "로그인이 필요한 서비스입니다.");
			return "redirect:/";
		}
		
	    model.addAttribute("regionType", type.equals("main") ? 1 : 2);
	    
	    return "member/regionAuth";
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
	
	@GetMapping("findId")
	public String findIdForm(
			@AuthenticationPrincipal CustomUserDetails userDetails,
			RedirectAttributes rattr) {
		
		if(userDetails != null) {
			rattr.addFlashAttribute("msg", "이미 로그인된 상태입니다.");
			return "redirect:/";
		}
		
		return "member/findId";
	}
	
	@GetMapping("findPwd")
	public String findPwdForm(
			@AuthenticationPrincipal CustomUserDetails userDetails,
			RedirectAttributes rattr) {
		
		if(userDetails != null) {
			rattr.addFlashAttribute("msg", "이미 로그인된 상태입니다.");
			return "redirect:/";
		}
		
		return "member/findPwd";
	}
	
	@GetMapping("updatePwd")
	public String updatePwdForm(
			@AuthenticationPrincipal CustomUserDetails userDetails,
			RedirectAttributes rattr,
			HttpSession session) {
		
		if(userDetails != null) {
			rattr.addFlashAttribute("msg", "이미 로그인된 상태입니다.");
			return "redirect:/";
		}
		
		GuestSessionInfo guestInfo = (GuestSessionInfo) session.getAttribute("guestInfo");
	    
	    if (guestInfo == null || guestInfo.getFindUserIdx() == null|| !guestInfo.isVerified()) {
	        rattr.addFlashAttribute("msg", "인증 정보가 만료되었거나 비정상적인 접근입니다.");
	        return "redirect:/";
	    }
	    
		return "member/updatePwd";
	}
	
	@GetMapping("linkAccount")
	public String linkAccount(
			@AuthenticationPrincipal CustomUserDetails userDetails,
			RedirectAttributes rattr,
			HttpSession session,
			Model model) {
		
		if(userDetails != null) {
			rattr.addFlashAttribute("msg", "이미 로그인된 상태입니다.");
			return "redirect:/";
		}
		
		GuestSessionInfo guestInfo = (GuestSessionInfo) session.getAttribute("guestInfo");
	    
	    if (guestInfo == null || guestInfo.getLinkedUserEmail() == null || guestInfo.getLinkedUserId() == null) {
	        rattr.addFlashAttribute("msg", "비정상적인 접근입니다.");
	        return "redirect:/member/login";
	    }
	    
	    model.addAttribute("userId", guestInfo.getLinkedUserId());
	    model.addAttribute("email", guestInfo.getLinkedUserEmail());
	    
		return "member/linkAccount";
	}
	
	@GetMapping("complete")
    public String complete(
			@AuthenticationPrincipal CustomUserDetails userDetails,
			RedirectAttributes rattr,
			HttpSession session,
			SessionStatus status,
			Model model) {
		
		if(userDetails != null) {
			rattr.addFlashAttribute("msg", "이미 로그인된 상태입니다.");
			return "redirect:/";
		}
		
		GuestSessionInfo guestInfo = (GuestSessionInfo) session.getAttribute("guestInfo");
		if (guestInfo == null) {
	        return "redirect:/";
	    }
		
		String nickname = guestInfo.getCompleteNickname();
		String userId = guestInfo.getCompleteUserId();
		
	    if (nickname == null || userId == null) {
	        return "redirect:/";
	    }
	    
	    model.addAttribute("nickname", nickname);
	    model.addAttribute("userId", userId);
	    
	    status.setComplete();

        return "member/complete";
    }
	
	@GetMapping("linkComplete")
    public String linkComplete(
			@AuthenticationPrincipal CustomUserDetails userDetails,
			RedirectAttributes rattr,
			HttpSession session,
			SessionStatus status,
			Model model) {
		
		if(userDetails == null) {
			rattr.addFlashAttribute("msg", "비정상적인 접근입니다.");
			return "redirect:/";
		}
		
		GuestSessionInfo guestInfo = (GuestSessionInfo) session.getAttribute("guestInfo");
	    
	    if (guestInfo == null || guestInfo.getSnsUserDto() == null || guestInfo.getLinkedUserId() == null) {
	        rattr.addFlashAttribute("msg", "비정상적인 접근입니다.");
	        return "redirect:/member/login";
	    }
		
	    SnsUserDto snsUserDto = guestInfo.getSnsUserDto();
	    String provider = switch(snsUserDto.getProvider()) {
	    		case "K" -> "Kakao";
	    		case "N" -> "Naver";
	    		case "G" -> "Google";
	    		default -> "unknown";
	    };
	    
	    model.addAttribute("userId", guestInfo.getLinkedUserId());
	    model.addAttribute("nickname", guestInfo.getLinkedUserNickname());
	    model.addAttribute("provider", provider);
	    
	    status.setComplete();
	    
		return "member/linkComplete";
	}
	
	

}