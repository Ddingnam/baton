package com.sp.app.repository;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
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

    public Page<Community> findByTemporaryFalseAndCategory(String category, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndCategoryAndSubjectContaining(String category, String kwd, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndCategoryAndContentContaining(String category, String kwd, Pageable pageable);

    public Page<Community> findByTemporaryFalseAndRegionCode(String regionCode, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndRegionCodeAndSubjectContaining(String regionCode, String kwd, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndRegionCodeAndContentContaining(String regionCode, String kwd, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndRegionCodeAndSubjectContainingOrTemporaryFalseAndRegionCodeAndContentContaining(String regionCode1, String kwd1, String regionCode2, String kwd2, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndRegionCodeAndCategory(String regionCode, String category, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndRegionCodeAndCategoryAndSubjectContaining(String regionCode, String category, String kwd, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndRegionCodeAndCategoryAndContentContaining(String regionCode, String category, String kwd, Pageable pageable);
    public List<Community> findAll(Sort sort);
    public List<Community> findByRegionCode(String regionCode, Sort sort);
}