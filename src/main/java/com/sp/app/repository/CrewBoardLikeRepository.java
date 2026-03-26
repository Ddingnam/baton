package com.sp.app.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sp.app.domain.entity.CrewBoardLike;

@Repository
public interface CrewBoardLikeRepository extends JpaRepository<CrewBoardLike, Long> {
	Optional<CrewBoardLike> findByCrewBoardIdxAndUserIdx(Long crewBoardIdx, Long userIdx);
    int countByCrewBoardIdx(Long crewBoardIdx);
    boolean existsByCrewBoardIdxAndUserIdx(Long crewBoardIdx, Long userIdx);
} 
