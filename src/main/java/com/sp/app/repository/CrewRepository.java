package com.sp.app.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sp.app.domain.entity.Crew;

@Repository
public interface CrewRepository extends JpaRepository<Crew, Long> {
	List<Crew> findByLeader_UserIdxAndStatus(Long userIdx, String status);
}
