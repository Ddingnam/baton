package com.sp.app.security;

import java.util.ArrayList;
import java.util.List;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.sp.app.domain.dto.SessionInfo;
import com.sp.app.domain.dto.UserDto;
import com.sp.app.service.MemberService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {
	private final MemberService memberService;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		
		UserDto member = memberService.findByLoginId(username);
		 
		if(member == null) {
			throw new UsernameNotFoundException("아이디가 존재하지 않습니다.");
		}
		
		List<String> authorities = new ArrayList<>();
		String authority = memberService.findByAuthority(username);
		
		if (authority != null && !authority.trim().isEmpty()) {
			authorities.add(authority.trim().toUpperCase());
		} else {
			authorities.add("USER");
		}
		
		return toUserDetails(member, authority, authorities);
	}
	
	private UserDetails toUserDetails(UserDto member, String authority, List<String> authorities) {
		SessionInfo info = SessionInfo.builder()
				.userIdx(member.getUserIdx())
				.userId(member.getUserId())
				.pwd(member.getPwd())
				.name(member.getName())
				.email(member.getEmail())
				.userLevel(NumericRoleGranted.getUserLevel(authority != null ? authority : "USER"))
				.avatar(member.getProfile_photo())
				.login_type(member.getProvider())
				.build();
		
		return CustomUserDetails.builder()
				.sessionInfo(info)
				.disabled(member.getStatus() == 0)
				.roles(authorities)
				.build();
	}
}