package com.sp.app.model;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class Trade {
	private long productIdx;
	private long userIdx;
	private String nickName;
	
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
	private String createdDate;
	private String updatedDate;
	
	private long categoryIdx;
	private String categoryName;
	
	private long tagIdx;
	private String tagName;
	private String tags;
	
	private String imgUrl;
	private List<Integer> deleteImgOrders;
	private List<MultipartFile> newFiles;
	private List<TradeImg> imageList;
	
	private boolean likeByMe;
	
}
