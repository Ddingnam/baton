package com.sp.app.admin.mapper;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface AdminDashboardMapper {
    Map<String, Object> getSummary();
    List<Map<String, Object>> listRevenueChart();
    List<Map<String, Object>> listRecentActivities();
    List<Map<String, Object>> listRecentTransactions();
}
