package com.sp.app.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TradeImg {
	private int imgOrder;
    private long productIdx;
    
    private String originalName;
    private String saveName;
    private String imgUrl;
}
