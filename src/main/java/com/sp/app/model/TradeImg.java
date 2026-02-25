package com.sp.app.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class TradeImg {
	private long imgOrder;
    private long productIdx;
    private String imgUrl;
}
