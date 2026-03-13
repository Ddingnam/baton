package com.sp.app.repository;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import com.sp.app.domain.entity.Community;

public interface CommunityRepository extends JpaRepository<Community, Long> {
    public Page<Community> findBySubjectContaining(String keyword, Pageable pageable);
    public Page<Community> findByContentContaining(String keyword, Pageable pageable);
    public Page<Community> findBySubjectContainingOrContentContaining(String subject, String content, Pageable pageable);

    public Page<Community> findByTemporaryFalse(Pageable pageable);
    public Page<Community> findByTemporaryFalseAndSubjectContaining(String keyword, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndContentContaining(String keyword, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndSubjectContainingOrTemporaryFalseAndContentContaining(String subject, String content, Pageable pageable);
    public List<Community> findByMemberIdxAndTemporaryTrueOrderByRegDateDesc(Long memberIdx);
    public List<Community> findByMemberIdxAndTemporaryTrue(Long memberIdx);
    
    public List<Community> findByMemberIdxAndTemporaryFalseOrderByRegDateDesc(Long memberIdx);
    public Page<Community> findByMemberIdxAndTemporaryFalse(Long memberIdx, Pageable pageable);
    public long countByMemberIdxAndTemporaryFalse(Long memberIdx);
}