package com.sp.app.admin.service;

import com.sp.app.admin.domain.dto.ReportDto;
import com.sp.app.admin.mapper.AdminReportMapper;
import com.sp.app.security.LoginMemberUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class AdminReportServiceImpl implements AdminReportService {

    @Autowired
    private AdminReportMapper mapper;

    @Autowired
    private AdminNotificationService adminNotificationService;

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
    public void processReport(Map<String, Object> map) throws Exception {
        Object rawIdx = map.get("reportIdx");
        if (rawIdx instanceof Integer) {
            map.put("reportIdx", ((Integer) rawIdx).longValue());
        }
        mapper.updateProcessStatus(map);

        try {
            var session = LoginMemberUtil.getSessionInfo();
            if (session != null) {
                int status = Integer.parseInt(map.get("processStatus").toString());
                Long reportIdx = Long.valueOf(map.get("reportIdx").toString());
                String statusLabel = status == 1 ? "처리 완료" : "반려";
                String content = "신고 #" + reportIdx + " 가 " + statusLabel + " 처리되었습니다.";
                adminNotificationService.sendToAdmin(session.getUserIdx(), "REPORT", content, "/admin/report/list");
            }
        } catch (Exception ignored) {}
    }
}