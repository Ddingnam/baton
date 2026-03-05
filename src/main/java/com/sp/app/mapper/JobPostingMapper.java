package com.sp.app.mapper;

import com.sp.app.model.JobPosting;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;
import java.util.Map;

@Mapper
public interface JobPostingMapper {

    // 게시글
    void insertPosting(JobPosting dto);
    void updatePosting(JobPosting dto);
    void deletePosting(long postingIdx);

    // 이미지
    void insertPostingImage(JobPosting dto);
    List<String> findImages(long postingIdx);
    void deleteImages(long postingIdx);

    // 조회
    int dataCount(Map<String, Object> map);
    List<JobPosting> listPosting(Map<String, Object> map);
    JobPosting findById(long postingIdx);

    void updateHitCount(long postingIdx);           
}