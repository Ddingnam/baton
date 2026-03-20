package com.sp.app.admin.mapper;

import com.sp.app.model.JobPosting;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface AdminAlbaMapper {
	public List<JobPosting> listPosting(Map<String, Object> map);
	public int dataCount(Map<String, Object> map);
	public JobPosting findById(@Param("postingIdx") long postingIdx);
	public List<String> findImages(@Param("postingIdx") long postingIdx);
	public void deletePosting(@Param("postingIdx") long postingIdx);
	public void deleteImages(@Param("postingIdx") long postingIdx);
}