package com.sp.app.controller;

import com.sp.app.model.JobPosting;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.JobPostingService;

import com.sp.app.service.JobProfileService; // 이력서

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
	private final JobProfileService jobProfileService;

	@GetMapping("list")
	public String list(@RequestParam(value = "page", defaultValue = "1") int current_page,
			@RequestParam(value = "sido", required = false) String sido,
			@RequestParam(value = "gugun", required = false) String gugun,
			@RequestParam(value = "dong", required = false) String dong,
			@AuthenticationPrincipal CustomUserDetails userDetails, Model model) {
		
		if (userDetails != null) {
			model.addAttribute("loginMember", userDetails.getMember());
		    model.addAttribute("member", userDetails.getMember());
		}

		int resumeCount = 0;
		if (userDetails != null) {
			try {
				resumeCount = jobProfileService.getResumeCount(userDetails.getUserIdx());
			} catch (Exception e) {
				log.error("이력서 개수 조회 실패", e);
			}
		}

		int size = 10;
		int offset = (current_page - 1) * size;

		Map<String, Object> map = new HashMap<>();
		map.put("offset", offset);
		map.put("size", size);

		map.put("sido", (sido != null && !sido.contains("전체")) ? sido : null);
		map.put("gugun", (gugun != null && !gugun.contains("전체")) ? gugun : null);
		map.put("dong", (dong != null && !dong.contains("전체")) ? dong : null);

		int dataCount = postingService.dataCount(map);
		List<JobPosting> list = postingService.listPosting(map);

		model.addAttribute("list", list);
		model.addAttribute("dataCount", dataCount);
		model.addAttribute("page", current_page);
		model.addAttribute("resumeCount", resumeCount); // 이력서

		return "alba/list";
	}

	@GetMapping("write")
	public String writeForm() {
		return "alba/write";
	}

	@PostMapping("write")
	public String writeSubmit(JobPosting dto, @AuthenticationPrincipal CustomUserDetails userDetails) throws Exception {
		try {

			if (userDetails != null) {
				dto.setUserIdx(userDetails.getUserIdx());
			}
			
			 // 🔥 추가 (테스트용 필수)
	        dto.setRegionIdx(1);
	        
			postingService.insertPosting(dto);

		} catch (Exception e) {
			 log.error("writeSubmit 에러", e);
			 throw e;
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
	        
	        if (dto == null) return "redirect:/alba/list?page=" + page;

	        // 1. 요일 변환 (데이터가 없으면 그냥 빈값으로 둡니다)
	        String koreanDays = convertToKoreanDays(dto.getWorkDays());
	        model.addAttribute("koreanDays", koreanDays);

	        // 2. 근무시간 (시작/종료 시간이 둘 다 있을 때만 합치고, 없으면 시간협의)
	        String computedWorkTime = (dto.getStartTime() != null && !dto.getStartTime().isEmpty() && 
	                                   dto.getEndTime() != null && !dto.getEndTime().isEmpty()) 
	                                   ? dto.getStartTime() + " ~ " + dto.getEndTime() 
	                                   : "시간협의";
	        model.addAttribute("computedWorkTime", computedWorkTime);

	        model.addAttribute("dto", dto);
	        model.addAttribute("page", page);
	        
	        return "alba/article"; 
	    } catch (Exception e) {
	        log.error("상세보기 에러: ", e);
	        return "redirect:/alba/list?page=" + page;
	    }
	}

	@GetMapping("update")
	public String updateForm(@RequestParam(value = "postingIdx") long postingIdx,
			@RequestParam(value = "page") String page, @AuthenticationPrincipal CustomUserDetails userDetails,
			Model model) {

		try {
			JobPosting dto = postingService.findById(postingIdx);

			if (dto == null) {
				return "redirect:/alba/list?page=" + page;
			}

			if (userDetails == null || dto.getUserIdx() != userDetails.getUserIdx()) {
				return "redirect:/alba/list?page=" + page;
			}

			model.addAttribute("dto", dto);
			model.addAttribute("page", page);
			model.addAttribute("mode", "update");

			return "alba/write";

		} catch (Exception e) {
			log.error("updateForm 에러 발생: ", e);
			return "redirect:/alba/list?page=" + page;
		}
	}

	@PostMapping("update")
	public String updateSubmit(JobPosting dto, @RequestParam(value = "page") String page) throws Exception {
		postingService.updatePosting(dto);
		return "redirect:/alba/article/" + dto.getPostingIdx() + "?page=" + page;
	}

	@GetMapping("delete")
	public String delete(@RequestParam("postingIdx") long postingIdx) throws Exception {
		postingService.deletePosting(postingIdx);
		return "redirect:/alba/list";
	}

	@GetMapping("filter")
	@ResponseBody
	public List<JobPosting> filter(@RequestParam("sido") String sido, @RequestParam("gugun") String gugun,
			@RequestParam("dong") String dong) {

		Map<String, Object> map = new HashMap<>();

		map.put("sido", (sido != null && !sido.contains("전체")) ? sido : null);
		map.put("gugun", (gugun != null && !gugun.contains("전체")) ? gugun : null);
		map.put("dong", (dong != null && !dong.contains("전체")) ? dong : null);

		return postingService.listPostingByArea(map);
	}

	private String convertToKoreanDays(String days) {
		if (days == null || days.trim().isEmpty())
			return ""; 

		String[] dayArr = days.split(",");
		String[] korNames = { "", "월", "화", "수", "목", "금", "토", "일" };
		StringBuilder sb = new StringBuilder();

		for (String d : dayArr) {
			try {
				int dayNum = Integer.parseInt(d.trim());
				if (dayNum >= 1 && dayNum <= 7) {
					if (sb.length() > 0)
						sb.append(", ");
					sb.append(korNames[dayNum]);
				}
			} catch (Exception e) {
				continue;
			}
		}
		return sb.toString();
	}
	
	@GetMapping("/dong")
	@ResponseBody
	public List<String> listDong(
	        @RequestParam("sido") String sido,
	        @RequestParam("gugun") String gugun) {

	    System.out.println("sido = " + sido);
	    System.out.println("gugun = " + gugun);

	    Map<String,Object> map = new HashMap<>();
	    map.put("sido", sido);
	    map.put("gugun", gugun);

	    List<String> list = postingService.listDong(map);

	    System.out.println("dong list = " + list);

	    return list;
	}
}