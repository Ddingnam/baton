package com.sp.app.controller;

import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.sp.app.service.MemberService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping(value = "/member/*")
public class MemberRestController {
	private final MemberService service;
	
	@GetMapping("/chkId")
    public Map<String, Object> checkId(@RequestParam String userId) {
        // boolean available = service.isIdAvailable(userId);
        // return Map.of("available", available);
		return null;
    }

    @GetMapping("/chkNickname")
    public Map<String, Object> checkNick(@RequestParam String nickname) {
        // boolean available = service.isNickAvailable(nickname);
        // return Map.of("available", available);
    	return null;
    }
	

}
