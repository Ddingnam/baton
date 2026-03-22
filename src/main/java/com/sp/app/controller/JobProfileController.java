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
    public String article(@PathVariable long profileIdx,
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
    public String updateForm(@RequestParam long profileIdx,
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
    public String delete(@RequestParam long profileIdx, HttpSession session) {
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
}
