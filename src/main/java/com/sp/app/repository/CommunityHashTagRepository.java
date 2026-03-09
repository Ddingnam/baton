package com.sp.app.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.transaction.annotation.Transactional;
import com.sp.app.domain.entity.CommunityHashTag;

public interface CommunityHashTagRepository extends JpaRepository<CommunityHashTag, Long> {
	public List<CommunityHashTag> findByCommunityId(Long communityId);
    
    @Transactional
    public void deleteByCommunityId(Long communityId);
}