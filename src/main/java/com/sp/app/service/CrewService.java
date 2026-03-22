package com.sp.app.service;

import java.util.List;
import java.util.Map;

import com.sp.app.domain.dto.CrewDto;

public interface CrewService {
	public void insertCrew(CrewDto dto, String uploadPath) throws Exception;
	public void updateCrew(CrewDto dto, String uploadPath) throws Exception;
	public void deleteCrew(long crewIdx, String uploadPath) throws Exception;
	
	public CrewDto findByCrewIdx(Long crewIdx);
	
	public int getCrewCount(Map<String, Object> map);
	public List<CrewDto> listCrew(Map<String, Object> map);
}