package com.sp.app.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sp.app.model.Trade;
import com.sp.app.model.TradeImg;
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
	
	@GetMapping("article")
	public String article(@RequestParam("productIdx") long productIdx, Model model) {
		try {
			Trade dto = service.findByIdx(productIdx);
			List<TradeImg> imageList = service.findImgsByIdx(productIdx);
			List<String> tagList = service.findTagsByIdx(productIdx);
			
			model.addAttribute("trade", dto);
			model.addAttribute("imageList", imageList);
			model.addAttribute("tagList", tagList);
			
		} catch (Exception e) {
			log.info("article : ", e);
		}
		
		return "trade/article";
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
	
	@GetMapping("update")
	public String updateForm() {
		return "trade/write";
	}
	
	@PostMapping("update")
	public String updateSubmit() {
		return "trade/article";
	}
	
	@GetMapping("delete")
	public String delete() {
		return "redirect:/";
	}
}
