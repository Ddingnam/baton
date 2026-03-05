package com.sp.app.service;

import java.util.Map;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sp.app.domain.dto.CommunityDto;

public interface CommunityService {
    void insertCommunity(CommunityDto dto, String uploadPath) throws Exception;
    void updateCommunity(CommunityDto dto, String uploadPath) throws Exception;
    void deleteCommunity(long id, String uploadPath) throws Exception;
    
    CommunityDto getCommunity(long id);
    Page<CommunityDto> getCommunityList(Pageable pageable, String schType, String kwd);
    
    void updateHitCount(long id) throws Exception;
    void deleteCommunityFile(long id, String filename, String uploadPath) throws Exception;
    
    boolean toggleLike(long id, long memberIdx) throws Exception;
    int getLikeCount(long id);
    boolean isUserLiked(Map<String, Object> map);
    
    boolean toggleScrap(long id, long memberIdx) throws Exception;
    boolean isUserScraped(Map<String, Object> map);
}