package com.sp.app.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.sp.app.domain.dto.BadgeDto;
import com.sp.app.domain.dto.MemberDto;
import com.sp.app.domain.dto.RegionDto;
import com.sp.app.domain.dto.SnsUserDto;
import com.sp.app.domain.dto.UserDto;
import com.sp.app.domain.dto.UserRegionInfo;

public interface MemberService {
	public SnsUserDto loginSnsUser(Map<String, Object> map);
	public UserDto loginUser(Map<String, Object> map);

	public void insertUser(UserDto dto, String uploadPath) throws Exception;
	public void insertUser(UserDto userDto, SnsUserDto snsUserDto, String uploadPath) throws Exception;
	public void insertSnsUser(SnsUserDto dto) throws Exception;

	public void insertMemberStatus(MemberDto dto) throws Exception;

	public void updatePassword(MemberDto dto) throws Exception;
	public void updateUserEnabled(Map<String, Object> map) throws Exception;
	public void updateMember(MemberDto dto, String uploadPath) throws Exception;

	public void updateLastLogin(Long member_id) throws Exception;
	public void updateLastLogin(String login_id) throws Exception;

	public UserDto findById(Long member_id);
	public UserDto findByLoginId(String login_id);
	public UserDto findByEmail(String email);
	public Long getMemberId(String login_id);

	public int checkFailureCount(String login_id);
	public void updateFailureCountReset(String login_id) throws Exception;
	public void updateFailureCount(String login_id) throws Exception;

	public void deleteMember(Map<String, Object> map, String uploadPath) throws Exception;
	public void deleteProfilePhoto(Map<String, Object> map, String uploadPath) throws Exception;

	public void generatePwd(MemberDto dto) throws Exception;

	public List<MemberDto> listFindMember(Map<String, Object> map);

	public String findByAuthority(String login_id);

	public void insertRefreshToken(MemberDto dto) throws Exception;
	public void updateRefreshToken(MemberDto dto) throws Exception;
	public MemberDto findByToken(String login_id);

	public boolean isPasswordCheck(String login_id, String password);

	public boolean isUserIdDuplicated(String userId);
	public boolean isNicknameDuplicated(String nickname);
	public boolean isEmailDuplicated(String email);

	public String findUserId(Map<String, Object> map);
	public long findByUserIdAndEmail(Map<String, Object> map);
	public void updateUserPwd(Map<String, Object> map) throws SQLException;

	public RegionDto findRegionByCode(String regionCode);
	public RegionDto findUserRegionbyType(Map<String, Object> map);

	public void saveUserRegion(RegionDto dto) throws SQLException;
	public void deleteRegion(Map<String, Object> map) throws SQLException;
	public void updateActiveStatus(Map<String, Object> map) throws SQLException;

	public UserRegionInfo getUserRegionInfo(Long userIdx);

	public boolean hasPendingWithdraw(Long userIdx);
	public int countActiveTrades(Long userIdx);
	public int countPendingReports(Long userIdx);
	public void requestWithdraw(Map<String, Object> map) throws Exception;
	
	public void updateBatonDistance(Long userIdx, double distance) throws Exception;
	public void checkAndAwardBadge(Long userIdx, String actionType) throws Exception;
	
	public List<BadgeDto> getUserBadgeProgress(Long userIdx) throws Exception;
}