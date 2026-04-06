package com.sp.app.service;

import com.sp.app.common.StorageService;
import com.sp.app.domain.dto.JobApplyDto;
import com.sp.app.mapper.JobApplyMapper;
import com.sp.app.mapper.JobPostingMapper;
import com.sp.app.model.JobPosting;
import com.sp.app.model.JobPostingImage;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class JobPostingServiceImpl implements JobPostingService {
    private final JobPostingMapper mapper;
    private final StorageService storageService;
    private final JobApplyMapper jobApplyMapper;
    
    
    @Value("${file.upload-root}/job")
    private String uploadPath;

    @Override
    @Transactional
    public void insertPosting(JobPosting dto) throws Exception {
        try {
            mapper.insertPosting(dto);

           
            if(dto.getImages() != null && !dto.getImages().isEmpty()) {
                for(MultipartFile mf : dto.getImages()) {
                    if(mf.isEmpty()) continue;

                  
                    String saveFilename = storageService.upload(mf, uploadPath);

                    JobPostingImage imgDto = new JobPostingImage();
                    imgDto.setPostingIdx(dto.getPostingIdx()); 
                    imgDto.setImgUrl(saveFilename);          

                    mapper.insertPostingImage(imgDto);
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
	        int count = mapper.checkJobScrap(map);

	        if (count == 0) {
	            mapper.insertJobScrap(map);
	        } else {
	            log.info("이미 스크랩 존재 → insert 안함");
	        }

	    } catch (Exception e) {
	        log.error("스크랩 insert 실패", e);
	        throw e;
	    }
	}

	@Override
	@Transactional
	public void deleteJobScrap(Map<String, Object> map) throws Exception {
	    try {
	        int result = mapper.deleteJobScrap(map);

	        if (result == 0) {
	            log.warn("삭제된 데이터 없음 → 이미 없거나 조건 불일치");
	        } else {
	            log.info("스크랩 삭제 성공");
	        }

	    } catch (Exception e) {
	        log.error("스크랩 삭제 실패", e);
	        throw e;
	    }
	}
	
	@Override
	public List<JobPosting> listJobScrap(long userIdx) {
	    List<JobPosting> list = null;
	    try {
	        list = mapper.listJobScrap(userIdx);
	    } catch (Exception e) {
	        log.info("listJobScrap error : ", e);
	    }
	    return list;
	}
	
	@Override
	public int checkJobScrap(Map<String, Object> map) {
	    int result = 0;
	    try {
	        result = mapper.checkJobScrap(map);
	    } catch (Exception e) {
	        log.info("checkJobScrap error", e);
	    }
	    return result;
	}
	

	@Override
	@Transactional
	public void applyToAlba(long userIdx, long postingIdx, long profileIdx, String message) throws Exception {
	    try {
	        Map<String, Object> map = new HashMap<>();
	        map.put("userIdx", userIdx);
	        map.put("postingIdx", postingIdx);
	        map.put("profileIdx", profileIdx);
	        map.put("message", message);

	        // 1. 여기서 중복 지원 여부를 먼저 체크 (JobApplyMapper에 있는 쿼리 활용)
	        // 주의: mapper.checkDuplicate() 형태로 연결할 수 있도록 JobPostingMapper나 JobApplyMapper를 적절히 호출해주세요.
	        // int isDuplicate = mapper.checkDuplicate(map); 
	        // if(isDuplicate > 0) {
	        //     throw new DuplicateKeyException("이미 지원한 공고입니다.");
	        // }

	        // 2. 중복이 아니면 지원 데이터 삽입
	        mapper.insertAlbaApply(map); 
	    } catch (Exception e) {
	        log.error("지원 실패", e);
	        throw e;
	    }
	}

	@Override
	public int applyCount(long postingIdx) throws Exception {
		int result = 0;
		try {
			result = mapper.applyCount(postingIdx);
		} catch (Exception e) {
			log.info("지원자 수 카운트 에러", e);
			throw e;
		}
		return result;
	}

	@Override
	public List<JobApplyDto> listApplicantsByPosting(long postingIdx) {
	    return jobApplyMapper.listApplicantsByPosting(postingIdx);
	}
	
	@Override
	public List<JobPostingImage> listPostingImage(long postingIdx) {
	    List<JobPostingImage> list = null;
	    try {
	        list = mapper.listPostingImage(postingIdx);
	    } catch (Exception e) {
	        log.error("listPostingImage error : ", e);
	    }
	    return list;
	}

	@Override
	public int getMyApplyCount(long userIdx) throws Exception {
	    try {
	        return mapper.getMyApplyCount(userIdx);
	    } catch (Exception e) {
	        log.error("getMyApplyCount error", e);
	        return 0;
	    }
	}

	@Override
	public int getMyApplyResultCount(long userIdx) throws Exception {
	    try {
	        return mapper.getMyApplyResultCount(userIdx);
	    } catch (Exception e) {
	        log.error("getMyApplyResultCount error", e);
	        return 0;
	    }
	}

	@Override
	public int getMyScrapCount(long userIdx) throws Exception {
	    try {
	        return mapper.getMyScrapCount(userIdx);
	    } catch (Exception e) {
	        log.error("getMyScrapCount error", e);
	        return 0;
	    }
	}

	
}