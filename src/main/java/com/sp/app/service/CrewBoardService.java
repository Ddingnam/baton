package com.sp.app.service;

import java.util.Map;

import com.sp.app.domain.dto.CrewBoardDto;
import com.sp.app.domain.dto.CrewCommentDto;

public interface CrewBoardService {
    Long savePost(CrewBoardDto dto);
    void updatePost(CrewBoardDto dto);
    void deletePost(long crewBoardIdx, long userIdx);
    
    CrewBoardDto getPostDetail(Long boardIdx, Long userIdx);
    Map<String, Object> getPostList(Long crewIdx, Long userIdx, int page, int size);
    Map<String, Object> getDashboardBoardData(Long crewIdx, Long userIdx);
    
    Long saveComment(CrewCommentDto dto);
    void updateComment(CrewCommentDto dto);
    void deleteComment(Long commentId, Long userIdx);
    
    Map<String, Object> getCommentList(Long boardIdx, int page, int size);
    
    Map<String, Object> toggleLike(Long boardIdx, Long userIdx);
    boolean isLikedByUser(Long boardIdx, Long userIdx);
}
