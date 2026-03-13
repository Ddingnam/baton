package com.sp.app.service;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.sp.app.domain.entity.Product;
import com.sp.app.domain.entity.WishList;
import com.sp.app.domain.entity.WishListId;
import com.sp.app.repository.ProductRepository;
import com.sp.app.repository.WishListRepository;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional
public class WishListServiceImpl implements WishListService{
	private final WishListRepository wishListRepository;
    private final ProductRepository productRepository;
    
	@Override
	public Map<String, Object> toggleWishList(long productIdx, long userIdx) throws Exception {
Map<String, Object> result = new HashMap<>();
        
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
        }

        result.put("likeCount", product.getLikeCount());
        return result;
	}
	@Override
	public boolean isUserLiked(long productIdx, long userIdx) {
		WishListId id = new WishListId(productIdx, userIdx);
	    return wishListRepository.existsById(id);
	}
}
