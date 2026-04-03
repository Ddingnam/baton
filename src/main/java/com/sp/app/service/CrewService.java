package com.sp.app.service;

import java.util.List;
import java.util.Map;

import com.sp.app.domain.dto.CrewDto;
import com.sp.app.domain.dto.CrewMemberDto;
import com.sp.app.domain.dto.MyCrewListDto;

public interface CrewService {
	public void insertCrew(CrewDto dto, String uploadPath) throws Exception;
	public void updateCrew(CrewDto dto, String uploadPath) throws Exception;
	public void deleteCrew(long crewIdx, String uploadPath) throws Exception;
	
	public CrewDto findByCrewIdx(Long crewIdx);
	
	public int getCrewCount(Map<String, Object> map);
	public List<CrewDto> listCrew(Map<String, Object> map);
	
	public List<MyCrewListDto> listMyCrewJoined(Long userIdx);
	public List<MyCrewListDto> listMyCrewCreated(Long userIdx);
	
	public CrewMemberDto getCrewMemberInfo(Long crewIdx, Long userIdx);
	public CrewMemberDto joinCrew(Long crewIdx, Long userIdx, String reason);
	public void exitCrew(Long crewIdx, Long userIdx, String reason);
	
	public void banMember(Long loginUserIdx, Long crewIdx, Long userIdx, String reason);
	
	Map<String, Object> getCrewDashboardStats(Long crewIdx);
}