package com.sp.app.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/community/*")
public class CommunityController {
   
	@GetMapping("list")
    public String list() {
        return "community/list";
    }
    
    @Value("${kakao.map.key}")
    private String kakaoMapKey;
    
    @GetMapping("write")
    public String write(Model model) {
        model.addAttribute("kakaoMapKey", kakaoMapKey);
        return "community/write";
    }
    
    @GetMapping("article/{id}")
    public String article() {
    	return "community/article";
    }

 
}