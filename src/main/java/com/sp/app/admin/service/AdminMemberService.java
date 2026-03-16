package com.sp.app.admin.service;

import com.sp.app.domain.dto.UserDto;
import java.util.List;
import java.util.Map;

public interface AdminMemberService {
	public List<UserDto> listMembers(Map<String, Object> map);
	public int countMembers(Map<String, Object> map);
	public UserDto getMemberDetail(Long userIdx);
	public void updateMemberStatus(Map<String, Object> map) throws Exception;
	public void updateAuthority(Map<String, Object> map) throws Exception;

	public List<Map<String, Object>> listSanctions(Map<String, Object> map);
	public int countSanctions(Map<String, Object> map);
	public void insertSanction(Map<String, Object> map) throws Exception;
	public void liftSanction(Map<String, Object> map) throws Exception;

	public List<Map<String, Object>> listWithdrawals(Map<String, Object> map);
	public int countWithdrawals(Map<String, Object> map);
	public void approveWithdrawal(Map<String, Object> map) throws Exception;
	public void rejectWithdrawal(Map<String, Object> map) throws Exception;
}