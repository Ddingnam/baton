package com.sp.app.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpSession;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.sp.app.common.StorageService;
import com.sp.app.domain.dto.CommunityDto;
import com.sp.app.domain.dto.SessionInfo;
import com.sp.app.service.CommunityService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/community")
@RequiredArgsConstructor
public class CommunityApiController {

    private final CommunityService communityService;
    private final StorageService storageService;

    @PostMapping
    public ResponseEntity<Map<String, Object>> write(
            @RequestPart("dto") CommunityDto dto,
            @RequestPart(value = "uploadFiles", required = false) List<MultipartFile> uploadFiles,
            HttpSession session) {
        
        Map<String, Object> map = new HashMap<>();
        
        try {
            SessionInfo info = (SessionInfo) session.getAttribute("member");
            if (info == null) {
                map.put("status", "false");
                map.put("message", "로그인이 필요한 서비스입니다.");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(map);
            }

            dto.setMemberIdx(info.getUserIdx());
            dto.setWriterNickname(info.getName());

            List<String> savedFiles = new ArrayList<>();
            String rootPath = storageService.getRealPath("/uploads/community");

            if (uploadFiles != null && !uploadFiles.isEmpty()) {
                for (MultipartFile file : uploadFiles) {
                    String filename = storageService.uploadFileToServer(file, rootPath); 
                    if (filename != null) {
                        savedFiles.add(filename);
                    }
                }
            }
            dto.setImageFiles(savedFiles);

            Long id = communityService.createCommunity(dto);
            
            map.put("status", "true");
            map.put("message", "게시글이 등록되었습니다.");
            map.put("id", id);
            
            return ResponseEntity.ok(map);
            
        } catch (Exception e) {
            log.error("글 등록 실패", e);
            map.put("status", "false");
            map.put("message", "등록 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(map);
        }
    }
    
    @GetMapping
    public ResponseEntity<Page<CommunityDto>> list(
            @PageableDefault(size = 10, sort = "regDate", direction = Sort.Direction.DESC) Pageable pageable) {
        Page<CommunityDto> list = communityService.getCommunityList(pageable);
        return ResponseEntity.ok(list);
    }

    @GetMapping("/{id}")
    public ResponseEntity<CommunityDto> detail(@PathVariable Long id) {
        try {
            CommunityDto dto = communityService.getCommunity(id);
            return ResponseEntity.ok(dto);
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<String> update(
            @PathVariable Long id, 
            @RequestBody CommunityDto dto,
            HttpSession session) {
        
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        if (info == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        try {
            dto.setId(id);
            dto.setMemberIdx(info.getUserIdx());
            
            communityService.updateCommunity(id, dto);
            
            return ResponseEntity.ok("수정되었습니다.");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("수정 실패: " + e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> delete(@PathVariable Long id, HttpSession session) {
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        if (info == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        try {
            communityService.deleteCommunity(id); 
            return ResponseEntity.ok("삭제되었습니다.");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("삭제 실패: " + e.getMessage());
        }
    }
}