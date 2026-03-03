package com.sp.app.mapper;

import com.sp.app.model.JobPosting;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;
import java.util.Map;

@Mapper
public interface JobPostingMapper {
    void insertPosting(JobPosting dto);
    void updatePosting(JobPosting dto);
    void deletePosting(long postingIdx);
    
    int dataCount(Map<String, Object> map);
    List<JobPosting> listPosting(Map<String, Object> map);
    JobPosting findById(long postingIdx);
}