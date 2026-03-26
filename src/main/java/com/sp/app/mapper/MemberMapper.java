package com.sp.app.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.domain.dto.MemberDto;
import com.sp.app.domain.dto.RegionDto;
import com.sp.app.domain.dto.SnsUserDto;
import com.sp.app.domain.dto.UserDto;

@Mapper
public interface MemberMapper {
	public SnsUserDto loginSnsUser(Map<String, Object> map);
	public UserDto loginUser(Map<String, Object> map);

	public Long userSeq();
	public void insertUser(UserDto dto) throws SQLException;
	public void insertSnsUser(SnsUserDto dto) throws SQLException;

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
	public Long findByUserIdAndEmail(Map<String, Object> map);
	public void updateUserPwd(Map<String, Object> map) throws SQLException;

	public void insertRegion(RegionDto dto) throws SQLException;

	public RegionDto findUserRegionbyType(Map<String, Object> map);
	public RegionDto findRegionbyCode(String regionCode);

	public void saveUserRegion(RegionDto dto) throws SQLException;
	public void deleteUserRegion(Map<String, Object> map) throws SQLException;
	public void updateActiveStatus(Map<String, Object> map) throws SQLException;

	public int hasPendingWithdraw(Long userIdx);
	public void insertWithdrawRequest(Map<String, Object> map) throws SQLException;
	public int countActiveTrades(Long userIdx);
	public int countPendingReports(Long userIdx);
	
	public void updateBatonDistance(Map<String, Object> map) throws SQLException;
	public void insertUserBadge(Map<String, Object> map) throws SQLException;
	public int checkUserBadge(Map<String, Object> map) throws SQLException;
	public int countTradeCompleted(Long userIdx) throws SQLException;
	public int countReviewBest(Long userIdx) throws SQLException;
	public int countCommunityPost(Long userIdx) throws SQLException;
	public int countCommunityReply(Long userIdx) throws SQLException;
	public int countCommunityPoll(Long userIdx) throws SQLException;
	public int countPointCharge(Long userIdx) throws SQLException;
	public int countAlbaScrap(Long userIdx) throws SQLException;
}