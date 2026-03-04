package com.sp.app.controller;

import com.sp.app.domain.dto.CommunityDto;
import com.sp.app.service.CommunityService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/community")
@RequiredArgsConstructor
public class CommunityApiController {

    private final CommunityService communityService;

    @PostMapping
    public ResponseEntity<String> write(@RequestBody CommunityDto dto) {
        try {
            
            Long id = communityService.createCommunity(dto);
            return ResponseEntity.ok("게시글이 등록되었습니다. ID: " + id);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("등록 실패: " + e.getMessage());
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
        CommunityDto dto = communityService.getCommunity(id);
        return ResponseEntity.ok(dto);
    }

    @PutMapping("/{id}")
    public ResponseEntity<String> update(@PathVariable Long id, @RequestBody CommunityDto dto) {
        communityService.updateCommunity(id, dto);
        return ResponseEntity.ok("수정되었습니다.");
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<String> delete(@PathVariable Long id) {
        communityService.deleteCommunity(id);
        return ResponseEntity.ok("삭제되었습니다.");
    }
}