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
import org.springframework.web.servlet.FlashMap;
import org.springframework.web.servlet.FlashMapManager;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.sp.app.domain.dto.SessionInfo;
import com.sp.app.domain.dto.UserDto;
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
			memberService.updateFailureCountReset(authentication.getName());
			
			UserDto dto = memberService.findByLoginId(authentication.getName());
			
			DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
			LocalDateTime curDate = LocalDateTime.now();
			LocalDateTime targetDate = LocalDateTime.parse(dto.getUpdatedDate(), dtf);
			long daysBetween = ChronoUnit.DAYS.between(targetDate, curDate);
			
			if(daysBetween >= 90) {
				String targetUrl = "/member/updatePwd";
				redirectStrategy.sendRedirect(request, response, targetUrl);
				return;
			}
			
		} catch (Exception e) {
		}
		
		resultRedirectStrategy(request, response, authentication);
	}
	
	protected void resultRedirectStrategy(HttpServletRequest request, 
	        HttpServletResponse response,
	        Authentication authentication) throws IOException, ServletException {

		request.getSession().setAttribute("msg", authentication.getName() + "님, 환영합니다!");
		
		try {
		    UserDto dto2 = memberService.findByLoginId(authentication.getName());
		    SessionInfo info = new SessionInfo();
		    info.setUserIdx(dto2.getUserIdx());
		    info.setUserId(dto2.getUserId());
		    info.setName(dto2.getName());
		    info.setEmail(dto2.getEmail());
		    info.setUserLevel(dto2.getUserLevel());
		    info.setAvatar(dto2.getProfile_photo());
		    info.setLogin_type("local");
		    request.getSession().setAttribute("member", info);
		} catch (Exception e) {
			
		}
	    
	    SavedRequest savedRequest = requestCache.getRequest(request, response);

	    if (savedRequest != null) {
	        String targetUrl = savedRequest.getRedirectUrl();
	        redirectStrategy.sendRedirect(request, response, targetUrl);
	    } else {
	        if (defaultUrl == null || defaultUrl.isEmpty()) {
	            redirectStrategy.sendRedirect(request, response, "/");
	        } else {
	            redirectStrategy.sendRedirect(request, response, defaultUrl);
	        }
	    }
	}

	public void setDefaultUrl(String defaultUrl) {
		this.defaultUrl = defaultUrl;
	}
}
