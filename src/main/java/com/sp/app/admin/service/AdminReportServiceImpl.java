package com.sp.app.admin.service;

import com.sp.app.admin.domain.dto.ReportDto;
import com.sp.app.admin.mapper.AdminReportMapper;
import com.sp.app.service.NotificationService;
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

    @Autowired
    private NotificationService notificationService;

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

            // 콘텐츠 숨김 처리
            Object hideContentObj = map.get("hideContent");
            boolean hideContent = hideContentObj != null
                    && Boolean.parseBoolean(hideContentObj.toString());

            if (hideContent) {
                Object targetIdxObj = map.get("targetIdx");
                String domainType   = map.get("domainType") != null ? map.get("domainType").toString() : "";

                if (targetIdxObj != null && !domainType.isEmpty()) {
                    Long targetIdx = Long.valueOf(targetIdxObj.toString());

                    if ("COMMUNITY".equals(domainType)) {
                        mapper.hideCommunityPost(targetIdx);
                    } else if ("COMMUNITY_REPLY".equals(domainType)) {
                        mapper.hideCommunityReply(targetIdx);
                    }
                }
            }
        }

        try {
            Long reportIdx = Long.valueOf(map.get("reportIdx").toString());
            Long reporterIdx = mapper.getReporterIdx(reportIdx);
            if (reporterIdx != null) {
                String statusLabel = status == 1 ? "처리 완료" : "반려";
                String content = "접수하신 신고(#" + reportIdx + ")가 [" + statusLabel + "] 처리되었습니다.";
                notificationService.sendNotification(reporterIdx, "REPORT", content, "/mypage/report");
            }
        } catch (Exception ignored) {}
    }
}