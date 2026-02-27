package com.sp.app.mail;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.sp.app.common.MyUtil;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mail/*")
public class MailController {
	private final MailSender mailSender;
	
	@GetMapping("send")
	public String sendForm(Model model) throws Exception {

		return "mail/send";
	}

	@PostMapping("send")
	public String sendSubmit(Mail dto, 
			final RedirectAttributes reAttr) throws Exception {

		dto.setContent(dto.getContent().replaceAll("\n", "<br>"));
		
		boolean b = mailSender.mailSend(dto);
		
		String msg = "<span style='color:blue;'>" + dto.getReceiverEmail() + "</span> 님에게<br>";
		if( b ) {
			msg += "메일을 성공적으로 전송 했습니다.";
		} else {
			msg += "메일을 전송하는데 실패했습니다.";
		}
		
		reAttr.addFlashAttribute("message", msg);
		
		return "redirect:/mail/complete";
	}
	
	@PostMapping("sendAuthEmail")
	public String sendAuthEmail(final RedirectAttributes reAttr) throws Exception {

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
        String msg;
		
		dto.setSenderName("Baton_Myungtato");
		dto.setSenderEmail("jmn5316@gmail.com");
		dto.setReceiverEmail(null);
		dto.setSubject(subject);
		dto.setContent(content);
		
		boolean b = mailSender.mailSend(dto);
		
		if( b ) {
			msg = "메일을 성공적으로 전송 했습니다.";
		} else {
			msg = "메일을 전송하는데 실패했습니다.";
		}
		
		reAttr.addFlashAttribute("message", msg);
		
		return "redirect:/mail/complete";
	}
	
	@GetMapping("complete")
	public String complete(@ModelAttribute("message") String message) throws Exception{
		
		// 컴플릿 페이지(complete.jsp)의 출력되는 message와 title는 RedirectAttributes 값이다. 
		// F5를 눌러 새로 고침을 하면 null이 된다.
		
		if(message == null || message.length() == 0) // F5를 누른 경우
			return "redirect:/";
		
		return "mail/complete";
	}
}
