package com.sp.app.mapper;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import com.sp.app.model.TradingReviews;

@Mapper
public interface TradingReviewsMapper {
    public List<TradingReviews> listReviews(Map<String, Object> map);
    public int getReviewCount();
    public void insertReview(TradingReviews dto);
}