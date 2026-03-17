package com.sp.app.service;

import java.util.List;
import java.util.Map;

import com.sp.app.model.Trade;

public interface WishListService {
	public Map<String, Object> toggleWishList(long productIdx, long userIdx) throws Exception;
    public boolean isUserLiked(long productIdx, long userIdx);
    public List<Trade> findWishList(long userIdx);
    
}
