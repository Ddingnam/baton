package com.sp.app.service;

import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.mail.MailSender;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.sp.app.domain.dto.MemberDto;
import com.sp.app.mapper.MemberMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class MemberServiceImpl implements MemberService {
	private final MemberMapper mapper;
	// private final StorageService storageService;
	// private final MailSender mailSender;
	private final PasswordEncoder bcryptEncoder;

	@Override
	public MemberDto loginSnsMember(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void insertMember(MemberDto dto, String uploadPath) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void insertSnsMember(MemberDto dto) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void insertMemberStatus(MemberDto dto) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updatePassword(MemberDto dto) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateMemberEnabled(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateMember(MemberDto dto, String uploadPath) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateLastLogin(Long member_id) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateLastLogin(String login_id) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public MemberDto findById(Long member_id) {
		MemberDto dto = null;

		try {
			dto = Objects.requireNonNull(mapper.findById(member_id));
		} catch (NullPointerException e) {
		} catch (ArrayIndexOutOfBoundsException e) {
		} catch (Exception e) {
			log.info("findById : ", e);
		}

		return dto;
	}

	@Override
	public MemberDto findById(String login_id) {
		MemberDto dto = null;

		try {
			dto = Objects.requireNonNull(mapper.findByLoginId(login_id));
		} catch (NullPointerException e) {
		} catch (Exception e) {
			log.info("findById : ", e);
		}

		return dto;
	}

	@Override
	public Long getMemberId(String login_id) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int checkFailureCount(String login_id) {
		int result = 0;
		
		try {
			result = mapper.checkFailureCount(login_id);
		} catch (Exception e) {
			log.info("checkFailureCount : ", e);
		}
		
		return result;
	}

	@Override
	public void updateFailureCountReset(String login_id) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateFailureCount(String login_id) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteMember(Map<String, Object> map, String uploadPath) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteProfilePhoto(Map<String, Object> map, String uploadPath) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void generatePwd(MemberDto dto) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public List<MemberDto> listFindMember(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String findByAuthority(String login_id) {
		String authority = null;
		
		try {
			authority = mapper.findByAuthority(login_id);
		} catch (Exception e) {
			log.info("findByAuthority", e);
		}
		
		return authority;
	}

	@Override
	public void insertRefreshToken(MemberDto dto) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateRefreshToken(MemberDto dto) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public MemberDto findByToken(String login_id) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean isPasswordCheck(String login_id, String password) {
		// TODO Auto-generated method stub
		return false;
	}

}
