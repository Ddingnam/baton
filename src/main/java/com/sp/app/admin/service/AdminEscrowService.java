package com.sp.app.admin.service;

import java.util.List;
import java.util.Map;

public interface AdminEscrowService {
    int dataCount(Map<String, Object> map);
    List<Map<String, Object>> listEscrow(Map<String, Object> map);
}