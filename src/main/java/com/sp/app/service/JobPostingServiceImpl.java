package com.sp.app.service;

import com.sp.app.common.StorageService;
import com.sp.app.mapper.JobPostingMapper;
import com.sp.app.model.JobPosting;

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

    @Override
    @Transactional(readOnly = true)
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
            log.error("listPosting error : ", e);
        }

        return list;
    }

    @Override
    @Transactional(readOnly = true)
    public JobPosting findById(long postingIdx) {
        return mapper.findById(postingIdx);
    }

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

    @Override
    public List<String> listDong(Map<String, Object> map) {
        return mapper.listDong(map);
    }

	@Override
	public List<JobPosting> postListByUserId(long userIdx) {
		List<JobPosting> list = null;
		try {
			list = mapper.postListByUserIdx(userIdx);
		} catch (Exception e) {
			log.info("postListByUserId : ", e);
		}
		return list;
	}
	
	@Override
	public void insertJobScrap(Map<String, Object> map) throws Exception {
	    try {
	        mapper.insertJobScrap(map);
	    } catch (Exception e) {
	        log.warn("이미 스크랩된 데이터", e);
	        // 그냥 무시 (중복 클릭 방지)
	    }
	}

	@Override
	public void deleteJobScrap(Map<String, Object> map) throws Exception {
	    try {
	        mapper.deleteJobScrap(map);
	    } catch (Exception e) {
	        log.warn("스크랩 삭제 실패", e);
	    }
	}
    
}