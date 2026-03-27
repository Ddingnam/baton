package com.sp.app.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sp.app.domain.entity.CrewMemberHistory;

@Repository
public interface CrewMemberHistoryRepository extends JpaRepository<CrewMemberHistory, Long> {
	List<CrewMemberHistory> findByCrewMember_CrewMemberIdxOrderByLogDateDesc(Long crewMemberIdx);
}
