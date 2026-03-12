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
	private int regionType;
    private String regionCode;
    private String fullAddress;
    private String coreAddress;
    private double lat;
    private double lng;
    
    private Long userIdx;
    private int isActive;
    private int isAuthenticated;
}
