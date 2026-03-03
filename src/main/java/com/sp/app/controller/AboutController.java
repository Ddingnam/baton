package com.sp.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/about/*")
public class AboutController {

    @GetMapping("intro")
    public String intro(Model model) {
        model.addAttribute("menu", "intro");
        return "about/intro";
    }

    @GetMapping("service")
    public String service(Model model) {
    	model.addAttribute("menu", "service");
    	return "about/service";
    }

    @GetMapping("terms")
    public String terms(Model model) {
        model.addAttribute("menu", "terms");
        model.addAttribute("title", "서비스 이용약관");
        return "about/intro";
    }

    @GetMapping("privacy")
    public String privacy(Model model) {
        model.addAttribute("menu", "privacy");
        model.addAttribute("title", "개인정보처리방침");
        return "about/intro";
    }
}