package com.sp.app.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.sp.app.common.StorageService;
import com.sp.app.domain.entity.Product;
import com.sp.app.domain.entity.WishList;
import com.sp.app.domain.entity.WishListId;
import com.sp.app.mapper.TradeMapper;
import com.sp.app.model.Trade;
import com.sp.app.model.TradeImg;
import com.sp.app.repository.ProductRepository;
import com.sp.app.repository.WishListRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class TradeServiceImpl implements TradeService {
	private final TradeMapper mapper;
	private final StorageService storageService;
	private final WishListRepository wishListRepository;
    private final ProductRepository productRepository;

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
		} catch (Exception e) {
			log.info("updateTradePost", e);
			throw e;
		}
		
	}

	@Override
	@Transactional
	public void deleteTradePost(long productIdx, String uploadPath) throws Exception {
		try {
			
			List<TradeImg> list = mapper.findImagesByIdx(productIdx);
	        if(list != null) {
	            for(TradeImg img : list) {
	                // 저장된 실제 파일 삭제
	                storageService.deleteFile(uploadPath, img.getSaveName());
	            }
	        }
			
			mapper.deleteTradePostTag(productIdx);
			mapper.deleteTradePostImgAll(productIdx);
			mapper.deleteTradePost(productIdx);
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
	@Transactional
	public Map<String, Object> toggleWishList(long productIdx, long userIdx) throws Exception {
		Map<String, Object> result = new HashMap<>();
        
        WishListId id = new WishListId(productIdx, userIdx);
        
        Product product = productRepository.findById(productIdx)
                .orElseThrow(() -> new RuntimeException("상품을 찾을 수 없습니다."));

        Optional<WishList> wishOpt = wishListRepository.findById(id);

        if (wishOpt.isPresent()) {
        	wishListRepository.delete(wishOpt.get());
            product.updateLikeCount(-1);
            result.put("isLiked", false);
        } else {
        	WishList newWish = WishList.builder()
                    .productIdx(productIdx)
                    .userIdx(userIdx)
                    .build();
        	wishListRepository.save(newWish);
            product.updateLikeCount(1);
            result.put("isLiked", true);
        }

        result.put("likeCount", product.getLikeCount());
        return result;
	}

	@Override
	public boolean isUserLiked(long productIdx, long userIdx) {
		WishListId id = new WishListId(productIdx, userIdx);
	    return wishListRepository.existsById(id);
	}

	@Override
	public void updateTradeStatus(long productIdx, String tradeStatus) throws Exception {
		Map<String, Object> map = new HashMap<>();
		
		try {
			map.put("tradeStatus", tradeStatus);
			map.put("productIdx", productIdx);
			
			mapper.updateTradeStatus(map);
		} catch (Exception e) {
			log.info("updateTradeStatus : ", e);
		}
	}

	@Override
	public void updateLastUpDate(long productIdx) throws SQLException {
		try {
			mapper.updateLastUpDate(productIdx);
			mapper.updatePullCount(productIdx);
		} catch (Exception e) {
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
	
}