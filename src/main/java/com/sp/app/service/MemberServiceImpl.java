package com.sp.app.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sp.app.common.MyUtil;
import com.sp.app.common.StorageService;
import com.sp.app.domain.dto.BadgeDto;
import com.sp.app.domain.dto.MemberDto;
import com.sp.app.domain.dto.RegionDto;
import com.sp.app.domain.dto.SnsUserDto;
import com.sp.app.domain.dto.UserDto;
import com.sp.app.domain.dto.UserRegionInfo;
import com.sp.app.mapper.MemberMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class MemberServiceImpl implements MemberService {

	private final MemberMapper mapper;
	private final StorageService storageService;
	private final PasswordEncoder bcryptEncoder;

	@Override
	public SnsUserDto loginSnsUser(Map<String, Object> map) {
		SnsUserDto dto = null;
		try {
			dto = mapper.loginSnsUser(map);
		} catch (Exception e) {
			log.info("loginSnsUser : ", e);
		}
		return dto;
	}

	@Override
	public UserDto loginUser(Map<String, Object> map) {
		UserDto dto = null;
		try {
			String pwd = (String)map.get("pwd");
			dto = mapper.loginUser(map);
			if(!bcryptEncoder.matches(pwd, dto.getPwd())) {
				return dto;
			}
		} catch (Exception e) {
			log.info("loginUser : ", e);
		}
		return dto;
	}

	@Override
	public void insertUser(UserDto dto, String uploadPath) throws Exception {
	    this.insertUser(dto, null, uploadPath);
	}

	@Transactional(rollbackFor = Exception.class)
	@Override
	public void insertUser(UserDto userDto, SnsUserDto snsUserDto, String uploadPath) throws Exception {
		try {
			if (userDto.getSelectFile() != null && !userDto.getSelectFile().isEmpty()) {
	            String saveFilename = storageService.uploadFileToServer(userDto.getSelectFile(), uploadPath);
	            userDto.setProfile_photo(saveFilename);
	        }		
			
			String rawPwd = userDto.getPwd();
			if(rawPwd == null || rawPwd.isEmpty()) {
				rawPwd = MyUtil.generateUUID();
			}
			
			String encPassword = bcryptEncoder.encode(rawPwd);
			userDto.setPwd(encPassword);
						
			Long seq = mapper.userSeq();
			userDto.setUserIdx(seq);
			
			mapper.insertUser(userDto);
			
			userDto.setAuthority("USER");
			mapper.insertAuthority(userDto);
			
			if(snsUserDto != null) {
				snsUserDto.setUserIdx(seq);
				mapper.insertSnsUser(snsUserDto);
			}
			
		} catch (Exception e) {
			log.info("insertUser : ", e);
			throw e;
		}
	}
	
	@Transactional(rollbackFor = Exception.class)
	@Override
	public void updateUser(UserDto dto, String uploadPath) throws Exception {
		try {
			UserDto before = mapper.findById(dto.getUserIdx());
			if (dto.getSelectFile() != null && !dto.getSelectFile().isEmpty()) {
				String saveFilename = storageService.uploadFileToServer(dto.getSelectFile(), uploadPath);
				dto.setProfile_photo(saveFilename);
				if (before.getProfile_photo() != null) {
		            storageService.deleteFile(uploadPath, before.getProfile_photo());
		        }
			} else if ("true".equals(dto.getDeletedPhoto())) {
		        dto.setProfile_photo(null);
		        if (before.getProfile_photo() != null) {
		            storageService.deleteFile(uploadPath, before.getProfile_photo());
		        }
		    } else {
		        dto.setProfile_photo(before.getProfile_photo());
		    }
			mapper.updateUser(dto);
		} catch (Exception e) {
			log.info("updateMember : ", e);
			throw e;
		} 
	}
	

	@Override
	public void insertSnsUser(SnsUserDto snsUserDto) {
		try {
			mapper.insertSnsUser(snsUserDto);
		} catch (Exception e) {
			log.info("insertSnsUser : ", e);
		}
	}

	@Override
	public void insertMemberStatus(MemberDto dto) throws Exception {
		try {
			mapper.insertMemberStatus(dto);
		} catch (Exception e) {
			log.info("insertMemberStatus : ", e);
		}
	}

	@Override
	public void updatePassword(MemberDto dto) throws Exception {
		mapper.updateMemberPassword(dto);
	}

	@Override
	public void updateUserEnabled(Map<String, Object> map) throws Exception {
		try {
			mapper.updateUserEnabled(map);
		} catch (Exception e) {
			log.info("updateUserEnabled : ", e);
			throw e;
		}
	}

	@Transactional(rollbackFor = Exception.class)
	@Override
	public void updateMember(MemberDto dto, String uploadPath) throws Exception {
		try {
			UserDto before = mapper.findById(dto.getUserIdx());
			
			if (dto.getSelectFile() != null && !dto.getSelectFile().isEmpty()) {
				String saveFilename = storageService.uploadFileToServer(dto.getSelectFile(), uploadPath);
				if (saveFilename != null) {
					dto.setProfile_photo(saveFilename);
					mapper.updateMember2(dto);
					
					if (before != null && before.getProfile_photo() != null && !before.getProfile_photo().isBlank()) {
						storageService.deleteFile(uploadPath, before.getProfile_photo());
					}
				}
			}
			
			mapper.updateMember1(dto);
		} catch (Exception e) {
			log.info("updateMember : ", e);
			throw e;
		}
	}

	@Override
	public void updateLastLogin(Long member_id) throws Exception {
		mapper.updateLastLogin(member_id);
	}

	@Override
	public void updateLastLogin(String login_id) throws Exception {
		mapper.updateLastLoginId(login_id);
	}

	@Override
	public UserDto findById(Long member_id) {
		UserDto dto = null;
		try {
			dto = mapper.findById(member_id);
		} catch (Exception e) {
			log.info("findById : ", e);
		}
		return dto;
	}

	@Override
	public UserDto findByLoginId(String login_id) {
		UserDto dto = null;
		try {
			dto = mapper.findByLoginId(login_id);
		} catch (Exception e) {
			log.info("findByLoginId : ", e);
		}
		return dto;
	}

	@Override
	public UserDto findByEmail(String email) {
		UserDto dto = null;
		try {
			dto = mapper.findByEmail(email);
		} catch (Exception e) {
			log.info("findByEmail : ", e);
		}
		return dto;
	}

	@Override
	public Long getMemberId(String login_id) {
		return null;
	}

	@Override
	public int checkFailureCount(String login_id) {
		int result = 0;
		try {
			result = mapper.checkFailureCount(login_id);
		} catch (Exception e) {
			log.info("checkFailureCount : ", e);
		}
		return result;
	}

	@Override
	public void updateFailureCountReset(String login_id) throws Exception {
		try {
			mapper.updateFailureCountReset(login_id);
		} catch (Exception e) {
			log.info("updateFailureCountReset : ", e);
			throw e;
		}
	}

	@Override
	public void updateFailureCount(String login_id) throws Exception {
		try {
			mapper.updateFailureCount(login_id);
		} catch (Exception e) {
			log.info("updateFailureCount : ", e);
			throw e;
		}
	}

	@Override
	public void deleteMember(Map<String, Object> map, String uploadPath) throws Exception {
		mapper.deleteMember1(map);
	}

	@Override
	public void deleteProfilePhoto(Map<String, Object> map, String uploadPath) throws Exception {
		try {
			Object userIdxObj = map.get("userIdx");
			Long userIdx = userIdxObj instanceof Long ? (Long) userIdxObj : Long.valueOf(String.valueOf(userIdxObj));
			
			UserDto before = mapper.findById(userIdx);
			
			mapper.deleteProfilePhoto(map);
			
			if (before != null && before.getProfile_photo() != null && !before.getProfile_photo().isBlank()) {
				storageService.deleteFile(uploadPath, before.getProfile_photo());
			}
		} catch (Exception e) {
			log.info("deleteProfilePhoto : ", e);
			throw e;
		}
	}

	@Override
	public void generatePwd(MemberDto dto) throws Exception {
	}

	@Override
	public List<MemberDto> listFindMember(Map<String, Object> map) {
		return null;
	}

	@Override
	public String findByAuthority(String login_id) {
		String authority = null;
		try {
			authority = mapper.findByAuthority(login_id);
		} catch (Exception e) {
			log.info("findByAuthority : ", e);
		}
		return authority;
	}

	@Override
	public void insertRefreshToken(MemberDto dto) throws Exception {
		mapper.insertRefreshToken(dto);
	}

	@Override
	public void updateRefreshToken(MemberDto dto) throws Exception {
		mapper.updateRefreshToken(dto);
	}

	@Override
	public MemberDto findByToken(String login_id) {
		return null;
	}

	@Override
	public boolean isPasswordCheck(String login_id, String password) {
		return false;
	}

	@Override
	public boolean isUserIdDuplicated(String userId) {
		return mapper.isUserIdDuplicated(userId) > 0;
	}

	@Override
	public boolean isNicknameDuplicated(String nickname) {
		return mapper.isNicknameDuplicated(nickname) > 0;
	}

	@Override
	public boolean isEmailDuplicated(String email) {
		return mapper.isEmailDuplicated(email) > 0;
	}

	@Override
	public String findUserId(Map<String, Object> map) {
		String userId = null;
		try {
			userId = mapper.findUserId(map);
		} catch (Exception e) {
			log.info("findUserId : ", e);
		}
		return userId;
	}

	@Override
	public long findByUserIdAndEmail(Map<String, Object> map) {
		Long userIdx = null;
		try {
			userIdx = mapper.findByUserIdAndEmail(map);
		} catch (Exception e) {
			log.info("findByUserIdAndEmail : ", e);
		}
		return (userIdx == null) ? 0L : userIdx;
	}

	@Override
	public void updateUserPwd(Map<String, Object> map) throws SQLException {
		try {
			String newPwd = bcryptEncoder.encode((String) map.get("pwd"));
			map.put("newPwd", newPwd);
			mapper.updateUserPwd(map);
		} catch (Exception e) {
			log.info("updateUserPwd : ", e);
			throw e;
		}
	}

	@Override
	public RegionDto findRegionByCode(String regionCode) {
		RegionDto regionDto = null;
		try {
			regionDto = mapper.findRegionbyCode(regionCode);
		} catch (Exception e) {
			log.info("findRegionByCode : ", e);
		}
		return regionDto;
	}

	@Override
	public RegionDto findUserRegionbyType(Map<String, Object> map) {
		RegionDto regionDto = null;
		try {
			regionDto = mapper.findUserRegionbyType(map);
		} catch (Exception e) {
			log.info("findUserRegionbyType : ", e);
		}
		return regionDto;
	}

	@Override
	public void saveUserRegion(RegionDto dto) throws SQLException {
		try {
			if (!Objects.isNull(dto.getRegionCode()) && !dto.getRegionCode().isEmpty()) {
				mapper.saveUserRegion(dto);
			}
		} catch (Exception e) {
			log.info("saveUserRegion : ", e);
		}
	}

	@Override
	public void deleteRegion(Map<String, Object> map) throws SQLException {
		try {
		} catch (Exception e) {
			log.info("deleteRegion : ", e);
		}
	}

	@Override
	public void updateActiveStatus(Map<String, Object> map) throws SQLException {
		try {
			mapper.updateActiveStatus(map);
		} catch (Exception e) {
			log.info("updateActiveStatus : ", e);
		}
	}

	@Override
	public UserRegionInfo getUserRegionInfo(Long userIdx) {
		UserRegionInfo userRegionInfo = new UserRegionInfo();
		Map<String, Object> map = new HashMap<>();
		map.put("userIdx", userIdx);
		try {
			map.put("regionType", 1);
			RegionDto main = mapper.findUserRegionbyType(map);
			userRegionInfo.setMainRegion(main);

			map.put("regionType", 2);
			RegionDto sub = mapper.findUserRegionbyType(map);
			userRegionInfo.setSubRegion(sub);

			if (sub != null && sub.getIsActive() == 1) {
	            userRegionInfo.setActiveType(2);
	        } else if (main != null && main.getIsActive() == 1) {
	            userRegionInfo.setActiveType(1);
	        } else {
	            userRegionInfo.setActiveType(1); 
	        }
			
		} catch (Exception e) {
			log.info("getUserRegionInfo", e);
		}
		return userRegionInfo;
	}

	@Override
	public boolean hasPendingWithdraw(Long userIdx) {
		try {
			return mapper.hasPendingWithdraw(userIdx) > 0;
		} catch (Exception e) {
			log.info("hasPendingWithdraw : ", e);
			return false;
		}
	}

	@Override
	public int countActiveTrades(Long userIdx) {
		try {
			return mapper.countActiveTrades(userIdx);
		} catch (Exception e) {
			log.info("countActiveTrades : ", e);
			return 0;
		}
	}

	@Override
	public int countPendingReports(Long userIdx) {
		try {
			return mapper.countPendingReports(userIdx);
		} catch (Exception e) {
			log.info("countPendingReports : ", e);
			return 0;
		}
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public void requestWithdraw(Map<String, Object> map) throws Exception {
		mapper.insertWithdrawRequest(map);
		Map<String, Object> statusMap = new HashMap<>();
		statusMap.put("userIdx", map.get("userIdx"));
		statusMap.put("status",  8);
		mapper.updateUserEnabled(statusMap);
	}
	
	@Override
	public void updateBatonDistance(Long userIdx, double distance) throws Exception {
		try {
			Map<String, Object> map = new HashMap<>();
			map.put("userIdx", userIdx);
			map.put("distance", distance);
			mapper.updateBatonDistance(map);
		} catch (Exception e) {
			log.info("updateBatonDistance : ", e);
			throw e;
		}
	}

	@Override
	public void checkAndAwardBadge(Long userIdx, String actionType) throws Exception {
		try {
			int badgeId = 0;
			boolean conditionMet = false;
			
			if ("TRADE".equals(actionType)) {
				Map<String, Object> map = new HashMap<>();
				map.put("userIdx", userIdx);
				map.put("badgeId", 1);
				if (mapper.checkUserBadge(map) == 0) {
					if (mapper.countTradeCompleted(userIdx) >= 1) {
						badgeId = 1; conditionMet = true;
					}
				}
			} else if ("REVIEW".equals(actionType)) {
				Map<String, Object> map = new HashMap<>();
				map.put("userIdx", userIdx);
				map.put("badgeId", 2);
				if (mapper.checkUserBadge(map) == 0) {
					if (mapper.countReviewBest(userIdx) >= 5) {
						badgeId = 2; conditionMet = true;
					}
				}
			} else if ("COMMUNITY_POST".equals(actionType)) {
				Map<String, Object> map = new HashMap<>();
				map.put("userIdx", userIdx);
				map.put("badgeId", 3);
				if (mapper.checkUserBadge(map) == 0) {
					if (mapper.countCommunityPost(userIdx) >= 10) {
						badgeId = 3; conditionMet = true;
					}
				}
			} else if ("COMMUNITY_REPLY".equals(actionType)) {
				Map<String, Object> map = new HashMap<>();
				map.put("userIdx", userIdx);
				map.put("badgeId", 4);
				if (mapper.checkUserBadge(map) == 0) {
					if (mapper.countCommunityReply(userIdx) >= 30) {
						badgeId = 4; conditionMet = true;
					}
				}
			} else if ("POLL".equals(actionType)) {
				Map<String, Object> map = new HashMap<>();
				map.put("userIdx", userIdx);
				map.put("badgeId", 5);
				if (mapper.checkUserBadge(map) == 0) {
					if (mapper.countCommunityPoll(userIdx) >= 5) {
						badgeId = 5; conditionMet = true;
					}
				}
			} else if ("CHARGE".equals(actionType)) {
				Map<String, Object> map = new HashMap<>();
				map.put("userIdx", userIdx);
				map.put("badgeId", 6);
				if (mapper.checkUserBadge(map) == 0) {
					if (mapper.countPointCharge(userIdx) >= 1) {
						badgeId = 6; conditionMet = true;
					}
				}
			} else if ("ALBA_SCRAP".equals(actionType)) {
				Map<String, Object> map = new HashMap<>();
				map.put("userIdx", userIdx);
				map.put("badgeId", 7);
				if (mapper.checkUserBadge(map) == 0) {
					if (mapper.countAlbaScrap(userIdx) >= 5) {
						badgeId = 7; conditionMet = true;
					}
				}
			}
			
			if (conditionMet && badgeId > 0) {
				Map<String, Object> map = new HashMap<>();
				map.put("userIdx", userIdx);
				map.put("badgeId", badgeId);
				mapper.insertUserBadge(map);
			}
			
		} catch (Exception e) {
			log.info("checkAndAwardBadge : ", e);
			throw e;
		}
	}
	
	@Override
	public List<BadgeDto> getUserBadgeProgress(Long userIdx) throws Exception {
		try {
			List<BadgeDto> allBadges = mapper.getAllBadges();
			List<Integer> acquiredIds = mapper.getAcquiredBadgeIds(userIdx);

			int tradeCount = mapper.countTradeCompleted(userIdx);
			int reviewCount = mapper.countReviewBest(userIdx);
			int postCount = mapper.countCommunityPost(userIdx);
			int replyCount = mapper.countCommunityReply(userIdx);
			int pollCount = mapper.countCommunityPoll(userIdx);
			int chargeCount = mapper.countPointCharge(userIdx);
			int scrapCount = mapper.countAlbaScrap(userIdx);

			for (com.sp.app.domain.dto.BadgeDto badge : allBadges) {
				badge.setAcquired(acquiredIds.contains(badge.getBadgeId()));
				
				switch (badge.getBadgeId()) {
					case 1: badge.setCurrentCount(tradeCount); badge.setTargetCount(1); badge.setIconImage("ri-hand-coin-fill"); break;
					case 2: badge.setCurrentCount(reviewCount); badge.setTargetCount(5); badge.setIconImage("ri-star-smile-fill"); break;
					case 3: badge.setCurrentCount(postCount); badge.setTargetCount(10); badge.setIconImage("ri-megaphone-fill"); break;
					case 4: badge.setCurrentCount(replyCount); badge.setTargetCount(30); badge.setIconImage("ri-thumb-up-fill"); break;
					case 5: badge.setCurrentCount(pollCount); badge.setTargetCount(5); badge.setIconImage("ri-ball-pen-fill"); break;
					case 6: badge.setCurrentCount(chargeCount); badge.setTargetCount(1); badge.setIconImage("ri-money-dollar-circle-fill"); break;
					case 7: badge.setCurrentCount(scrapCount); badge.setTargetCount(5); badge.setIconImage("ri-briefcase-4-fill"); break;
					case 8: badge.setCurrentCount(tradeCount); badge.setTargetCount(10); badge.setIconImage("ri-store-2-fill"); break; 
                    case 9: badge.setCurrentCount(reviewCount); badge.setTargetCount(15); badge.setIconImage("ri-award-fill"); break; 
                    case 10: badge.setCurrentCount(postCount); badge.setTargetCount(50); badge.setIconImage("ri-fire-fill"); break; 
                    case 11: badge.setCurrentCount(replyCount); badge.setTargetCount(100); badge.setIconImage("ri-chat-smile-3-fill"); break; 
                    case 12: badge.setCurrentCount(pollCount); badge.setTargetCount(20); badge.setIconImage("ri-pie-chart-2-fill"); break;
				}
				
				if (userIdx == 1) {
			        badge.setCurrentCount(badge.getTargetCount()); 
			        badge.setProgressPercent(100);               
			        badge.setAcquired(true);                      
			    } else {		        	
			        if (badge.getCurrentCount() >= badge.getTargetCount()) {
			            badge.setCurrentCount(badge.getTargetCount()); 
			            badge.setProgressPercent(100); 

			            if (!badge.isAcquired()) { 
			                Map<String, Object> param = new HashMap<>();
			                param.put("userIdx", userIdx);
			                param.put("badgeId", badge.getBadgeId());
			                try { 
			                    mapper.insertUserBadge(param); 
			                    badge.setAcquired(true); 
			                } catch(Exception ignored) {}
			            }
			        } else {	                    
			            badge.setProgressPercent((int) ((double) badge.getCurrentCount() / badge.getTargetCount() * 100));
			        } 
			    }
			}

			allBadges.sort((b1, b2) -> {
				if (b1.isAcquired() && !b2.isAcquired()) return -1;
				if (!b1.isAcquired() && b2.isAcquired()) return 1;
				return Integer.compare(b2.getProgressPercent(), b1.getProgressPercent());
			});

			return allBadges;
		} catch (Exception e) {
			log.info("getUserBadgeProgress : ", e);
			throw e;
		}
	}
}