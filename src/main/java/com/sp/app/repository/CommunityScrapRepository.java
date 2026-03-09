package com.sp.app.repository;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import com.sp.app.domain.entity.CommunityScrap;

public interface CommunityScrapRepository extends JpaRepository<CommunityScrap, Long> {
	public Optional<CommunityScrap> findByCommunityIdAndMemberIdx(Long communityId, Long memberIdx);
	public boolean existsByCommunityIdAndMemberIdx(Long communityId, Long memberIdx);
}