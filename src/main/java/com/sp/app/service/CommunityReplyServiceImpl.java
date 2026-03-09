package com.sp.app.service;

import java.util.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sp.app.domain.dto.CommunityReplyDto;
import com.sp.app.domain.entity.Community;
import com.sp.app.domain.entity.CommunityReply;
import com.sp.app.repository.CommunityReplyRepository;
import com.sp.app.repository.CommunityRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CommunityReplyServiceImpl implements CommunityReplyService {

    private final CommunityReplyRepository replyRepository;
    private final CommunityRepository communityRepository;

    @Override
    @Transactional(readOnly = true)
    public List<CommunityReplyDto> listReply(Long communityId) {
        List<CommunityReply> entities = replyRepository.findByCommunityIdOrderByRegDateAsc(communityId);
        
        List<CommunityReplyDto> result = new ArrayList<>();
        Map<Long, List<CommunityReply>> childrenMap = new HashMap<>(); // 부모ID -> 자식리스트
        List<CommunityReply> roots = new ArrayList<>(); // 최상위 댓글 리스트

        for (CommunityReply entity : entities) {
            if (entity.getParentId() == null) {
                roots.add(entity);
            } else {
                childrenMap.computeIfAbsent(entity.getParentId(), k -> new ArrayList<>()).add(entity);
            }
        }

        for (CommunityReply root : roots) {
            addReplyRecursive(root, childrenMap, result, 0);
        }

        return result;
    }

    private void addReplyRecursive(CommunityReply parent, Map<Long, List<CommunityReply>> childrenMap, List<CommunityReplyDto> result, int depth) {
        CommunityReplyDto dto = CommunityReplyDto.builder()
                .id(parent.getId())
                .communityId(parent.getCommunity().getId())
                .memberIdx(parent.getMemberIdx())
                .writerNickname(parent.getWriterNickname())
                .content(parent.isDeleted() ? "삭제된 댓글입니다." : parent.getContent())
                .regDate(parent.getRegDate())
                .parentId(parent.getParentId())
                .depth(depth)
                .isDeleted(parent.isDeleted())
                .build();
        
        result.add(dto);

        List<CommunityReply> children = childrenMap.get(parent.getId());
        if (children != null) {
            for (CommunityReply child : children) {
                addReplyRecursive(child, childrenMap, result, depth + 1);
            }
        }
    }

    @Override
    @Transactional
    public void insertReply(Long communityId, CommunityReplyDto dto) {
        Community community = communityRepository.findById(communityId)
                .orElseThrow(() -> new RuntimeException("게시글이 존재하지 않습니다."));

        CommunityReply reply = CommunityReply.builder()
                .community(community)
                .memberIdx(dto.getMemberIdx())
                .writerNickname(dto.getWriterNickname())
                .content(dto.getContent())
                .parentId(dto.getParentId())
                .isDeleted(false)
                .build();

        replyRepository.save(reply);
    }

    @Override
    @Transactional
    public void deleteReply(Long replyId, Long memberIdx) {
        CommunityReply reply = replyRepository.findById(replyId)
                .orElseThrow(() -> new RuntimeException("댓글이 존재하지 않습니다."));

        if (!reply.getMemberIdx().equals(memberIdx)) {
            throw new RuntimeException("삭제 권한이 없습니다.");
        }
        
        reply.setDeleted(true);
    }

    @Override
    @Transactional(readOnly = true)
    public int replyCount(Long communityId) {
        return replyRepository.findByCommunityIdOrderByRegDateAsc(communityId).size();
    }
}