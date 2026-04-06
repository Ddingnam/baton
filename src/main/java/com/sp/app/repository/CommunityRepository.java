package com.sp.app.repository;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.sp.app.domain.entity.Community;

public interface CommunityRepository extends JpaRepository<Community, Long> {
    public Page<Community> findBySubjectContaining(String keyword, Pageable pageable);
    public Page<Community> findByContentContaining(String keyword, Pageable pageable);
    public Page<Community> findBySubjectContainingOrContentContaining(String subject, String content, Pageable pageable);

    public Page<Community> findByTemporaryFalseAndIsHiddenFalse(Pageable pageable);
    public Page<Community> findByTemporaryFalseAndIsHiddenFalseAndSubjectContaining(String keyword, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndIsHiddenFalseAndContentContaining(String keyword, Pageable pageable);

    @Query("SELECT c FROM Community c WHERE c.temporary = false AND c.isHidden = false AND (c.subject LIKE %:kwd% OR c.content LIKE %:kwd%)")
    public Page<Community> findByTemporaryFalseAndIsHiddenFalseAndSubjectOrContent(@Param("kwd") String kwd, Pageable pageable);

    public Page<Community> findByTemporaryFalseAndIsHiddenFalseAndHashTags_TagNameContaining(String tagName, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndIsHiddenFalseAndCategoryAndHashTags_TagNameContaining(String category, String tagName, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndIsHiddenFalseAndRegionCodeAndHashTags_TagNameContaining(String regionCode, String tagName, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndIsHiddenFalseAndRegionCodeAndCategoryAndHashTags_TagNameContaining(String regionCode, String category, String tagName, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndIsHiddenFalseAndCategory(String category, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndIsHiddenFalseAndCategoryAndSubjectContaining(String category, String kwd, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndIsHiddenFalseAndCategoryAndContentContaining(String category, String kwd, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndIsHiddenFalseAndRegionCode(String regionCode, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndIsHiddenFalseAndRegionCodeAndSubjectContaining(String regionCode, String kwd, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndIsHiddenFalseAndRegionCodeAndContentContaining(String regionCode, String kwd, Pageable pageable);

    @Query("SELECT c FROM Community c WHERE c.temporary = false AND c.isHidden = false AND c.regionCode = :regionCode AND (c.subject LIKE %:kwd% OR c.content LIKE %:kwd%)")
    public Page<Community> findByTemporaryFalseAndIsHiddenFalseAndRegionCodeAndSubjectOrContent(@Param("regionCode") String regionCode, @Param("kwd") String kwd, Pageable pageable);

    public Page<Community> findByTemporaryFalseAndIsHiddenFalseAndRegionCodeAndCategory(String regionCode, String category, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndIsHiddenFalseAndRegionCodeAndCategoryAndSubjectContaining(String regionCode, String category, String kwd, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndIsHiddenFalseAndRegionCodeAndCategoryAndContentContaining(String regionCode, String category, String kwd, Pageable pageable);

    // ── 기존 메서드 (내부/임시글 용도 유지) ─────────────────────────
    public Page<Community> findByTemporaryFalse(Pageable pageable);
    public Page<Community> findByTemporaryFalseAndSubjectContaining(String keyword, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndContentContaining(String keyword, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndSubjectContainingOrTemporaryFalseAndContentContaining(String subject, String content, Pageable pageable);
    public List<Community> findByMemberIdxAndTemporaryTrueOrderByRegDateDesc(Long memberIdx);
    public List<Community> findByMemberIdxAndTemporaryTrue(Long memberIdx);
    public Page<Community> findByTemporaryFalseAndHashTags_TagNameContaining(String tagName, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndCategoryAndHashTags_TagNameContaining(String category, String tagName, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndRegionCodeAndHashTags_TagNameContaining(String regionCode, String tagName, Pageable pageable);
    public Page<Community> findByTemporaryFalseAndRegionCodeAndCategoryAndHashTags_TagNameContaining(String regionCode, String category, String tagName, Pageable pageable);
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