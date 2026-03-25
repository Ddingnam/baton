package com.sp.app.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.sp.app.model.Trade;
import com.sp.app.model.TradeAiResponse;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.EscrowService;
import com.sp.app.service.FollowService;
import com.sp.app.service.TradeAiService;
import com.sp.app.service.TradeService;
import com.sp.app.service.WishListService;
import com.sp.app.service.NotificationService;
import com.sp.app.mapper.TradeMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/api/trade")
public class TradeRestController {

    private final TradeService tradeService;
    private final EscrowService escrowService;
    private final WishListService wishListService;
    private final FollowService followService;
    private final TradeAiService tradeAiService;
    private final NotificationService notificationService;
    private final TradeMapper tradeMapper;

    @Value("${file.upload-root}/trade")
    private String uploadPath;

    @GetMapping("/list")
    public ResponseEntity<?> list(
            @RequestParam(value = "page", defaultValue = "1") int currentPage,
            @RequestParam(value = "keyword", defaultValue = "") String keyword,
            @RequestParam(value = "priceMin", required = false) String priceMin,
            @RequestParam(value = "priceMax", required = false) String priceMax,
            @RequestParam(value = "available", required = false) String available,
            @RequestParam(value = "categoryIdx", defaultValue = "") String categoryIdx,
            @RequestParam(value = "sort", defaultValue = "newest") String sort,
            @RequestParam(value = "km", defaultValue = "1") double km,
            @AuthenticationPrincipal CustomUserDetails userDetails) {

        Map<String, Object> result = new HashMap<>();
        try {
            String regionCode = userDetails.getMember().getUserRegionInfo().getActiveRegion().getRegionCode();
            Map<String, Object> latLng = tradeService.findLatLngByRegionCode(regionCode);
            List<Map<String, Object>> categoryList = tradeService.categoryList();

            int size = 12;
            Map<String, Object> map = new HashMap<>();
            map.put("keyword", keyword);      
            map.put("regionCode", regionCode);
            map.put("categoryIdx", categoryIdx); 
            map.put("priceMin", priceMin);
            map.put("priceMax", priceMax);     
            map.put("available", available);
            map.put("sort", sort);             
            map.put("userIdx", userDetails.getMember().getUserIdx());
            
            if (latLng != null) { 
            	map.put("lat", latLng.get("LAT"));
            	map.put("lng", latLng.get("LNG")); 
            	map.put("km", km); 
            }

            int dataCount = tradeService.dataCount(map);
            int totalPage = dataCount == 0 ? 0 : dataCount / size + (dataCount % size > 0 ? 1 : 0);
            if (currentPage > totalPage && totalPage > 0) currentPage = totalPage;

            map.put("start", (currentPage - 1) * size + 1);
            map.put("end", currentPage * size);

            result.put("tradeList", tradeService.tradeList(map));
            result.put("categoryList", categoryList);
            result.put("currentPage", currentPage);
            result.put("totalPage", totalPage);
        } catch (Exception e) {
            log.info("api/trade/list : ", e);
            result.put("tradeList", new java.util.ArrayList<>());
            result.put("totalPage", 0); 
            result.put("currentPage", 1);
        }
        return ResponseEntity.ok(result);
    }

    @GetMapping("/write-init")
    public ResponseEntity<?> writeInit(@AuthenticationPrincipal CustomUserDetails userDetails) {
        Map<String, Object> result = new HashMap<>();
        try {
            result.put("categoryList", tradeService.categoryList());
            if (userDetails != null) {
                Trade temp = tradeService.findTempTradeByUserIdx(userDetails.getMember().getUserIdx());
                if (temp != null) {
                	result.put("tempProductIdx", temp.getProductIdx());
                }
            }
        } catch (Exception e) { 
        	log.info("api/trade/write-init : ", e); 
        }
        return ResponseEntity.ok(result);
    }

    @GetMapping("/article/{productIdx}")
    public ResponseEntity<?> article(
            @PathVariable("productIdx") long productIdx,
            @AuthenticationPrincipal CustomUserDetails userDetails) {

        Map<String, Object> result = new HashMap<>();
        try {
            Trade trade = tradeService.findByIdx(productIdx);
            boolean isLiked = false, isOwner = false, isLoggedIn = (userDetails != null);
            Long currentUserIdx = null;
            
            if (userDetails != null) {
                long userIdx = userDetails.getMember().getUserIdx();
                currentUserIdx = userIdx;
                isLiked = wishListService.isUserLiked(productIdx, userIdx);
                isOwner = (trade != null && trade.getUserIdx() == userIdx);
            }
            
            result.put("trade", trade);
            result.put("imageList", tradeService.findImgsByIdx(productIdx));
            result.put("tagList", tradeService.findTagsByIdx(productIdx));
            result.put("escrowInfo", escrowService.getTradeTransaction(productIdx));
            result.put("isLiked", isLiked);
            result.put("isOwner", isOwner);
            result.put("isLoggedIn", isLoggedIn);
            result.put("currentUserIdx", currentUserIdx);
        } catch (Exception e) {
            log.info("api/trade/article : ", e);
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(result);
    }
    
    @PostMapping("/write")
	public ResponseEntity<?> writeSubmit(Trade dto, 
			@AuthenticationPrincipal CustomUserDetails userDetails) throws Exception{
    	
    	Map<String, Object> result = new HashMap<>();
    	
    	try {
			dto.setUserIdx(userDetails.getUserIdx());
			dto.setRegionCode(userDetails.getMember().getUserRegionInfo().getActiveRegion().getRegionCode());
			tradeService.saveTradePost(dto, uploadPath);
			
			result.put("status", "success");
	        return ResponseEntity.ok(result);
		} catch (Exception e) {
			log.info("writeSubmit : ", e);
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("status", "fail", "message", e.getMessage()));
		}
		
	}

    @PostMapping("/update")
	public ResponseEntity<?> updateSubmit(Trade dto, 
			@AuthenticationPrincipal CustomUserDetails userDetails) {
		try {
			Trade originDto = tradeService.findByIdx(dto.getProductIdx());
			
			if (originDto != null && userDetails != null && originDto.getUserIdx() == userDetails.getUserIdx()) {
	            tradeService.updateTradePost(dto, uploadPath);

	            return ResponseEntity.ok(Map.of("status", "success"));
	        }
			return ResponseEntity.status(HttpStatus.FORBIDDEN).body("수정 권한이 없습니다.");
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
		}
		
	}
	
    @GetMapping("/updateData")
    public ResponseEntity<?> getUpdateData(@RequestParam("productIdx") long productIdx) {
        try {
            Map<String, Object> data = new HashMap<>();
            data.put("trade", tradeService.findByIdx(productIdx));
            data.put("imageList", tradeService.findImgsByIdx(productIdx));
            data.put("tagList", tradeService.findTagsByIdx(productIdx));
            return ResponseEntity.ok(data);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
    }
	
    @PostMapping("/delete")
    public ResponseEntity<?> delete(@RequestParam("productIdx") long productIdx) {
        try {
            tradeService.deleteTradePost(productIdx, uploadPath);
            return ResponseEntity.ok(Map.of("status", "success"));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }
	
    @PostMapping("/updateStatus")
    public ResponseEntity<?> updateTradeStatus(@RequestParam("productIdx") long productIdx, 
    		@RequestParam("tradeStatus") String tradeStatus) {
        try {
            Trade trade = tradeService.findByIdx(productIdx);
            tradeService.updateTradeStatus(productIdx, tradeStatus);
            
            if("판매완료".equals(tradeStatus) || "예약중".equals(tradeStatus)) {
                List<Long> wishUsers = tradeMapper.getWishUserList(productIdx);
                for(Long uId : wishUsers) {
                    notificationService.sendTradeNotification(
                        uId, 
                        "찜하신 [" + trade.getTitle() + "] 상품이 " + tradeStatus + "로 변경되었습니다.", 
                        "/trade/article?productIdx=" + productIdx
                    );
                }
            }
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
    }
	
    @PostMapping("/toggleLike")
    public ResponseEntity<?> toggleLike(@RequestParam("productIdx") long productIdx, 
    		@AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        try {
            return ResponseEntity.ok(wishListService.toggleWishList(productIdx, userDetails.getMember().getUserIdx()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
    }
	
    @PostMapping("/toggleFollow")
    public ResponseEntity<?> toggleFollow(
            @RequestParam("followingIdx") long followingIdx,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        
        if (userDetails == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();

        try {
            long followerIdx = userDetails.getMember().getUserIdx();
            boolean isFollowing = followService.isFollowing(followerIdx, followingIdx);
            Map<String, Object> map = new HashMap<>();
            
            if (isFollowing) {
                long count = followService.unfollow(followerIdx, followingIdx);
                map.put("isFollowing", false);
                map.put("followerCount", count);
            } else {
                long count = followService.follow(followerIdx, followingIdx);
                map.put("isFollowing", true);
                map.put("followerCount", count);
                
                notificationService.sendTradeNotification(
                    followingIdx, 
                    userDetails.getMember().getNickname() + "님이 회원님을 팔로우하기 시작했습니다.", 
                    "/mypage/main?tab=trade"
                );
            }
            map.put("status", "success");
            return ResponseEntity.ok(map);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
    }

    @PostMapping("/pullUp")
    public ResponseEntity<?> tradePullUp(@RequestParam("productIdx") long productIdx) {
        Map<String, Object> map = new HashMap<>();
        try {
            String lastUpDateStr = tradeService.findLastUpDateByIdx(productIdx);
            
            if(lastUpDateStr != null) {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                LocalDateTime lastUpTime = LocalDateTime.parse(lastUpDateStr, formatter);
                LocalDateTime todayTime = LocalDateTime.now();
                
                if(lastUpTime.plusDays(1).isAfter(todayTime)) {
                    long diffSeconds = java.time.Duration.between(todayTime, lastUpTime.plusDays(1)).getSeconds();
                    long hours = diffSeconds / 3600;
                    long minutes = (diffSeconds % 3600) / 60;

                    map.put("status", "limit");
                    map.put("message", String.format("아직 끌어올릴 수 없습니다. (%d시간 %d분 남음)", hours, minutes));
                    return ResponseEntity.ok(map);
                }
            }
            
            tradeService.updateLastUpDate(productIdx);
            Trade trade = tradeService.findByIdx(productIdx);
            
            List<Long> wishUsers = tradeMapper.getWishUserList(productIdx);
            for(Long uId : wishUsers) {
                notificationService.sendTradeNotification(
                    uId, 
                    "찜하신 [" + trade.getTitle() + "] 상품이 끌어올림 되었습니다.", 
                    "/trade/article?productIdx=" + productIdx
                );
            }
            
            map.put("status", "success");
            return ResponseEntity.ok(map);
        } catch (Exception e) {
            log.info("tradePullUp : ", e);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
    }

    @PostMapping("/aigenerate")
    public ResponseEntity<?> aiVisionGenerate(@RequestParam("imageFile") MultipartFile imageFile) {
        try {
            if (imageFile == null || imageFile.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("status", "false", "message", "이미지 파일이 없습니다."));
            }

            TradeAiResponse response = tradeAiService.analyzeProductImage(imageFile);
            return ResponseEntity.ok(Map.of(
                "status", "success",
                "title", response.getTitle(),
                "content", response.getContent()
            ));
        } catch (Exception e) {
            log.info("aiVisionGenerate : ", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}