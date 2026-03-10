package com.sp.app.controller;

import java.util.List;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.multipart.MultipartFile;

import com.sp.app.common.PaginateUtil;
import com.sp.app.common.RequestUtils;
import com.sp.app.common.StorageService;
import com.sp.app.domain.dto.CommunityDto;
import com.sp.app.domain.dto.SessionInfo;
import com.sp.app.service.CommunityService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/community/*")
public class CommunityController {

    private final CommunityService service;
    private final PaginateUtil paginateUtil;
    private final StorageService storageService;

    @Value("${file.upload-root}/community")
    private String uploadPath;
    
    @Value("${kakao.map.key}")
    private String kakaoMapKey;

    @GetMapping("list")
    public String list(
            @RequestParam(name = "page", defaultValue = "1") int current_page,
            @RequestParam(name = "schType", defaultValue = "all") String schType,
            @RequestParam(name = "kwd", defaultValue = "") String kwd,
            @RequestParam(name = "category", defaultValue = "") String category,
            @RequestParam(name = "sort", defaultValue = "latest") String sort,
            HttpServletRequest req,
            Model model) throws Exception {

        try {
            if (req.getMethod().equalsIgnoreCase("GET")) {
                kwd = URLDecoder.decode(kwd, "UTF-8");
            }

            int size = 9;
            Sort sortOrder = "hit".equals(sort) ? Sort.by("hitCount").descending()
                           : "like".equals(sort) ? Sort.by("likeCount").descending()
                           : Sort.by("id").descending();
            Pageable pageable = PageRequest.of(current_page - 1, size, sortOrder);
            Page<CommunityDto> pages = service.getCommunityList(pageable, schType, kwd);

            int total_page = pages.getTotalPages();
            long dataCount = pages.getTotalElements();

            String cp = RequestUtils.getContextPath();
            String listUrl = cp + "/community/list";
            String query = "page=" + current_page;

            StringBuilder params = new StringBuilder();
            if (!category.isBlank()) params.append("&category=").append(URLEncoder.encode(category, "UTF-8"));
            if (!"latest".equals(sort)) params.append("&sort=").append(sort);
            if (!kwd.isBlank()) params.append("&schType=").append(schType).append("&kwd=").append(URLEncoder.encode(kwd, "UTF-8"));

            if (params.length() > 0) {
                listUrl += "?" + params.substring(1);
                query += params.toString();
            }

            String paging = paginateUtil.paging(current_page, total_page, listUrl);

            model.addAttribute("list", pages.getContent());
            model.addAttribute("dataCount", dataCount);
            model.addAttribute("total_page", total_page);
            model.addAttribute("page", current_page);
            model.addAttribute("paging", paging);
            model.addAttribute("query", query);
            model.addAttribute("schType", schType);
            model.addAttribute("kwd", kwd);
            model.addAttribute("category", category);
            model.addAttribute("sort", sort);

        } catch (Exception e) {
            log.info("list : ", e);
        }
        return "community/list";
    }

    @GetMapping("write")
    public String writeForm(Model model) {
        model.addAttribute("mode", "write");
        model.addAttribute("kakaoMapKey", kakaoMapKey);
        return "community/write";
    }

    @PostMapping("write")
    public String writeSubmit(CommunityDto dto,
            @RequestParam(value = "uploadFiles", required = false) List<MultipartFile> uploadFiles,
            @RequestParam(value = "isTemporary", required = false, defaultValue = "0") int isTemporary,
            HttpSession session) throws Exception {
        SessionInfo info = (SessionInfo) session.getAttribute("member");

        dto.setMemberIdx(info.getUserIdx());
        dto.setWriterNickname(info.getName());
        dto.setUploadFiles(uploadFiles);
        dto.setTemporary(isTemporary == 1);

        try {
            service.insertCommunity(dto, uploadPath);
        } catch (Exception e) {
            log.error("writeSubmit error", e);
        }

        if (isTemporary == 1) {
            return "redirect:/community/list?tab=temp";
        }
        return "redirect:/community/list";
    }

    @GetMapping("article/{id}")
    public String article(@PathVariable("id") long id,
            @RequestParam(name = "page", defaultValue = "1") String page,
            @RequestParam(name = "schType", defaultValue = "all") String schType,
            @RequestParam(name = "kwd", defaultValue = "") String kwd,
            @SessionAttribute("member") SessionInfo info,
            Model model) throws Exception {

        String query = "page=" + page;
        try {
            kwd = URLDecoder.decode(kwd, "UTF-8");
            if (!kwd.isBlank()) {
                query += "&schType=" + schType + "&kwd=" + URLEncoder.encode(kwd, "UTF-8");
            }

            service.updateHitCount(id);
            CommunityDto dto = service.getCommunity(id);

            boolean isWriter = dto.getMemberIdx().equals(info.getUserIdx());
            model.addAttribute("isWriter", isWriter);

            Map<String, Object> map = new HashMap<>();
            map.put("communityId", id);
            map.put("memberIdx", info.getUserIdx());
            
            model.addAttribute("isUserLiked", service.isUserLiked(map));
            model.addAttribute("isUserScraped", service.isUserScraped(map));
            
            model.addAttribute("dto", dto);
            model.addAttribute("page", page);
            model.addAttribute("query", query);
            model.addAttribute("kakaoMapKey", kakaoMapKey);

            return "community/article";
        } catch (Exception e) {
            return "redirect:/community/list?" + query;
        }
    }
    
    @GetMapping("update")
    public String updateForm(@RequestParam("id") long id,
            @RequestParam("page") String page,
            @SessionAttribute("member") SessionInfo info,
            Model model) throws Exception {
        
        CommunityDto dto = service.getCommunity(id);
        if (dto == null || !dto.getMemberIdx().equals(info.getUserIdx())) {
            return "redirect:/community/list?page=" + page;
        }

        model.addAttribute("mode", "update");
        model.addAttribute("page", page);
        model.addAttribute("dto", dto);
        model.addAttribute("kakaoMapKey", kakaoMapKey); 

        return "community/write";
    }

    @PostMapping("update")
    public String updateSubmit(CommunityDto dto,
            @RequestParam(value = "uploadFiles", required = false) List<MultipartFile> uploadFiles,
            @RequestParam("page") String page,
            @SessionAttribute("member") SessionInfo info) throws Exception {

        try {
            dto.setMemberIdx(info.getUserIdx());
            dto.setUploadFiles(uploadFiles);
            service.updateCommunity(dto, uploadPath);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/community/article/" + dto.getId() + "?page=" + page;
    }

    @GetMapping("delete")
    public String delete(@RequestParam("id") long id,
            @RequestParam("page") String page,
            @SessionAttribute("member") SessionInfo info) throws Exception {

        try {
            service.deleteCommunity(id, uploadPath);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/community/list?page=" + page;
    }
    
    @PostMapping("like")
    public ResponseEntity<?> like(@RequestParam("id") long id, @SessionAttribute("member") SessionInfo info) {
        Map<String, Object> result = new HashMap<>();
        try {
            boolean liked = service.toggleLike(id, info.getUserIdx());
            int count = service.getLikeCount(id);
            result.put("state", "true");
            result.put("liked", liked);
            result.put("count", count);
        } catch (Exception e) {
            result.put("state", "false");
        }
        return ResponseEntity.ok(result);
    }
    
    @PostMapping("scrap")
    public ResponseEntity<?> scrap(@RequestParam("id") long id, @SessionAttribute("member") SessionInfo info) {
        Map<String, Object> result = new HashMap<>();
        try {
            boolean scraped = service.toggleScrap(id, info.getUserIdx());
            result.put("state", "true");
            result.put("scraped", scraped);
        } catch (Exception e) {
            result.put("state", "false");
        }
        return ResponseEntity.ok(result);
    }
    
    @GetMapping("download")
    public ResponseEntity<?> download(@RequestParam("filename") String filename, @RequestParam("originalFilename") String originalFilename) {
        try {
            return storageService.downloadFile(uploadPath, filename, originalFilename);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

    // 임시저장 목록 조회
    @GetMapping("temp/list")
    public ResponseEntity<?> tempList(@SessionAttribute("member") SessionInfo info) {
        try {
            List<CommunityDto> list = service.getTempList(info.getUserIdx());
            return ResponseEntity.ok(list);
        } catch (Exception e) {
            log.error("임시저장 목록 조회 실패", e);
            return ResponseEntity.badRequest().build();
        }
    }

    // 임시저장 글 삭제
    @PostMapping("temp/delete")
    public ResponseEntity<?> tempDelete(@RequestParam("id") long id,
            @SessionAttribute("member") SessionInfo info) {
        Map<String, Object> result = new HashMap<>();
        try {
            service.deleteTempCommunity(id, info.getUserIdx(), uploadPath);
            result.put("state", "true");
        } catch (Exception e) {
            log.error("임시저장 삭제 실패", e);
            result.put("state", "false");
            result.put("message", e.getMessage());
        }
        return ResponseEntity.ok(result);
    }

    // 임시저장 글 불러오기 (글쓰기 페이지로 이동)
    @GetMapping("temp/load")
    public String tempLoad(@RequestParam("id") long id,
            @SessionAttribute("member") SessionInfo info,
            Model model) {
        try {
            CommunityDto dto = service.getCommunity(id);
            if (dto == null || !dto.getMemberIdx().equals(info.getUserIdx())) {
                return "redirect:/community/write";
            }
            model.addAttribute("mode", "update");
            model.addAttribute("page", "1");
            model.addAttribute("dto", dto);
            model.addAttribute("kakaoMapKey", kakaoMapKey);
            return "community/write";
        } catch (Exception e) {
            return "redirect:/community/write";
        }
    }
}