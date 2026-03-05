package com.sp.app.controller;

import com.sp.app.model.JobPosting;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.JobPostingService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/alba")
public class JobPostingController {

    private final JobPostingService postingService;

    @GetMapping("list")
    public String list(
            @RequestParam(value = "page", defaultValue = "1") int current_page,
            Model model) {
        
        int size = 10;
        int offset = (current_page - 1) * size;
        
        Map<String, Object> map = new HashMap<>();
        map.put("offset", offset);
        map.put("size", size);
        
        int dataCount = postingService.dataCount(map);
        List<JobPosting> list = postingService.listPosting(map);
        
        model.addAttribute("list", list);
        model.addAttribute("dataCount", dataCount);
        model.addAttribute("page", current_page);
        
        return "alba/list";
    }

    @GetMapping("write")
    public String writeForm() {
        return "alba/write";
    }

    @PostMapping("write")
    public String writeSubmit(JobPosting dto, 
            @AuthenticationPrincipal CustomUserDetails userDetails) throws Exception {
        try {
            if (userDetails != null) {
                dto.setUserIdx(userDetails.getUserIdx());
            }
            
            //if (locationDetail != null && !locationDetail.trim().isEmpty()) {
            //    dto.setLocation(dto.getLocation() + " " + locationDetail.trim());
            //}
            
            postingService.insertPosting(dto); 
            
        } catch (Exception e) {
            log.info("writeSubmit 에러: ", e);
        }
        return "redirect:/alba/list";
    }

    @GetMapping("article/{num}")
    public String article(@PathVariable("num") long num, 
                          @RequestParam(value = "page", defaultValue = "1") String page,
                          Model model) {
        try {
           postingService.updateHitCount(num); 
            
            JobPosting dto = postingService.findById(num);
            
            if (dto == null) {
                log.info("@@@ 게시글 데이터가 없음: " + num);
                return "redirect:/alba/list?page=" + page;
            }

            model.addAttribute("dto", dto);
            model.addAttribute("page", page);
            
            return "alba/article";
            
        } catch (Exception e) {
            log.error("@@@ 상세보기 로직 에러 발생: ", e); 
            return "redirect:/alba/list?page=" + page;
        }
    }

    @GetMapping("update")
    public String updateForm(@RequestParam long postingIdx, Model model) {
        JobPosting dto = postingService.findById(postingIdx);
        
        if(dto == null) {
            return "redirect:/alba/list";
        }
        
        model.addAttribute("dto", dto);
        model.addAttribute("mode", "update");
        
        return "alba/write";
    }

    @PostMapping("update")
    public String updateSubmit(JobPosting dto) throws Exception {
        postingService.updatePosting(dto);
        //return "redirect:/alba/article?postingIdx=" + dto.getPostingIdx();
        return "redirect:/alba/article/" + dto.getPostingIdx();
    }

    @GetMapping("delete")
    public String delete(@RequestParam long postingIdx) throws Exception {
        postingService.deletePosting(postingIdx);
        return "redirect:/alba/list";
    }
}