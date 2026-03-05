package com.sp.app.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import com.sp.app.domain.entity.Community;

public interface CommunityRepository extends JpaRepository<Community, Long> {
    Page<Community> findBySubjectContaining(String keyword, Pageable pageable);
    Page<Community> findByContentContaining(String keyword, Pageable pageable);
    Page<Community> findBySubjectContainingOrContentContaining(String subject, String content, Pageable pageable);
}