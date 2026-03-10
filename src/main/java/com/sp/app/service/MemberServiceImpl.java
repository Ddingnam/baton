package com.sp.app.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sp.app.common.MyUtil;
import com.sp.app.common.StorageService;
import com.sp.app.domain.dto.MemberDto;
import com.sp.app.domain.dto.SnsUserDto;
import com.sp.app.domain.dto.UserDto;
import com.sp.app.mapper.MemberMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class MemberServiceImpl implements MemberService {

	private final MemberMapper mapper;
	private final StorageService storageService;
	private final PasswordEncoder bcryptEncoder;

	@Override
	public SnsUserDto loginSnsUser(Map<String, Object> map) {
		SnsUserDto dto = null;
		try {
			dto = mapper.loginSnsUser(map);
		} catch (Exception e) {

			log.info("loginSnsUser : ", e);
		}
		return dto;
	}
	
	@Override
	public UserDto loginUser(Map<String, Object> map) {
		UserDto dto = null;
		try {
			String pwd = (String)map.get("pwd");
			
			dto = mapper.loginUser(map);
			if(!bcryptEncoder.matches(pwd, dto.getPwd())) {
				return dto;
			}
			
		} catch (Exception e) {
			log.info("loginUser : ", e);
		}
		return dto;
	}
	
	@Override
	public void insertUser(UserDto dto, String uploadPath) throws Exception {
	    this.insertUser(dto, null, uploadPath);
	}

	@Transactional(rollbackFor = Exception.class)
	@Override
	public void insertUser(UserDto userDto, SnsUserDto snsUserDto, String uploadPath) throws Exception {
		try {
			if (userDto.getSelectFile() != null && !userDto.getSelectFile().isEmpty()) {
	            String saveFilename = storageService.uploadFileToServer(userDto.getSelectFile(), uploadPath);
	            userDto.setProfile_photo(saveFilename);
	        }		
			
			String rawPwd = userDto.getPwd();
			if(rawPwd == null || rawPwd.isEmpty()) {
				rawPwd = MyUtil.generateUUID();
			}
			
			String encPassword = bcryptEncoder.encode(rawPwd);
			userDto.setPwd(encPassword);
						
			Long seq = mapper.userSeq();
			userDto.setUserIdx(seq);
			
			mapper.insertUser(userDto);
			
			userDto.setAuthority("USER");
			mapper.insertAuthority(userDto);
			
			if(snsUserDto != null) {
				snsUserDto.setUserIdx(seq);
				mapper.insertSnsUser(snsUserDto);
			}
			
		} catch (Exception e) {
			log.info("insertUser : ", e);
			throw e;
		}
	}
	
	@Override
	public void insertSnsUser(SnsUserDto snsUserDto) {
		try {
			mapper.insertSnsUser(snsUserDto);
		} catch (Exception e) {
			log.info("insertSnsUser : ", e);
		}
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
	public void updateUserEnabled(Map<String, Object> map) throws Exception {
		try {
			mapper.updateUserEnabled(map);
		} catch (Exception e) {
			log.info("updateUserEnabled : ", e);
			
			throw e;
		}
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
	public UserDto findById(Long member_id) {
		UserDto dto = null;

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
	public UserDto findByLoginId(String login_id) {
		UserDto dto = null;

		try {
			dto = Objects.requireNonNull(mapper.findByLoginId(login_id));
		} catch (NullPointerException e) {
		} catch (Exception e) {
			log.info("findById : ", e);
		}

		return dto;
	}
	
	@Override
	public UserDto findByEmail(String email) {
		UserDto dto = null;

		try {
			dto = Objects.requireNonNull(mapper.findByEmail(email));
		} catch (NullPointerException e) {
		} catch (Exception e) {
			log.info("findByEmail : ", e);
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
		try {
			mapper.updateFailureCountReset(login_id);
		} catch (Exception e) {
			log.info("updateFailureCountReset : ", e);
			
			throw e;
		}
	}

	@Override
	public void updateFailureCount(String login_id) throws Exception {
		try {
			mapper.updateFailureCount(login_id);
		} catch (Exception e) {
			log.info("updateFailureCount : ", e);
			
			throw e;
		}
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

	@Override
	public boolean isUserIdDuplicated(String userId) {
		return mapper.isUserIdDuplicated(userId) > 0;
	}

	@Override
	public boolean isNicknameDuplicated(String nickname) {
		return mapper.isNicknameDuplicated(nickname) > 0;
	}
	
	@Override
	public boolean isEmailDuplicated(String email) {
		return mapper.isEmailDuplicated(email) > 0;
	}

	@Override
	public String findUserId(Map<String, Object> map) {
		String userId = null;
		try {
			userId = mapper.findUserId(map);
		} catch (Exception e) {
			log.info("findUserId", e);
		}
		return userId;
	}
	
	@Override
	public long findByUserIdAndEmail(Map<String, Object> map) {
		long userIdx = 0;
		try {
			userIdx = mapper.findByUserIdAndEmail(map);
		} catch (Exception e) {
			log.info("findByUserIdAndEmail", e);
		}
		return userIdx;
	}

	@Override
	public void updateUserPwd(Map<String, Object> map) throws SQLException {
		try {
			String pwd = (String) map.get("pwd");
			String encPassword = bcryptEncoder.encode(pwd);
			map.put("pwd", encPassword);
			
			mapper.updateUserPwd(map);
		} catch (Exception e) {
			log.info("updateUserPwd : ", e);
			throw e;
		}
	}
}
