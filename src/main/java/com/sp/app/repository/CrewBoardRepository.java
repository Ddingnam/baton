package com.sp.app.repository;

import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.sp.app.domain.entity.CrewBoard;

@Repository
public interface CrewBoardRepository extends JpaRepository<CrewBoard, Long> {
    List<CrewBoard> findByCrewIdxOrderByCreatedDateDesc(Long crewIdx);
    
    @Query("SELECT b FROM CrewBoard b " +
            "WHERE b.crewIdx = :crewIdx " +
            "ORDER BY b.isNotice DESC, b.createdDate DESC")
     List<CrewBoard> findByCrewIdx(@Param("crewIdx") Long crewIdx, Pageable pageable);
		
    long countByCrewIdx(Long crewIdx);
	
    @Modifying(clearAutomatically = true)
	@Transactional
	@Query("UPDATE CrewBoard b SET b.viewCount = b.viewCount + 1 WHERE b.crewBoardIdx = :boardIdx")
	int updateViewCount(@Param("boardIdx") Long boardIdx);
}
