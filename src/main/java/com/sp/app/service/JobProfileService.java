package com.sp.app.service;

import com.sp.app.model.JobProfile;

public interface JobProfileService {
    public void insertJobProfile(JobProfile dto) throws Exception;
    
    // public List<JobProfile> listJobProfile(Map<String, Object> map);
    // public JobProfile findById(long profileIdx); // 나중에 추가할꺼임
    
    public int getResumeCount(long userIdx) throws Exception;
}