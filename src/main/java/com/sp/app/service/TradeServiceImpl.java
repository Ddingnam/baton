package com.sp.app.service;

import org.springframework.stereotype.Service;

import com.sp.app.mapper.TradeMapper;
import com.sp.app.model.Trade;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class TradeServiceImpl implements TradeService {
	private final TradeMapper mapper;

	@Override
	public void insertTradePost(Trade dto) throws Exception {
		try {
			mapper.insertTradePost(dto);
		} catch (Exception e) {
			log.info("insertTradePost : ", e);
		}
		
	}

	@Override
	public void upodateTradePost(Trade dto) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteTradePost(long productIdx) throws Exception {
		// TODO Auto-generated method stub
		
	}
	
}