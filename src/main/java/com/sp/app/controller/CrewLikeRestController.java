package com.sp.app.controller;

import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sp.app.domain.dto.SessionInfo;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.CrewBoardService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping(value = "/api/crew/like/*")
public class CrewLikeRestController {
    private final CrewBoardService service;
    
    @PostMapping("/toggle/{boardIdx}")
    public ResponseEntity<?> toggleLike(
    		@PathVariable("boardIdx") Long boardIdx,
    		@AuthenticationPrincipal CustomUserDetails userDetails) {
    	
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        try {
        	SessionInfo info = userDetails.getMember();
            long loginUserIdx = info.getUserIdx();
            
            Map<String, Object> result = service.toggleLike(boardIdx, loginUserIdx);
            
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("toggleLike error: ", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("오류가 발생했습니다.");
        }
    }
}