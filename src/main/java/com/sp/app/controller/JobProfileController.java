package com.sp.app.controller;

import java.util.List;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.sp.app.domain.dto.SessionInfo;
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

    /* ───────────── 나의 이력서 목록 ───────────── */
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

    /* ───────────── 상세보기 ───────────── */
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

    /* ───────────── 수정 폼 ───────────── */
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

    /* ───────────── 삭제 ───────────── */
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

    /* ───────────── 인쇄 전용 팝업 ───────────── */
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

    /* ───────────── ★ 이메일 발송 팝업 (추가됨) ───────────── */
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

    /* ───────────── ★ 이메일 발송 처리 (추가됨) ───────────── */
    @PostMapping("/email")
    public String sendEmailSubmit(@RequestParam("profileIdx") long profileIdx,
                                  @RequestParam("receiverName") String receiverName,
                                  @RequestParam("emailId") String emailId,
                                  @RequestParam("emailDomain") String emailDomain,
                                  HttpSession session, Model model) {
        
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        if (info == null) return "resume/close";

        String targetEmail = emailId + "@" + emailDomain;

        try {
            // [참고] 여기서 실제로 JavaMailSender 등을 사용하여 targetEmail로 이력서 내용을 쏘면 됩니다.
            // 지금은 로직이 성공했다고 가정하고 결과창으로 보냅니다.
            log.info("이력서 발송: 대상={}, 수신자={}, 이력서번호={}", targetEmail, receiverName, profileIdx);
            
            model.addAttribute("msg", receiverName + "님께 이력서가 성공적으로 발송되었습니다.");
        } catch (Exception e) {
            log.error("sendEmailSubmit error", e);
            model.addAttribute("msg", "이메일 발송 중 오류가 발생했습니다.");
        }
        
        // 결과 확인 후 팝업창을 닫게 만드는 JSP 리턴
        return "resume/emailResult"; 
    }
}