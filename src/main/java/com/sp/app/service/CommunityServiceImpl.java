package com.sp.app.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.sp.app.common.StorageService;
import com.sp.app.domain.dto.CommunityDto;
import com.sp.app.domain.dto.RegionDto;
import com.sp.app.domain.entity.Community;
import com.sp.app.domain.entity.CommunityHashTag;
import com.sp.app.domain.entity.CommunityImage;
import com.sp.app.domain.entity.CommunityLike;
import com.sp.app.domain.entity.CommunityPoll;
import com.sp.app.domain.entity.CommunityScrap;
import com.sp.app.domain.entity.PollOption;
import com.sp.app.domain.entity.PollVote;
import com.sp.app.repository.CommunityPollRepository;
import com.sp.app.repository.CommunityReplyRepository;
import com.sp.app.repository.CommunityRepository;
import com.sp.app.repository.PollOptionRepository;
import com.sp.app.repository.PollVoteRepository;
import com.sp.app.repository.UserRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class CommunityServiceImpl implements CommunityService {

	private final CommunityRepository communityRepository;
	private final CommunityReplyRepository communityReplyRepository;
	private final CommunityPollRepository communityPollRepository;
	private final PollOptionRepository pollOptionRepository;
	private final PollVoteRepository pollVoteRepository;
	private final StorageService storageService;
	private final MemberService memberService;
	private final UserRepository userRepository;
	private final NotificationService notificationService;

	@Override
	@Transactional(rollbackFor = Exception.class)
	public void insertCommunity(CommunityDto dto, String uploadPath) throws Exception {
		try {
			Community community = Community.builder()
					.memberIdx(dto.getMemberIdx())
					.writerNickname(dto.getWriterNickname())
					.subject(dto.getSubject())
					.content(dto.getContent())
					.category(dto.getCategory())
					.placeName(dto.getPlaceName())
					.address(dto.getAddress())
					.latitude(dto.getLatitude())
					.longitude(dto.getLongitude())
					.regionCode(dto.getRegionCode())
					.hitCount(0)
					.likeCount(0)
					.temporary(dto.isTemporary()) 
					.regDate(java.time.LocalDateTime.now())
					.build();

			if (dto.getTags() != null) {
				for (String tagName : dto.getTags()) {
					community.addHashTag(CommunityHashTag.builder().tagName(tagName).build());
				}
			}

			List<MultipartFile> files = dto.getUploadFiles();
			String content = community.getContent();
			
			if (files != null && !files.isEmpty()) {
				for (MultipartFile mf : files) {
					if(mf.isEmpty()) continue;
					
					String tempId = mf.getOriginalFilename();
					String saveFilename = storageService.uploadFileToServer(mf, uploadPath);
					
					String webPath = "/uploads/community/" + saveFilename;
					
					content = content.replace("src=\"" + tempId + "\"", "src=\"" + webPath + "\"");

					community.addImage(CommunityImage.builder()
							.originalFilename(mf.getOriginalFilename())
							.saveFilename(saveFilename)
							.build());
				}
				
				community.setContent(content);
			}

			Community savedCommunity = communityRepository.save(community);

			try {
				List<MultipartFile> attachFiles = dto.getAttachFiles();
				if (attachFiles != null && !attachFiles.isEmpty()) {
					for (MultipartFile af : attachFiles) {
						if (af == null || af.isEmpty()) continue;
						String saveFilename = storageService.uploadFileToServer(af, uploadPath);
						community.addAttachFile(com.sp.app.domain.entity.CommunityAttachFile.builder()
								.originalFilename(af.getOriginalFilename())
								.saveFilename(saveFilename)
								.fileSize(af.getSize())
								.build());
					}
				}
			} catch (Exception attachEx) {
				log.warn("첨부파일 저장 중 오류 (테이블 미생성 가능성): {}", attachEx.getMessage());
			}

			if (dto.getPollTitle() != null && !dto.getPollTitle().isEmpty() && dto.getPollOptions() != null) {
				LocalDateTime endDate = null;
				if (dto.getPollEndDate() != null && !dto.getPollEndDate().isEmpty()) {
					endDate = LocalDateTime.of(LocalDate.parse(dto.getPollEndDate(), DateTimeFormatter.ISO_DATE), LocalTime.MAX);
				}

				CommunityPoll poll = CommunityPoll.builder()
						.community(savedCommunity)
						.title(dto.getPollTitle())
						.multipleChoice(dto.getPollMultiple() != null && dto.getPollMultiple())
						.endDate(endDate)
						.build();

				CommunityPoll savedPoll = communityPollRepository.save(poll);

				List<PollOption> options = new ArrayList<>();
				for (String optionContent : dto.getPollOptions()) {
					if (!optionContent.trim().isEmpty()) {
						options.add(PollOption.builder()
								.poll(savedPoll)
								.content(optionContent)
								.build());
					}
				}
				pollOptionRepository.saveAll(options);
			}

		} catch (Exception e) {
			log.error("insertCommunity error", e);
			throw e;
		}
	}

	@Override
	@Transactional(readOnly = true)
	public Page<CommunityDto> getCommunityList(Pageable pageable, String schType, String kwd) {
	    Page<Community> entities;
	    if (kwd == null || kwd.isBlank()) {
	        entities = communityRepository.findByTemporaryFalseAndIsHiddenFalse(pageable);
	    } else {
	        if ("subject".equals(schType)) {
	            entities = communityRepository.findByTemporaryFalseAndIsHiddenFalseAndSubjectContaining(kwd, pageable);
	        } else if ("content".equals(schType)) {
	            entities = communityRepository.findByTemporaryFalseAndIsHiddenFalseAndContentContaining(kwd, pageable);
	        } else if ("tag".equals(schType)) {
	            entities = communityRepository.findByTemporaryFalseAndIsHiddenFalseAndHashTags_TagNameContaining(kwd, pageable);
	        } else {
	            entities = communityRepository.findByTemporaryFalseAndIsHiddenFalseAndSubjectOrContent(kwd, pageable);
	        }
	    }
	    return entities.map(this::toDto);
	}

	@Override
	@Transactional(readOnly = true)
	public Page<CommunityDto> getCommunityListByRegion(Pageable pageable, String regionCode, String category, String schType, String kwd) {
	    Page<Community> entities;
	    boolean hasKwd = kwd != null && !kwd.isBlank();
	    boolean hasCat = category != null && !category.isBlank();

	    if (hasCat) {
	        if (hasKwd) {
	            if ("subject".equals(schType)) {
	                entities = communityRepository.findByTemporaryFalseAndIsHiddenFalseAndRegionCodeAndCategoryAndSubjectContaining(regionCode, category, kwd, pageable);
	            } else if ("content".equals(schType)) {
	                entities = communityRepository.findByTemporaryFalseAndIsHiddenFalseAndRegionCodeAndCategoryAndContentContaining(regionCode, category, kwd, pageable);
	            } else if ("tag".equals(schType)) {
	                entities = communityRepository.findByTemporaryFalseAndIsHiddenFalseAndRegionCodeAndCategoryAndHashTags_TagNameContaining(regionCode, category, kwd, pageable);
	            } else {
	                entities = communityRepository.findByTemporaryFalseAndIsHiddenFalseAndRegionCodeAndCategoryAndSubjectContaining(regionCode, category, kwd, pageable);
	            }
	        } else {
	            entities = communityRepository.findByTemporaryFalseAndIsHiddenFalseAndRegionCodeAndCategory(regionCode, category, pageable);
	        }
	    } else {
	        if (hasKwd) {
	            if ("subject".equals(schType)) {
	                entities = communityRepository.findByTemporaryFalseAndIsHiddenFalseAndRegionCodeAndSubjectContaining(regionCode, kwd, pageable);
	            } else if ("content".equals(schType)) {
	                entities = communityRepository.findByTemporaryFalseAndIsHiddenFalseAndRegionCodeAndContentContaining(regionCode, kwd, pageable);
	            } else if ("tag".equals(schType)) {
	                entities = communityRepository.findByTemporaryFalseAndIsHiddenFalseAndRegionCodeAndHashTags_TagNameContaining(regionCode, kwd, pageable);
	            } else {
	                entities = communityRepository.findByTemporaryFalseAndIsHiddenFalseAndRegionCodeAndSubjectOrContent(regionCode, kwd, pageable);
	            }
	        } else {
	            entities = communityRepository.findByTemporaryFalseAndIsHiddenFalseAndRegionCode(regionCode, pageable);
	        }
	    }
	    return entities.map(this::toDto);
	}

	@Override
	@Transactional(readOnly = true)
	public Page<CommunityDto> getCommunityListByCategory(Pageable pageable, String category, String schType, String kwd) {
	    Page<Community> entities;
	    if (kwd == null || kwd.isBlank()) {
	        entities = communityRepository.findByTemporaryFalseAndIsHiddenFalseAndCategory(category, pageable);
	    } else if ("subject".equals(schType)) {
	        entities = communityRepository.findByTemporaryFalseAndIsHiddenFalseAndCategoryAndSubjectContaining(category, kwd, pageable);
	    } else if ("content".equals(schType)) {
	        entities = communityRepository.findByTemporaryFalseAndIsHiddenFalseAndCategoryAndContentContaining(category, kwd, pageable);
	    } else if ("tag".equals(schType)) {
	        entities = communityRepository.findByTemporaryFalseAndIsHiddenFalseAndCategoryAndHashTags_TagNameContaining(category, kwd, pageable);
	    } else {
	        entities = communityRepository.findByTemporaryFalseAndIsHiddenFalseAndCategoryAndSubjectContaining(category, kwd, pageable);
	    }
	    return entities.map(this::toDto);
	}

	@Override
	@Transactional(readOnly = true)
	public CommunityDto getCommunity(long id) {
		Community entity = communityRepository.findById(id).orElseThrow();
		return toDto(entity);
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public void updateHitCount(long id) throws Exception {
		Community community = communityRepository.findById(id).orElse(null);
		if(community != null) {
			community.setHitCount(community.getHitCount() + 1);
		}
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public void updateCommunity(CommunityDto dto, String uploadPath) throws Exception {
		try {
			Community community = communityRepository.findById(dto.getId()).orElseThrow();
			
			String content = dto.getContent();
			List<MultipartFile> files = dto.getUploadFiles();
			
			if (files != null && !files.isEmpty()) {
				for (MultipartFile mf : files) {
					if(mf.isEmpty()) continue;
					String tempId = mf.getOriginalFilename();
					String saveFilename = storageService.uploadFileToServer(mf, uploadPath);
					String webPath = "/uploads/community/" + saveFilename;
					
					content = content.replace("src=\"" + tempId + "\"", "src=\"" + webPath + "\"");
					
					community.addImage(CommunityImage.builder()
							.originalFilename(mf.getOriginalFilename())
							.saveFilename(saveFilename)
							.build());
				}
			}
			
			community.setSubject(dto.getSubject());
			community.setContent(content);
			community.setCategory(dto.getCategory());
			community.setTemporary(false);
			if (community.getRegDate() == null) community.setRegDate(java.time.LocalDateTime.now());
			community.setPlaceName(dto.getPlaceName());
			community.setAddress(dto.getAddress());
			community.setLatitude(dto.getLatitude());
			community.setLongitude(dto.getLongitude());

			community.getHashTags().clear();
			if (dto.getTags() != null) {
				for (String tagName : dto.getTags()) {
					if (tagName != null && !tagName.trim().isEmpty()) {
						community.addHashTag(CommunityHashTag.builder().tagName(tagName.trim()).build());
					}
				}
			}

			try {
				List<String> removedFiles = dto.getRemoveFiles();
				if (removedFiles != null && !removedFiles.isEmpty()) {
					community.getAttachFiles().removeIf(af -> {
						if (removedFiles.contains(af.getSaveFilename())) {
							storageService.deleteFile(uploadPath, af.getSaveFilename());
							return true;
						}
						return false;
					});
				}

				List<MultipartFile> attachFiles = dto.getAttachFiles();
				if (attachFiles != null && !attachFiles.isEmpty()) {
					for (MultipartFile af : attachFiles) {
						if (af == null || af.isEmpty()) continue;
						String saveFilename = storageService.uploadFileToServer(af, uploadPath);
						community.addAttachFile(com.sp.app.domain.entity.CommunityAttachFile.builder()
								.originalFilename(af.getOriginalFilename())
								.saveFilename(saveFilename)
								.fileSize(af.getSize())
								.build());
					}
				}
			} catch (Exception attachEx) {
				log.warn("첨부파일 처리 중 오류 (테이블 미생성 가능성): {}", attachEx.getMessage());
			}
			
			try {
				if (community.getLikes() != null) {
					for (CommunityLike like : community.getLikes()) {
						if (!like.getMemberIdx().equals(community.getMemberIdx())) { 
							notificationService.sendNotification(
								like.getMemberIdx(), 
								"게시글 수정", 
								"[" + dto.getSubject() + "] 게시글이 수정되었습니다.", 
								"/community/article?id=" + dto.getId()
							);
						}
					}
				}
			} catch(Exception e) { 
				log.info("커뮤니티 수정 알림 전송 실패: ", e); 
			}
		
		} catch (Exception e) {
			log.error("updateCommunity error", e);
			throw e;
		}
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public void updateTempCommunity(CommunityDto dto, String uploadPath) throws Exception {
		try {
			Community community = communityRepository.findById(dto.getId()).orElseThrow();
			if (!community.getMemberIdx().equals(dto.getMemberIdx()) || !community.isTemporary()) {
				throw new RuntimeException("수정 권한이 없습니다.");
			}

			String content = dto.getContent();
			List<MultipartFile> files = dto.getUploadFiles();

			if (files != null && !files.isEmpty()) {
				for (MultipartFile mf : files) {
					if (mf.isEmpty()) continue;
					String tempId = mf.getOriginalFilename();
					String saveFilename = storageService.uploadFileToServer(mf, uploadPath);
					String webPath = "/uploads/community/" + saveFilename;
					content = content.replace("src=\"" + tempId + "\"", "src=\"" + webPath + "\"");
					community.addImage(CommunityImage.builder()
							.originalFilename(mf.getOriginalFilename())
							.saveFilename(saveFilename)
							.build());
				}
			}

			community.setSubject(dto.getSubject());
			community.setContent(content);
			community.setCategory(dto.getCategory());
			community.setTemporary(true);
			community.setPlaceName(dto.getPlaceName());
			community.setAddress(dto.getAddress());
			community.setLatitude(dto.getLatitude());
			community.setLongitude(dto.getLongitude());

			if (dto.getTags() != null) {
				community.getHashTags().clear();
				for (String tagName : dto.getTags()) {
					community.addHashTag(CommunityHashTag.builder().tagName(tagName).build());
				}
			}

		} catch (Exception e) {
			log.error("updateTempCommunity error", e);
			throw e;
		}
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public void deleteCommunity(long id, String uploadPath) throws Exception {
		try {
			Community community = communityRepository.findById(id).orElseThrow();
			if (community.getImages() != null) {
				for (CommunityImage img : community.getImages()) {
					storageService.deleteFile(uploadPath, img.getSaveFilename());
				}
			}
			if (community.getAttachFiles() != null) {
				for (com.sp.app.domain.entity.CommunityAttachFile af : community.getAttachFiles()) {
					storageService.deleteFile(uploadPath, af.getSaveFilename());
				}
			}
			
			try {
				if (community.getLikes() != null) {
					for (CommunityLike like : community.getLikes()) {
						if (!like.getMemberIdx().equals(community.getMemberIdx())) {
							notificationService.sendNotification(
								like.getMemberIdx(), 
								"게시글 삭제", 
								"[" + community.getSubject() + "] 게시글이 삭제되었습니다.", 
								""
							);
						}
					}
				}
			} catch(Exception e) { 
				log.info("커뮤니티 삭제 알림 전송 실패: ", e); 
			}
			
			communityRepository.delete(community);
		} catch (Exception e) {
			log.error("deleteCommunity error", e);
			throw e;
		}
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public void deleteCommunityFile(long id, String filename, String uploadPath) throws Exception {
		Community community = communityRepository.findById(id).orElseThrow();
		community.getImages().removeIf(img -> img.getSaveFilename().equals(filename));
		storageService.deleteFile(uploadPath, filename);
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public boolean toggleLike(long id, long memberIdx) throws Exception {
		Community community = communityRepository.findById(id).orElseThrow();
		Optional<CommunityLike> like = community.getLikes().stream()
				.filter(l -> l.getMemberIdx() == memberIdx).findFirst();

		if (like.isPresent()) {
			community.getLikes().remove(like.get());
			community.setLikeCount(Math.max(0, community.getLikeCount() - 1));
			return false;
		} else {
			community.addLike(CommunityLike.builder().memberIdx(memberIdx).build());
			community.setLikeCount(community.getLikeCount() + 1);
			return true;
		}
	}

	@Override
	public int getLikeCount(long id) {
		return communityRepository.findById(id).map(Community::getLikeCount).orElse(0);
	}
	
	@Override
	public boolean isUserLiked(Map<String, Object> map) {
		long id = (long) map.get("communityId");
		long memberIdx = (long) map.get("memberIdx");
		Community c = communityRepository.findById(id).orElse(null);
		return c != null && c.getLikes().stream().anyMatch(l -> l.getMemberIdx() == memberIdx);
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public boolean toggleScrap(long id, long memberIdx) throws Exception {
		Community community = communityRepository.findById(id).orElseThrow();
		Optional<CommunityScrap> scrap = community.getScraps().stream()
				.filter(s -> s.getMemberIdx() == memberIdx).findFirst();

		if (scrap.isPresent()) {
			community.getScraps().remove(scrap.get());
			return false;
		} else {
			community.addScrap(CommunityScrap.builder().memberIdx(memberIdx).build());
			return true;
		}
	}

	@Override
	public boolean isUserScraped(Map<String, Object> map) {
		long id = (long) map.get("communityId");
		long memberIdx = (long) map.get("memberIdx");
		Community c = communityRepository.findById(id).orElse(null);
		return c != null && c.getScraps().stream().anyMatch(s -> s.getMemberIdx() == memberIdx);
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public void votePoll(long pollId, long memberIdx, List<Long> optionIds) throws Exception {
		CommunityPoll poll = communityPollRepository.findById(pollId)
				.orElseThrow(() -> new RuntimeException("Poll not found"));

		if (poll.getEndDate() != null && java.time.LocalDateTime.now().isAfter(poll.getEndDate())) {
			throw new RuntimeException("투표가 마감되었습니다.");
		}

		if (!poll.isMultipleChoice() && optionIds.size() > 1) {
			throw new RuntimeException("Multiple choice not allowed");
		}

		pollVoteRepository.deleteByPollPollIdAndMemberId(pollId, memberIdx);
		pollVoteRepository.flush();

		List<PollVote> votes = new ArrayList<>();
		for (Long optionId : optionIds) {
			PollOption option = pollOptionRepository.findById(optionId)
					.orElseThrow(() -> new RuntimeException("Option not found"));
			votes.add(PollVote.builder()
					.poll(poll)
					.memberId(memberIdx)
					.option(option)
					.build());
		}
		pollVoteRepository.saveAll(votes);
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public void cancelVote(long pollId, long memberIdx) throws Exception {
		pollVoteRepository.deleteByPollPollIdAndMemberId(pollId, memberIdx);
	}

	@Override
	@Transactional(readOnly = true)
	public CommunityDto getPollInfo(long communityId) {
		CommunityPoll poll = communityPollRepository.findByCommunityId(communityId);
		if (poll == null) {
			return null;
		}
		
		List<String> options = poll.getOptions().stream()
				.map(PollOption::getContent)
				.collect(Collectors.toList());

		return CommunityDto.builder()
				.pollTitle(poll.getTitle())
				.pollOptions(options)
				.pollMultiple(poll.isMultipleChoice())
				.pollEndDate(poll.getEndDate() != null ? poll.getEndDate().toString() : null)
				.build();
	}

	@Override
	public boolean hasUserVoted(long pollId, long memberIdx) {
		return pollVoteRepository.existsByPollPollIdAndMemberId(pollId, memberIdx);
	}

	@Override
	@Transactional(readOnly = true)
	public List<CommunityDto> getTempList(long memberIdx) {
		return communityRepository.findByMemberIdxAndTemporaryTrueOrderByRegDateDesc(memberIdx)
				.stream().map(this::toDto).collect(Collectors.toList());
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public void deleteTempCommunity(long id, long memberIdx, String uploadPath) throws Exception {
		Community community = communityRepository.findById(id).orElseThrow();
		if (!community.getMemberIdx().equals(memberIdx) || !community.isTemporary()) {
			throw new RuntimeException("삭제 권한이 없습니다.");
		}
		if (community.getImages() != null) {
			for (CommunityImage img : community.getImages()) {
				storageService.deleteFile(uploadPath, img.getSaveFilename());
			}
		}
		communityRepository.delete(community);
	}

	@Override
	public long getPollTotalVotes(long communityId) {
		CommunityPoll poll = communityPollRepository.findByCommunityId(communityId);
		if (poll == null) return 0;
		return pollVoteRepository.countDistinctMemberByPollPollId(poll.getPollId());
	}

	@Override
	@Transactional(readOnly = true)
	public List<CommunityDto> getUserPostList(Long memberIdx) {
		return communityRepository
				.findByMemberIdxAndTemporaryFalseOrderByRegDateDesc(memberIdx)
				.stream()
				.limit(10)
				.map(this::toDto)
				.collect(Collectors.toList());
	}

	@Override
	@Transactional(readOnly = true)
	public List<CommunityDto> getUserPostListPaged(Long memberIdx, Pageable pageable) {
		return communityRepository
				.findByMemberIdxAndTemporaryFalse(memberIdx, pageable)
				.getContent()
				.stream()
				.map(this::toDto)
				.collect(Collectors.toList());
	}

	@Override
	@Transactional(readOnly = true)
	public long getUserPostCount(Long memberIdx) {
		return communityRepository.countByMemberIdxAndTemporaryFalse(memberIdx);
	}

	@Override
	@Transactional(readOnly = true)
	public long getUserReplyCount(Long memberIdx) {
		return communityReplyRepository.countByMemberIdxAndDeletedFalse(memberIdx);
	}

	@Override
	@Transactional(readOnly = true)
	public int getUserTotalLikes(Long memberIdx) {
		return communityRepository
				.findByMemberIdxAndTemporaryFalseOrderByRegDateDesc(memberIdx)
				.stream()
				.mapToInt(Community::getLikeCount)
				.sum();
	}

	@Override
	public LocalDateTime getUserJoinDate(Long memberIdx) {
	    try {
	        com.sp.app.domain.entity.User user = userRepository.findById(memberIdx).orElse(null);
	        if (user != null) {
	            return user.getCreatedDate();
	        }
	    } catch (Exception e) {
	        log.warn("getUserJoinDate 조회 실패, memberIdx={}", memberIdx, e);
	    }
	    return null;
	}

	@Override
	@Transactional(readOnly = true)
	public List<Map<String, Object>> getUserRepliesWithPostTitle(Long memberIdx) {
		return communityReplyRepository
				.findByMemberIdxAndDeletedFalseOrderByRegDateDesc(memberIdx)
				.stream()
				.map(r -> {
					Map<String, Object> m = new HashMap<>();
					m.put("id",          r.getId());
					m.put("content",     r.getContent());
					m.put("regDate",     r.getRegDate());
					m.put("communityId", r.getCommunity() != null ? r.getCommunity().getId() : null);
					m.put("postTitle",   r.getCommunity() != null ? r.getCommunity().getSubject() : "");
					return m;
				})
				.collect(Collectors.toList());
	}

	private CommunityDto toDto(Community entity) {
		List<CommunityDto.AttachFileInfo> attachFileInfos = entity.getAttachFiles().stream()
				.map(af -> new CommunityDto.AttachFileInfo(
						af.getOriginalFilename(),
						af.getSaveFilename(),
						af.getFileSize()))
				.collect(Collectors.toList());

		CommunityDto dto = CommunityDto.builder()
				.id(entity.getId())
				.memberIdx(entity.getMemberIdx())
				.writerNickname(entity.getWriterNickname())
				.subject(entity.getSubject())
				.content(entity.getContent())
				.category(entity.getCategory())
				.hitCount(entity.getHitCount())
				.likeCount(entity.getLikeCount())
				.regDate(entity.getRegDate())
				.placeName(entity.getPlaceName())
				.address(entity.getAddress())
				.latitude(entity.getLatitude())
	            .longitude(entity.getLongitude())
	            .regionCode(entity.getRegionCode())
	            .dong(entity.getRegionCode() != null ? getDongByRegionCode(entity.getRegionCode()) : null)
				.imageFiles(entity.getImages().stream().map(CommunityImage::getSaveFilename).collect(Collectors.toList()))
				.tags(entity.getHashTags().stream().map(CommunityHashTag::getTagName).collect(Collectors.toList()))
				.attachFileInfos(attachFileInfos)
				.build();

		CommunityPoll poll = communityPollRepository.findByCommunityId(entity.getId());
		if (poll != null) {
			dto.setPollTitle(poll.getTitle());
			dto.setPollMultiple(poll.isMultipleChoice());
			dto.setPollEndDate(poll.getEndDate() != null ? poll.getEndDate().toString() : null);
			
			List<String> options = poll.getOptions().stream()
					.map(PollOption::getContent)
					.collect(Collectors.toList());
			dto.setPollOptions(options);
		}
		
		return dto;
	}


	@Override
	@Transactional(readOnly = true)
	public List<Map<String, Object>> getPollOptionsWithVotes(long communityId) {
		CommunityPoll poll = communityPollRepository.findByCommunityId(communityId);
		if (poll == null) return new ArrayList<>();
		return poll.getOptions().stream().map(opt -> {
			Map<String, Object> m = new java.util.LinkedHashMap<>();
			m.put("optionId", opt.getOptionId());
			m.put("content", opt.getContent());
			m.put("voteCount", pollVoteRepository.countByOptionOptionId(opt.getOptionId()));
			return m;
		}).collect(Collectors.toList());
	}

	private String getDongByRegionCode(String regionCode) {
		try {
			RegionDto region = memberService.findRegionByCode(regionCode);
			return region != null ? region.getDong() : null;
		} catch (Exception e) {
			return null;
		}
	}
}