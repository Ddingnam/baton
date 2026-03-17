package com.sp.app.admin.controller;

import com.sp.app.admin.service.AdminPaymentService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/payment")
public class AdminPaymentController {

    private final AdminPaymentService adminPaymentService;

    @GetMapping("/list")
    public String paymentList(
            @RequestParam(name = "page", defaultValue = "1") int page,
            @RequestParam(name = "schType", required = false) String schType,
            @RequestParam(name = "kwd", required = false) String kwd,
            @RequestParam(name = "status", required = false) String status,
            Model model) {

        int pageSize = 15;
        int offset = (page - 1) * pageSize;

        Map<String, Object> map = new HashMap<>();
        map.put("schType", schType);
        map.put("kwd", kwd);
        map.put("status", status);
        map.put("offset", offset);
        map.put("pageSize", pageSize);

        List<Map<String, Object>> list = adminPaymentService.listPayment(map);
        int totalCount = adminPaymentService.dataCount(map);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        model.addAttribute("list", list);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("page", page);
        model.addAttribute("schType", schType);
        model.addAttribute("kwd", kwd);
        model.addAttribute("status", status);

        return "admin/payment/list";
    }
}