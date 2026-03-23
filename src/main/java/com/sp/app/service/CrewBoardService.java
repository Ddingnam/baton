package com.sp.app.service;

import java.util.Map;

import com.sp.app.domain.dto.CrewBoardDto;

public interface CrewBoardService {
    Long savePost(CrewBoardDto dto);
    void updatePost(CrewBoardDto dto);
    
    CrewBoardDto getPostDetail(Long boardIdx);
    Map<String, Object> getPostList(Long crewIdx, int page, int size);
}
