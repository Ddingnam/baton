package com.sp.app.service;

import com.sp.app.common.StorageService;
import com.sp.app.mapper.JobPostingMapper;
import com.sp.app.model.JobPosting;
import com.sp.app.model.JobPostingImage;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class JobPostingServiceImpl implements JobPostingService {
    private final JobPostingMapper mapper;
    private final StorageService storageService;
    
    @Value("${file.upload-root}/job")
    private String uploadPath;

    @Override
    @Transactional
    public void insertPosting(JobPosting dto) throws Exception {
        try {
            mapper.insertPosting(dto);

            if(dto.getImages() != null) {

                for(MultipartFile mf : dto.getImages()) {

                    if(mf.isEmpty()) continue;

                    String saveFilename = storageService.upload(mf, uploadPath);

                    dto.setThumbUrl(saveFilename);

                    mapper.insertPostingImage(dto);
                }
            }

        } catch (Exception e) {
            log.error("insertPosting error : ", e);
            throw e;
        }
    }

    /**
     * 게시글 수정
     */
    @Override
    @Transactional
    public void updatePosting(JobPosting dto) throws Exception {
        try {
            mapper.updatePosting(dto);

        } catch (Exception e) {
            log.error("updatePosting error : ", e);
            throw e;
        }
    }

    /**
     * 게시글 삭제
     */
    @Override
    @Transactional
    public void deletePosting(long postingIdx) throws Exception {
        try {
            mapper.deletePosting(postingIdx);

        } catch (Exception e) {
            log.error("deletePosting error : ", e);
            throw e;
        }
    }

    /**
     * 게시글 수
     */
    @Override
    @Transactional(readOnly = true)
    public int dataCount(Map<String, Object> map) {
        return mapper.dataCount(map);
    }

    /**
     * 게시글 리스트
     */
    @Override
    @Transactional(readOnly = true)
    public List<JobPosting> listPosting(Map<String, Object> map) {

        List<JobPosting> list = null;

        try {
            list = mapper.listPosting(map);

        } catch (Exception e) {
            log.error("listPosting error : ", e);
        }

        return list;
    }

    /**
     * 게시글 상세
     */
    @Override
    @Transactional(readOnly = true)
    public JobPosting findById(long postingIdx) {
        return mapper.findById(postingIdx);
    }

    /**
     * 조회수 증가
     */
    @Override
    @Transactional
    public void updateHitCount(long postingIdx) throws Exception {

        try {
            mapper.updateHitCount(postingIdx);

        } catch (Exception e) {
            log.error("updateHitCount error : ", e);
            throw e;
        }
    }
    
    @Override
    public List<JobPosting> listPostingByArea(Map<String, Object> map) {
        return mapper.listPostingByArea(map);
    }
    
}