package com.sp.app.security;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

import com.sp.app.domain.dto.UserDto;
import com.sp.app.service.MemberService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class LoginFailureHandler implements AuthenticationFailureHandler {
	@Autowired
	private MemberService memberService;
	
	private String defaultFailureUrl;
	
	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException exception) throws IOException, ServletException {

		String login_id = request.getParameter("login_id");
		String loginType = request.getParameter("loginType");
		
		String redirectUrl = defaultFailureUrl;
		
		if ("ADMIN".equals(loginType)) {
			redirectUrl = request.getContextPath() + "/admin/login?error";
		} else {
			redirectUrl = request.getContextPath() + defaultFailureUrl;
		}

		// Spring Security 6에서 DisabledException이 InternalAuthenticationServiceException으로
		// 래핑될 수 있으므로 getCause()까지 함께 확인
		Throwable actual = exception;
		if (actual instanceof InternalAuthenticationServiceException && actual.getCause() != null) {
			actual = actual.getCause();
		}

		// ★ DisabledException은 try-catch 바깥에서 독립 처리
		// 기존 코드는 전체 try-catch 안에 있어서 내부 예외가 catch에 잡히면
		// redirectUrl이 ?error 그대로 유지돼 안내 메시지가 절대 안 떴음
		if (actual instanceof DisabledException) {
			try {
				UserDto dto = memberService.findByLoginId(login_id);
				if (dto != null && dto.getStatus() == 8) {
					redirectUrl = defaultFailureUrl.replace("?error", "?withdraw");
				}
			} catch (Exception e) {
				// findByLoginId가 실패해도 DisabledException인 이상 ?withdraw로 이동
				log.warn("탈퇴 상태 확인 중 오류 (login_id={}): {}", login_id, e.getMessage());
				redirectUrl = defaultFailureUrl.replace("?error", "?withdraw");
			}
			response.sendRedirect(redirectUrl);
			return;
		}

		// 일반 로그인 실패 처리
		try {
			if (exception instanceof BadCredentialsException) {

				int cnt = memberService.checkFailureCount(login_id);
				if (cnt <= 4) {
					memberService.updateFailureCount(login_id);
				}

				if (cnt >= 4) {
					UserDto dto = memberService.findByLoginId(login_id);

					Map<String, Object> map = new HashMap<>();
					map.put("status", 0);
					map.put("userIdx", dto.getUserIdx());
					memberService.updateUserEnabled(map);
				}

			} else if (exception instanceof InternalAuthenticationServiceException) {
				log.info("Login Failure - 존재하지 않는 아이디: {}", login_id);
			}

		} catch (Exception e) {
			log.info("Login Failure 처리 중 오류: ", e);
		}

		response.sendRedirect(redirectUrl);
	}

	public void setDefaultFailureUrl(String defaultFailureUrl) {
		this.defaultFailureUrl = defaultFailureUrl;
	}
}