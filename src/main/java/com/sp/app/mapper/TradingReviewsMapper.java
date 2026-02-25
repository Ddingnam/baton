package com.sp.app.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.sp.app.model.TradingReviews;

@Mapper
public interface TradingReviewsMapper {
    public List<TradingReviews> listReviewsByType(String saleReviewType);
    public void insertReview(TradingReviews dto);
}