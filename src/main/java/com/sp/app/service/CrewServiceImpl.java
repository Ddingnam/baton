package com.sp.app.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sp.app.common.StorageService;
import com.sp.app.domain.dto.CrewDto;
import com.sp.app.domain.dto.CrewMemberDto;
import com.sp.app.domain.entity.Crew;
import com.sp.app.domain.entity.CrewMember;
import com.sp.app.domain.entity.CrewMemberHistory;
import com.sp.app.domain.entity.User;
import com.sp.app.mapper.CrewMapper;
import com.sp.app.repository.CrewMemberHistoryRepository;
import com.sp.app.repository.CrewMemberRepository;
import com.sp.app.repository.CrewRepository;
import com.sp.app.repository.UserRepository;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class CrewServiceImpl implements CrewService {
	
	private final CrewMapper mapper;
	private final StorageService storageService;
	
	private final UserRepository userRepository;
	private final CrewRepository crewRepository;
	private final CrewMemberRepository memberRepository;
	private final CrewMemberHistoryRepository historyRepository;
	
	@Transactional(rollbackFor = Exception.class)
	@Override
	public void insertCrew(CrewDto crewDto, String uploadPath) throws Exception {
		try {
			if (crewDto.getLogoImageFile() != null && !crewDto.getLogoImageFile().isEmpty()) {
	            String saveFilename = storageService.uploadFileToServer(crewDto.getLogoImageFile(), uploadPath);
	            crewDto.setLogoImage(saveFilename);
	        }		
			
			Long crewSeq = mapper.crewSeq();
			crewDto.setCrewIdx(crewSeq);
			
			mapper.insertCrew(crewDto);
	        
	        if (crewDto.getCategoryIdxs() != null && !crewDto.getCategoryIdxs().isEmpty()) {
	            mapper.insertCrewCategories(crewDto);
	        }
	        
	        if (crewDto.getRegionCodes() != null && !crewDto.getRegionCodes().isEmpty()) {
	            mapper.insertCrewRegions(crewDto);
	        }
	        
	        Crew crew = crewRepository.findById(crewSeq)
	                .orElseThrow(() -> new EntityNotFoundException("생성된 모임을 찾을 수 없습니다."));
	        User user = userRepository.findById(crewDto.getUserIdx())
	                .orElseThrow(() -> new EntityNotFoundException("방장 유저를 찾을 수 없습니다."));
	        
	        CrewMember leader = CrewMember.builder()
	                .crew(crew)
	                .user(user)
	                .role("LEADER")
	                .status("ACTIVE")
	                .joinedDate(LocalDateTime.now())
	                .applicationReason("모임 생성")
	                .build();
	        
	        memberRepository.save(leader);

	        CrewMemberHistory history = CrewMemberHistory.builder()
	                .crewMember(leader)
	                .changedStatus("JOINED")
	                .reason("모임 생성")
	                .actor(user)
	                .build();
	        
	        historyRepository.save(history);
	        
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
			Crew crew = crewRepository.findById(crewIdx).orElseThrow();
		    crew.setStatus("DELETED");
		    
		    CrewMember leader = memberRepository.findByCrew_CrewIdxAndUser_UserIdx(crew.getCrewIdx(), crew.getLeader().getUserIdx())
		    		.orElseThrow(() -> new EntityNotFoundException("유저 정보를 찾을 수 없습니다."));
		    
		    List<CrewMember> activeMembers = memberRepository.findByCrew_CrewIdxAndStatus(crewIdx, "ACTIVE");
		    for (CrewMember member : activeMembers) {
		    	if (!member.getCrewMemberIdx().equals(leader.getCrewMemberIdx())) {
			    	member.setStatus("EXITED");
			        historyRepository.save(CrewMemberHistory.builder()
				    		.crewMember(member)
				    		.changedStatus("EXITED")
				    		.reason("모임 해체로 인한 자동 탈퇴")
				    		.actor(leader.getUser())
				    		.build());
		    	}
		    }

		    List<CrewMember> waitingMembers = memberRepository.findByCrew_CrewIdxAndStatus(crewIdx, "WAIT");
		    for (CrewMember member : waitingMembers) {
		    	member.setStatus("REJECTED");
		        historyRepository.save(CrewMemberHistory.builder()
			    		.crewMember(member)
			    		.changedStatus("REJECTED")
			    		.reason("모임 삭제로 인한 신청 반려")
			    		.actor(leader.getUser())
			    		.build());
		    }
		    
		    leader.setStatus("EXITED");
		    historyRepository.save(CrewMemberHistory.builder()
		    		.crewMember(leader)
		    		.changedStatus("CLOSED")
		    		.reason("모임장이 모임을 폐쇄하였습니다.")
		    		.actor(leader.getUser())
		    		.build());
		    
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
	
	@Override
	public CrewMemberDto getCrewMemberInfo(Long crewIdx, Long userIdx) {
	    return memberRepository.findByCrew_CrewIdxAndUser_UserIdx(crewIdx, userIdx)
	            .map(CrewMemberDto::fromEntity)
	            .orElse(null);
	}
	
	@Transactional(rollbackFor = Exception.class)
	@Override
	public CrewMemberDto joinCrew(Long crewIdx, Long userIdx, String reason) {
	    Crew crew = crewRepository.findById(crewIdx)
	            .orElseThrow(() -> new EntityNotFoundException("모임을 찾을 수 없습니다."));
	    
	    User user = userRepository.findById(userIdx)
	            .orElseThrow(() -> new EntityNotFoundException("유저를 찾을 수 없습니다."));

	    if (crew.getCurrentMember() >= crew.getMaxMember()) {
	        throw new IllegalStateException("모임 정원이 가입 신청이 불가능합니다.");
	    }

	    String initialStatus = "F".equals(crew.getJoinType()) ? "ACTIVE" : "WAIT";
	    String historyStatus = "F".equals(crew.getJoinType()) ? "JOINED" : "APPLIED";

	    CrewMember member = memberRepository.findByCrew_CrewIdxAndUser_UserIdx(crewIdx, userIdx)
	            .orElseGet(() -> CrewMember.builder()
	                    .crew(crew)
	                    .user(user)
	                    .build());

	    member.setStatus(initialStatus);
	    member.setApplicationReason(reason);
	    if ("ACTIVE".equals(initialStatus)) {
	        member.setJoinedDate(LocalDateTime.now());
	        crew.setCurrentMember(crew.getCurrentMember() + 1);
	    }
	    
        memberRepository.save(member);

	    CrewMemberHistory history = CrewMemberHistory.builder()
	            .crewMember(member)
	            .changedStatus(historyStatus)
	            .reason(reason)
	            .actor(user)
	            .build();
	    historyRepository.save(history);

	    return CrewMemberDto.fromEntity(member);
	}
	
	@Transactional(rollbackFor = Exception.class)
	@Override
	public void exitCrew(Long crewIdx, Long userIdx, String reason) {
		
		CrewMember member = memberRepository.findByCrew_CrewIdxAndUser_UserIdx(crewIdx, userIdx)
				.orElseThrow(() -> new EntityNotFoundException("유저 정보를 찾을 수 없습니다."));
		
		if (!"ACTIVE".equals(member.getStatus())) {
			throw new IllegalStateException("이미 탈퇴했거나 가입 승인 대기 중인 유저입니다.");
		}
		
	    Crew crew = crewRepository.findById(crewIdx)
	            .orElseThrow(() -> new EntityNotFoundException("모임을 찾을 수 없습니다."));

	    if (userIdx.equals(crew.getLeader().getUserIdx())) {
	        throw new IllegalStateException("리더는 탈퇴가 불가능합니다.");
	    }
	    
	    String finalReason = (reason != null && !reason.trim().isEmpty()) ? reason : "자진 탈퇴";
	    
	    member.setStatus("EXITED");
	    member.setApplicationReason(finalReason);
	    crew.setCurrentMember(crew.getCurrentMember() - 1);
	    
        memberRepository.save(member);

	    CrewMemberHistory history = CrewMemberHistory.builder()
	            .crewMember(member)
	            .changedStatus("EXITED")
	            .reason(finalReason)
	            .actor(member.getUser())
	            .build();
	    
	    historyRepository.save(history);
	}
	
	@Transactional(rollbackFor = Exception.class)
	@Override
	public void banMember(Long loginUserIdx, Long crewIdx, Long userIdx, String reason) {
		
		validateLeader(crewIdx, loginUserIdx);
		
		CrewMember member = memberRepository.findByCrew_CrewIdxAndUser_UserIdx(crewIdx, userIdx)
				.orElseThrow(() -> new EntityNotFoundException("유저 정보를 찾을 수 없습니다."));
		
		if (!"ACTIVE".equals(member.getStatus())) {
			throw new IllegalStateException("이미 탈퇴했거나 가입 승인 대기 중인 유저입니다.");
		}
		
	    Crew crew = crewRepository.findById(crewIdx)
	            .orElseThrow(() -> new EntityNotFoundException("모임을 찾을 수 없습니다."));

	    if (userIdx.equals(crew.getLeader().getUserIdx())) {
	        throw new IllegalStateException("리더는 스스로를 강퇴할 수 없습니다.");
	    }
	    
	    String finalReason = (reason != null && !reason.trim().isEmpty()) ? reason : "리더에 의한 강제 퇴장";
	    
	    member.setStatus("BANNED");
	    member.setApplicationReason(finalReason);
	    crew.setCurrentMember(crew.getCurrentMember() - 1);
	    
        memberRepository.save(member);

	    CrewMemberHistory history = CrewMemberHistory.builder()
	            .crewMember(member)
	            .changedStatus("BANNED")
	            .reason(finalReason)
	            .actor(crew.getLeader())
	            .build();
	    
	    historyRepository.save(history);
	}
	
	private void validateLeader(Long crewIdx, Long userIdx) {
	    Crew crew = crewRepository.findById(crewIdx)
	            .orElseThrow(() -> new EntityNotFoundException("모임을 찾을 수 없습니다."));
	            
	    if (!crew.getLeader().getUserIdx().equals(userIdx)) {
	        throw new IllegalStateException("모임장만 접근 가능한 메뉴입니다.");
	    }
	}
}