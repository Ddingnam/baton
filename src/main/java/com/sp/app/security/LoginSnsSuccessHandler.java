package com.sp.app.security;

import java.util.Arrays;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import com.sp.app.common.RequestUtils;
import com.sp.app.domain.dto.SessionInfo;
import com.sp.app.domain.dto.UserDto;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class LoginSnsSuccessHandler {
	public void forceLogin(UserDto dto) throws Exception{
		try {
			SessionInfo info = SessionInfo.builder()
					.userIdx(dto.getUserIdx())
					.userId(dto.getUserId())
					.name(dto.getName())
					.email(dto.getEmail())
					.userLevel(NumericRoleGranted.getUserLevel("USER"))					
					.login_type(dto.getProvider())
					.build();
			
			CustomUserDetails userDetails = CustomUserDetails.builder()
					.sessionInfo(info)
					.disabled(dto.getStatus() == 0)
					.roles(Arrays.asList(dto.getAuthority()))
					.build();
			
			// 시큐리티 로그인 처리
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
		    session.setAttribute("SPRING_SECURITY_CONTEXT", securityContext);	
		    
		} catch (Exception e) {
			log.info("forceLogin : ", e);
			
			throw e;
		}
	}
}
