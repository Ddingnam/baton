package com.sp.app.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.model.JobProfile;

@Mapper
public interface JobProfileMapper {

	void insertJobProfile(JobProfile dto);
	
}
