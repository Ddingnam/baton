package com.sp.app.service;

import java.util.Map;

public interface WishListService {
	Map<String, Object> toggleWishList(long productIdx, long userIdx) throws Exception;
    boolean isUserLiked(long productIdx, long userIdx);
}
