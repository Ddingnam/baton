package com.sp.app.admin.service;

import com.sp.app.admin.mapper.AdminPaymentMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AdminPaymentServiceImpl implements AdminPaymentService {
    private final AdminPaymentMapper adminPaymentMapper;

    @Override
    public int dataCount(Map<String, Object> map) {
        return adminPaymentMapper.dataCount(map);
    }

    @Override
    public List<Map<String, Object>> listPayment(Map<String, Object> map) {
        return adminPaymentMapper.listPayment(map);
    }
}