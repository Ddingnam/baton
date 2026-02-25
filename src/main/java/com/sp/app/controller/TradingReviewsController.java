package com.sp.app.controller;

import java.util.List;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sp.app.model.TradingReviews;
import com.sp.app.mapper.TradingReviewsMapper;

@Controller
@RequestMapping("/review")
public class TradingReviewsController {

    private final TradingReviewsMapper reviewMapper;

    public TradingReviewsController(TradingReviewsMapper reviewMapper) {
        this.reviewMapper = reviewMapper;
    }

    @GetMapping("/list")
    public String reviewList(
            @RequestParam(value = "type", defaultValue = "BUYER") String type, 
            Model model) {

        List<TradingReviews> list = reviewMapper.listReviewsByType(type);
        
        model.addAttribute("reviewList", list);
        model.addAttribute("currentType", type); 
        
        return "review/list";
    }
}