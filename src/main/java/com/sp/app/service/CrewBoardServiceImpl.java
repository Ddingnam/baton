package com.sp.app.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sp.app.domain.dto.CrewBoardDto;
import com.sp.app.domain.entity.CrewBoard;
import com.sp.app.mapper.MemberMapper;
import com.sp.app.repository.CrewBoardRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional
public class CrewBoardServiceImpl implements CrewBoardService{

	private final CrewBoardRepository boardRepository;
	private final MemberMapper memberMapper;
	
	@Override
	public Long savePost(CrewBoardDto dto) {
		
		CrewBoard board = CrewBoard.builder()
                .crewIdx(dto.getCrewIdx())
                .userIdx(dto.getUserIdx())
                .title(dto.getTitle())
                .content(dto.getContent())
                .isNotice(dto.getIsNotice() != null ? dto.getIsNotice() : "N")
                .status("ACTIVE")
                .viewCount(0)
                .build();
        
        return boardRepository.save(board).getCrewBoardIdx();
	}

	@Override
	@Transactional(readOnly = true)
	public List<CrewBoardDto> findAllPosts(Long crewIdx) {
		return boardRepository.findAllByCrewIdxWithUser(crewIdx)
                .stream()
                .map(CrewBoardDto::fromEntity)
                .collect(Collectors.toList());
	}

	@Override
	public CrewBoardDto findPostById(Long boardIdx) {
		CrewBoard board = boardRepository.findById(boardIdx)
                .orElseThrow(() -> new IllegalArgumentException("해당 게시글이 존재하지 않습니다."));
        
        return CrewBoardDto.fromEntity(board);
	}

	@Override
	public Map<String, Object> getPostListCustom(Long crewIdx, int page, int size) {
		int offset = (page - 1) * size;

	    List<CrewBoard> posts = boardRepository.findByCrewIdxNative(crewIdx, offset, size);
	    
	    List<CrewBoardDto> postList = posts.stream()
	            .map(CrewBoardDto::fromEntity)
	            .collect(Collectors.toList());
	    
	    if (!postList.isEmpty()) {
	    	postList.forEach(dto -> {
	            dto.setAuthorNickname(memberMapper.findById(dto.getUserIdx()).getNickname());
	        });
	    }

	    long totalElements = boardRepository.countByCrewIdxNative(crewIdx);
	    int totalPages = (int) Math.ceil((double) totalElements / size);

	    Map<String, Object> result = new HashMap<>();
	    result.put("posts", postList);
	    result.put("totalPages", totalPages);
	    result.put("totalElements", totalElements);
	    result.put("currentPage", page);

	    return result;
	}

	@Override
	@Transactional
	public void updateViewCount(Long boardIdx) {
		boardRepository.updateViewCount(boardIdx);
	}

}
