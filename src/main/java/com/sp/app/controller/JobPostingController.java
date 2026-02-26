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
@RequestMapping("/alba") // 클래스 기본 경로를 /alba 로 설정
public class JobPostingController {

    private final JobPostingService postingService;

    @GetMapping("list") // 실제 경로: /alba/list
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
        
        return "alba/list"; // 뷰 파일 (WEB-INF/views/alba/list.jsp)
    }

    @GetMapping("write") // 실제 경로: /alba/write
    public String writeForm() {
        return "alba/write";
    }

    @PostMapping("write") // 실제 경로: /alba/write
    public String writeSubmit(JobPosting dto) throws Exception {
        dto.setUserIdx(1L); 
        dto.setRegionIdx(100L); 
        
        postingService.insertPosting(dto);
        
        // 작성 완료 후 이동할 경로 (posting 제거)
        return "redirect:/alba/list"; 
    }

    @GetMapping("article") // 실제 경로: /alba/article?postingIdx=8
    public String article(@RequestParam long postingIdx, Model model) {
        JobPosting dto = postingService.findById(postingIdx);
        
        if(dto == null) {
            // 없는 글일 경우 이동할 경로 (posting 제거)
            return "redirect:/alba/list";
        }
        
        if (dto.getStartTime() != null && dto.getEndTime() != null) {
            dto.setWorkTime(dto.getStartTime() + " ~ " + dto.getEndTime());
        } else if ("Y".equals(dto.getTimeNegotiable())) {
            dto.setWorkTime("시간협의 가능");
        }
        
        model.addAttribute("dto", dto);
        
        return "alba/article";
    }
}