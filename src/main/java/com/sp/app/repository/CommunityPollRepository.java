package com.sp.app.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import com.sp.app.domain.entity.CommunityPoll;

public interface CommunityPollRepository extends JpaRepository<CommunityPoll, Long> {
	public CommunityPoll findByCommunityId(Long communityId);
}