package com.sp.app.service;

import java.util.List;
import com.sp.app.domain.dto.CommunityReplyDto;

public interface CommunityReplyService {
	public List<CommunityReplyDto> listReply(Long communityId);
    
	public void insertReply(Long communityId, CommunityReplyDto dto);
	public void deleteReply(Long replyId, Long memberIdx);
	public int replyCount(Long communityId);
}