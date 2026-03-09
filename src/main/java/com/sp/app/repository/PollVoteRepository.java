package com.sp.app.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import com.sp.app.domain.entity.PollVote;

public interface PollVoteRepository extends JpaRepository<PollVote, Long> {
    boolean existsByPollPollIdAndMemberId(Long pollId, Long memberId);
    long countByOptionOptionId(Long optionId);
}