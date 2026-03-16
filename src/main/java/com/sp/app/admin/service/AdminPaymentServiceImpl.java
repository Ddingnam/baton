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

    @Override
    public Map<String, Object> findById(String orderId) {
        return adminPaymentMapper.findById(orderId);
    }

    @Override
    public void updatePaymentStatus(Map<String, Object> map) throws Exception {
        try {
            adminPaymentMapper.updatePaymentStatus(map);
        } catch (Exception e) {
            throw new Exception("결제 상태 업데이트 중 오류가 발생했습니다.");
        }
    }
}