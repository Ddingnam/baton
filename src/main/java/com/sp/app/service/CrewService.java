package com.sp.app.service;

import com.sp.app.domain.dto.CrewDto;

public interface CrewService {
	public void insertCrew(CrewDto dto, String uploadPath) throws Exception;
	public void updateCrew(CrewDto dto, String uploadPath) throws Exception;
	public void deleteCrew(long crewIdx, String uploadPath) throws Exception;
	
	public CrewDto findByCrewIdx(Long crewIdx);
}