package com.sp.app.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sp.app.domain.dto.CrewDto;
import com.sp.app.domain.dto.SessionInfo;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.CrewService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping(value = "/crew/*")
public class CrewRestController {
	private final CrewService service;
	
	@Value("${file.upload-root}/crew")
    private String uploadPath;
	
	@PostMapping("formSubmit")
    public ResponseEntity<?> formSubmit(
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
}