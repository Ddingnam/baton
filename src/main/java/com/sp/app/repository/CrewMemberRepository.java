package com.sp.app.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sp.app.domain.entity.CrewMember;

@Repository
public interface CrewMemberRepository extends JpaRepository<CrewMember, Long> {
	long countByCrew_CrewIdxAndStatus(Long crewIdx, String status);
	
	Optional<CrewMember> findByCrew_CrewIdxAndUser_UserIdx(Long crewIdx, Long userIdx);
	
    List<CrewMember> findByCrew_CrewIdxAndStatus(Long crewIdx, String status);
    List<CrewMember> findByUser_UserIdxAndStatus(Long userIdx, String status);
    List<CrewMember> findAllByCrew_CrewIdx(Long crewIdx);
}
