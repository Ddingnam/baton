package com.sp.app.domain.dto;

import java.time.LocalDate;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class UserDto {
	private long userIdx;
	
	private String userId;
	private String pwd;
	
	private String name;
	private String nickname;
	private String email;
	private String tel;
	
	private String birth;
	private LocalDate birthDate;
	
	private String profile_photo;
	private String deletedPhoto;
	
	private double score;
	private Double batonDistance;
	private int userLevel;
	private int pwdFailCount;
	private int status;
	
	private String createdDate;
	private String updatedDate;
	private String lastLoginDate;
	
	private int batonpoint;
	private String authority;
	
	private String provider;
	private List<SnsUserDto> snsUserList;
	
	private MultipartFile selectFile;		
	
	private String regionCode;
    private String fullAddress;
    private String coreAddress;
    private Double lat;
    private Double lng;
    
    private int isOnline;

	public int getIsOnline() {
		return isOnline;
	}

	public void setIsOnline(int isOnline) {
		this.isOnline = isOnline;
	}
}
