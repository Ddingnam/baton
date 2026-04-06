package com.sp.app.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import com.sp.app.domain.entity.CommunityReply;

public interface CommunityReplyRepository extends JpaRepository<CommunityReply, Long> {
	public List<CommunityReply> findByCommunityIdOrderByRegDateAsc(Long communityId);
	public List<CommunityReply> findByMemberIdxAndDeletedFalseOrderByRegDateDesc(Long memberIdx);
	public long countByMemberIdxAndDeletedFalse(Long memberIdx);
}