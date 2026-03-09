package com.sp.app.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.sp.app.common.MyUtil;
import com.sp.app.common.StorageService;
import com.sp.app.model.Trade;
import com.sp.app.model.TradeAiResponse;
import com.sp.app.model.TradeImg;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.TradeService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/trade/*")
public class TradeController {
	private final TradeService service;
	private final StorageService storageService;
	private final MyUtil myUtil;
	private final com.sp.app.service.EscrowService escrowService;
	private final com.sp.app.service.TradeAiService tradeAiService;
	
	@Value("${file.upload-root}/trade")
    private String uploadPath;
	
	@GetMapping("list")
	public String list(@RequestParam(value = "page", defaultValue = "1") int current_page,
	        @RequestParam(value = "keyword", defaultValue = "") String keyword,
	        @RequestParam(value = "priceMin", required = false) String priceMin,
	        @RequestParam(value = "priceMax", required = false) String priceMax,
	        @RequestParam(value = "available", required = false) String available,
	        @RequestParam(value = "categoryIdx", defaultValue = "") String categoryIdx,
	        @RequestParam(value = "sort", defaultValue = "newest") String sort,
	        @AuthenticationPrincipal CustomUserDetails userDetails,
	        Model model) {
		try {
			
			List<Map<String, Object>> categoryList = service.categoryList();
	        model.addAttribute("categoryList", categoryList);
			
			int size = 12; // 한 페이지에 보여줄 개수
	        int total_page = 0;
	        int dataCount = 0;

	        Map<String, Object> map = new HashMap<>();
	        map.put("keyword", keyword);
	        map.put("categoryIdx", categoryIdx);
	        map.put("priceMin", priceMin);
	        map.put("priceMax", priceMax);
	        map.put("available", available);
	        map.put("sort", sort);
	        
	        if (userDetails != null) {
	            map.put("userIdx", userDetails.getMember().getUserIdx());
	        }

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
	        model.addAttribute("priceMin", priceMin);
	        model.addAttribute("priceMax", priceMax);
	        model.addAttribute("available", available);
	        model.addAttribute("sort", sort);
		} catch (Exception e) {
			log.info("list", e);
		}
		return "trade/list";
	}
	
	@GetMapping("article")
	public String article(@RequestParam("productIdx") long productIdx, 
			@AuthenticationPrincipal CustomUserDetails userDetails, Model model) {
		try {
			Trade dto = service.findByIdx(productIdx);
			List<TradeImg> imageList = service.findImgsByIdx(productIdx);
			List<String> tagList = service.findTagsByIdx(productIdx);
			
			boolean isLiked = false;
	        if (userDetails != null) {
	            isLiked = service.isUserLiked(productIdx, userDetails.getMember().getUserIdx());
	        }
			
	        Map<String, Object> escrowInfo = escrowService.getTradeTransaction(productIdx);
	        model.addAttribute("escrowInfo", escrowInfo);
	        
			model.addAttribute("trade", dto);
			model.addAttribute("imageList", imageList);
			model.addAttribute("tagList", tagList);
			model.addAttribute("isLiked", isLiked);
			
		} catch (Exception e) {
			log.info("article : ", e);
		}
		
		return "trade/article";
	}
	
	@GetMapping("write")
	public String writeForm(Model model,
			@AuthenticationPrincipal CustomUserDetails userDetails) {
		try {
			List<Map<String, Object>> categoryList = service.categoryList();
		    model.addAttribute("categoryList", categoryList);
			model.addAttribute("mode", "write");
			
			Trade dto = service.findTempTradeByUserIdx((userDetails.getMember().getUserIdx()));
	        if (dto != null) {
	            model.addAttribute("tempProductIdx", dto.getProductIdx());
	        }
			
		} catch (Exception e) {
			log.info("writeForm : ", e);
		}
		
		return "trade/write";
	}
	
	@PostMapping("write")
	public String writeSubmit(Trade dto, 
			@AuthenticationPrincipal CustomUserDetails userDetails) throws Exception{
		try {
			dto.setUserIdx(userDetails.getUserIdx());

			service.saveTradePost(dto, uploadPath);
		} catch (Exception e) {
			log.info("writeSubmit : ", e);
		}
		return "redirect:/trade/list";
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
			return "redirect:/trade/list";
		}
	}
	
	@PostMapping("update")
	public String updateSubmit(Trade dto, 
			@AuthenticationPrincipal CustomUserDetails userDetails) {
		try {
			Trade originDto = service.findByIdx(dto.getProductIdx());
			
			if (originDto != null && userDetails != null && originDto.getUserIdx() == userDetails.getUserIdx()) {
	            service.updateTradePost(dto, uploadPath);

	            return "redirect:/trade/article?productIdx=" + dto.getProductIdx();
	        }
			
		} catch (Exception e) {
			log.info("updateSubmit : ", e);
		}
		
		return "redirect:/trade/list";
	}
	
	@GetMapping("updateData")
	@ResponseBody
	public Map<String, Object> getUpdateData(@RequestParam("productIdx") long productIdx) {
	    Map<String, Object> data = new HashMap<>();
	    
	    Trade dto = service.findByIdx(productIdx);
	    List<TradeImg> imageList = service.findImgsByIdx(productIdx);
	    List<String> tagList = service.findTagsByIdx(productIdx);
	    
	    data.put("trade", dto);
	    data.put("imageList", imageList);
	    data.put("tagList", tagList);
	    
	    return data;
	}
	
	@GetMapping("delete")
	public String delete(@RequestParam("productIdx") long productIdx) {
		try {
			service.deleteTradePost(productIdx, uploadPath);
		} catch (Exception e) {
			log.info("delete : ", e);
		}
		
		return "redirect:/trade/list";
	}
	
	@PostMapping("updateStatus")
	@ResponseBody
	public void updateTradeStatus(@RequestParam("productIdx") long productIdx, 
			@RequestParam("tradeStatus") String tradeStatus) {
		try {
	        service.updateTradeStatus(productIdx, tradeStatus);

	    } catch (Exception e) {
	    	log.info("updateTradeStatus : ", e);
	    }
	}
	
	@PostMapping("toggleLike")
	@ResponseBody
	public Map<String, Object> toggleLike(
	        @RequestParam("productIdx") long productIdx,
	        @AuthenticationPrincipal CustomUserDetails userDetails) {
	    
	    Map<String, Object> map = new HashMap<>();
	    try {
	        if (userDetails == null) {
	            map.put("status", "loginRequired");
	            return map;
	        }

	        long userIdx = userDetails.getMember().getUserIdx();
	        
	        Map<String, Object> result = service.toggleWishList(productIdx, userIdx);
	        
	        map.put("status", "success");
	        map.put("isLiked", result.get("isLiked"));
	        map.put("likeCount", result.get("likeCount"));
	        
	    } catch (Exception e) {
	        map.put("status", "error");
	        map.put("message", e.getMessage());
	    }
	    
	    return map;
	}
	
	@PostMapping("pullUp")
	@ResponseBody
	public Map<String, Object> tradePullUp(@RequestParam("productIdx") long productIdx) {
		Map<String, Object> map = new HashMap<>();
		
		try {
	        service.updateLastUpDate(productIdx);
	        
	        map.put("status", "success");
		} catch (Exception e) {
			log.info("tradePullUp : ", e);
			map.put("status", "error");
		}
		
		return map;
	}
	
	@PostMapping("aigenerate")
    @ResponseBody
    public Map<String, Object> aiVisionGenerate(@RequestParam("imageFile") MultipartFile imageFile) {
        Map<String, Object> model = new HashMap<>();
        
        try {
            if (imageFile == null || imageFile.isEmpty()) {
                model.put("status", "false");
                model.put("message", "이미지 파일이 없습니다.");
                return model;
            }

            TradeAiResponse response = tradeAiService.analyzeProductImage(imageFile);
            
            model.put("status", "success");
            model.put("title", response.getTitle());
            model.put("content", response.getContent());
            
        } catch (Exception e) {
            log.info("aiVisionGenerate : ", e);
            model.put("status", "error");
            model.put("message", "AI 분석 중 오류가 발생했습니다.");
        }
        
        return model;
    }
}
