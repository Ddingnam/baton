package com.sp.app.service;

import com.sp.app.domain.dto.AiResumeRequest;

public interface AlbaAiService {
    String generateResume(AiResumeRequest request) throws Exception;
}