package com.sp.app.admin.service;

import com.sp.app.admin.mapper.AdminDashboardMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AdminDashboardServiceImpl implements AdminDashboardService {

    private final AdminDashboardMapper adminDashboardMapper;

    @Override
    public Map<String, Object> getDashboardData() {
        Map<String, Object> result = new HashMap<>();

        Map<String, Object> summary = adminDashboardMapper.getSummary();
        long totalMemberCount = toLong(summary.get("totalMemberCount"));
        long todayMemberCount = toLong(summary.get("todayMemberCount"));
        long yesterdayMemberCount = toLong(summary.get("yesterdayMemberCount"));
        long todayRevenue = toLong(summary.get("todayRevenue"));
        long yesterdayRevenue = toLong(summary.get("yesterdayRevenue"));
        long todayTradeCount = toLong(summary.get("todayTradeCount"));
        long yesterdayTradeCount = toLong(summary.get("yesterdayTradeCount"));
        long pendingReportCount = toLong(summary.get("pendingReportCount"));

        result.put("totalMemberCount", totalMemberCount);
        result.put("todayRevenue", todayRevenue);
        result.put("todayTradeCount", todayTradeCount);
        result.put("pendingReportCount", pendingReportCount);

        result.put("memberTrendText", buildTrendText(todayMemberCount, yesterdayMemberCount, "오늘 가입 "));
        result.put("memberTrendUp", todayMemberCount >= yesterdayMemberCount);
        result.put("revenueTrendText", buildTrendText(todayRevenue, yesterdayRevenue, "전일 대비 "));
        result.put("revenueTrendUp", todayRevenue >= yesterdayRevenue);
        result.put("tradeTrendText", buildTrendText(todayTradeCount, yesterdayTradeCount, "전일 대비 "));
        result.put("tradeTrendUp", todayTradeCount >= yesterdayTradeCount);
        result.put("pendingReportLabel", pendingReportCount > 0 ? "처리 필요" : "모두 처리됨");

        List<Map<String, Object>> chartRows = adminDashboardMapper.listRevenueChart();
        List<String> chartLabels = new ArrayList<>();
        List<Long> chartValues = new ArrayList<>();
        for (Map<String, Object> row : chartRows) {
            chartLabels.add(String.valueOf(row.get("label")));
            chartValues.add(toLong(row.get("amount")));
        }
        result.put("chartLabels", chartLabels);
        result.put("chartValues", chartValues);

        result.put("recentActivities", adminDashboardMapper.listRecentActivities());
        result.put("recentTransactions", adminDashboardMapper.listRecentTransactions());

        return result;
    }

    private long toLong(Object value) {
        if (value == null) {
            return 0L;
        }
        if (value instanceof Number number) {
            return number.longValue();
        }
        return Long.parseLong(String.valueOf(value));
    }

    private String buildTrendText(long current, long previous, String prefix) {
        if (previous <= 0) {
            if (current <= 0) {
                return prefix + "0%";
            }
            return prefix + "신규";
        }

        BigDecimal currentValue = BigDecimal.valueOf(current);
        BigDecimal previousValue = BigDecimal.valueOf(previous);
        BigDecimal diff = currentValue.subtract(previousValue)
                .multiply(BigDecimal.valueOf(100))
                .divide(previousValue, 1, RoundingMode.HALF_UP)
                .abs();

        return prefix + String.format(Locale.KOREA, "%s%%", diff.stripTrailingZeros().toPlainString());
    }
}
