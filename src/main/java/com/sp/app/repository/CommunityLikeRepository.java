package com.sp.app.repository;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import com.sp.app.domain.entity.CommunityLike;

public interface CommunityLikeRepository extends JpaRepository<CommunityLike, Long> {
	public Optional<CommunityLike> findByCommunityIdAndMemberIdx(Long communityId, Long memberIdx);
	public boolean existsByCommunityIdAndMemberIdx(Long communityId, Long memberIdx);
	public long countByCommunityId(Long communityId);
}