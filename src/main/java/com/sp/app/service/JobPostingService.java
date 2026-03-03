package com.sp.app.service;

import com.sp.app.model.JobPosting;
import java.util.List;
import java.util.Map;

public interface JobPostingService {
    void insertPosting(JobPosting dto) throws Exception;
    void updatePosting(JobPosting dto) throws Exception;
    void deletePosting(long postingIdx) throws Exception;
    
    int dataCount(Map<String, Object> map);
    List<JobPosting> listPosting(Map<String, Object> map);
    JobPosting findById(long postingIdx);
}