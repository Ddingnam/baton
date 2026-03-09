package com.sp.app.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import com.sp.app.domain.entity.CommunityImage;

public interface CommunityImageRepository extends JpaRepository<CommunityImage, Long> {
	public List<CommunityImage> findByCommunityId(Long communityId);
	public CommunityImage findBySaveFilename(String saveFilename);
}