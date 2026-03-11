package com.sp.app.repository;

import com.sp.app.domain.entity.PollVote;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface PollVoteRepository extends JpaRepository<PollVote, Long> {
	public void deleteByPollPollIdAndMemberId(Long pollId, Long memberId);
	public boolean existsByPollPollIdAndMemberId(Long pollId, Long memberId);
    public List<PollVote> findAllByPollPollIdAndMemberId(Long pollId, Long memberId);
    public long countByOptionOptionId(Long optionId);

    @Query("SELECT COUNT(DISTINCT v.memberId) FROM PollVote v WHERE v.poll.pollId = :pollId")
    public long countDistinctMemberByPollPollId(@Param("pollId") Long pollId);
}