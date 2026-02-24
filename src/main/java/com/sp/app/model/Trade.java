package com.sp.app.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class Trade {
	private long productIdx;
	private long userIdx;
	
	private String title;
	private String content;
	private int price;

	private int hitCount;
	private int likeCount;
	private int chatCount;
	private int pullCount;
	
	private String tradeType;
	private String tradeStatus;
	private String productStatus;
	
	private String tradePlace;
	private long regionIdx;	

	private String lastUpDate;
	private String createDate;
	private String updateDate;
	
	// 게시물 카테고리
	private long categoryIdx;
	private String categoryName;
	
	// 게시물 태그
	private long tagIdx;
	private String tagName;
	
	// 게시물 이미지
	private long imgOrder;
	private String imgUrl;
	
}
