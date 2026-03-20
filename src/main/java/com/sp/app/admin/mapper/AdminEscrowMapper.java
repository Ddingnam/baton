package com.sp.app.admin.mapper;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;
import java.util.Map;

@Mapper
public interface AdminEscrowMapper {
    int dataCount(Map<String, Object> map);
    List<Map<String, Object>> listEscrow(Map<String, Object> map);
    Map<String, Object> getEscrowDetail(Long tradeIdx);
}