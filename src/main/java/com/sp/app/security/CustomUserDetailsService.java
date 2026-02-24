package com.sp.app.security;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.sp.app.domain.dto.MemberDto;
import com.sp.app.domain.dto.SessionInfo;
import com.sp.app.service.MemberService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {
	private final MemberService memberService;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		
		MemberDto member = memberService.findById(username);
		
		if(member == null) {
			throw new UsernameNotFoundException("아이디가 존재하지 않습니다.");
		}
		
		List<String> authorities = new ArrayList<>();
		String authority = memberService.findByAuthority(username);
		authorities.add(authority);
		
		return toUserDetails(member, authorities);
	}
	
	private UserDetails toUserDetails(MemberDto member, List<String> authorities) {
		SessionInfo info = SessionInfo.builder()
				.member_id(member.getMember_id())
				.login_id(member.getLogin_id())
				.password(member.getPassword())
				.name(member.getName())
				.email(member.getEmail())
				.userLevel(NumericRoleGranted.getUserLevel(member.getAuthority()))
				.avatar(member.getProfile_photo())
				.login_type("local")
				.build();
		
		return CustomUserDetails.builder()
				.sessionInfo(info)
				.disabled(member.getEnabled() == 0)
				.roles(authorities)
				.build();
	}

}
