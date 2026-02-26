package com.sp.app.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.sp.app.mapper.TradeMapper;
import com.sp.app.model.Trade;
import com.sp.app.model.TradeImg;

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
		try {
			mapper.deleteTradePostTag(productIdx);
			mapper.deleteTragePostImg(productIdx);
			mapper.deleteTradePost(productIdx);
		} catch (Exception e) {
			log.info("deleteTradePost : ", e);
		}
		
	}

	@Override
	public Trade findByIdx(long productIdx) {
		Trade dto = null;
		try {
			dto = mapper.findByIdx(productIdx);
		} catch (Exception e) {
			log.info("findByIdx : ", e);
		}
		return dto;
	}

	@Override
	public List<TradeImg> findImgsByIdx(long productIdx) {
		List<TradeImg> list = null;
		try {
			mapper.findImagesByIdx(productIdx);
		} catch (Exception e) {
			log.info("findImgsByIdx", e);
		}
		return list;
	}

	@Override
	public List<String> findTagsByIdx(long productIdx) {
		List<String> list = null;
		try {
			mapper.findTagsByIdx(productIdx);
		} catch (Exception e) {
			log.info("findTagsByIdx", e);
		}
		return list;
	}

	@Override
	public List<Trade> tradeList(Map<String, Object> map) {
		List<Trade> list = null;
	    try {
	        list = mapper.tradeList(map);
	    } catch (Exception e) {
	        log.info("tradeList : ", e);
	    }
	    return list;
	}

	@Override
	public int dataCount(Map<String, Object> map) {
		int result = 0;
	    try {
	        result = mapper.dataCount(map);
	    } catch (Exception e) {
	        log.info("dataCount error", e);
	    }
	    return result;
	}
	
}