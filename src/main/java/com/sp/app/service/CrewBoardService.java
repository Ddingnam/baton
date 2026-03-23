package com.sp.app.service;

import java.util.List;
import java.util.Map;

import com.sp.app.domain.dto.CrewBoardDto;

public interface CrewBoardService {
    Long savePost(CrewBoardDto dto);
    List<CrewBoardDto> findAllPosts(Long crewIdx);
    CrewBoardDto findPostById(Long boardIdx);
    Map<String, Object> getPostListCustom(Long crewIdx, int page, int size);
    void updateViewCount(Long boardIdx);
}
