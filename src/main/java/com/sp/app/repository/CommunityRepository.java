package com.sp.app.repository;

import com.sp.app.domain.entity.Community;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface CommunityRepository extends JpaRepository<Community, Long> {
    @Modifying
    @Query("UPDATE Community c SET c.hitCount = c.hitCount + 1 WHERE c.id = :id")
    void updateHitCount(@Param("id") Long id);
}