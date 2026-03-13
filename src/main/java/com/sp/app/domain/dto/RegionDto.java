package com.sp.app.domain.dto;

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
public class RegionDto {
	private long regionIdx;
	private long userIdx;
	private int regionType;    
	private int isActive;
	private int isAuthenticated;
	private String authDate;
	
	private String regionCode;
	private String sido;
	private String sigungu;
	private String dong;
	private double lat;
	private double lng;
    
    private String fullAddress;
    private String coreAddress;
}
