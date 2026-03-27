package com.sp.app.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.sp.app.admin.service.AdminDashboardService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
public class HomeManageController {
	
	private final AdminDashboardService adminDashboardService;
	
	@GetMapping("/admin")
	public String handleHome(Model model) {
        model.addAllAttributes(adminDashboardService.getDashboardData());
		return "admin/main/home";
	}
}
