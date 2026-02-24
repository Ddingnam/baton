package com.sp.app.mapper;

import com.sp.app.model.JobPosting;
import org.apache.ibatis.annotations.Mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@Mapper
public interface JobPostingMapper {
    public void insertPosting(JobPosting dto) throws SQLException;
    public void updatePosting(JobPosting dto) throws SQLException;
    public void deletePosting(long postingIdx) throws SQLException;
    public JobPosting findById(long postingIdx);
    public List<JobPosting> listPosting(Map<String, Object> map);
    public int dataCount(Map<String, Object> map);
}