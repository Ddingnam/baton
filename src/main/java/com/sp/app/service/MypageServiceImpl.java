package com.sp.app.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sp.app.domain.dto.CommunityDto;
import com.sp.app.domain.dto.MypageCommunityDto;
import com.sp.app.domain.entity.Community;
import com.sp.app.repository.CommunityReplyRepository;
import com.sp.app.repository.CommunityRepository;
import com.sp.app.repository.CommunityScrapRepository;
import com.sp.app.repository.PollVoteRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class MypageServiceImpl implements MypageService {

    private final CommunityRepository communityRepository;
    private final CommunityReplyRepository communityReplyRepository;
    private final CommunityScrapRepository communityScrapRepository;
    private final PollVoteRepository pollVoteRepository;

    @Override
    @Transactional(readOnly = true)
    public List<CommunityDto> getMyPosts(long memberIdx) {
        return communityRepository
                .findByMemberIdxAndTemporaryFalseOrderByRegDateDesc(memberIdx)
                .stream()
                .map(this::toSimpleDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<MypageCommunityDto.ReplyDto> getMyReplies(long memberIdx) {
        return communityReplyRepository
                .findByMemberIdxAndIsDeletedFalseOrderByRegDateDesc(memberIdx)
                .stream()
                .map(reply -> {
                    Community community = reply.getCommunity();
                    return MypageCommunityDto.ReplyDto.builder()
                            .replyId(reply.getId())
                            .content(reply.getContent())
                            .regDate(reply.getRegDate())
                            .communityId(community != null ? community.getId() : null)
                            .communitySubject(community != null ? community.getSubject() : "")
                            .parentReply(reply.getParentId() == null)
                            .build();
                })
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<CommunityDto> getMyScraps(long memberIdx) {
        return communityScrapRepository
                .findByMemberIdxOrderByScrapDateDesc(memberIdx)
                .stream()
                .map(scrap -> {
                    Community community = scrap.getCommunity();
                    if (community == null || community.isTemporary()) return null;
                    return toSimpleDto(community);
                })
                .filter(dto -> dto != null)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<MypageCommunityDto.VoteDto> getMyVotes(long memberIdx) {
        return pollVoteRepository
                .findDistinctPollsByMemberId(memberIdx)
                .stream()
                .map(poll -> {
                    Community community = poll.getCommunity();

                    String myOptions = pollVoteRepository
                            .findAllByPollPollIdAndMemberId(poll.getPollId(), memberIdx)
                            .stream()
                            .map(v -> v.getOption().getContent())
                            .collect(Collectors.joining(", "));

                    long totalVotes = pollVoteRepository
                            .countDistinctMemberByPollPollId(poll.getPollId());

                    boolean expired = poll.getEndDate() != null
                            && LocalDateTime.now().isAfter(poll.getEndDate());

                    return MypageCommunityDto.VoteDto.builder()
                            .pollId(poll.getPollId())
                            .pollTitle(poll.getTitle())
                            .pollEndDate(poll.getEndDate() != null ? poll.getEndDate().toLocalDate().toString() : null)
                            .expired(expired)
                            .communityId(community != null ? community.getId() : null)
                            .communitySubject(community != null ? community.getSubject() : "")
                            .myOptions(myOptions)
                            .totalVotes(totalVotes)
                            .build();
                })
                .collect(Collectors.toList());
    }

    private CommunityDto toSimpleDto(Community entity) {
        return CommunityDto.builder()
                .id(entity.getId())
                .memberIdx(entity.getMemberIdx())
                .writerNickname(entity.getWriterNickname())
                .subject(entity.getSubject())
                .category(convertCategory(entity.getCategory()))
                .hitCount(entity.getHitCount())
                .likeCount(entity.getLikeCount())
                .regDate(entity.getRegDate())
                .build();
    }

    private String convertCategory(String categoryCode) {
        if (categoryCode == null || categoryCode.isBlank()) return "";
        switch (categoryCode.trim()) {
            case "1":  return "일상";
            case "2":  return "동네질문";
            case "3":  return "동네맛집";
            case "4":  return "같이해요";
            case "5":  return "분실/실종";
            case "6":  return "동네사건사고";
            case "7":  return "생활정보";
            case "8":  return "취미생활";
            default:   return categoryCode;
        }
    }
} 