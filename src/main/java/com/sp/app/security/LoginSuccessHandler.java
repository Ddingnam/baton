package com.sp.app.security;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;

import com.sp.app.domain.dto.MemberDto;
import com.sp.app.service.MemberService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class LoginSuccessHandler implements AuthenticationSuccessHandler{
	private RequestCache requestCache = new HttpSessionRequestCache();
	private RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();
	private String defaultUrl;
	
	@Autowired
	private MemberService memberService;
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		
		try {
			memberService.updateLastLogin(authentication.getName());
			
			MemberDto dto = memberService.findById(authentication.getName());
			
			DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
			LocalDateTime curDate = LocalDateTime.now();
			LocalDateTime targetDate = LocalDateTime.parse(dto.getUpdate_at(), dtf);
			long daysBetween = ChronoUnit.DAYS.between(targetDate, curDate);
			
			/*
			if(daysBetween >= 90) {
				String targetUrl = "/member/updatePwd";
				redirectStrategy.sendRedirect(request, response, targetUrl);
				return;
			}
			*/
			
		} catch (Exception e) {
		}
		
		resultRedirectStrategy(request, response, authentication);
	}
	
	protected void resultRedirectStrategy(HttpServletRequest request, 
	        HttpServletResponse response,
	        Authentication authentication) throws IOException, ServletException {

	    // 1. 세션에 저장된 이전 요청 정보를 가져옴
	    SavedRequest savedRequest = requestCache.getRequest(request, response);

	    System.out.println("----- [로그인 성공 후 리다이렉트 체크 시작] -----");

	    if (savedRequest != null) {
	        // Case A: 사용자가 로그인 전에 가려던 페이지가 있는 경우
	        String targetUrl = savedRequest.getRedirectUrl();
	        System.out.println(">>> [Case A] 저장된 이전 요청 발견!");
	        System.out.println(">>> 이동하려는 주소(targetUrl): " + targetUrl);
	        
	        // 만약 이 주소가 .js나 .css면 여기서 문제가 생기는 겁니다.
	        redirectStrategy.sendRedirect(request, response, targetUrl);

	    } else {
	        // Case B: 직접 로그인 페이지로 와서 가려는 주소가 없는 경우 (보통 메인으로 가야 함)
	        System.out.println(">>> [Case B] 저장된 이전 요청 없음. 기본 설정 주소로 이동합니다.");
	        System.out.println(">>> 이동하려는 주소(defaultUrl): " + defaultUrl);

	        if (defaultUrl == null || defaultUrl.isEmpty()) {
	            System.out.println("!!! [위험] defaultUrl이 null입니다! 강제로 '/'로 리다이렉트 시도");
	            redirectStrategy.sendRedirect(request, response, "/");
	        } else {
	            redirectStrategy.sendRedirect(request, response, defaultUrl);
	        }
	    }
	    
	    System.out.println("----- [로그인 성공 후 리다이렉트 체크 종료] -----");
	}

	public void setDefaultUrl(String defaultUrl) {
		this.defaultUrl = defaultUrl;
	}
}
