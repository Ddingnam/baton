package com.sp.app.repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sp.app.domain.entity.CrewChatMessage;

@Repository
public interface CrewChatMessageRepository extends JpaRepository<CrewChatMessage, Long> {
    
	Long countByChatRoom_ChatRoomIdAndChatIdxGreaterThan(Long chatRoomId, Long lastReadIdx);
    Optional<CrewChatMessage> findFirstByChatRoom_ChatRoomIdOrderByCreatedDateDesc(Long chatRoomId);
    
    // 1. [초기 입장] 특정 방에서 '내가 참여한 시간' 이후의 최신 메시지 50개 (역순 조회)
    List<CrewChatMessage> findTop50ByChatRoom_ChatRoomIdAndCreatedDateGreaterThanEqualOrderByChatIdxDesc(Long chatRoomId, LocalDateTime joinedDate);

    // 2. [과거 내역] 위로 스크롤: 특정 ID보다 작고(과거), '내가 참여한 시간' 이후인 메시지 50개 (역순 조회)
    List<CrewChatMessage> findTop50ByChatRoom_ChatRoomIdAndChatIdxLessThanAndCreatedDateGreaterThanEqualOrderByChatIdxDesc(Long chatRoomId, Long chatIdx, LocalDateTime joinedDate);

    // 3. [최신 갱신] 아래로 스크롤/새 메시지: 특정 ID보다 큰(최신) 메시지 모두 (정순 조회)
    List<CrewChatMessage> findByChatRoom_ChatRoomIdAndChatIdxGreaterThanOrderByChatIdxAsc(Long chatRoomId, Long chatIdx);
}
