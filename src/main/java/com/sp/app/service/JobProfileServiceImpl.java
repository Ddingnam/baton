package com.sp.app.service;

import org.springframework.stereotype.Service;
import com.sp.app.mapper.JobProfileMapper;
import com.sp.app.model.JobProfile;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j 
public class JobProfileServiceImpl implements JobProfileService {
    
    private final JobProfileMapper mapper;

    @Override
    public void insertJobProfile(JobProfile dto) throws Exception {
        try {
            mapper.insertJobProfile(dto);
        } catch (Exception e) {
            log.error("insertJobProfile error : ", e);
            throw e;
        }
    }
    
    @Override
    public int getResumeCount(long userIdx) throws Exception {
        int count = 0;
        try {
            count = mapper.getResumeCount(userIdx); 
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
}