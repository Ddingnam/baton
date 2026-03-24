package com.sp.app.controller;

import com.sp.app.domain.dto.SessionInfo;
import com.sp.app.model.JobPosting;
import com.sp.app.model.JobProfile;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.JobPostingService;

import com.sp.app.service.JobProfileService; // 이력서

import jakarta.servlet.http.HttpSession;
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
		
		java.util.List<Long> userScrapList = new java.util.ArrayList<>();
		if (userDetails != null) {
		    List<JobPosting> scraps = postingService.listJobScrap(userDetails.getUserIdx());
		    System.out.println("scraps size = " + scraps.size());
		    for(JobPosting p : scraps) {
		        userScrapList.add(p.getPostingIdx());
		    }
		}
		model.addAttribute("userScrapList", userScrapList);

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
			
			dto.setRecruitStatus("RECRUITING");
			
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
		                      @AuthenticationPrincipal CustomUserDetails userDetails, // 🔥 로그인 정보 추가
		                      Model model) {
		    try {
		        postingService.updateHitCount(num); 
		        JobPosting dto = postingService.findById(num);
		        
		        if (dto == null) return "redirect:/alba/list?page=" + page;

		        String koreanDays = convertToKoreanDays(dto.getWorkDays());
		        model.addAttribute("koreanDays", koreanDays);

		        String computedWorkTime = (dto.getStartTime() != null && !dto.getStartTime().isEmpty() && 
		                                   dto.getEndTime() != null && !dto.getEndTime().isEmpty()) 
		                                   ? dto.getStartTime() + " ~ " + dto.getEndTime() 
		                                   : "시간협의";
		        model.addAttribute("computedWorkTime", computedWorkTime);

		        boolean isUserScrap = false;
		        if (userDetails != null) {
		            Map<String, Object> map = new HashMap<>();
		            map.put("memberId", userDetails.getUserIdx());
		            map.put("postingIdx", num);
		            int scrapCount = postingService.checkJobScrap(map);
		            if (scrapCount > 0) {
		                isUserScrap = true;
		            }
		        }
		        model.addAttribute("userScrap", isUserScrap); 

		        model.addAttribute("dto", dto);
		        model.addAttribute("page", page);
		        
		        if (userDetails != null) {
		        	List<JobProfile> resumeList = jobProfileService.listJobProfile(userDetails.getUserIdx());
		        	model.addAttribute("resumeList", resumeList);
		        }
		        
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
	public List<JobPosting> filter(
	        @RequestParam("sido") String sido,
	        @RequestParam("gugun") String gugun,
	        @RequestParam("dong") String dong,
	        @AuthenticationPrincipal CustomUserDetails userDetails) { // 🔥 추가

	    Map<String, Object> map = new HashMap<>();

	    map.put("sido", (sido != null && !sido.contains("전체")) ? sido : null);
	    map.put("gugun", (gugun != null && !gugun.contains("전체")) ? gugun : null);
	    map.put("dong", (dong != null && !dong.contains("전체")) ? dong : null);

	    if (userDetails != null) {
	        map.put("userIdx", userDetails.getUserIdx());
	    } else {
	        map.put("userIdx", -1L); 
	    }

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
	
	@PostMapping("status")
	@ResponseBody
	public String updateStatus(@RequestParam long postingIdx,
	                           @RequestParam String status,
	                           @AuthenticationPrincipal CustomUserDetails userDetails) {

	    try {
	        JobPosting dto = postingService.findById(postingIdx);

	        if (dto == null || userDetails == null || dto.getUserIdx() != userDetails.getUserIdx()) {
	            return "fail";
	        }

	        dto.setRecruitStatus(status);
	        postingService.updatePosting(dto);

	        return "success";

	    } catch (Exception e) {
	        log.error("상태 변경 실패", e);
	        return "fail";
	    }
	}
	
	// 2. toggleScrap 메서드를 통째로 아래 코드로 변경하세요. (Security 인증 객체 사용으로 변경)
		@PostMapping("/scrap")
		@ResponseBody
		public Map<String, Object> toggleScrap(
		        @RequestParam("postingIdx") long postingIdx,
		        @RequestParam("isScrap") boolean isScrap,
		        @AuthenticationPrincipal CustomUserDetails userDetails) { // 🔥 HttpSession 대신 Security 객체 사용

		    Map<String, Object> result = new HashMap<>();

		    // 로그인하지 않은 경우
		    if (userDetails == null) {
		        result.put("status", "login_required");
		        return result;
		    }

		    try {
		        Map<String, Object> map = new HashMap<>();
		        map.put("memberId", userDetails.getUserIdx()); // 🔥 확실하게 Security에서 UserIdx를 꺼내옴
		        map.put("postingIdx", postingIdx);

		        if (isScrap) {
		            postingService.insertJobScrap(map);
		        } else {
		            postingService.deleteJobScrap(map);
		        }

		        result.put("status", "success");

		    } catch (Exception e) {
		    	log.error("스크랩 에러", e);
		        result.put("status", "error");
		    }

		    return result;
		}
		
		
	
}