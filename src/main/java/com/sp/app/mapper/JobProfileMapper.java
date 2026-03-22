package com.sp.app.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.sp.app.model.JobProfile;

@Mapper
public interface JobProfileMapper {
    void insertJobProfile(JobProfile dto);
    int getResumeCount(long userIdx) throws Exception;
    List<JobProfile> listJobProfile(long userIdx);
    JobProfile findById(long profileIdx);
    void updateJobProfile(JobProfile dto);
    void deleteJobProfile(long profileIdx);
}
