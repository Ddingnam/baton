package com.sp.app.admin.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sp.app.domain.dto.CommunityDto;
import com.sp.app.service.CommunityService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/community")
public class AdminCommunityController {

    private final CommunityService communityService;

    @Value("${file.upload-root}/community")
    private String uploadPath;

    @GetMapping("/list")
    public String list(
            @RequestParam(name = "page",     defaultValue = "1")  int page,
            @RequestParam(name = "schType",  defaultValue = "all") String schType,
            @RequestParam(name = "kwd",      defaultValue = "")    String kwd,
            @RequestParam(name = "category", defaultValue = "")    String category,
            Model model) throws Exception {

        int size = 15;
        Pageable pageable = PageRequest.of(page - 1, size, Sort.by("id").descending());

        Page<CommunityDto> pages;
        if (!category.isEmpty()) {
            if (!kwd.isEmpty()) {
                if ("subject".equals(schType)) {
                    pages = communityService.getCommunityListByCategory(pageable, category, "subject", kwd);
                } else if ("content".equals(schType)) {
                    pages = communityService.getCommunityListByCategory(pageable, category, "content", kwd);
                } else {
                    pages = communityService.getCommunityListByCategory(pageable, category, "all", kwd);
                }
            } else {
                pages = communityService.getCommunityListByCategory(pageable, category, "", "");
            }
        } else {
            pages = communityService.getCommunityList(pageable, schType, kwd);
        }

        int total_page = pages.getTotalPages();
        long dataCount = pages.getTotalElements();
        if (total_page > 0 && total_page < page) page = total_page;

        model.addAttribute("list",       pages.getContent());
        model.addAttribute("page",       page);
        model.addAttribute("total_page", total_page);
        model.addAttribute("dataCount",  dataCount);
        model.addAttribute("schType",    schType);
        model.addAttribute("kwd",        kwd);
        model.addAttribute("category",   category);

        return "admin/community/list";
    }

    @PostMapping("/delete")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> delete(@RequestBody Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            long id = Long.parseLong(param.get("id").toString());
            communityService.deleteCommunity(id, uploadPath);
            result.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", e.getMessage());
        }
        return ResponseEntity.ok(result);
    }
}