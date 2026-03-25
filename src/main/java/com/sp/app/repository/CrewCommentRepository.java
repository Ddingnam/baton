package com.sp.app.repository;

import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.sp.app.domain.entity.CrewComment;

@Repository
public interface CrewCommentRepository extends JpaRepository<CrewComment, Long> {
	
	@Query("SELECT c FROM CrewComment c " +
	           "JOIN FETCH c.user " +
	           "WHERE c.crewBoardIdx = :boardIdx " +
	           "AND c.parent IS NULL " +
	           "AND c.isDeleted = :isDeleted " +
	           "ORDER BY c.createdAt ASC")
    List<CrewComment> findActiveComments(
        @Param("boardIdx") Long boardIdx, 
        @Param("isDeleted") String isDeleted, 
        Pageable pageable
    );
	
	int countByCrewBoardIdxAndIsDeleted(Long boardIdx, String isDeleted);
	int countByCrewBoardIdx(Long boardIdx);
	
	void deleteByCrewBoardIdx(Long boardIdx);
}
