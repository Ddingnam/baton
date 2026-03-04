package com.sp.app.service;

import com.sp.app.domain.dto.CommunityDto;
import com.sp.app.domain.entity.Community;
import com.sp.app.domain.entity.CommunityHashTag;
import com.sp.app.domain.entity.CommunityImage;
import com.sp.app.repository.CommunityRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CommunityService {

    private final CommunityRepository communityRepository;

    @Transactional
    public Long createCommunity(CommunityDto dto) {
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
                .build();

        if (dto.getTags() != null) {
            for (String tagName : dto.getTags()) {
                community.addHashTag(CommunityHashTag.builder().tagName(tagName).build());
            }
        }

        if (dto.getImageFiles() != null) {
            for (String filename : dto.getImageFiles()) {
                community.addImage(CommunityImage.builder().originalFilename(filename).saveFilename(filename).build());
            }
        }

        Community saved = communityRepository.save(community);
        return saved.getId();
    }

    public Page<CommunityDto> getCommunityList(Pageable pageable) {
        return communityRepository.findAll(pageable)
                .map(entity -> CommunityDto.builder()
                        .id(entity.getId())
                        .subject(entity.getSubject())
                        .writerNickname(entity.getWriterNickname())
                        .hitCount(entity.getHitCount())
                        .regDate(entity.getRegDate())
                        .category(entity.getCategory())
                        .build());
    }

    @Transactional
    public CommunityDto getCommunity(Long id) {
        communityRepository.updateHitCount(id);

        Community entity = communityRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("게시글이 존재하지 않습니다. id=" + id));

        return CommunityDto.builder()
                .id(entity.getId())
                .memberIdx(entity.getMemberIdx())
                .writerNickname(entity.getWriterNickname())
                .subject(entity.getSubject())
                .content(entity.getContent())
                .category(entity.getCategory())
                .placeName(entity.getPlaceName())
                .address(entity.getAddress())
                .hitCount(entity.getHitCount() + 1)
                .likeCount(entity.getLikeCount())
                .regDate(entity.getRegDate())
                .tags(entity.getHashTags().stream().map(CommunityHashTag::getTagName).collect(Collectors.toList()))
                .imageFiles(entity.getImages().stream().map(CommunityImage::getSaveFilename).collect(Collectors.toList()))
                .build();
    }

    @Transactional
    public Long updateCommunity(Long id, CommunityDto dto) {
        Community entity = communityRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("게시글이 없습니다."));

        entity.setSubject(dto.getSubject());
        entity.setContent(dto.getContent());
        entity.setCategory(dto.getCategory());
        entity.setPlaceName(dto.getPlaceName());
        
        entity.getHashTags().clear(); 
        if(dto.getTags() != null) {
             for (String tagName : dto.getTags()) {
                entity.addHashTag(CommunityHashTag.builder().tagName(tagName).build());
            }
        }
      
        return id;
    }

    @Transactional
    public void deleteCommunity(Long id) {
        communityRepository.deleteById(id);
    }
}