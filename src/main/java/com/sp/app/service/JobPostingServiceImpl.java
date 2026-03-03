package com.sp.app.service;

import com.sp.app.mapper.JobPostingMapper;
import com.sp.app.model.JobPosting;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class JobPostingServiceImpl implements JobPostingService {

    private final JobPostingMapper mapper;

    @Override
    public void insertPosting(JobPosting dto) throws Exception {
        mapper.insertPosting(dto);
    }

    @Override
    public void updatePosting(JobPosting dto) throws Exception {
        mapper.updatePosting(dto);
    }

    @Override
    public void deletePosting(long postingIdx) throws Exception {
        mapper.deletePosting(postingIdx);
    }

    @Override
    public int dataCount(Map<String, Object> map) {
        return mapper.dataCount(map);
    }

    @Override
    public List<JobPosting> listPosting(Map<String, Object> map) {
        return mapper.listPosting(map);
    }

    @Override
    public JobPosting findById(long postingIdx) {
        return mapper.findById(postingIdx);
    }
}