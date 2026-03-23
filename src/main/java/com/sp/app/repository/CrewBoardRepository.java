package com.sp.app.repository;

import java.util.List;

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
    
    @Query(value = "SELECT b.* FROM crewBoard b " +
            "JOIN users u ON b.user_idx = u.userIdx " +
            "WHERE b.crew_idx = :crewIdx " +
            "ORDER BY b.created_date DESC", 
            nativeQuery = true)
    List<CrewBoard> findAllByCrewIdxWithUser(@Param("crewIdx") Long crewIdx);	
    
    @Query(value = "SELECT * FROM CREWBOARD " +
            "WHERE crew_idx = :crewIdx " +
            "ORDER BY is_notice DESC, created_date DESC " +
            "OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY", 
		    nativeQuery = true)
	List<CrewBoard> findByCrewIdxNative(
		 @Param("crewIdx") Long crewIdx, 
		 @Param("offset") int offset, 
		 @Param("limit") int limit
	);
		
	@Query(value = "SELECT COUNT(*) FROM CREWBOARD WHERE crew_idx = :crewIdx", 
			nativeQuery = true)
	long countByCrewIdxNative(@Param("crewIdx") Long crewIdx);
	
	@Modifying
	@Transactional
	@Query("UPDATE CrewBoard b SET b.viewCount = b.viewCount + 1 WHERE b.crewBoardIdx = :boardIdx")
	int updateViewCount(@Param("boardIdx") Long boardIdx);
}
