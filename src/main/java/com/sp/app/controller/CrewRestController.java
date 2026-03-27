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

import com.sp.app.domain.dto.CrewDto;
import com.sp.app.domain.dto.CrewMemberDto;
import com.sp.app.domain.dto.CrewRequestDto;
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
	        @RequestParam(value = "distance", required = false, defaultValue = "") String distance,
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
}