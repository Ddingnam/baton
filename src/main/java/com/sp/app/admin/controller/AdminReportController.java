package com.sp.app.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sp.app.admin.domain.dto.ReportDto;
import com.sp.app.admin.service.AdminReportService;
import com.sp.app.common.PaginateUtil;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/admin/report")
public class AdminReportController {

    @Autowired
    private AdminReportService service;

    @Autowired
    private PaginateUtil paginateUtil;

    @GetMapping("/list")
    public String reportList(
            @RequestParam(value = "page", defaultValue = "1") int current_page,
            @RequestParam(value = "processStatus", defaultValue = "") String processStatus,
            @RequestParam(value = "domainType", required = false) String domainType,
            @RequestParam(value = "kwd", required = false) String kwd,
            HttpServletRequest req,
            Model model) throws Exception {

        int size = 10;
        int total_page = 0;
        int dataCount = 0;

        Map<String, Object> map = new HashMap<>();
        map.put("processStatus", processStatus);
        map.put("domainType", domainType);
        map.put("kwd", kwd);

        dataCount = service.dataCount(map);
        if (dataCount != 0) {
            total_page = paginateUtil.pageCount(dataCount, size);
        }

        if (total_page < current_page) {
            current_page = total_page;
        }

        int offset = (current_page - 1) * size;
        if (offset < 0) offset = 0;

        map.put("offset", offset);
        map.put("size", size);

        List<ReportDto> list = service.listReport(map);

        String cp = req.getContextPath();
        String query = "processStatus=" + processStatus;
        if (domainType != null) query += "&domainType=" + domainType;
        if (kwd != null)        query += "&kwd=" + kwd;
        String listUrl = cp + "/admin/report/list?" + query;
        String paging = paginateUtil.paging(current_page, total_page, listUrl);

        model.addAttribute("list", list);
        model.addAttribute("page", current_page);
        model.addAttribute("dataCount", dataCount);
        model.addAttribute("size", size);
        model.addAttribute("total_page", total_page);
        model.addAttribute("paging", paging);
        model.addAttribute("processStatus", processStatus);
        model.addAttribute("domainType", domainType);
        model.addAttribute("kwd", kwd);

        return "admin/report/list";
    }

    @GetMapping("/detail")
    @ResponseBody
    public ResponseEntity<ReportDto> reportDetail(
            @RequestParam(value = "reportIdx") Long reportIdx) {
        ReportDto dto = service.getReport(reportIdx);
        if (dto == null) return ResponseEntity.notFound().build();
        return ResponseEntity.ok(dto);
    }

    @PostMapping("/process")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> processReport(
            @RequestBody Map<String, Object> param) {

        Map<String, Object> result = new HashMap<>();
        try {
            service.processReport(param);
            result.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", e.getMessage());
        }
        return ResponseEntity.ok(result);
    }
}