package com.sp.app.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sp.app.domain.entity.CrewScheduleVote;

@Repository
public interface CrewScheduleVoteRepository extends JpaRepository<CrewScheduleVote, Long> {
	Optional<CrewScheduleVote> findBySchedule_ScheduleIdxAndUser_UserIdx(Long scheduleIdx, Long userIdx);
	int countBySchedule_ScheduleIdxAndStatus(Long scheduleIdx, String status);
	List<CrewScheduleVote> findAllBySchedule_ScheduleIdx(Long scheduleIdx);
}
