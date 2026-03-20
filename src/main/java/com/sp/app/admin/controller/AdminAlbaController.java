package com.sp.app.admin.controller;

import com.sp.app.admin.mapper.AdminAlbaMapper;
import com.sp.app.model.JobPosting;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/alba")
public class AdminAlbaController {

    private final AdminAlbaMapper adminAlbaMapper;

    @GetMapping("/list")
    public String list(
            @RequestParam(name = "page",          defaultValue = "1")  int page,
            @RequestParam(name = "schType",       defaultValue = "all") String schType,
            @RequestParam(name = "kwd",           defaultValue = "")    String kwd,
            @RequestParam(name = "category",      defaultValue = "")    String category,
            @RequestParam(name = "recruitStatus", defaultValue = "")    String recruitStatus,
            Model model) {

        int size  = 15;
        int start = (page - 1) * size + 1;
        int end   = page * size;

        Map<String, Object> map = new HashMap<>();
        map.put("schType",       schType);
        map.put("keyword",       kwd);
        map.put("category",      category.isEmpty()      ? null : category);
        map.put("recruitStatus", recruitStatus.isEmpty() ? null : recruitStatus);
        map.put("start",         start);
        map.put("end",           end);

        List<JobPosting> list = adminAlbaMapper.listPosting(map);
        int dataCount         = adminAlbaMapper.dataCount(map);
        int total_page        = (int) Math.ceil((double) dataCount / size);
        if (total_page > 0 && total_page < page) page = total_page;

        model.addAttribute("list",          list);
        model.addAttribute("page",          page);
        model.addAttribute("total_page",    total_page);
        model.addAttribute("dataCount",     dataCount);
        model.addAttribute("schType",       schType);
        model.addAttribute("kwd",           kwd);
        model.addAttribute("category",      category);
        model.addAttribute("recruitStatus", recruitStatus);

        return "admin/alba/list";
    }

    @GetMapping("/detail")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> detail(@RequestParam("id") long id) {
        Map<String, Object> result = new LinkedHashMap<>();
        try {
            JobPosting   posting = adminAlbaMapper.findById(id);
            List<String> images  = adminAlbaMapper.findImages(id);

            result.put("success", true);
            result.put("posting", posting);
            result.put("images",  images);
        } catch (Exception e) {
            result.put("success", false);
            result.put("msg",     e.getMessage());
        }
        return ResponseEntity.ok(result);
    }

    @PostMapping("/delete")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> delete(@RequestBody Map<String, Object> param) {
        Map<String, Object> result = new HashMap<>();
        try {
            long id = Long.parseLong(param.get("id").toString());
            adminAlbaMapper.deleteImages(id);
            adminAlbaMapper.deletePosting(id);
            result.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg",     e.getMessage());
        }
        return ResponseEntity.ok(result);
    }
}