package com.sp.app.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sp.app.common.StorageService;
import com.sp.app.domain.dto.CrewDto;
import com.sp.app.mapper.CrewMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class CrewServiceImpl implements CrewService {
	
	private final CrewMapper mapper;
	private final StorageService storageService;
	
	@Transactional(rollbackFor = Exception.class)
	@Override
	public void insertCrew(CrewDto crewDto, String uploadPath) throws Exception {
		try {
			if (crewDto.getLogoImageFile() != null && !crewDto.getLogoImageFile().isEmpty()) {
	            String saveFilename = storageService.uploadFileToServer(crewDto.getLogoImageFile(), uploadPath);
	            crewDto.setLogoImage(saveFilename);
	        }		
			
			Long seq = mapper.crewSeq();
			crewDto.setCrewIdx(seq);
			
			mapper.insertCrew(crewDto);
	        
	        if (crewDto.getCategoryIdxs() != null && !crewDto.getCategoryIdxs().isEmpty()) {
	            mapper.insertCrewCategories(crewDto);
	        }
	        
	        if (crewDto.getRegionCodes() != null && !crewDto.getRegionCodes().isEmpty()) {
	            mapper.insertCrewRegions(crewDto);
	        }
	        
		} catch (Exception e) {
			log.info("insertCrew : ", e);
			throw e;
		}
	}

	@Transactional(rollbackFor = Exception.class)
	@Override
	public void updateCrew(CrewDto crewDto, String uploadPath) throws Exception {
		try {
			if (crewDto.getLogoImageFile() != null && !crewDto.getLogoImageFile().isEmpty()) {
				if (!crewDto.getLogoImage().isBlank()) {
					storageService.deleteFile(uploadPath, crewDto.getLogoImage());
				}

				String saveFilename = storageService.uploadFileToServer(crewDto.getLogoImageFile(), uploadPath);
				crewDto.setLogoImage(saveFilename);
			}		
			
			long crewIdx = crewDto.getCrewIdx();
			mapper.updateCrew(crewDto);
	        
			mapper.deleteCrewCategories(crewIdx);
	        if (crewDto.getCategoryIdxs() != null && !crewDto.getCategoryIdxs().isEmpty()) {
	            mapper.insertCrewCategories(crewDto);
	        }
	        
	        mapper.deleteCrewRegions(crewIdx);
	        if (crewDto.getRegionCodes() != null && !crewDto.getRegionCodes().isEmpty()) {
	            mapper.insertCrewRegions(crewDto);
	        }
	        
		} catch (Exception e) {
			log.info("updateCrew : ", e);
			throw e;
		}
	}

	@Transactional(rollbackFor = Exception.class)
	@Override
	public void deleteCrew(long crewIdx, String uploadPath) throws Exception {
		try {
			CrewDto dto = mapper.findByCrewIdx(crewIdx);
			
			if(dto != null) {
				String filename = dto.getLogoImage();
				if (filename != null && !filename.isBlank()) {
					storageService.deleteFile(uploadPath, filename);
				}
			}
			mapper.deleteCrew(crewIdx);
		} catch (Exception e) {
			log.info("deleteCrew : ", e);
			throw e;
		}
	}

	@Transactional(rollbackFor = Exception.class)
	@Override
	public CrewDto findByCrewIdx(Long crewIdx) {
		CrewDto dto = null;
		try {
			dto = mapper.findByCrewIdx(crewIdx);
			if(dto != null) {
				dto.setCategories(mapper.listCrewCategories(crewIdx));
				dto.setRegions(mapper.listCrewRegions(crewIdx));
			}
		} catch (Exception e) {
			log.info("findByCrewIdx : ", e);
			throw e;
		}
		return dto;
	}

	@Transactional(rollbackFor = Exception.class)
	@Override
	public List<CrewDto> listCrew(Map<String, Object> map) {
		List<CrewDto> crewList = null;
		long crewIdx = 0;
		try {
			crewList = mapper.listCrew(map);
			for(CrewDto crew : crewList) {
				crewIdx = crew.getCrewIdx();
				crew.setCategories(mapper.listCrewCategories(crewIdx));
				crew.setRegions(mapper.listCrewRegions(crewIdx));
			}
		} catch (Exception e) {
			log.info("listAllCrew : ", e);
			throw e;
		}
		return crewList;
	}

	@Override
	public int getCrewCount(Map<String, Object> map) {
		int count = 0;
		try {
			count = mapper.getCrewCount(map);
		} catch (Exception e) {
			log.info("getCrewCount : ", e);
			throw e;
		}
		return count;
	}
}