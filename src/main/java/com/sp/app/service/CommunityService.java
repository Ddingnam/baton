package com.sp.app.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.sp.app.domain.dto.CommunityDto;

public interface CommunityService {
	public void insertCommunity(CommunityDto dto, String uploadPath) throws Exception;
	public void updateCommunity(CommunityDto dto, String uploadPath) throws Exception;
	public void deleteCommunity(long id, String uploadPath) throws Exception;
	
	public CommunityDto getCommunity(long id);
	public Page<CommunityDto> getCommunityList(Pageable pageable, String schType, String kwd);
	
	public void updateHitCount(long id) throws Exception;
	public void deleteCommunityFile(long id, String filename, String uploadPath) throws Exception;
	
	public boolean toggleLike(long id, long memberIdx) throws Exception;
	public int getLikeCount(long id);
	public boolean isUserLiked(Map<String, Object> map);
	
	public boolean toggleScrap(long id, long memberIdx) throws Exception;
	public boolean isUserScraped(Map<String, Object> map);

	public void votePoll(long pollId, long memberIdx, List<Long> optionIds) throws Exception;
	public void cancelVote(long pollId, long memberIdx) throws Exception;
	public CommunityDto getPollInfo(long communityId);
	public boolean hasUserVoted(long pollId, long memberIdx);

	public List<CommunityDto> getTempList(long memberIdx);
	public void deleteTempCommunity(long id, long memberIdx, String uploadPath) throws Exception;
	public void updateTempCommunity(CommunityDto dto, String uploadPath) throws Exception;
	
	public long getPollTotalVotes(long communityId);
	public List<CommunityDto> getUserPostList(Long memberIdx);
	public List<CommunityDto> getUserPostListPaged(Long memberIdx, Pageable pageable);
	public long getUserPostCount(Long memberIdx);
	public long getUserReplyCount(Long memberIdx);
	public int getUserTotalLikes(Long memberIdx);
	public LocalDateTime getUserJoinDate(Long memberIdx);
	public List<Map<String, Object>> getUserRepliesWithPostTitle(Long memberIdx);
}