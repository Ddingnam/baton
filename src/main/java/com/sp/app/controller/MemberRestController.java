package com.sp.app.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;

import com.sp.app.common.MyUtil;
import com.sp.app.domain.dto.GuestSessionInfo;
import com.sp.app.domain.dto.RegionDto;
import com.sp.app.domain.dto.SnsUserDto;
import com.sp.app.domain.dto.UserDto;
import com.sp.app.domain.dto.UserRegionInfo;
import com.sp.app.mail.Mail;
import com.sp.app.mail.MailSender;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.security.LoginSnsSuccessHandler;
import com.sp.app.service.MemberService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping(value = "/member/*")
@SessionAttributes("guestInfo")
public class MemberRestController {
	private final MemberService service;
	private final MailSender mailSender;
	
	private final LoginSnsSuccessHandler successHandler;
	
	@Value("${file.upload-root}/trade")
    private String uploadPath;
	
	@ModelAttribute("guestInfo")
    public GuestSessionInfo setupGuestInfo() {
        return new GuestSessionInfo();
    }
	
	@GetMapping("checkDuplicated")
    public ResponseEntity<?> checkDuplicated(
    		@RequestParam("type") String type,
    		@RequestParam("input") String input) {
		Map<String, Object> model = new HashMap<>();

		if (type == null || input == null || input.trim().isEmpty()) {
			model.put("state", "null");
			return ResponseEntity.ok(model);
		}
		
        try {
        	boolean isDuplicated = false;
        	
        	if("userId".equals(type)) {
        		isDuplicated = service.isUserIdDuplicated(input);
        	} else if ("nickname".equals(type)){
        		isDuplicated = service.isNicknameDuplicated(input);
        	} else {
        		model.put("state", "invalidType");
                return ResponseEntity.ok(model);
        	}
	        
        	model.put("state", isDuplicated ? "duplicated" : "available");
            return ResponseEntity.ok(model);
        	
        } catch (Exception e) {
        	log.info("checkDuplicated(" + type + ") error: ", e);
            model.put("state", "serverError");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(model);
        }
    }
    
    @PostMapping("sendAuthEmail")
    public ResponseEntity<?> sendAuthEmail(
    		@RequestParam("email") String email,
            @ModelAttribute("guestInfo") GuestSessionInfo guestInfo
            ) throws Exception {

        Map<String, Object> model = new HashMap<>();

        try {
        	guestInfo.clearAll();
        	
        	/*
        	if(service.isEmailDuplicated(email)) {
        		model.put("state", "duplicated");
        		return ResponseEntity.ok(model);
        	}
        	*/
            
            String subject = "[BATON] 회원가입을 위한 이메일 인증번호입니다.";
            String authCode = MyUtil.generateAuthCode();
            
            String content = 
                    "<div style='background-color: #F9FAFB; padding: 60px 20px; font-family: \"Pretendard\", -apple-system, \"Malgun Gothic\", sans-serif;'>"
                    + "  <div style='max-width: 480px; margin: 0 auto; background-color: #FFFFFF; border-radius: 32px; padding: 50px 40px; text-align: center; box-shadow: 0 10px 30px rgba(0,0,0,0.05); border: 1px solid #E5E8EB;'>"
                    + "    <div style='margin: 0 auto 24px auto; width: 64px; height: 64px; background-color: #E8F3FF; border-radius: 50%; display: block;'>"
                    + "      <div style='line-height: 64px; color: #3182F6; font-size: 28px; font-weight: 900; font-family: Arial, sans-serif;'>B</div>"
                    + "    </div>"
                    + "    <h2 style='font-size: 24px; font-weight: 800; color: #191F28; margin: 0 0 16px 0; letter-spacing: -0.5px;'>이메일 인증번호</h2>"
                    + "    <p style='font-size: 15px; color: #4E5968; line-height: 1.6; margin: 0 0 40px 0;'>"
                    + "      바톤에 오신 것을 환영합니다!<br>"
                    + "      안전한 가입을 위해 아래 <b>인증번호 6자리</b>를 입력해 주세요."
                    + "    </p>"
                    + "    <div style='background-color: #F2F7FF; border: 1px dashed #3182F6; border-radius: 16px; padding: 32px 0; margin-bottom: 40px; text-align: center;'>"
                    + "      <div style='font-size: 13px; color: #3182F6; font-weight: 700; margin-bottom: 12px;'>인증번호</div>"
                    + "      <div style='font-size: 40px; font-weight: 800; color: #191F28; letter-spacing: 14px; margin-left: 14px; display: inline-block; vertical-align: middle;'>" + authCode + "</div>"
                    + "    </div>"
                    + "    <p style='font-size: 13px; color: #8B95A1; line-height: 1.6; margin: 0;'>"
                    + "      본 인증번호는 <b>3분간</b> 유효합니다.<br>"
                    + "      타인에게 절대 노출되지 않도록 주의해 주세요."
                    + "    </p>"
                    + "    <div style='margin: 40px 0 30px; border-top: 1px solid #F2F4F6;'></div>"
                    + "    <p style='font-size: 12px; color: #8B95A1; line-height: 1.8; margin: 0;'>"
                    + "      본 메일은 발신 전용입니다.<br>"
                    + "      ⓒ 2026 BATON. All rights reserved."
                    + "    </p>"
                    + "  </div>"
                    + "</div>";
            
            Mail dto = new Mail();
            dto.setSenderName("BATON");
            dto.setSenderEmail("jmn5316@gmail.com");
            dto.setReceiverEmail(email);
            dto.setSubject(subject);
            dto.setContent(content);
            
            boolean b = mailSender.mailSend(dto);
            
            if( b ) {
            	guestInfo.resetEmailAuth(email, authCode);
                model.put("state", "true");
                model.put("message", "인증번호가 전송되었습니다.");
                
                return ResponseEntity.ok(model);
            } else {
                model.put("state", "false");
                model.put("message", "메일 전송에 실패했습니다.");
                
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(model);
            }
            
        } catch (Exception e) {
            model.put("state", "false");
            model.put("message", "서버 오류가 발생했습니다.");
            
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(model);
        }
    }
    
    @PostMapping("chkAuthCode")
    public ResponseEntity<?> chkAuthCode(
    		@RequestParam("userCode") String userCode,
    		@RequestParam("email") String currentEmail,
    		@ModelAttribute("guestInfo") GuestSessionInfo guestInfo
            ) throws Exception {

        Map<String, Object> model = new HashMap<>();

        try {
            
        	if (userCode == null || userCode.trim().isEmpty()) {
                model.put("state", "null");
                return ResponseEntity.ok(model);
            }
        	
        	String authCode = guestInfo.getAuthCode();
	        Long authCodeTime = guestInfo.getAuthCodeTime();
	        String targetEmail = guestInfo.getTargetEmail();
        	
	        if (authCode == null || authCodeTime == null || targetEmail == null) {
	        	model.put("state", "expired");
	            return ResponseEntity.ok(model);
	        }
	        
	        if(!targetEmail.equals(currentEmail)) {
	        	model.put("state", "invalidEmail");
	            return ResponseEntity.ok(model);
	        }
	        
	        long currentTime = System.currentTimeMillis();
	        if (currentTime - authCodeTime > 3 * 60 * 1000) {
	        	guestInfo.clearAll();
	            model.put("state", "timeout");
	            return ResponseEntity.ok(model);
	        }

	        if (!authCode.equals(userCode)) {
	        	model.put("state", "invalidCode");
                return ResponseEntity.ok(model);
	        }
	        
	        guestInfo.setVerified(true);
	        guestInfo.setVerifiedEmail(targetEmail);
	        
	        guestInfo.setAuthCode(null);
	        guestInfo.setAuthCodeTime(null);
        	
	        model.put("state", "success");
        	return ResponseEntity.ok(model);
        	
        } catch (Exception e) {
        	log.info("Email verification error: ", e);
            model.put("state", "serverError");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(model);
        }
    }
    
    @PostMapping("register")
    public ResponseEntity<?> register(
    		UserDto dto, @ModelAttribute("guestInfo") GuestSessionInfo guestInfo) {
    	Map<String, Object> model = new HashMap<>();
    	
		try {
			service.insertUser(dto, uploadPath);
			
			guestInfo.setCompleteUserId(dto.getUserId());
			guestInfo.setCompleteNickname(dto.getNickname());
			
			model.put("state", "success");
        	return ResponseEntity.ok(model);
		} catch (Exception e) {
			log.info("Register error: ", e);
            model.put("state", "serverError");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(model);
		}
    }
    
    @PostMapping("findId")
    public ResponseEntity<?> findId(
    		@RequestParam("name") String name,
    		@RequestParam("email") String email,
    		SessionStatus status) {
    	Map<String, Object> model = new HashMap<>();
    	
		try {
			Map<String, Object> map = new HashMap<>();
			map.put("name", name);
			map.put("email", email);
			
			String userId = service.findUserId(map);
			
			if(userId == null) {
				model.put("state", "fail");
				return ResponseEntity.ok(model);
			}
			
			String maskedId = "";
	        if (userId.length() > 3) {
	            maskedId = userId.substring(0, 3) + "*".repeat(userId.length() - 3);
	        } else {
	            maskedId = userId.substring(0, 1) + "*".repeat(userId.length() - 1);
	        }
			
	        status.setComplete();
			model.put("state", "success");
			model.put("userId", maskedId);
        	return ResponseEntity.ok(model);
		} catch (Exception e) {
			log.info("findId error: ", e);
            model.put("state", "serverError");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(model);
		}
    }
    
    @PostMapping("findPwd")
    public ResponseEntity<?> findPwd(
    		@RequestParam("userId") String userId,
    		@RequestParam("email") String email,
    		@ModelAttribute("guestInfo") GuestSessionInfo guestInfo,
    		Model model) {
    	Map<String, Object> responseModel = new HashMap<>();
    	
		try {
			Map<String, Object> map = new HashMap<>();
			map.put("userId", userId);
			map.put("email", email);
			
			long userIdx= service.findByUserIdAndEmail(map);
			
			if(userIdx <= 0) {
				responseModel.put("state", "fail");
				return ResponseEntity.ok(model);
			}
			
			guestInfo.clearAll();
			
			String subject = "[BATON] 비밀번호 변경을 위한 이메일 인증번호입니다.";
            String authCode = MyUtil.generateAuthCode();
            
            String content = 
                    "<div style='background-color: #F9FAFB; padding: 60px 20px; font-family: \"Pretendard\", -apple-system, \"Malgun Gothic\", sans-serif;'>"
                    + "  <div style='max-width: 480px; margin: 0 auto; background-color: #FFFFFF; border-radius: 32px; padding: 50px 40px; text-align: center; box-shadow: 0 10px 30px rgba(0,0,0,0.05); border: 1px solid #E5E8EB;'>"
                    + "    <div style='margin: 0 auto 24px auto; width: 64px; height: 64px; background-color: #E8F3FF; border-radius: 50%; display: block;'>"
                    + "      <div style='line-height: 64px; color: #3182F6; font-size: 28px; font-weight: 900; font-family: Arial, sans-serif;'>B</div>"
                    + "    </div>"
                    + "    <h2 style='font-size: 24px; font-weight: 800; color: #191F28; margin: 0 0 16px 0; letter-spacing: -0.5px;'>이메일 인증번호</h2>"
                    + "    <p style='font-size: 15px; color: #4E5968; line-height: 1.6; margin: 0 0 40px 0;'>"
                    + "      안전한 비밀번호 변경을 위해 아래 <b>인증번호 6자리</b>를 입력해 주세요."
                    + "    </p>"
                    + "    <div style='background-color: #F2F7FF; border: 1px dashed #3182F6; border-radius: 16px; padding: 32px 0; margin-bottom: 40px; text-align: center;'>"
                    + "      <div style='font-size: 13px; color: #3182F6; font-weight: 700; margin-bottom: 12px;'>인증번호</div>"
                    + "      <div style='font-size: 40px; font-weight: 800; color: #191F28; letter-spacing: 14px; margin-left: 14px; display: inline-block; vertical-align: middle;'>" + authCode + "</div>"
                    + "    </div>"
                    + "    <p style='font-size: 13px; color: #8B95A1; line-height: 1.6; margin: 0;'>"
                    + "      본 인증번호는 <b>3분간</b> 유효합니다.<br>"
                    + "      타인에게 절대 노출되지 않도록 주의해 주세요."
                    + "    </p>"
                    + "    <div style='margin: 40px 0 30px; border-top: 1px solid #F2F4F6;'></div>"
                    + "    <p style='font-size: 12px; color: #8B95A1; line-height: 1.8; margin: 0;'>"
                    + "      본 메일은 발신 전용입니다.<br>"
                    + "      ⓒ 2026 BATON. All rights reserved."
                    + "    </p>"
                    + "  </div>"
                    + "</div>";
            
            Mail dto = new Mail();
            dto.setSenderName("BATON");
            dto.setSenderEmail("jmn5316@gmail.com");
            dto.setReceiverEmail(email);
            dto.setSubject(subject);
            dto.setContent(content);
            
            boolean b = mailSender.mailSend(dto);
            
            if( b ) {
            	guestInfo.resetEmailAuth(email, authCode);
            	guestInfo.setFindUserIdx(userIdx);
            	model.addAttribute("guestInfo", guestInfo);
            	
            	log.info(">>>> [findPwd] 세션 저장 직전 userIdx: {}", guestInfo.getFindUserIdx());
            	
            	responseModel.put("state", "success");
                return ResponseEntity.ok(responseModel);
            } else {
            	responseModel.put("state", "fail");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(responseModel);
            }
		} catch (Exception e) {
			log.info("findId error: ", e);
			responseModel.put("state", "serverError");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(responseModel);
		}
    }
    
    @PostMapping("updatePassword")
    public ResponseEntity<?> updatePassword(
            @RequestParam("pwd") String pwd,
            @ModelAttribute("guestInfo") GuestSessionInfo guestInfo,
            SessionStatus status) {

        Map<String, Object> model = new HashMap<>();
        log.info(">>>> 세션에서 꺼낸 userIdx: {}", guestInfo.getFindUserIdx());
        
        try {
            Long userIdx = guestInfo.getFindUserIdx();
            
            if (userIdx == null) {
                model.put("state", "fail");
                return ResponseEntity.ok(model);
            }
            
            Map<String, Object> map = new HashMap<>();
            map.put("userIdx", userIdx);
            map.put("pwd", pwd);

            service.updateUserPwd(map);

            status.setComplete();

            model.put("state", "success");
            return ResponseEntity.ok(model);
            
        } catch (Exception e) {
            log.error("updatePassword error", e);
            model.put("state", "serverError");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(model);
        }
    }
    
    @PostMapping("linkAccount")
    public ResponseEntity<?> linkAccount(
    		@RequestParam("pwd") String pwd,
    		@ModelAttribute("guestInfo") GuestSessionInfo guestInfo) {
    	Map<String, Object> model = new HashMap<>();
    	
		try {
			Map<String, Object> map = new HashMap<>();
			map.put("userId", guestInfo.getLinkedUserId());
			map.put("pwd", pwd);
			
			UserDto userDto = service.loginUser(map);
			
			if(userDto == null) {
				model.put("state", "fail");
				return ResponseEntity.ok(model);
			}
			
			SnsUserDto snsUserDto = guestInfo.getSnsUserDto();
			snsUserDto.setUserIdx(userDto.getUserIdx());
			service.insertSnsUser(snsUserDto);
			
			userDto.setProvider(snsUserDto.getProvider());
			successHandler.forceLogin(userDto);
			
			model.put("state", "success");
        	return ResponseEntity.ok(model);
        	
		} catch (Exception e) {
			log.info("findId error: ", e);
            model.put("state", "serverError");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(model);
		}
    }
    
    @PostMapping("verifyLocation")
    public ResponseEntity<?> verifyLocation(
    		@AuthenticationPrincipal CustomUserDetails userDetails,
    		@RequestBody RegionDto regionDTO,
    		HttpSession session) {
    	Map<String, Object> model = new HashMap<>();
    	
    	if(userDetails == null) {
    		model.put("state", "fail");
    		return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(model);
    	}
    	
        try {
            Long userIdx = userDetails.getMember().getUserIdx();
            regionDTO.setUserIdx(userIdx);

            service.saveRegion(regionDTO);
            
            UserRegionInfo userRegionInfo = service.getUserRegionInfo(userIdx);
            userDetails.getMember().setUserRegionInfo(userRegionInfo);
            
            model.put("state", "success");
            return ResponseEntity.ok(model);

        } catch (Exception e) {
        	log.info("verifyLocation error: ", e);
            model.put("state", "serverError");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(model);
        }
    }
    
	

}
