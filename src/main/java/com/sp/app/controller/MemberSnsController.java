package com.sp.app.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sp.app.common.RequestUtils;
import com.sp.app.domain.dto.UserDto;
import com.sp.app.oauth.KakaoAuthService;
import com.sp.app.oauth.KakaoUser;
import com.sp.app.security.LoginSnsSuccessHandler;
import com.sp.app.service.MemberService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
public class MemberSnsController {
	private final MemberService memberService;
	private final KakaoAuthService kakaoService;
	
	private final LoginSnsSuccessHandler successHandler;
	
	public static final String SNS_PROVIDER_KAKAO = "kakao";
	public static final String SNS_PROVIDER_NAVER = "naver";
	public static final String SNS_PROVIDER_GOOGLE = "google";
	
	@GetMapping("/oauth/kakao/callback")
	public ResponseEntity<?> kakaoLogin(@RequestParam("code") String code) throws Exception {
		try {
			System.out.println(code);
			String accessToken = kakaoService.getAccessToken(code);
			KakaoUser kakaoUser = kakaoService.getUserInfo(accessToken);
			String sns_id = kakaoUser.getId().toString();
			String sns_provider = SNS_PROVIDER_KAKAO;
			
			Map<String, Object> map = new HashMap<>();
			map.put("sns_id", sns_id);
			map.put("sns_provider", sns_provider);
			
			UserDto dto = memberService.loginSnsUser(map);
			if(dto == null) {
				dto = new UserDto();
				
				dto.setUserId(sns_provider + "_" + sns_id);
				dto.setOauthId(sns_id);
				dto.setProvider(sns_provider);
				dto.setNickname(kakaoUser.getNickname());
				dto.setName(kakaoUser.getName());
				dto.setBirth(kakaoUser.getBirth());
				dto.setTel(kakaoUser.getTel());
				dto.setEmail(kakaoUser.getEmail());
				
				memberService.insertSnsUser(dto);
			}
			
			successHandler.forceLogin(dto);

		} catch (Exception e) {
			log.info("kakaoLogin : ", e);
		}
		
		String cp = RequestUtils.getContextPath();
		String uri = cp + "/";
		
		StringBuilder sb = new StringBuilder();
		sb.append("<script>");
		// 부모창
		sb.append("window.opener.location.replace('" + uri + "');");
		sb.append("window.close()"); // 로그인 팝업창
		sb.append("</script>");
		
		return ResponseEntity.status(HttpStatus.OK)
				.contentType(MediaType.valueOf("text/html;charset=UTF-8")) // HTML 콘텐츠 타입 설정
				.body(sb.toString());		
	}
	
}
