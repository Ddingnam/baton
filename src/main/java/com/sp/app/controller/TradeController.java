package com.sp.app.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.sp.app.domain.dto.SessionInfo;
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
	public String list(@RequestParam(value = "page", defaultValue = "1") int current_page,
	        @RequestParam(value = "keyword", defaultValue = "") String keyword,
	        @RequestParam(value = "categoryIdx", defaultValue = "") String categoryIdx,
	        Model model) {
		try {
			int size = 12; // 한 페이지에 보여줄 개수
	        int total_page = 0;
	        int dataCount = 0;

	        Map<String, Object> map = new HashMap<>();
	        map.put("keyword", keyword);
	        map.put("categoryIdx", categoryIdx);

	        dataCount = service.dataCount(map);
	        if (dataCount != 0) {
	            total_page = dataCount / size + (dataCount % size > 0 ? 1 : 0);
	        }

	        if (current_page > total_page) current_page = total_page;

	        int start = (current_page - 1) * size + 1;
	        int end = current_page * size;
	        map.put("start", start);
	        map.put("end", end);

	        List<Trade> list = service.tradeList(map);

	        model.addAttribute("tradeList", list);
	        model.addAttribute("dataCount", dataCount);
	        model.addAttribute("page", current_page);
	        model.addAttribute("total_page", total_page);
	        model.addAttribute("keyword", keyword);
	        model.addAttribute("categoryIdx", categoryIdx);
		} catch (Exception e) {
			log.info("list", e);
		}
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
	public String writeForm(Model model) {
		
		model.addAttribute("mode", "write");
		
		return "trade/write";
	}
	
	@PostMapping("write")
	public String writeSubmit(Trade dto) throws Exception{
		try {
			service.insertTradePost(dto);
		} catch (Exception e) {
			log.info("writeSubmit : ", e);
		}
		return "redirect:/trade/list";
	}
	
	@GetMapping("update")
	public String updateForm(@RequestParam("productIdx") long productIdx, 
			@RequestParam(name = "page") String page, Model model) {
		try {
			Trade dto = Objects.requireNonNull(service.findByIdx(productIdx));
			
			model.addAttribute("trade", dto);
			model.addAttribute("mode", "update");
			model.addAttribute("page", page);
					
			
		} catch (Exception e) {
			log.info("updateForm : ", e);
		}
		return "trade/write";
	}
	
	@PostMapping("update")
	public String updateSubmit() {
		return "trade/article";
	}
	
	@GetMapping("delete")
	public String delete(@RequestParam("productIdx") long productIdx) {
		try {
			service.deleteTradePost(productIdx);
		} catch (Exception e) {
			log.info("delete : ", e);
		}
		
		return "redirect:/trade/list";
	}
}
