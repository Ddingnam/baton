package com.sp.app.service;

import org.springframework.web.multipart.MultipartFile;

import com.sp.app.model.TradeAiResponse;

public interface TradeAiService {
	public TradeAiResponse analyzeProductImage(MultipartFile imageFile) throws Exception;
}
