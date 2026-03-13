package com.sp.app.security;

import java.util.Arrays;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import com.sp.app.common.RequestUtils;
import com.sp.app.domain.dto.SessionInfo;
import com.sp.app.domain.dto.UserDto;
import com.sp.app.domain.dto.UserRegionInfo;
import com.sp.app.service.MemberService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class LoginSnsSuccessHandler {
	
	@Autowired
	private MemberService memberService;
	
	public void forceLogin(UserDto dto) throws Exception{
		try {
			UserRegionInfo userRegionInfo = memberService.getUserRegionInfo(dto.getUserIdx());
			
			SessionInfo info = SessionInfo.builder()
					.userIdx(dto.getUserIdx())
					.userId(dto.getUserId())
					.name(dto.getName())
					.email(dto.getEmail())
					.userLevel(NumericRoleGranted.getUserLevel("USER"))					
					.login_type(dto.getProvider())
					.userRegionInfo(userRegionInfo)
					.build();
			
			CustomUserDetails userDetails = CustomUserDetails.builder()
					.sessionInfo(info)
					.disabled(dto.getStatus() == 0)
					.roles(Arrays.asList(dto.getAuthority()))
					.build();
			
			Authentication authentication =
					new UsernamePasswordAuthenticationToken(
							userDetails,
							null,
							userDetails.getAuthorities()
					);

			SecurityContext securityContext = SecurityContextHolder.getContext();
			securityContext.setAuthentication(authentication);
			
			HttpServletRequest request = RequestUtils.getCurrentRequest();
		    HttpSession session = request.getSession(true);
		    
		    session.setAttribute("msg", dto.getUserId() + "님, 환영합니다!");
		    session.setAttribute("isFirstLogin", true);
		    session.setAttribute("SPRING_SECURITY_CONTEXT", securityContext);	
		    
		} catch (Exception e) {
			log.info("forceLogin : ", e);
			
			throw e;
		}
	}
}
