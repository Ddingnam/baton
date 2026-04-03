package com.sp.app.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sp.app.domain.entity.CrewSchedule;

@Repository
public interface CrewScheduleRepository extends JpaRepository<CrewSchedule, Long> {
	List<CrewSchedule> findAllByCrew_CrewIdx(Long crewIdx);
	List<CrewSchedule> findAllByCrew_CrewIdxAndStartDateBetweenOrderByStartDateAsc(Long crewIdx, LocalDateTime start, LocalDateTime end);
	List<CrewSchedule> findTop3ByCrew_CrewIdxAndStartDateBetweenOrderByStartDateAsc(Long crewIdx, LocalDateTime start, LocalDateTime end);
}
