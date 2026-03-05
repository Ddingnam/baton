package com.sp.app.service;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.sp.app.common.StorageService;
import com.sp.app.domain.dto.CommunityDto;
import com.sp.app.domain.entity.Community;
import com.sp.app.domain.entity.CommunityHashTag;
import com.sp.app.domain.entity.CommunityImage;
import com.sp.app.domain.entity.CommunityLike;
import com.sp.app.domain.entity.CommunityScrap;
import com.sp.app.repository.CommunityRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class CommunityServiceImpl implements CommunityService {

    private final CommunityRepository communityRepository;
    private final StorageService storageService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void insertCommunity(CommunityDto dto, String uploadPath) throws Exception {
        try {
            Community community = Community.builder()
                    .memberIdx(dto.getMemberIdx())
                    .writerNickname(dto.getWriterNickname())
                    .subject(dto.getSubject())
                    .content(dto.getContent())
                    .category(dto.getCategory())
                    .placeName(dto.getPlaceName())
                    .address(dto.getAddress())
                    .latitude(dto.getLatitude())
                    .longitude(dto.getLongitude())
                    .hitCount(0)
                    .likeCount(0)
                    .build();

            // 해시태그 저장
            if (dto.getTags() != null) {
                for (String tagName : dto.getTags()) {
                    community.addHashTag(CommunityHashTag.builder().tagName(tagName).build());
                }
            }

            // 파일 저장
            List<MultipartFile> files = dto.getSelectFiles();
            if (files != null && !files.isEmpty()) {
                for (MultipartFile mf : files) {
                    if(mf.isEmpty()) continue;
                    String saveFilename = storageService.uploadFileToServer(mf, uploadPath);
                    community.addImage(CommunityImage.builder()
                            .originalFilename(mf.getOriginalFilename())
                            .saveFilename(saveFilename)
                            .build());
                }
            }

            communityRepository.save(community);
        } catch (Exception e) {
            log.error("insertCommunity error", e);
            throw e;
        }
    }

    @Override
    @Transactional(readOnly = true)
    public Page<CommunityDto> getCommunityList(Pageable pageable, String schType, String kwd) {
        Page<Community> entities;
        if (kwd == null || kwd.isBlank()) {
            entities = communityRepository.findAll(pageable);
        } else {
            if ("subject".equals(schType)) {
                entities = communityRepository.findBySubjectContaining(kwd, pageable);
            } else if ("content".equals(schType)) {
                entities = communityRepository.findByContentContaining(kwd, pageable);
            } else {
                entities = communityRepository.findBySubjectContainingOrContentContaining(kwd, kwd, pageable);
            }
        }
        return entities.map(this::toDto);
    }

    @Override
    @Transactional(readOnly = true)
    public CommunityDto getCommunity(long id) {
        Community entity = communityRepository.findById(id).orElseThrow();
        return toDto(entity);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateHitCount(long id) throws Exception {
        Community community = communityRepository.findById(id).orElse(null);
        if(community != null) {
            community.setHitCount(community.getHitCount() + 1);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateCommunity(CommunityDto dto, String uploadPath) throws Exception {
        try {
            Community community = communityRepository.findById(dto.getId()).orElseThrow();
            community.setSubject(dto.getSubject());
            community.setContent(dto.getContent());
            community.setCategory(dto.getCategory());
            community.setPlaceName(dto.getPlaceName());
            community.setAddress(dto.getAddress());

            List<MultipartFile> files = dto.getSelectFiles();
            if (files != null && !files.isEmpty()) {
                for (MultipartFile mf : files) {
                    if(mf.isEmpty()) continue;
                    String saveFilename = storageService.uploadFileToServer(mf, uploadPath);
                    community.addImage(CommunityImage.builder()
                            .originalFilename(mf.getOriginalFilename())
                            .saveFilename(saveFilename)
                            .build());
                }
            }
        } catch (Exception e) {
            log.error("updateCommunity error", e);
            throw e;
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteCommunity(long id, String uploadPath) throws Exception {
        try {
            Community community = communityRepository.findById(id).orElseThrow();
            if (community.getImages() != null) {
                for (CommunityImage img : community.getImages()) {
                    storageService.deleteFile(uploadPath, img.getSaveFilename());
                }
            }
            communityRepository.delete(community);
        } catch (Exception e) {
            log.error("deleteCommunity error", e);
            throw e;
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteCommunityFile(long id, String filename, String uploadPath) throws Exception {
        Community community = communityRepository.findById(id).orElseThrow();
        community.getImages().removeIf(img -> img.getSaveFilename().equals(filename));
        storageService.deleteFile(uploadPath, filename);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean toggleLike(long id, long memberIdx) throws Exception {
        Community community = communityRepository.findById(id).orElseThrow();
        Optional<CommunityLike> like = community.getLikes().stream()
                .filter(l -> l.getMemberIdx() == memberIdx).findFirst();

        if (like.isPresent()) {
            community.getLikes().remove(like.get());
            community.setLikeCount(Math.max(0, community.getLikeCount() - 1));
            return false;
        } else {
            community.addLike(CommunityLike.builder().memberIdx(memberIdx).build());
            community.setLikeCount(community.getLikeCount() + 1);
            return true;
        }
    }

    @Override
    public int getLikeCount(long id) {
        return communityRepository.findById(id).map(Community::getLikeCount).orElse(0);
    }

    @Override
    public boolean isUserLiked(Map<String, Object> map) {
        long id = (long) map.get("communityId");
        long memberIdx = (long) map.get("memberIdx");
        Community c = communityRepository.findById(id).orElse(null);
        return c != null && c.getLikes().stream().anyMatch(l -> l.getMemberIdx() == memberIdx);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean toggleScrap(long id, long memberIdx) throws Exception {
        Community community = communityRepository.findById(id).orElseThrow();
        Optional<CommunityScrap> scrap = community.getScraps().stream()
                .filter(s -> s.getMemberIdx() == memberIdx).findFirst();

        if (scrap.isPresent()) {
            community.getScraps().remove(scrap.get());
            return false;
        } else {
            community.addScrap(CommunityScrap.builder().memberIdx(memberIdx).build());
            return true;
        }
    }

    @Override
    public boolean isUserScraped(Map<String, Object> map) {
        long id = (long) map.get("communityId");
        long memberIdx = (long) map.get("memberIdx");
        Community c = communityRepository.findById(id).orElse(null);
        return c != null && c.getScraps().stream().anyMatch(s -> s.getMemberIdx() == memberIdx);
    }

    private CommunityDto toDto(Community entity) {
        return CommunityDto.builder()
                .id(entity.getId())
                .memberIdx(entity.getMemberIdx())
                .writerNickname(entity.getWriterNickname())
                .subject(entity.getSubject())
                .content(entity.getContent())
                .category(entity.getCategory())
                .hitCount(entity.getHitCount())
                .likeCount(entity.getLikeCount())
                .regDate(entity.getRegDate())
                .placeName(entity.getPlaceName())
                .address(entity.getAddress())
                .imageFiles(entity.getImages().stream().map(CommunityImage::getSaveFilename).collect(Collectors.toList()))
                .build();
    }
}