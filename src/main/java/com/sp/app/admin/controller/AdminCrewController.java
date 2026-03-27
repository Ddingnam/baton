package com.sp.app.admin.controller;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sp.app.domain.dto.CrewBoardDto;
import com.sp.app.domain.dto.CrewDto;
import com.sp.app.service.CrewBoardService;
import com.sp.app.service.CrewService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/crew")
public class AdminCrewController {

    private final CrewService crewService;
    private final CrewBoardService crewBoardService;

    @GetMapping("/list")
    public String list(
            @RequestParam(name = "page", defaultValue = "1") int page,
            @RequestParam(name = "categoryIdx", defaultValue = "0") int categoryIdx,
            @RequestParam(name = "joinType", defaultValue = "all") String joinType,
            @RequestParam(name = "kwd", defaultValue = "") String kwd,
            Model model) {

        int size = 12;
        int offset = (page - 1) * size;

        Map<String, Object> params = new LinkedHashMap<>();
        params.put("categoryIdx", categoryIdx);
        params.put("joinType", joinType);
        params.put("distance", "");
        params.put("isRecruiting", true);
        params.put("sortType", "latest");
        params.put("keyword", kwd == null ? "" : kwd.trim());
        params.put("offset", offset);
        params.put("size", size);

        List<CrewDto> list = crewService.listCrew(params);
        int dataCount = crewService.getCrewCount(params);
        int totalPage = dataCount == 0 ? 0 : (int) Math.ceil((double) dataCount / size);

        if (totalPage > 0 && page > totalPage) {
            page = totalPage;
        }

        model.addAttribute("list", list);
        model.addAttribute("page", page);
        model.addAttribute("size", size);
        model.addAttribute("total_page", totalPage);
        model.addAttribute("dataCount", dataCount);
        model.addAttribute("categoryIdx", categoryIdx);
        model.addAttribute("joinType", joinType);
        model.addAttribute("kwd", kwd == null ? "" : kwd.trim());

        return "admin/crew/list";
    }

    @GetMapping("/detail")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> detail(@RequestParam("crewIdx") Long crewIdx) {
        Map<String, Object> result = new LinkedHashMap<>();
        try {
            CrewDto crew = crewService.findByCrewIdx(crewIdx);
            Map<String, Object> boardData = crewBoardService.getPostList(crewIdx, 0L, 1, 5);

            result.put("success", true);
            result.put("crew", crew);
            result.put("recentPosts", boardData.getOrDefault("posts", new ArrayList<>()));
            result.put("postCount", boardData.getOrDefault("totalElements", 0));
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }

    @GetMapping("/inspection")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> inspection(@RequestParam("crewIdx") Long crewIdx) {
        Map<String, Object> result = new LinkedHashMap<>();
        try {
            CrewDto crew = crewService.findByCrewIdx(crewIdx);
            Map<String, Object> boardData = crewBoardService.getPostList(crewIdx, 0L, 1, 10);

            @SuppressWarnings("unchecked")
            List<CrewBoardDto> posts = (List<CrewBoardDto>) boardData.getOrDefault("posts", new ArrayList<CrewBoardDto>());

            int totalComments = 0;
            int totalLikes = 0;
            Integer hottestViews = 0;
            String hottestTitle = "-";

            for (CrewBoardDto post : posts) {
                totalComments += post.getCommentCount() == null ? 0 : post.getCommentCount();
                totalLikes += post.getLikeCount() == null ? 0 : post.getLikeCount();
                int views = post.getViewCount() == null ? 0 : post.getViewCount();
                if (hottestViews == null || views > hottestViews) {
                    hottestViews = views;
                    hottestTitle = post.getTitle();
                }
            }

            double participationRate = 0d;
            if (crew != null && crew.getMaxMember() > 0) {
                participationRate = (double) crew.getCurrentMember() * 100d / (double) crew.getMaxMember();
            }

            result.put("success", true);
            result.put("crew", crew);
            result.put("posts", posts);
            result.put("postCount", boardData.getOrDefault("totalElements", 0));
            result.put("totalComments", totalComments);
            result.put("totalLikes", totalLikes);
            result.put("participationRate", Math.round(participationRate * 10.0) / 10.0);
            result.put("hottestTitle", hottestTitle);
            result.put("hottestViews", hottestViews == null ? 0 : hottestViews);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }
}
