package com.sp.app.service;

import java.util.Map;

import com.sp.app.domain.dto.CrewBoardDto;
import com.sp.app.domain.dto.CrewCommentDto;

public interface CrewBoardService {
    Long savePost(CrewBoardDto dto);
    void updatePost(CrewBoardDto dto);
    void deletePost(long crewBoardIdx, long userIdx);
    
    CrewBoardDto getPostDetail(Long boardIdx);
    Map<String, Object> getPostList(Long crewIdx, int page, int size);
    
    Long saveComment(CrewCommentDto dto);
    void updateComment(CrewCommentDto dto);
    void deleteComment(Long commentId, Long userIdx);
    
    Map<String, Object> getCommentList(Long boardIdx, int page, int size);
}
