package com.sp.app.admin.service;

import com.sp.app.admin.mapper.AdminMemberMapper;
import com.sp.app.domain.dto.UserDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class AdminMemberServiceImpl implements AdminMemberService {

    private final AdminMemberMapper mapper;

    @Override
    public List<UserDto> listMembers(Map<String, Object> map) {
        return mapper.listMembers(map);
    }

    @Override
    public int countMembers(Map<String, Object> map) {
        return mapper.countMembers(map);
    }

    @Override
    public UserDto getMemberDetail(Long userIdx) {
        return mapper.getMemberDetail(userIdx);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateMemberStatus(Map<String, Object> map) throws Exception {
        mapper.updateMemberStatus(map);
        int status = Integer.parseInt(String.valueOf(map.get("status")));
        if (status == 1) {
            Long userIdx = Long.valueOf(String.valueOf(map.get("userIdx")));
            mapper.liftSanctionByUserIdx(userIdx);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateAuthority(Map<String, Object> map) throws Exception {
        String userId = (String) map.get("userId");
        mapper.deleteAuthority(userId);
        mapper.insertAuthority(map);

        String authority = (String) map.get("authority");
        int level = 1;
        if ("ADMIN".equals(authority))           level = 99;
        else if ("EMP".equals(authority))        level = 51;
        else if ("INSTRUCTOR".equals(authority)) level = 31;

        Map<String, Object> levelMap = new HashMap<>();
        levelMap.put("userId",    userId);
        levelMap.put("userLevel", level);
        mapper.updateUserLevel(levelMap);
    }

    @Override
    public List<Map<String, Object>> listSanctions(Map<String, Object> map) {
        return mapper.listSanctions(map);
    }

    @Override
    public int countSanctions(Map<String, Object> map) {
        return mapper.countSanctions(map);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void insertSanction(Map<String, Object> map) throws Exception {
        mapper.insertSanction(map);
        Map<String, Object> statusMap = new HashMap<>();
        statusMap.put("userIdx", map.get("userIdx"));
        statusMap.put("status", 2);
        mapper.updateMemberStatus(statusMap);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void liftSanction(Map<String, Object> map) throws Exception {
        mapper.liftSanction(map);
        Map<String, Object> statusMap = new HashMap<>();
        statusMap.put("userIdx", map.get("userIdx"));
        statusMap.put("status", 1);
        mapper.updateMemberStatus(statusMap);
    }

    @Override
    public List<Map<String, Object>> listWithdrawals(Map<String, Object> map) {
        return mapper.listWithdrawals(map);
    }

    @Override
    public int countWithdrawals(Map<String, Object> map) {
        return mapper.countWithdrawals(map);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void approveWithdrawal(Map<String, Object> map) throws Exception {
        map.put("withdrawStatus", "APPROVED");
        mapper.updateWithdrawalStatus(map);
        Map<String, Object> statusMap = new HashMap<>();
        statusMap.put("userIdx", map.get("userIdx"));
        statusMap.put("status", 9);
        mapper.updateMemberStatus(statusMap);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void rejectWithdrawal(Map<String, Object> map) throws Exception {
        map.put("withdrawStatus", "REJECTED");
        mapper.updateWithdrawalStatus(map);
        Map<String, Object> statusMap = new HashMap<>();
        statusMap.put("userIdx", map.get("userIdx"));
        statusMap.put("status", 1);
        mapper.updateMemberStatus(statusMap);
    }

    @Override
    public Map<String, Object> getWithdrawDetail(Long userIdx) {
        Map<String, Object> result = new HashMap<>();
        try {
            result.put("trades",      mapper.getActiveTrades(userIdx));
            result.put("reports",     mapper.getPendingReports(userIdx));
            Long point = mapper.getUserBatonPoint(userIdx);
            result.put("batonpoint",  point != null ? point : 0L);
        } catch (Exception e) {
            log.info("getWithdrawDetail error", e);
        }
        return result;
    }
}