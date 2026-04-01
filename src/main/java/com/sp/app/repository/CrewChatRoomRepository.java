package com.sp.app.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.sp.app.domain.entity.CrewChatRoom;

@Repository
public interface CrewChatRoomRepository extends JpaRepository<CrewChatRoom, Long> {
	Optional<CrewChatRoom> findByCrew_CrewIdxAndRoomType(Long crewIdx, Integer roomType);
	
    List<CrewChatRoom> findByCrew_CrewIdx(Long crewIdx); 
    
    @Query("SELECT r FROM CrewChatRoom r " +
    	       "JOIN CrewChatRead cr ON r.chatRoomId = cr.chatRoom.chatRoomId " +
    	       "LEFT JOIN CrewChatMessage m ON r.chatRoomId = m.chatRoom.chatRoomId " +
    	       "WHERE cr.user.userIdx = :userIdx " +
    	       "GROUP BY r " +
    	       "ORDER BY MAX(m.createdDate) DESC NULLS LAST, r.createdDate DESC")
	List<CrewChatRoom> findChatRoomsByUserIdOrderByLastMessage(@Param("userIdx") Long userIdx);
}
