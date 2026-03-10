package com.sp.app.domain.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class SnsUserDto {
	private long snsUserIdx;
	private long userIdx;	
	private String provider;
	private String oauthId;	
	private String linkedDate;
}
