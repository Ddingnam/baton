package com.sp.app.service;

import com.sp.app.model.JobPosting;
import java.util.List;
import java.util.Map;

public interface JobPostingService {
    public void insertPosting(JobPosting dto) throws Exception;
    public List<JobPosting> listPosting(Map<String, Object> map);
    public int dataCount(Map<String, Object> map);
    public JobPosting findById(long postingIdx);
}