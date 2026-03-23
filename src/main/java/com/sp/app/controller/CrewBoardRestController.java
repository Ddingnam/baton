package com.sp.app.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.sp.app.domain.dto.CrewBoardDto;
import com.sp.app.domain.dto.SessionInfo;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.CrewBoardService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping(value = "/api/crew/board/*")
public class CrewBoardRestController {
	private final CrewBoardService service;
	
	@Value("${file.upload-root}/crew")
    private String uploadPath;
	
	@PostMapping("write")
    public ResponseEntity<?> writePost(
    		@RequestBody CrewBoardDto dto,
    		@AuthenticationPrincipal CustomUserDetails userDetails) {
        Map<String, Object> model = new HashMap<>();
        
        try {
        	SessionInfo info = userDetails.getMember();
        	dto.setUserIdx(info.getUserIdx());
            service.savePost(dto);
            model.put("status", "success");
            return ResponseEntity.ok(model);
            
        } catch (Exception e) {
            log.error("writePost error : ", e);
            model.put("status", "error");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(model);
        }
    }
	
	@GetMapping("list/{crewIdx}")
    public ResponseEntity<?> boardList(
    		@PathVariable("crewIdx") Long crewIdx,
    		@RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "5") int size) {
		Map<String, Object> model = new HashMap<>();
		try {
            model = service.getPostListCustom(crewIdx, page, size);
            model.put("status", "success");
            return ResponseEntity.ok(model);
        } catch (Exception e) {
            log.error("boardList error : ", e);
            model.put("status", "error");
            return ResponseEntity.internalServerError().body(model);
        }
    }

    @GetMapping("detail/{boardIdx}")
    public ResponseEntity<CrewBoardDto> getPostDetail(@PathVariable("boardIdx") Long boardIdx) {
        CrewBoardDto dto = service.findPostById(boardIdx);
        service.updateViewCount(boardIdx);
        return ResponseEntity.ok(dto);
    }
	
	
}