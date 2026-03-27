package com.sp.app.controller;

import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sp.app.model.Trade;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.TradeService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/trade/*")
public class TradeViewController {
	
	private final TradeService service;	
	
	@Value("${file.upload-root}/trade")
    private String uploadPath;

    @GetMapping("main")
    public String tradeMain() {
        return "trade/main";
    }
	
	@GetMapping("update")
	public String updateForm(@RequestParam("productIdx") long productIdx, 
			@AuthenticationPrincipal CustomUserDetails userDetails, Model model) {
		try {
			Trade dto = Objects.requireNonNull(service.findByIdx(productIdx));
			
			if(dto == null || userDetails == null || dto.getUserIdx() != userDetails.getUserIdx()) {
				return "redirect:/trade/list";
			}
			
			if(dto.getProductStatus().equals("판매완료")) {
				return "redirect:/trade/list";
			}
			
			List<Map<String, Object>> categoryList = service.categoryList();
	        model.addAttribute("categoryList", categoryList);
			model.addAttribute("trade", dto);
			model.addAttribute("mode", "update");
			
			return "trade/write";
			
		} catch (Exception e) {
			log.info("updateForm : ", e);
			return "redirect:/trade/main";
		}
	}
}
