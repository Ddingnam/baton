package com.sp.app.domain.dto;

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
	private String oauthId;
	private String pwd;
	
	private String name;
	private String nickname;
	private String email;
	private String tel;
	private String addr;
	private String birth;
	private String profile_photo;
	
	private double score;
	private int userLevel;
	private int pwdFailCount;
	private int status;
	
	private String createdDate;
	private String updatedDate;
	private String lastLoginDate;
	
	private MultipartFile selectFile;		
	
	private String authority;
}
