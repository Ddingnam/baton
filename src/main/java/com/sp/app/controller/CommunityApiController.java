package com.sp.app.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.multipart.MultipartFile;

import com.sp.app.domain.dto.CommunityDto;
import com.sp.app.domain.dto.SessionInfo;
import com.sp.app.service.CommunityService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/community")
@RequiredArgsConstructor
public class CommunityApiController {

    private final CommunityService communityService;

    @Value("${file.upload-root}/community")
    private String uploadPath;

    @PostMapping
    public Map<String, Object> write(
			@RequestPart(value = "dto") CommunityDto dto,
			@RequestPart(value = "uploadFiles", required = false) List<MultipartFile> uploadFiles,
			HttpSession session) { 
        
    	Map<String, Object> state = new HashMap<>();
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			if (info == null) {
				state.put("status", "false");
				state.put("message", "로그인이 필요합니다.");
				return state;
			}

			dto.setMemberIdx(info.getUserIdx());
			dto.setWriterNickname(info.getName());
			dto.setUploadFiles(uploadFiles);

			String root = session.getServletContext().getRealPath("/");
			String path = root + "uploads" + File.separator + "community";

			communityService.insertCommunity(dto, path);

			state.put("status", "true");
			state.put("message", "게시글이 등록되었습니다.");
		} catch (Exception e) {
			log.error("Community Insert Error", e);
			state.put("status", "false");
			state.put("message", "등록 중 오류가 발생했습니다.");
		}
		return state;
	}
    
    @GetMapping
    public ResponseEntity<Map<String, Object>> list(
            @RequestParam(name = "page", defaultValue = "1") int page,
            @RequestParam(name = "size", defaultValue = "10") int size,
            @RequestParam(name = "schType", defaultValue = "all") String schType,
            @RequestParam(name = "kwd", defaultValue = "") String kwd) {
        
        try {
            Pageable pageable = PageRequest.of(page - 1, size, Sort.by("id").descending());
            Page<CommunityDto> list = communityService.getCommunityList(pageable, schType, kwd);
            
            Map<String, Object> response = new HashMap<>();
            response.put("list", list.getContent());
            response.put("totalPage", list.getTotalPages());
            response.put("totalElements", list.getTotalElements());
            response.put("currentPage", page);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("리스트 조회 실패", e);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<CommunityDto> detail(@PathVariable("id") Long id) {
        try {
            communityService.updateHitCount(id);
            CommunityDto dto = communityService.getCommunity(id);
            return ResponseEntity.ok(dto);
        } catch (Exception e) {
            log.error("상세 조회 실패", e);
            return ResponseEntity.notFound().build();
        }
    }

    @PostMapping("/{id}")
    public ResponseEntity<Map<String, Object>> update(
            @PathVariable("id") Long id, 
            @RequestPart(value = "dto") CommunityDto dto,
            @RequestPart(value = "uploadFiles", required = false) List<MultipartFile> uploadFiles,
            @SessionAttribute(name = "member", required = false) SessionInfo info) {
        
        Map<String, Object> map = new HashMap<>();

        if (info == null) {
            map.put("status", "false");
            map.put("message", "로그인이 필요합니다.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(map);
        }

        try {
            CommunityDto existing = communityService.getCommunity(id);
            if(existing == null || !existing.getMemberIdx().equals(info.getUserIdx())) {
                 map.put("status", "false");
                 map.put("message", "수정 권한이 없습니다.");
                 return ResponseEntity.status(HttpStatus.FORBIDDEN).body(map);
            }

            dto.setId(id);
            dto.setUploadFiles(uploadFiles);
            
            communityService.updateCommunity(dto, uploadPath);
            
            map.put("status", "true");
            map.put("message", "수정되었습니다.");
            return ResponseEntity.ok(map);
        } catch (Exception e) {
            log.error("수정 실패", e);
            map.put("status", "false");
            map.put("message", "수정 실패: " + e.getMessage());
            return ResponseEntity.badRequest().body(map);
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> delete(
            @PathVariable("id") Long id, 
            @SessionAttribute(name = "member", required = false) SessionInfo info) {
        
        Map<String, Object> map = new HashMap<>();
        
        if (info == null) {
            map.put("status", "false");
            map.put("message", "로그인이 필요합니다.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(map);
        }

        try {
            CommunityDto existing = communityService.getCommunity(id);
            if(existing != null && (existing.getMemberIdx().equals(info.getUserIdx()) || info.getUserLevel() >= 51)) {
                communityService.deleteCommunity(id, uploadPath); 
                map.put("status", "true");
                map.put("message", "삭제되었습니다.");
                return ResponseEntity.ok(map);
            } else {
                map.put("status", "false");
                map.put("message", "삭제 권한이 없습니다.");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(map);
            }
        } catch (Exception e) {
            log.error("삭제 실패", e);
            map.put("status", "false");
            map.put("message", "삭제 중 오류가 발생했습니다.");
            return ResponseEntity.badRequest().body(map);
        }
    }
}