package com.sp.app.domain.dto;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class CrewDto {
	private long crewIdx;
	private long userIdx;
	private String name;
    private String description;
    private String logoImage;
    private int maxMember;
    private int currentMember;
    private String joinType;
    private long chatRoomId;
    private int viewCount;
    private String status;
    private String createdDate;
    
    private MultipartFile logoImageFile;
    
    private List<Integer> categoryIdxs; 
    private List<String> regionCodes;
}
