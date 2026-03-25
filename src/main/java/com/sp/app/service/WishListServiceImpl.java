package com.sp.app.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.sp.app.domain.entity.Product;
import com.sp.app.domain.entity.WishList;
import com.sp.app.domain.entity.WishListId;
import com.sp.app.mapper.TradeMapper;
import com.sp.app.model.Trade;
import com.sp.app.repository.ProductRepository;
import com.sp.app.repository.WishListRepository;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class WishListServiceImpl implements WishListService{
	private final WishListRepository wishListRepository;
    private final ProductRepository productRepository;
    private final TradeMapper tradeMapper;
    private final NotificationService notificationService; 
    
	@Override
	public Map<String, Object> toggleWishList(long productIdx, long userIdx) throws Exception {
		Map<String, Object> result = new HashMap<>();
        
		try {
			WishListId id = new WishListId(productIdx, userIdx);
			
			Product product = productRepository.findById(productIdx)
					.orElseThrow(() -> new RuntimeException("상품을 찾을 수 없습니다."));
			
			Optional<WishList> wishOpt = wishListRepository.findById(id);
			
			if (wishOpt.isPresent()) {
				wishListRepository.delete(wishOpt.get());
				product.updateLikeCount(-1);
				result.put("isLiked", false);
			} else {
				WishList newWish = WishList.builder()
						.productIdx(productIdx)
						.userIdx(userIdx)
						.build();
				wishListRepository.save(newWish);
				product.updateLikeCount(1);
				result.put("isLiked", true);

				Trade tradeDto = tradeMapper.findByIdx(productIdx);
				if(tradeDto != null && tradeDto.getUserIdx() != userIdx) {
                    notificationService.sendTradeNotification(
                        tradeDto.getUserIdx(), 
                        "누군가 회원님의 [" + tradeDto.getTitle() + "] 상품을 찜했습니다.", 
                        "/trade/article?productIdx=" + productIdx
                    );
                }
			}
			
			result.put("likeCount", product.getLikeCount());
		} catch (Exception e) {
			log.info("toggleWishList : ", e);
		}
        return result;
	}
	
	@Override
	public boolean isUserLiked(long productIdx, long userIdx) {
		try {
			WishListId id = new WishListId(productIdx, userIdx);
			return wishListRepository.existsById(id);
		} catch (Exception e) {
			log.info("isUserLiked : ", e);
			return false;
		}
	}

	@Override
	public List<Trade> findWishList(long userIdx) {
		List<Trade> list = null;
		try {
			list = tradeMapper.findWishListByUserIdx(userIdx);
			for (Trade trade : list) {
	            trade.setImageList(tradeMapper.findImagesByIdx(trade.getProductIdx()));
	        }
		} catch (Exception e) {
			log.info("findWishList : ", e);
		}
		return list;
	}
}