package com.sp.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sp.app.model.Trade;
import com.sp.app.service.TradeService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/trade/*")
public class TradeController {
	private final TradeService service;
	
	@GetMapping("list")
	public String list() {
		return "trade/list";
	}
	
	@GetMapping("write")
	public String writeForm() {
		return "trade/write";
	}
	
	@PostMapping("write")
	public String writeSubmit(Trade dto) throws Exception{
		try {
			service.insertTradePost(dto);
		} catch (Exception e) {
			log.info("writeSubmit : ", e);
		}
		
		return "trade/list";
	}
}
