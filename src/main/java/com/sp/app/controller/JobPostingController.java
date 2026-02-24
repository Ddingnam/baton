package com.sp.app.controller;

import com.sp.app.model.JobPosting;
import com.sp.app.service.JobPostingService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/alba/posting/*")
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
        
        return "alba/posting/list"; 
    }

    @GetMapping("write")
    public String writeForm() {
        return "alba/posting/write";
    }

    @PostMapping("write")
    public String writeSubmit(JobPosting dto) throws Exception {
        // 실제로는 로그인한 유저 세션 정보를 가져와 맵핑해야 합니다.
        dto.setUserIdx(1L); 
        dto.setRegionIdx(100L); // 예시 동네 인덱스
        
        postingService.insertPosting(dto);
        return "redirect:/alba/posting/list";
    }

    @GetMapping("article")
    public String article(@RequestParam long postingIdx, Model model) {
        JobPosting dto = postingService.findById(postingIdx);
        
        if(dto == null) {
            return "redirect:/alba/posting/list";
        }
        
        model.addAttribute("dto", dto);
        return "alba/posting/article";
    }
}