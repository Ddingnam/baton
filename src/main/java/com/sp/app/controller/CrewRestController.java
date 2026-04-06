package com.sp.app.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import com.sp.app.domain.dto.CrewDto;
import com.sp.app.domain.dto.CrewHistoryDto;
import com.sp.app.domain.dto.CrewMemberDto;
import com.sp.app.domain.dto.CrewRequestDto;
import com.sp.app.domain.dto.MyCrewListDto;
import com.sp.app.domain.dto.RegionDto;
import com.sp.app.domain.dto.SessionInfo;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.CrewService;
import com.sp.app.service.MemberService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping(value = "/api/crew/*")
public class CrewRestController {
	private final CrewService service;
	private final MemberService memberService;
	
	@Value("${file.upload-root}/crew")
    private String uploadPath;
	
	/*
	@Value("${weather.api.key}")
	private String weatherApiKey;

	@Value("${weather.api.url}")
	private String weatherApiUrl;
	*/
	
	@PostMapping("register")
    public ResponseEntity<?> register(
    		@ModelAttribute CrewDto crewDto,
    		@AuthenticationPrincipal CustomUserDetails userDetails) {
		Map<String, Object> model = new HashMap<>();
		
	    if (userDetails == null || userDetails.getMember() == null) {
	        model.put("state", "login_required");
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(model);
	    }
	    
	    if (crewDto == null) {
	    	model.put("state", "null");
	    	return ResponseEntity.ok(model);
	    }
		
        try {
        	SessionInfo info = userDetails.getMember();
        	crewDto.setUserIdx(info.getUserIdx());
        	
        	service.insertCrew(crewDto, uploadPath);
        	model.put("state", "success");
        	
            return ResponseEntity.ok(model);
        } catch (Exception e) {
        	log.info("formSubmit error: ", e);
            model.put("state", "error");
            
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(model);
        }
    }
	
	@GetMapping("list")
	public ResponseEntity<?> crewList(
	        @RequestParam(value = "categoryIdx", defaultValue = "0") int categoryIdx,
	        @RequestParam(value = "distance", required = false, defaultValue = "local") String distance,
	        @RequestParam(value = "joinType", defaultValue = "all") String joinType,
	        @RequestParam(value = "isRecruiting", defaultValue = "true") boolean isRecruiting,
	        @RequestParam(value = "sortType", defaultValue = "latest") String sortType,
	        @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
	        @RequestParam(value = "page", defaultValue = "1") int page,
	        @RequestParam(value = "size", defaultValue = "9") int size,
	        @AuthenticationPrincipal CustomUserDetails userDetails
	    ) {
	    Map<String, Object> model = new HashMap<>();
	    
	    try {
	        Map<String, Object> params = new HashMap<>();
	        params.put("categoryIdx", categoryIdx);
	        params.put("distance", distance);
	        params.put("joinType", joinType);
	        params.put("isRecruiting", isRecruiting);
	        params.put("sortType", sortType);
	        params.put("keyword", keyword);
	        
	        int offset = (page - 1) * size;
	        params.put("offset", offset);
	        params.put("size", size);
	        
	        SessionInfo info = userDetails.getMember();
	        RegionDto region = memberService.findRegionByCode(info.getUserRegionInfo().getActiveRegion().getRegionCode());
	        params.put("userRegionCode", region.getRegionCode());
	        params.put("userRegionLat", region.getLat());
	        params.put("userRegionLng", region.getLng());

	        List<CrewDto> list = service.listCrew(params);
	        int totalCount = service.getCrewCount(params);

	        model.put("state", "success");
	        model.put("crewList", list != null ? list : new ArrayList<>());
	        model.put("count", totalCount);
	        
	        return ResponseEntity.ok(model);
	        
	    } catch (Exception e) {
	        log.error("crewList error : ", e);
	        model.put("state", "error");
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(model);
	    }
	}
	
	@GetMapping("article/{crewIdx}")
    public ResponseEntity<?> getCrewDetail(
    		@PathVariable("crewIdx") long crewIdx,
    		@AuthenticationPrincipal CustomUserDetails userDetails) {
		Map<String, Object> response = new HashMap<>();
		
		if (userDetails == null || userDetails.getMember() == null) {
			response.put("state", "login_required");
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
	    }
		
        try {
        	Long loginUserIdx = userDetails.getMember().getUserIdx();
            CrewDto crew = service.findByCrewIdx(crewIdx); 
            CrewMemberDto myStatus = service.getCrewMemberInfo(crewIdx, loginUserIdx);
            
            response.put("crew", crew);
            response.put("myStatus", myStatus);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
        	log.error("getCrewDetail Error : ", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("서버 오류가 발생했습니다.");
        }
    }
	
	@GetMapping("myCrew")
    public ResponseEntity<?> getMyCrew( @AuthenticationPrincipal CustomUserDetails userDetails ) {
		Map<String, Object> response = new HashMap<>();
		
		if (userDetails == null || userDetails.getMember() == null) {
			response.put("state", "login_required");
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
	    }
		
        try {
        	Long loginUserIdx = userDetails.getMember().getUserIdx();
        	
            List<MyCrewListDto> myCrewListJoined = service.listMyCrewJoined(loginUserIdx);
            List<MyCrewListDto> myCrewListCreated = service.listMyCrewCreated(loginUserIdx);
            
            response.put("myCrewListJoined", myCrewListJoined);
            response.put("myCrewListCreated", myCrewListCreated);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
        	log.error("getCrewDetail Error : ", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("서버 오류가 발생했습니다.");
        }
    }
	
	@PostMapping("join")
    public ResponseEntity<String> joinCrew(
    		@RequestBody CrewRequestDto dto,
    		@AuthenticationPrincipal CustomUserDetails userDetails) {
        Long loginUserIdx = userDetails.getMember().getUserIdx();
        try {
	        service.joinCrew(dto.getCrewIdx(), loginUserIdx, dto.getReason());
	        return ResponseEntity.ok("가입 신청이 완료되었습니다.");
        } catch (Exception e) {
            log.error("joinCrew Error : ", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("서버 오류가 발생했습니다.");
        }
    }

    @PostMapping("exit")
    public ResponseEntity<String> exitCrew(
    		@RequestBody CrewRequestDto dto,
    		@AuthenticationPrincipal CustomUserDetails userDetails) {
    	Long loginUserIdx = userDetails.getMember().getUserIdx();
        
    	try {
	        service.exitCrew(dto.getCrewIdx(), loginUserIdx, dto.getReason());
	        return ResponseEntity.ok("탈퇴 처리가 완료되었습니다.");
    	} catch (Exception e) {
            log.error("exitCrew Error : ", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("서버 오류가 발생했습니다.");
        }
    }

    @PostMapping("ban")
    public ResponseEntity<String> banMember(
    		@RequestBody CrewRequestDto dto,
    		@AuthenticationPrincipal CustomUserDetails userDetails) {
    	Long loginUserIdx = userDetails.getMember().getUserIdx();
        try {
	        service.banMember(loginUserIdx, dto.getCrewIdx(), dto.getTargetUserIdx(), dto.getReason());
	        return ResponseEntity.ok("해당 멤버를 강퇴 처리하였습니다.");
        } catch (Exception e) {
            log.error("banMember Error : ", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("서버 오류가 발생했습니다.");
        }
    }
    
    @GetMapping("dashboard/{crewIdx}/stats")
    public ResponseEntity<?> getDashboardStats(
            @PathVariable("crewIdx") Long crewIdx,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        Map<String, Object> model = new HashMap<>();
        
        if (userDetails == null || userDetails.getMember() == null) {
            model.put("state", "login_required");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(model);
        }
        
        try {
            Map<String, Object> stats = service.getCrewDashboardStats(crewIdx);
            
            model.put("state", "success");
            model.put("data", stats);
            
            return ResponseEntity.ok(model);
            
        } catch (Exception e) {
            log.error("getDashboardStats error : ", e);
            model.put("state", "error");
            model.put("message", "대시보드 통계를 불러오는 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(model);
        }
    }
    
    /*
    @SuppressWarnings("unchecked")
    @GetMapping("dashboard/weather")
    public ResponseEntity<?> getCrewWeather(@RequestParam(name = "city", defaultValue = "Seoul") String city) {
        try {
            RestTemplate restTemplate = new RestTemplate();
            
            String url = String.format("%s?q=%s&units=metric&lang=kr&appid=%s", 
                                        weatherApiUrl, city, weatherApiKey);
            
            Map<String, Object> response = restTemplate.getForObject(url, Map.class);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Weather API Error: ", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("날씨 정보를 가져올 수 없습니다.");
        }
    }
    */
    
    @GetMapping("manage/{crewIdx}/members")
	public ResponseEntity<?> getActiveMembers(
	        @PathVariable("crewIdx") Long crewIdx,
	        @AuthenticationPrincipal CustomUserDetails userDetails) {
	    try {
	        List<CrewMemberDto> list = service.getCrewMembers(crewIdx, "ACTIVE");
	        return ResponseEntity.ok(list);
	    } catch (Exception e) {
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("멤버 목록 조회 실패");
	    }
	}

	@GetMapping("manage/{crewIdx}/applications")
	public ResponseEntity<?> getPendingApplications(
	        @PathVariable("crewIdx") Long crewIdx,
	        @AuthenticationPrincipal CustomUserDetails userDetails) {
	    try {
	        List<CrewMemberDto> list = service.getCrewMembers(crewIdx, "WAIT");
	        return ResponseEntity.ok(list);
	    } catch (Exception e) {
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("신청 목록 조회 실패");
	    }
	}

	@PostMapping("manage/{crewIdx}/applications/{userIdx}")
	public ResponseEntity<?> handleApplication(
	        @PathVariable("crewIdx") Long crewIdx,
	        @PathVariable("userIdx") Long targetUserIdx,
	        @RequestParam("action") String action,
	        @AuthenticationPrincipal CustomUserDetails userDetails) {
	    try {
	        Long loginUserIdx = userDetails.getMember().getUserIdx();
	        service.handleApplication(loginUserIdx, crewIdx, targetUserIdx, action);
	        return ResponseEntity.ok("처리되었습니다.");
	    } catch (Exception e) {
	        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
	    }
	}

	@PostMapping("manage/{crewIdx}/members/{userIdx}/kick")
	public ResponseEntity<?> kickMember(
	        @PathVariable("crewIdx") Long crewIdx,
	        @PathVariable("userIdx") Long targetUserIdx,
	        @AuthenticationPrincipal CustomUserDetails userDetails) {
	    try {
	        Long loginUserIdx = userDetails.getMember().getUserIdx();
	        service.banMember(loginUserIdx, crewIdx, targetUserIdx, "관리자에 의한 강퇴");
	        return ResponseEntity.ok("강퇴 처리되었습니다.");
	    } catch (Exception e) {
	        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
	    }
	}

	@PostMapping("manage/{crewIdx}/close")
	public ResponseEntity<?> closeCrew(
	        @PathVariable("crewIdx") Long crewIdx,
	        @AuthenticationPrincipal CustomUserDetails userDetails) {
	    try {
	        service.deleteCrew(crewIdx, uploadPath);
	        return ResponseEntity.ok("모임이 폐쇄되었습니다.");
	    } catch (Exception e) {
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("모임 폐쇄 실패");
	    }
	}
	
	@PostMapping("manage/{crewIdx}/members/{userIdx}/role")
	public ResponseEntity<?> updateMemberRole(
	        @PathVariable("crewIdx") Long crewIdx,
	        @PathVariable("userIdx") Long targetUserIdx,
	        @RequestParam("role") String role,
	        @AuthenticationPrincipal CustomUserDetails userDetails) {
	    try {
	        Long loginUserIdx = userDetails.getMember().getUserIdx();
	        service.updateMemberRole(loginUserIdx, crewIdx, targetUserIdx, role);
	        return ResponseEntity.ok("권한이 변경되었습니다.");
	    } catch (Exception e) {
	        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
	    }
	}
	
	@GetMapping("manage/{crewIdx}/history")
	public ResponseEntity<?> getCrewHistory(
	        @PathVariable("crewIdx") Long crewIdx,
	        @AuthenticationPrincipal CustomUserDetails userDetails) {
	    try {
	        List<CrewHistoryDto> history = service.getCrewHistory(crewIdx);
	        return ResponseEntity.ok(history);
	    } catch (Exception e) {
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("이력 조회 실패");
	    }
	}
}