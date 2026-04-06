package com.sp.app.service;

import com.sp.app.domain.dto.JobApplyDto;
import com.sp.app.model.JobPosting;
import com.sp.app.model.JobPostingImage;

import java.util.List;
import java.util.Map;

public interface JobPostingService {

    void insertPosting(JobPosting dto) throws Exception;
    void updatePosting(JobPosting dto) throws Exception;
    void deletePosting(long postingIdx) throws Exception;

    int dataCount(Map<String, Object> map);
    List<JobPosting> listPosting(Map<String, Object> map);
    JobPosting findById(long postingIdx);
    void updateHitCount(long postingIdx) throws Exception;

    List<JobPosting> listPostingByArea(Map<String, Object> map);
    List<String> listDong(Map<String, Object> map);

    List<JobPosting> postListByUserId(long userIdx);

    void insertJobScrap(Map<String, Object> map) throws Exception;
    void deleteJobScrap(Map<String, Object> map) throws Exception;
    List<JobPosting> listJobScrap(long userIdx);
    int checkJobScrap(Map<String, Object> map) throws Exception;

    void applyToAlba(long userIdx, long postingIdx, long profileIdx, String message) throws Exception;
    int applyCount(long postingIdx) throws Exception;

    List<JobApplyDto> listApplicantsByPosting(long postingIdx);
    List<JobPostingImage> listPostingImage(long postingIdx);
    
    int getMyApplyCount(long userIdx) throws Exception;
    int getMyApplyResultCount(long userIdx) throws Exception;
    int getMyScrapCount(long userIdx) throws Exception;


}