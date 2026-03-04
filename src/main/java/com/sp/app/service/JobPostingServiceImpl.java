package com.sp.app.service;

import com.sp.app.common.StorageService;
import com.sp.app.mapper.JobPostingMapper;
import com.sp.app.model.JobPosting;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class JobPostingServiceImpl implements JobPostingService {

	private final JobPostingMapper mapper;
    private final StorageService storageService;
    
    
    @Override
    public void insertPosting(JobPosting dto) throws Exception {
        try {
            mapper.insertPosting(dto);
        } catch (Exception e) {
            log.error("insertPosting error", e);
            throw e;
        }
    }

    @Override
    public void updatePosting(JobPosting dto) throws Exception {
        try {
            mapper.updatePosting(dto);
        } catch (Exception e) {
            log.error("updatePosting error", e);
            throw e;
        }
    }

    @Override
    public void deletePosting(long postingIdx) throws Exception {
        try {
            mapper.deletePosting(postingIdx);
        } catch (Exception e) {
            log.error("deletePosting error", e);
            throw e;
        }
    }

    @Override
    @Transactional(readOnly = true) // 단순 조회는 readOnly를 설정하면 성능이 최적화됩니다.
    public int dataCount(Map<String, Object> map) {
        return mapper.dataCount(map);
    }

    @Override
    @Transactional(readOnly = true)
    public List<JobPosting> listPosting(Map<String, Object> map) {
        List<JobPosting> list = null;
        try {
            list = mapper.listPosting(map);
        } catch (Exception e) {
            log.error("listPosting error", e);
        }
        return list;
    }

    @Override
    @Transactional(readOnly = true)
    public JobPosting findById(long postingIdx) {
        return mapper.findById(postingIdx);
    }
}