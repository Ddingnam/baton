package com.sp.app.controller;

import java.util.List;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.sp.app.domain.dto.SessionInfo;
import com.sp.app.mail.Mail;
import com.sp.app.mail.MailSender;
import com.sp.app.model.JobProfile;
import com.sp.app.service.JobProfileService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/resume")
@RequiredArgsConstructor
@Slf4j
public class JobProfileController {

    private final JobProfileService jobProfileService;
    private final MailSender mailSender;

    @GetMapping("/write")
    public String writeForm(HttpSession session, Model model) {
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        if (info == null) return "redirect:/member/login";
        model.addAttribute("info", info);
        return "resume/write";
    }

    @PostMapping("/write")
    public String writeSubmit(JobProfile dto, HttpSession session) {
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        if (info == null) return "redirect:/member/login";
        try {
            dto.setUserIdx(info.getUserIdx());
            jobProfileService.insertJobProfile(dto);
        } catch (Exception e) {
            log.error("writeSubmit error", e);
            return "redirect:/resume/write?error=true";
        }
        return "redirect:/resume/myList";
    }

    @GetMapping("/myList")
    public String myList(HttpSession session, Model model) {
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        if (info == null) return "redirect:/member/login";
        try {
            List<JobProfile> list = jobProfileService.listJobProfile(info.getUserIdx());
            model.addAttribute("list", list);
        } catch (Exception e) {
            log.error("myList error", e);
        }
        return "resume/myList";
    }

    @GetMapping("/article/{profileIdx}")
    public String article(@PathVariable("profileIdx") long profileIdx,
                          HttpSession session, Model model) {
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        if (info == null) return "redirect:/member/login";
        try {
            JobProfile dto = jobProfileService.findById(profileIdx);
            if (dto == null || dto.getUserIdx() != info.getUserIdx())
                return "redirect:/resume/myList";
            model.addAttribute("dto", dto);
        } catch (Exception e) {
            log.error("article error", e);
            return "redirect:/resume/myList";
        }
        return "resume/article";
    }

    @GetMapping("/update")
    public String updateForm(@RequestParam("profileIdx") long profileIdx,
                             HttpSession session, Model model) {
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        if (info == null) return "redirect:/member/login";
        try {
            JobProfile dto = jobProfileService.findById(profileIdx);
            if (dto == null || dto.getUserIdx() != info.getUserIdx())
                return "redirect:/resume/myList";
            model.addAttribute("dto", dto);
            model.addAttribute("info", info);
        } catch (Exception e) {
            log.error("updateForm error", e);
            return "redirect:/resume/myList";
        }
        return "resume/update";
    }

    @PostMapping("/update")
    public String updateSubmit(JobProfile dto, HttpSession session) {
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        if (info == null) return "redirect:/member/login";
        try {
            JobProfile origin = jobProfileService.findById(dto.getProfileIdx());
            if (origin == null || origin.getUserIdx() != info.getUserIdx())
                return "redirect:/resume/myList";
            jobProfileService.updateJobProfile(dto);
        } catch (Exception e) {
            log.error("updateSubmit error", e);
            return "redirect:/resume/update?profileIdx=" + dto.getProfileIdx() + "&error=true";
        }
        return "redirect:/resume/article/" + dto.getProfileIdx();
    }

    @GetMapping("/delete")
    public String delete(@RequestParam("profileIdx") long profileIdx, HttpSession session) {
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        if (info == null) return "redirect:/member/login";
        try {
            JobProfile origin = jobProfileService.findById(profileIdx);
            if (origin != null && origin.getUserIdx() == info.getUserIdx())
                jobProfileService.deleteJobProfile(profileIdx);
        } catch (Exception e) {
            log.error("delete error", e);
        }
        return "redirect:/resume/myList";
    }

    @GetMapping("/print")
    public String printResume(@RequestParam("profileIdx") long profileIdx, 
                              HttpSession session, Model model) {
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        if (info == null) return "redirect:/member/login";
        try {
            JobProfile dto = jobProfileService.findById(profileIdx);
            if (dto == null || dto.getUserIdx() != info.getUserIdx())
                return "redirect:/resume/myList";
            model.addAttribute("dto", dto);
        } catch (Exception e) {
            log.error("print error", e);
            return "redirect:/resume/myList";
        }
        return "resume/print";
    }

    @GetMapping("/email")
    public String emailPopup(@RequestParam("profileIdx") long profileIdx, 
                             HttpSession session, Model model) {
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        if (info == null) return "resume/close"; // 세션 없으면 팝업 닫기
        
        try {
            JobProfile dto = jobProfileService.findById(profileIdx);
            if (dto == null || dto.getUserIdx() != info.getUserIdx())
                return "resume/close";
                
            model.addAttribute("dto", dto);
        } catch (Exception e) {
            log.error("emailPopup error", e);
            return "resume/close";
        }
        return "resume/emailPopup";
    }

    @PostMapping("/email")
    public String sendEmailSubmit(@RequestParam("profileIdx") long profileIdx,
                                  @RequestParam("receiverName") String receiverName,
                                  @RequestParam("emailId") String emailId,
                                  @RequestParam("emailDomain") String emailDomain,
                                  HttpSession session, Model model) {
        
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        if (info == null) return "resume/close";

        try {
            JobProfile dto = jobProfileService.findById(profileIdx);
            if (dto == null) return "resume/close";

            Mail mail = new Mail();
            mail.setSenderName(info.getName()); // SessionInfo의 name 사용
            mail.setSenderEmail("jmn5316@gmail.com"); 
            mail.setReceiverEmail(emailId + "@" + emailDomain);
            mail.setSubject("[BATON] " + info.getName() + "님의 이력서입니다.");
            
            String intro = dto.getIntroduce() != null ? dto.getIntroduce() : "내용이 없습니다.";
            
            StringBuilder sb = new StringBuilder();
            sb.append("<div style='padding:20px; border:1px solid #ddd; max-width:600px;'>");
            sb.append("<h2 style='color:#002C5F;'>").append(dto.getTitle()).append("</h2>");
            sb.append("<hr>");
            sb.append("<p><strong>수신:</strong> ").append(receiverName).append("님</p>");
            sb.append("<p><strong>지원자:</strong> ").append(dto.getUserName()).append("</p>");
            sb.append("<div style='background:#f9f9f9; padding:15px; margin-top:10px;'>");
            
            sb.append(intro.replace("\n", "<br>")); 
            
            sb.append("</div>");
            sb.append("</div>");
            
            mail.setContent(sb.toString());

            boolean result = mailSender.mailSend(mail);
            model.addAttribute("msg", result ? receiverName + "님께 이력서를 발송했습니다." : "발송에 실패했습니다.");
            
        } catch (Exception e) {
            log.error("메일 발송 오류", e);
            model.addAttribute("msg", "시스템 오류가 발생했습니다.");
        }
        
        return "resume/emailResult"; 
    }
    
    @PostMapping("/deleteMulti")
    public String deleteMulti(@RequestParam("profileIdxs") List<Long> profileIdxs,
                              HttpSession session) {
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        if (info == null) return "redirect:/member/login";

        if (profileIdxs == null || profileIdxs.isEmpty()) {
            return "redirect:/resume/myList";
        }

        try {
            for (Long profileIdx : profileIdxs) {
                JobProfile origin = jobProfileService.findById(profileIdx);
                if (origin != null && origin.getUserIdx() == info.getUserIdx()) {
                    jobProfileService.deleteJobProfile(profileIdx);
                }
            }
        } catch (Exception e) {
            log.error("deleteMulti error", e);
        }

        return "redirect:/resume/myList";
    }

    
}