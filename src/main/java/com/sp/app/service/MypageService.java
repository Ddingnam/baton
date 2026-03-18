package com.sp.app.service;

import java.util.List;
import java.util.Map;

import com.sp.app.domain.dto.CommunityDto;
import com.sp.app.domain.dto.MypageCommunityDto;

public interface MypageService {
	public List<CommunityDto> getMyPosts(long memberIdx);
	public List<MypageCommunityDto.ReplyDto> getMyReplies(long memberIdx);
	public List<CommunityDto> getMyScraps(long memberIdx);
	public List<MypageCommunityDto.VoteDto> getMyVotes(long memberIdx);
	public List<Map<String, Object>> getMyTradeHistory(long memberIdx);
}