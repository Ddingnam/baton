package com.sp.app.admin.service;

import com.sp.app.admin.domain.dto.ReportDto;
import com.sp.app.admin.mapper.AdminReportMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AdminReportServiceImpl implements AdminReportService {

    @Autowired
    private AdminReportMapper mapper;

    @Autowired
    private AdminMemberService adminMemberService;

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
    @Transactional(rollbackFor = Exception.class)
    public void processReport(Map<String, Object> map) throws Exception {
        // reportIdx 타입 정규화 (Integer → Long)
        Object rawIdx = map.get("reportIdx");
        if (rawIdx instanceof Integer) {
            map.put("reportIdx", ((Integer) rawIdx).longValue());
        }

        // 1. 신고 처리 상태 업데이트
        mapper.updateProcessStatus(map);

        int status = Integer.parseInt(map.get("processStatus").toString());

        // 2. 처리 완료(1)이고 제재 옵션이 있을 때만 제재 삽입
        if (status == 1) {
            String sanctionType = map.get("sanctionType") != null
                    ? map.get("sanctionType").toString().trim()
                    : "";

            if (!sanctionType.isEmpty() && !sanctionType.equals("NONE")) {
                Long reportIdx = Long.valueOf(map.get("reportIdx").toString());

                // 피신고자 userIdx 조회
                Long reportedUserIdx = mapper.getReportedUserIdx(reportIdx);

                if (reportedUserIdx != null) {
                    Map<String, Object> sanctionMap = new HashMap<>();
                    sanctionMap.put("userIdx",      reportedUserIdx);
                    sanctionMap.put("sanctionType", sanctionType);
                    sanctionMap.put("reason",       map.getOrDefault("adminMemo", "신고 처리에 의한 제재"));

                    if ("TEMPORARY".equals(sanctionType)) {
                        Object daysObj = map.get("sanctionDays");
                        int days = (daysObj != null) ? Integer.parseInt(daysObj.toString()) : 7;
                        sanctionMap.put("days", days);
                    }

                    adminMemberService.insertSanction(sanctionMap);
                }
            }
        }

        // 3. 신고자에게 처리 결과 알림 발송
        try {
            Long reportIdx = Long.valueOf(map.get("reportIdx").toString());
            Long reporterIdx = mapper.getReporterIdx(reportIdx);
            if (reporterIdx != null) {
                String statusLabel = status == 1 ? "처리 완료" : "반려";
                String content = "접수하신 신고(#" + reportIdx + ")가 [" + statusLabel + "] 처리되었습니다.";
                adminNotificationService.sendToAdmin(reporterIdx, "REPORT", content, "/admin/report/list");
            }
        } catch (Exception ignored) {}
    }
}