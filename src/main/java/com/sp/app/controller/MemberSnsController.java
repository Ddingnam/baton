package com.sp.app.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sp.app.common.MyUtil;
import com.sp.app.common.RequestUtils;
import com.sp.app.domain.dto.GuestSessionInfo;
import com.sp.app.domain.dto.SnsUserDto;
import com.sp.app.domain.dto.UserDto;
import com.sp.app.oauth.KakaoAuthService;
import com.sp.app.oauth.KakaoUser;
import com.sp.app.security.LoginSnsSuccessHandler;
import com.sp.app.service.MemberService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
public class MemberSnsController {
	private final MemberService memberService;
	private final KakaoAuthService kakaoService;
	
	private final LoginSnsSuccessHandler successHandler;
	
	public static final String SNS_PROVIDER_KAKAO = "K";
	public static final String SNS_PROVIDER_NAVER = "N";
	public static final String SNS_PROVIDER_GOOGLE = "G";
	
	@Value("${file.upload-root}/trade")
    private String uploadPath;
	
	@GetMapping("/oauth/kakao/callback")
	public ResponseEntity<?> kakaoLogin(@RequestParam("code") String code,
			HttpSession session) throws Exception {
		String cp = RequestUtils.getContextPath();
		try {
			String accessToken = kakaoService.getAccessToken(code);
			KakaoUser kakaoUser = kakaoService.getUserInfo(accessToken);
			String sns_id = kakaoUser.getId().toString();
			String sns_provider = SNS_PROVIDER_KAKAO;
			
			Map<String, Object> map = new HashMap<>();
			map.put("oauthId", sns_id);
			map.put("provider", sns_provider);
			
			SnsUserDto snsUserDto = memberService.loginSnsUser(map);
			
			// SNS 연동된 계정이 있는 경우
			if(snsUserDto != null) {
				UserDto userDto = memberService.findById(snsUserDto.getUserIdx());
				userDto.setProvider(sns_provider);
				
				successHandler.forceLogin(userDto);
				return getScriptResponse(cp + "/");
			}
			
			SnsUserDto newSnsUserDto = new SnsUserDto();
			newSnsUserDto.setOauthId(sns_id);
			newSnsUserDto.setProvider(sns_provider);
			
			UserDto userDto = memberService.findByEmail(kakaoUser.getEmail());
			GuestSessionInfo guestInfo = new GuestSessionInfo();
			
			// 일반 계정은 있으나 연동이 되지 않은 경우
			if(userDto != null) {
				guestInfo.setSnsUserDto(newSnsUserDto);
				guestInfo.setLinkedUserId(userDto.getUserId());
				guestInfo.setLinkedUserEmail(userDto.getEmail());
				
				session.setAttribute("guestInfo", guestInfo);
				return getScriptResponse(cp + "/member/linkAccount");
			}
			
			// 신규 계정
			UserDto newUserDto = new UserDto();
			
			newUserDto.setUserId(sns_provider + "_" + MyUtil.generateUUID());
			newUserDto.setNickname(kakaoUser.getNickname());
			newUserDto.setEmail(kakaoUser.getEmail());
			
			memberService.insertUser(newUserDto, newSnsUserDto, uploadPath);
			successHandler.forceLogin(newUserDto);
			
			guestInfo.setCompleteUserId(newUserDto.getUserId());
			guestInfo.setCompleteNickname(newUserDto.getNickname());
			session.setAttribute("guestInfo", guestInfo);
			
			return getScriptResponse(cp + "/member/complete");
			
		} catch (Exception e) {
			log.info("kakaoLogin : ", e);
			return getScriptResponse(cp + "/member/login?error=sns");
		}	
	}
	
	private ResponseEntity<String> getScriptResponse(String uri) {
	    String script = "<script>window.opener.location.replace('" + uri + "'); window.close();</script>";
	    return ResponseEntity.ok()
	            .contentType(MediaType.valueOf("text/html;charset=UTF-8"))
	            .body(script);
	}
	
}
