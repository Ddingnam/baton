package com.sp.app.service;

import com.sp.app.mapper.JobPostingMapper;
import com.sp.app.model.JobPosting;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class JobPostingServiceImpl implements JobPostingService {
    
    private final JobPostingMapper postingMapper;

    @Override
    public void insertPosting(JobPosting dto) throws Exception {
        try {
            postingMapper.insertPosting(dto);
        } catch (Exception e) {
            log.error("알바 공고 등록 오류", e);
            throw e;
        }
    }

    @Override
    public List<JobPosting> listPosting(Map<String, Object> map) {
        List<JobPosting> list = null;
        try {
            list = postingMapper.listPosting(map);
        } catch (Exception e) {
            log.error("알바 공고 목록 조회 오류", e);
        }
        return list;
    }

    @Override
    public int dataCount(Map<String, Object> map) {
        int result = 0;
        try {
            result = postingMapper.dataCount(map);
        } catch (Exception e) {
            log.error("데이터 개수 조회 오류", e);
        }
        return result;
    }

    @Override
    public JobPosting findById(long postingIdx) {
        JobPosting dto = null;
        try {
            dto = postingMapper.findById(postingIdx);
        } catch (Exception e) {
            log.error("상세 조회 오류", e);
        }
        return dto;
    }
}