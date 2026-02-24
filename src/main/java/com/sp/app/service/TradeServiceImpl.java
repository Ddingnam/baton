package com.sp.app.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.sp.app.model.JobPosting;

import lombok.RequiredArgsConstructor;

@Service 
@RequiredArgsConstructor
public class TradeServiceImpl implements JobPostingService {
	
	@Override
	public void insertPosting(JobPosting dto) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public List<JobPosting> listPosting(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int dataCount(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public JobPosting findById(long postingIdx) {
		// TODO Auto-generated method stub
		return null;
	}
    // ... 내용
}