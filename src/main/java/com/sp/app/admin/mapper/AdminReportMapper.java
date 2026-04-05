package com.sp.app.admin.mapper;

import com.sp.app.admin.domain.dto.ReportDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface AdminReportMapper {
    public int dataCount(Map<String, Object> map);
    public List<ReportDto> listReport(Map<String, Object> map);
    public ReportDto getReport(@Param("reportIdx") Long reportIdx);
    public void updateProcessStatus(Map<String, Object> map);
    public Long getReportedUserIdx(@Param("reportIdx") Long reportIdx);
    public Long getReporterIdx(@Param("reportIdx") Long reportIdx);
}