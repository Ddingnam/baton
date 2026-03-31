package com.sp.app.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.sp.app.domain.entity.CrewChatRoom;

@Repository
public interface CrewChatRoomRepository extends JpaRepository<CrewChatRoom, Long> {
    List<CrewChatRoom> findByCrewId(Long crewId); 
    
    @Query("SELECT r FROM CrewChatRoom r " +
    	       "JOIN CrewChatRead cr ON r.chatRoomId = cr.chatRoom.chatRoomId " +
    	       "LEFT JOIN CrewChatMessage m ON r.chatRoomId = m.chatRoom.chatRoomId " +
    	       "WHERE cr.user.useridx = :userIdx " +
    	       "GROUP BY r " +
    	       "ORDER BY MAX(m.createdDate) DESC NULLS LAST, r.createdDate DESC")
	List<CrewChatRoom> findChatRoomsByUserIdOrderByLastMessage(@Param("userIdx") Long userIdx);
}
