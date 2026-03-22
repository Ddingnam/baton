package com.sp.app.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sp.app.domain.dto.AiResumeRequest;
import com.sp.app.service.AlbaAiService;

@RestController
@RequestMapping("/api/alba")
public class AlbaAiApiController {

    @Autowired
    private AlbaAiService albaAiService;

    // produces 설정으로 한글 깨짐 방지
    @PostMapping(value = "/generate-resume", produces = "text/plain;charset=UTF-8")
    public String generateResume(@RequestBody AiResumeRequest request) {
        try {
            // Service를 통해 Gemini API 호출 및 결과 반환
            return albaAiService.generateResume(request);
        } catch (Exception e) {
            e.printStackTrace();
            return "서버 오류로 인해 자기소개서를 생성하지 못했습니다.";
        }
    }
}