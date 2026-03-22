package com.sp.app.service;

import java.util.List;
import com.sp.app.model.JobProfile;

public interface JobProfileService {
    void insertJobProfile(JobProfile dto) throws Exception;
    int getResumeCount(long userIdx) throws Exception;
    List<JobProfile> listJobProfile(long userIdx) throws Exception;
    JobProfile findById(long profileIdx) throws Exception;
    void updateJobProfile(JobProfile dto) throws Exception;
    void deleteJobProfile(long profileIdx) throws Exception;
}
