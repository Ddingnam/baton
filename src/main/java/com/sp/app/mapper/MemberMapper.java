package com.sp.app.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.domain.dto.MemberDto;
import com.sp.app.domain.dto.SnsUserDto;
import com.sp.app.domain.dto.UserDto;

@Mapper
public interface MemberMapper {
	public SnsUserDto loginSnsUser(Map<String, Object> map);
	public UserDto loginUser(Map<String, Object> map);

	public Long userSeq();	
	public void insertUser(UserDto dto) throws SQLException;
	public void insertSnsUser(SnsUserDto dto) throws SQLException;
	public void insertRegion(UserDto dto) throws SQLException;
	
	public void insertMember12(MemberDto dto) throws SQLException;
	public void insertMemberStatus(MemberDto dto) throws SQLException;
	
	public void updateUserEnabled(Map<String, Object> map) throws SQLException;
	public void updateMemberPassword(MemberDto dto) throws SQLException;
	
	public void updateMember1(MemberDto dto) throws SQLException;
	public void updateMember2(MemberDto dto) throws SQLException;
	public void deleteProfilePhoto(Map<String, Object> map) throws SQLException;

	public void updateLastLogin(Long member_id) throws SQLException;
	public void updateLastLoginId(String login_id) throws SQLException;
	
	public UserDto findById(Long member_id);
	public UserDto findByLoginId(String login_id);
	public UserDto findByEmail(String email);
	public Long getMemberId(String login_id);
	
	public int checkFailureCount(String login_id);
	public void updateFailureCountReset(String login_id) throws SQLException;
	public void updateFailureCount(String login_id) throws SQLException;
	
	public void deleteMember1(Map<String, Object> map) throws SQLException;
	public void deleteMember2(Map<String, Object> map) throws SQLException;
	
	public List<MemberDto> listFindMember(Map<String, Object> map);
	
	public void insertAuthority(UserDto dto) throws SQLException;
	public void deleteAuthority(Map<String, Object> map) throws SQLException;
	public String findByAuthority(String login_id);
	
	public void insertRefreshToken(MemberDto dto) throws SQLException;
	public void updateRefreshToken(MemberDto dto) throws SQLException;
	public void deleteRefreshToken(String login_id) throws SQLException;
	public MemberDto findByToken(String login_id);
	
	public int isUserIdDuplicated(String userId);
	public int isNicknameDuplicated(String nickname);
	public int isEmailDuplicated(String email);
	
	public String findUserId(Map<String, Object> map);
	public long findByUserIdAndEmail(Map<String, Object> map);
	public void updateUserPwd(Map<String, Object> map) throws SQLException;
	
}
