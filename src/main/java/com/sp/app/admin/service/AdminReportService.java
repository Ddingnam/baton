package com.sp.app.admin.service;

import com.sp.app.admin.domain.dto.ReportDto;

import java.util.List;
import java.util.Map;

public interface AdminReportService {
    public int dataCount(Map<String, Object> map);
    public List<ReportDto> listReport(Map<String, Object> map);
    public ReportDto getReport(Long reportIdx);
    public void processReport(Map<String, Object> map) throws Exception;
}