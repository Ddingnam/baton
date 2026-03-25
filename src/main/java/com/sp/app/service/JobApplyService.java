package com.sp.app.service;

import com.sp.app.domain.dto.JobApplyDto;
import com.sp.app.mapper.JobApplyMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class JobApplyService {

    private final JobApplyMapper mapper;

    public int insertApply(JobApplyDto apply) {
        return mapper.insertApply(apply);
    }

    public List<JobApplyDto> listApplyByUser(long userIdx) {
        return mapper.listApplyByUser(userIdx);
    }

    public int updateStatus(Map<String,Object> map) {
        return mapper.updateStatus(map);
    }

    public boolean isDuplicate(long postingIdx, long userIdx) {
        Map<String,Object> map = Map.of("postingIdx", postingIdx, "userIdx", userIdx);
        return mapper.checkDuplicate(map) > 0;
    }
    
    
}