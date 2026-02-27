package com.sp.app.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.sp.app.common.MyUtil;
import com.sp.app.mail.Mail;
import com.sp.app.mail.MailSender;
import com.sp.app.service.MemberService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping(value = "/member/*")
public class MemberRestController {
	private final MemberService service;
	private final MailSender mailSender;
	
	@GetMapping("chkId")
    public Map<String, Object> checkId(@RequestParam String userId) {
        // boolean available = service.isIdAvailable(userId);
        // return Map.of("available", available);
		return null;
    }

    @GetMapping("chkNickname")
    public Map<String, Object> checkNick(@RequestParam String nickname) {
        // boolean available = service.isNickAvailable(nickname);
        // return Map.of("available", available);
    	return null;
    }
    
    @PostMapping("sendAuthEmail")
    public ResponseEntity<?> sendAuthEmail(
    		@RequestParam("email") String email,
            HttpSession session
            ) throws Exception {

        Map<String, Object> model = new HashMap<>();

        try {
        	session.removeAttribute("authCode");
            session.removeAttribute("authCodeTime");
            session.removeAttribute("targetEmail");
            session.removeAttribute("isVerified");
            session.removeAttribute("verifiedEmail");
            
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
            	session.setAttribute("isVerified", false);
    			session.setAttribute("targetEmail", email);
    			session.setAttribute("authCode", authCode);
    			session.setAttribute("authCodeTime", System.currentTimeMillis());
                
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
            HttpSession session
            ) throws Exception {

        Map<String, Object> model = new HashMap<>();

        try {
            
        	if (userCode == null || userCode.trim().isEmpty()) {
                model.put("state", "null");
                return ResponseEntity.ok(model);
            }
        	
        	String authCode = (String) session.getAttribute("authCode");
	        Long authCodeTime = (Long) session.getAttribute("authCodeTime");
	        String targetEmail = (String)session.getAttribute("targetEmail");
        	
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
	            session.removeAttribute("authCode");
	            session.removeAttribute("authCodeTime");
	            session.removeAttribute("targetEmail");
	            model.put("state", "timeout");
	            return ResponseEntity.ok(model);
	        }

	        if (!authCode.equals(userCode)) {
	        	model.put("state", "invalidCode");
                return ResponseEntity.ok(model);
	        }
	        
	        session.setAttribute("isVerified", true);
	        session.setAttribute("verifiedEmail", targetEmail);
	        
	        session.removeAttribute("authCode");
	        session.removeAttribute("authCodeTime");
        	
	        model.put("state", "success");
        	return ResponseEntity.ok(model);
        	
        } catch (Exception e) {
        	log.info("Email verification error: ", e);
            model.put("state", "serverError");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(model);
        }
    }
	

}
