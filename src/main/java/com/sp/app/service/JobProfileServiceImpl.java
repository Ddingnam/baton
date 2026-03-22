package com.sp.app.service;

import java.util.List;
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
            log.error("insertJobProfile error", e);
            throw e;
        }
    }

    @Override
    public int getResumeCount(long userIdx) throws Exception {
        try {
            return mapper.getResumeCount(userIdx);
        } catch (Exception e) {
            log.error("getResumeCount error", e);
            return 0;
        }
    }

    @Override
    public List<JobProfile> listJobProfile(long userIdx) throws Exception {
        try {
            return mapper.listJobProfile(userIdx);
        } catch (Exception e) {
            log.error("listJobProfile error", e);
            throw e;
        }
    }

    @Override
    public JobProfile findById(long profileIdx) throws Exception {
        try {
            return mapper.findById(profileIdx);
        } catch (Exception e) {
            log.error("findById error", e);
            throw e;
        }
    }

    @Override
    public void updateJobProfile(JobProfile dto) throws Exception {
        try {
            mapper.updateJobProfile(dto);
        } catch (Exception e) {
            log.error("updateJobProfile error", e);
            throw e;
        }
    }

    @Override
    public void deleteJobProfile(long profileIdx) throws Exception {
        try {
            mapper.deleteJobProfile(profileIdx);
        } catch (Exception e) {
            log.error("deleteJobProfile error", e);
            throw e;
        }
    }
}
