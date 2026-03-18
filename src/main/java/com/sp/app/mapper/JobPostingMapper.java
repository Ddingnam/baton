package com.sp.app.mapper;

import com.sp.app.model.JobPosting;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;
import java.util.Map;

@Mapper
public interface JobPostingMapper {

    void insertPosting(JobPosting dto);
    void updatePosting(JobPosting dto);
    void deletePosting(long postingIdx);

    void insertPostingImage(JobPosting dto);
    List<String> findImages(long postingIdx);
    void deleteImages(long postingIdx);
     
    int dataCount(Map<String, Object> map);
    List<JobPosting> listPosting(Map<String, Object> map);
    JobPosting findById(long postingIdx);

    void updateHitCount(long postingIdx);   
    
    List<JobPosting> listPostingByArea(Map<String,Object> map);
    
    List<String> listDong(Map<String, Object> map);
    
    public List<JobPosting> postListByUserIdx(long userIdx);
}