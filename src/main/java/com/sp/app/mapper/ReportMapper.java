package com.sp.app.mapper;

import org.apache.ibatis.annotations.Mapper;
import java.util.Map;

@Mapper
public interface ReportMapper {
	public void insertReport(Map<String, Object> map);
	public int checkDuplicate(Map<String, Object> map);
}