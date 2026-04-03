package com.sp.app.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.sp.app.domain.dto.CrewMemberPointDto;
import com.sp.app.domain.entity.CrewMember;

@Repository
public interface CrewMemberRepository extends JpaRepository<CrewMember, Long> {
	long countByCrew_CrewIdxAndStatus(Long crewIdx, String status);
	
	Optional<CrewMember> findByCrew_CrewIdxAndUser_UserIdx(Long crewIdx, Long userIdx);
	
    List<CrewMember> findByCrew_CrewIdxAndStatus(Long crewIdx, String status);
    List<CrewMember> findByUser_UserIdxAndStatus(Long userIdx, String status);
    List<CrewMember> findAllByCrew_CrewIdx(Long crewIdx);
    
    @Query("SELECT COUNT(b) FROM CrewBoard b WHERE b.crewIdx = :crewIdx AND b.status = 'ACTIVE'")
    long countActiveBoards(@Param("crewIdx") Long crewIdx);

    @Query("SELECT COUNT(c) FROM CrewComment c WHERE c.crewBoardIdx IN (SELECT b.crewBoardIdx FROM CrewBoard b WHERE b.crewIdx = :crewIdx) AND c.isDeleted = 'N'")
    long countActiveComments(@Param("crewIdx") Long crewIdx);

    @Query("SELECT COUNT(s) FROM CrewSchedule s WHERE s.crew.crewIdx = :crewIdx")
    long countSchedules(@Param("crewIdx") Long crewIdx);

    @Query("SELECT COUNT(v) FROM CrewScheduleVote v WHERE v.schedule.crew.crewIdx = :crewIdx")
    long countVotes(@Param("crewIdx") Long crewIdx);

    @Query("SELECT COUNT(l) FROM CrewBoardLike l WHERE l.crewBoardIdx IN (SELECT b.crewBoardIdx FROM CrewBoard b WHERE b.crewIdx = :crewIdx)")
    long countLikes(@Param("crewIdx") Long crewIdx);
    
    @Query("SELECT new com.sp.app.domain.dto.CrewMemberPointDto(" +
	       "m.user.userIdx, m.user.nickname, " +
	       "(SELECT COUNT(b) FROM CrewBoard b WHERE b.user.userIdx = m.user.userIdx AND b.crewIdx = m.crew.crewIdx AND b.status = 'ACTIVE'), " +
	       "(SELECT COUNT(c) FROM CrewComment c WHERE c.user.userIdx = m.user.userIdx AND c.isDeleted = 'N' AND c.crewBoardIdx IN (SELECT b.crewBoardIdx FROM CrewBoard b WHERE b.crewIdx = m.crew.crewIdx)), " +
	       "(SELECT COUNT(s) FROM CrewSchedule s WHERE s.user.userIdx = m.user.userIdx AND s.crew.crewIdx = m.crew.crewIdx) + " +
	       "(SELECT COUNT(v) FROM CrewScheduleVote v WHERE v.user.userIdx = m.user.userIdx AND v.schedule.crew.crewIdx = m.crew.crewIdx), " +
	       "(SELECT COUNT(l) FROM CrewBoardLike l WHERE l.userIdx = m.user.userIdx AND l.crewBoardIdx IN (SELECT b.crewBoardIdx FROM CrewBoard b WHERE b.crewIdx = m.crew.crewIdx)), " +
	       "0) " + 
	       "FROM CrewMember m " +
	       "WHERE m.crew.crewIdx = :crewIdx AND m.status = 'ACTIVE'")
	List<CrewMemberPointDto> findAllMemberActivityPoints(@Param("crewIdx") Long crewIdx);
}
