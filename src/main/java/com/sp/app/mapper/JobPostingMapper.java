package com.sp.app.mapper;

import com.sp.app.model.JobPostingImage;
import com.sp.app.domain.dto.JobApplyDto;
import com.sp.app.model.JobPosting;
import org.apache.ibatis.annotations.Mapper;


import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@Mapper
public interface JobPostingMapper {

    void insertPosting(JobPosting dto);
    void updatePosting(JobPosting dto);
    void deletePosting(long postingIdx);
    
    void insertPostingImage(JobPostingImage dto);
   // List<String> findImages(long postingIdx);
    List<JobPostingImage> listPostingImage(long postingIdx);
    void deleteImages(long postingIdx);
     
    int dataCount(Map<String, Object> map);
    List<JobPosting> listPosting(Map<String, Object> map);
    JobPosting findById(long postingIdx);

    void updateHitCount(long postingIdx);   
    
    List<JobPosting> listPostingByArea(Map<String,Object> map);
    
    List<String> listDong(Map<String, Object> map);
    
    public List<JobPosting> postListByUserIdx(long userIdx);
    
    public void insertJobScrap(Map<String, Object> map) throws SQLException;
    int deleteJobScrap(Map<String, Object> map) throws SQLException;
    public int checkJobScrap(Map<String, Object> map);
    
    public List<JobPosting> listJobScrap(long memberId);
    
    void insertAlbaApply(Map<String, Object> map);
	int applyCount(long postingIdx);
	
	List<JobApplyDto> listApplicantsByPosting(long postingIdx);
	int updateStatusByOwner(Map<String,Object> map);
	List<String> findImagesByPostingIdx(long postingIdx);
    
}