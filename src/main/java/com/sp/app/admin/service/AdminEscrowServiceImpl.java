package com.sp.app.admin.service;

import com.sp.app.admin.mapper.AdminEscrowMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AdminEscrowServiceImpl implements AdminEscrowService {
    private final AdminEscrowMapper adminEscrowMapper;

    @Override
    public int dataCount(Map<String, Object> map) {
        return adminEscrowMapper.dataCount(map);
    }

    @Override
    public List<Map<String, Object>> listEscrow(Map<String, Object> map) {
        return adminEscrowMapper.listEscrow(map);
    }
}