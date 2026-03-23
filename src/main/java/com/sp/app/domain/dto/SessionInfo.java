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
public class SessionInfo implements Serializable {
	private static final long serialVersionUID = 1L;

	private long userIdx;
	private String userId;
	private String pwd;
	private String name;
	private String nickname;
	private String email;
	private int userLevel;
	private String login_type; // local, kakao, naver, google
	private String avatar; // profile photo
	
	private UserRegionInfo userRegionInfo;
}