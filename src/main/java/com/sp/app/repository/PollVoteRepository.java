package com.sp.app.repository;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sp.app.domain.entity.PollVote;

public interface PollVoteRepository extends JpaRepository<PollVote, Long> {
	public boolean existsByPollPollIdAndMemberId(Long pollId, Long memberId);
	public long countByOptionOptionId(Long optionId);
	public void deleteByPollPollIdAndMemberId(Long pollId, Long memberId);
	public PollVote findByPollPollIdAndMemberId(Long pollId, Long memberId);
	public List<PollVote> findAllByPollPollIdAndMemberId(Long pollId, Long memberId);
	
}