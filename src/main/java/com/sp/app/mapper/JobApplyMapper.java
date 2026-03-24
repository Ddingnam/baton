package com.sp.app.mapper;


import org.apache.ibatis.annotations.Mapper;

import com.sp.app.domain.dto.JobApplyDto;

import java.util.List;
import java.util.Map;

@Mapper
public interface JobApplyMapper {
    int insertApply(JobApplyDto apply);
    List<JobApplyDto> listApplyByUser(long userIdx);
    int updateStatus(Map<String,Object> map);
    int checkDuplicate(Map<String,Object> map);
}