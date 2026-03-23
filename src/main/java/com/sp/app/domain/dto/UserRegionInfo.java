package com.sp.app.domain.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserRegionInfo implements Serializable {
	private static final long serialVersionUID = 1L;

	private RegionDto mainRegion;
    private RegionDto subRegion;
    private int activeType;
    
    public RegionDto getActiveRegion() {
        return (activeType == 2 && subRegion != null) ? subRegion : mainRegion;
    }
}