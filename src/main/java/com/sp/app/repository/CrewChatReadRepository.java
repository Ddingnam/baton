package com.sp.app.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sp.app.domain.entity.CrewChatRead;
import com.sp.app.domain.entity.CrewChatReadId;

@Repository
public interface CrewChatReadRepository extends JpaRepository<CrewChatRead, CrewChatReadId> {
	List<CrewChatRead> findByChatRoom_ChatRoomId(Long chatRoomId);
}
