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

import com.sp.app.domain.dto.CrewCommentDto;
import com.sp.app.domain.dto.SessionInfo;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.CrewBoardService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping(value = "/api/crew/comment/*")
public class CrewCommentRestController {
    private final CrewBoardService commentService;
    
	@Value("${file.upload-root}/crew")
    private String uploadPath;

    @PostMapping("write")
    public ResponseEntity<?> writeComment(
            @RequestBody CrewCommentDto dto,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        Map<String, Object> model = new HashMap<>();

        try {
            SessionInfo info = userDetails.getMember();
            dto.setUserIdx(info.getUserIdx());
            
            commentService.saveComment(dto);
            
            model.put("status", "success");
            return ResponseEntity.ok(model);

        } catch (Exception e) {
            log.error("writeComment error : ", e);
            model.put("status", "error");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(model);
        }
    }

    @PostMapping("update")
    public ResponseEntity<?> updateComment(
            @RequestBody CrewCommentDto dto,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        Map<String, Object> model = new HashMap<>();

        try {
            dto.setUserIdx(userDetails.getMember().getUserIdx());
            commentService.updateComment(dto);
            model.put("status", "success");
            return ResponseEntity.ok(model);

        } catch (Exception e) {
            log.error("updateComment error : ", e);
            model.put("status", "error");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(model);
        }
    }

    @PostMapping("delete")
    public ResponseEntity<?> deleteComment(
            @RequestBody Map<String, Long> params,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        Map<String, Object> model = new HashMap<>();

        try {
            Long commentId = params.get("commentId");
            Long userIdx = userDetails.getMember().getUserIdx();

            commentService.deleteComment(commentId, userIdx);

            model.put("status", "success");
            return ResponseEntity.ok(model);

        } catch (Exception e) {
            log.error("deleteComment error : ", e);
            model.put("status", "error");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(model);
        }
    }

    @GetMapping("list/{boardIdx}")
    public ResponseEntity<?> commentList(
            @PathVariable("boardIdx") Long boardIdx,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "10") int size) {
        
        Map<String, Object> model = new HashMap<>();
        try {
            model = commentService.getCommentList(boardIdx, page, size);
            model.put("status", "success");
            return ResponseEntity.ok(model);
            
        } catch (Exception e) {
            log.error("commentList error : ", e);
            model.put("status", "error");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(model);
        }
    }
}