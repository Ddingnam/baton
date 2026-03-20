package com.sp.app.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.sp.app.common.StorageService;
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
	private final StorageService storageService;
    private final NotificationService notificationService;

	@Override
	@Transactional
	public void insertTradePost(Trade dto, String uploadPath) throws Exception {
		try {
			mapper.insertTradePost(dto);
			
			if (dto.getTags() != null && !dto.getTags().trim().isEmpty()) {
	            String[] tagArray = dto.getTags().split(",");
	            for (String name : tagArray) {
	                String tagName = name.trim();
	                if (tagName.isEmpty()) continue;

	                Long tagIdx = mapper.findTagIdxByName(tagName);

	                if (tagIdx == null) {
	                    Trade tagDto = new Trade();
	                    tagDto.setTagName(tagName);
	                    mapper.insertTradeTag(tagDto);
	                    tagIdx = tagDto.getTagIdx();
	                }

	                Map<String, Object> map = new HashMap<>();
	                map.put("productIdx", dto.getProductIdx());
	                map.put("tagIdx", tagIdx);
	                mapper.insertTradePostTag(map);
	            }
	        }
			
			List<MultipartFile> files = dto.getNewFiles();
			if(files != null && !files.isEmpty()) {
				int order = 1;
				for(MultipartFile mf : files) {
					if(mf.isEmpty()) continue;
					
					String saveFilename = storageService.uploadFileToServer(mf, uploadPath);
					
					TradeImg imgDto = new TradeImg();
					imgDto.setProductIdx(dto.getProductIdx());
					imgDto.setImgOrder(order++);
					imgDto.setOriginalName(mf.getOriginalFilename());
					imgDto.setSaveName(saveFilename);
					imgDto.setImgUrl("/uploads/trade/" + saveFilename);
					
					mapper.insertTradePostImg(imgDto);
					
					if(order > 5) break;
				}
			}
		} catch (Exception e) {
			log.info("insertTradePost : ", e);
			throw e;
		}
		
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public void updateTradePost(Trade dto, String uploadPath) throws Exception {
		try {
			
			if (dto.getDeleteImgOrders() != null) {
	            for (Integer order : dto.getDeleteImgOrders()) {
	                String saveName = mapper.findSaveName(dto.getProductIdx(), order);
	                if (saveName != null) {
	                    storageService.deleteFile(uploadPath, saveName);
	                    mapper.deleteTradePostImg(dto.getProductIdx(), order);
	                }
	            }
	        }

			if (dto.getNewFiles() != null && !dto.getNewFiles().isEmpty()) {
	            Integer lastOrder = mapper.getLastOrder(dto.getProductIdx());
	            int currentOrder = (lastOrder == null) ? 0 : lastOrder;
	            
	            for (MultipartFile mf : dto.getNewFiles()) {
	                if (mf.isEmpty()) continue;
	                if (++currentOrder > 5) break;

	                String saveFilename = storageService.uploadFileToServer(mf, uploadPath);
	                
	                TradeImg imgDto = new TradeImg();
	                imgDto.setProductIdx(dto.getProductIdx());
	                imgDto.setImgOrder(currentOrder);
	                imgDto.setOriginalName(mf.getOriginalFilename());
	                imgDto.setSaveName(saveFilename);
	                imgDto.setImgUrl("/uploads/trade/" + saveFilename);

	                mapper.insertTradePostImg(imgDto);
	            }
	        }
            
            mapper.deleteTradePostTag(dto.getProductIdx());

            if (dto.getTags() != null && !dto.getTags().trim().isEmpty()) {
                String[] tagArray = dto.getTags().split(",");
                for (String name : tagArray) {
                    String tagName = name.trim();
                    if (tagName.isEmpty()) continue;

                    Long existingTagIdx = mapper.findTagIdxByName(tagName);
                    long currentTagIdx;

                    if (existingTagIdx == null) {
                        dto.setTagName(tagName); 
                        mapper.insertTradeTag(dto); 
                        currentTagIdx = dto.getTagIdx(); 
                    } else {
                        currentTagIdx = existingTagIdx;
                    }

                    Map<String, Object> tagMap = new HashMap<>();
                    tagMap.put("productIdx", dto.getProductIdx());
                    tagMap.put("tagIdx", currentTagIdx);
                    mapper.insertTradePostTag(tagMap);
                }
            }
			
			mapper.updateTradePost(dto);
			
			try {
                Trade origin = mapper.findByIdx(dto.getProductIdx());
                if(origin != null) {
                    List<Long> wishUsers = mapper.getWishUserList(dto.getProductIdx());
                    if(wishUsers != null) {
                        for(Long uIdx : wishUsers) {
                            if(uIdx != null && uIdx.longValue() != origin.getUserIdx()) {
                                notificationService.sendNotification(uIdx, "게시글 수정", "[" + dto.getTitle() + "] 상품의 정보가 수정되었습니다.", "/trade/article?productIdx=" + dto.getProductIdx());
                            }
                        }
                    }
                }
            } catch(Exception e) {}
				} catch(Exception e) {
					log.info("updateTradePost", e);
					throw e;
			}
	}
	

	@Override
	@Transactional
	public void deleteTradePost(long productIdx, String uploadPath) throws Exception {
		try {
			Trade trade = mapper.findByIdx(productIdx);
			List<Long> wishUsers = mapper.getWishUserList(productIdx);

			List<TradeImg> list = mapper.findImagesByIdx(productIdx);
	        if(list != null) {
	            for(TradeImg img : list) {
	                storageService.deleteFile(uploadPath, img.getSaveName());
	            }
	        }
			
			mapper.deleteTradePostTag(productIdx);
			mapper.deleteTradePostImgAll(productIdx);
			mapper.deleteTradePost(productIdx);

			if(trade != null && wishUsers != null) {
				for(Long uIdx : wishUsers) {
					if(uIdx != null && uIdx.longValue() != trade.getUserIdx()) {
						notificationService.sendNotification(uIdx, "게시글 삭제", "[" + trade.getTitle() + "] 상품이 삭제되었습니다.", "");
					}
				}
			}
		} catch (Exception e) {
			log.info("deleteTradePost : ", e);
			throw e;
		}
	}

	@Override
	public Trade findByIdx(long productIdx) {
		Trade dto = null;
		try {
			dto = mapper.findByIdx(productIdx);
		} catch (Exception e) {
			log.info("findByIdx : ", e);
			throw e;
		}
		return dto;
	}
	
	@Override
	public List<Trade> findByUserIdx(Map<String, Object> map) {
		List<Trade> list = null;
	    try {
	        list = mapper.findByUserIdx(map);
	    } catch (Exception e) {
	        log.info("findByUserIdx : ", e);
	        throw e;
	    }
	    return list;
	}

	@Override
	public List<TradeImg> findImgsByIdx(long productIdx) {
		try {
			return mapper.findImagesByIdx(productIdx);
		} catch (Exception e) {
			log.info("findImgsByIdx", e);
			throw e;
		}
	}

	@Override
	public List<String> findTagsByIdx(long productIdx) {
		try {
			return mapper.findTagsByIdx(productIdx);
		} catch (Exception e) {
			log.info("findTagsByIdx", e);
			throw e;
		}
	}

	@Override
	public List<Trade> tradeList(Map<String, Object> map) {
		List<Trade> list = null;
	    try {
	        list = mapper.tradeList(map);
	    } catch (Exception e) {
	        log.info("tradeList : ", e);
	        throw e;
	    }
	    return list;
	}
	
	@Override
	public List<Map<String, Object>> categoryList() {
		return mapper.CategoryList();
	}

	@Override
	public int dataCount(Map<String, Object> map) {
		int result = 0;
	    try {
	        result = mapper.dataCount(map);
	    } catch (Exception e) {
	        log.info("dataCount error", e);
	        throw e;
	    }
	    return result;
	}

	@Override
	public void updateHitCount(long productIdx) throws Exception {
		try {
			mapper.updateHitCount(productIdx);
		} catch (Exception e) {
			log.info("viewCount : ", e);
		}
		
	}

	@Override
	public void updateTradeStatus(long productIdx, String tradeStatus) throws Exception {
		Map<String, Object> map = new HashMap<>();
		try {
			map.put("tradeStatus", tradeStatus);
			map.put("productIdx", productIdx);
			
			mapper.updateTradeStatus(map);
			try {
				Trade trade = mapper.findByIdx(productIdx);
				if(trade != null) {
					List<Long> wishUsers = mapper.getWishUserList(productIdx);
					if(wishUsers != null) {
						for(Long uIdx : wishUsers) {
							if(uIdx != null && uIdx.longValue() != trade.getUserIdx()) {
								notificationService.sendNotification(uIdx, "상태 변경", "[" + trade.getTitle() + "] 상품의 상태가 [" + tradeStatus + "](으)로 변경되었습니다.", "/trade/article?productIdx=" + productIdx);
							}
						}
					}
				}
			} catch(Exception e) {
				log.info("상태변경 알림 전송 에러 : ", e);
			}
        } catch (Exception e) {
            log.info("updateTradeStatus : ", e);
            throw e;
        }
	}

	@Override
	public void updateLastUpDate(long productIdx) throws SQLException {
		try {
            mapper.updateLastUpDate(productIdx);
            mapper.updatePullCount(productIdx);

			Trade trade = mapper.findByIdx(productIdx);
			if(trade != null) {
				List<Long> wishUsers = mapper.getWishUserList(productIdx);
				if(wishUsers != null) {
					for(Long uIdx : wishUsers) {
						if(uIdx != null && uIdx.longValue() != trade.getUserIdx()) {
							notificationService.sendNotification(uIdx, "끌어올림", "[" + trade.getTitle() + "] 상품이 방금 끌어올려졌습니다.", "/trade/article?productIdx=" + productIdx);
						}
					}
				}
			}
		} catch(Exception e) {
            log.info("updateLastUpDate : ", e);
        }
	}

	@Override
	public void saveTradePost(Trade dto, String uploadPath) throws Exception {
		Trade temp = mapper.findTempTradeByUserIdx(dto.getUserIdx());

	    if ("임시저장".equals(dto.getTradeStatus()) && temp != null) {
	        dto.setProductIdx(temp.getProductIdx());
	    }

	    if (dto.getProductIdx() == 0) {
	        this.insertTradePost(dto, uploadPath);
	    } else {
	        this.updateTradePost(dto, uploadPath);
	    }
		
	}

	@Override
	public Trade findTempTradeByUserIdx(long UserIdx) {
		Trade dto = null;
		try {
			dto = mapper.findTempTradeByUserIdx(UserIdx);
		} catch (Exception e) {
			log.info("findTempTradeByUserIdx : ", e);
		}
		return dto;
	}

	@Override
	public String findLastUpDateByIdx(long productIdx) {
		String lastUpDate = null;
		try {
			lastUpDate = mapper.findLastUpDateByProductIdx(productIdx);
		} catch (Exception e) {
			log.info("findLastUpDateByIdx : ", e);
		}
		return lastUpDate;
	}

	@Override
	public List<Trade> findBuyList(long userIdx) {
		List<Trade> list = null;
		try {
			list = mapper.findBuyListByUserIdx(userIdx);
			
			for (Trade trade : list) {
	            trade.setImageList(mapper.findImagesByIdx(trade.getProductIdx()));
	        }
			
		} catch (Exception e) {
			log.info("tradeBuyList : ", e);
		}
		
		return list;
	}

	@Override
	public Map<String, Object> findLatLngByRegionCode(String regionCode) {
		try {
	        return mapper.findLatLngByRegionCode(regionCode);
	    } catch (Exception e) {
	        log.info("findLatLngByRegionCode : ", e);
	        return null;
	    }
	}

}