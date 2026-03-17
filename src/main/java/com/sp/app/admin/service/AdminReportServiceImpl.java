package com.sp.app.admin.service;

import com.sp.app.admin.domain.dto.ReportDto;
import com.sp.app.admin.mapper.AdminReportMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class AdminReportServiceImpl implements AdminReportService {

    @Autowired
    private AdminReportMapper mapper;

    @Override
    public int dataCount(Map<String, Object> map) {
        int result = 0;
        try {
            result = mapper.dataCount(map);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    @Override
    public List<ReportDto> listReport(Map<String, Object> map) {
        List<ReportDto> list = null;
        try {
            list = mapper.listReport(map);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public ReportDto getReport(Long reportIdx) {
        ReportDto dto = null;
        try {
            dto = mapper.getReport(reportIdx);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dto;
    }

    @Override
    public void processReport(Map<String, Object> map) {
        try {
            mapper.updateProcessStatus(map);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}