package com.sp.app.admin.mapper;

import com.sp.app.domain.dto.UserDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface AdminMemberMapper {
	public List<UserDto> listMembers(Map<String, Object> map);
	public int countMembers(Map<String, Object> map);
	public UserDto getMemberDetail(@Param("userIdx") Long userIdx);
	public void updateMemberStatus(Map<String, Object> map);
	public void deleteAuthority(@Param("userId") String userId);
	public void insertAuthority(Map<String, Object> map);
	public void updateUserLevel(Map<String, Object> map);

	public List<Map<String, Object>> listSanctions(Map<String, Object> map);
	public int countSanctions(Map<String, Object> map);
	public void insertSanction(Map<String, Object> map);
	public void liftSanction(Map<String, Object> map);

	public List<Map<String, Object>> listWithdrawals(Map<String, Object> map);
	public int countWithdrawals(Map<String, Object> map);
	public void updateWithdrawalStatus(Map<String, Object> map);

	public void liftSanctionByUserIdx(Long userIdx);
}