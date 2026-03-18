package com.sp.app.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.sp.app.domain.dto.SessionInfo;
import com.sp.app.mapper.ReportMapper;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/report")
public class ReportApiController {

    private final ReportMapper reportMapper;

    @PostMapping("/submit")
    public ResponseEntity<?> submit(
            @RequestParam("domainType")      String domainType,
            @RequestParam("targetIdx")       Long   targetIdx,
            @RequestParam("reportedUserIdx") Long   reportedUserIdx,
            @RequestParam("reportType")      String reportType,
            @RequestParam(value = "reportContent", defaultValue = "") String reportContent,
            HttpSession session) {

        Map<String, Object> result = new HashMap<>();

        SessionInfo info = (SessionInfo) session.getAttribute("member");
        if (info == null) {
            result.put("state", "unauthorized");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(result);
        }

        // long(primitive) vs Long(wrapper) 비교 - .longValue() 사용
        if (reportedUserIdx != null && info.getUserIdx() == reportedUserIdx.longValue()) {
            result.put("state", "selfReport");
            return ResponseEntity.ok(result);
        }

        try {
            Map<String, Object> param = new HashMap<>();
            param.put("reporterIdx",     info.getUserIdx());
            param.put("reportedUserIdx", reportedUserIdx);
            param.put("domainType",      domainType.toUpperCase());
            param.put("targetIdx",       targetIdx);
            param.put("reportType",      reportType);
            param.put("reportContent",   reportContent != null ? reportContent : "");

            int duplicate = reportMapper.checkDuplicate(param);
            if (duplicate > 0) {
                result.put("state", "duplicate");
                return ResponseEntity.ok(result);
            }

            reportMapper.insertReport(param);
            result.put("state", "success");
            return ResponseEntity.ok(result);

        } catch (Exception e) {
            log.error("report submit error: {}", e.getMessage(), e);
            result.put("state", "error");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(result);
        }
    }
}