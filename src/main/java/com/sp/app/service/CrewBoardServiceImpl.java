package com.sp.app.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sp.app.domain.dto.CrewBoardDto;
import com.sp.app.domain.entity.CrewBoard;
import com.sp.app.domain.entity.User;
import com.sp.app.mapper.MemberMapper;
import com.sp.app.repository.CrewBoardRepository;
import com.sp.app.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional
public class CrewBoardServiceImpl implements CrewBoardService{

	private final UserRepository userRepository;
	private final CrewBoardRepository boardRepository;
	
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
	public void updatePost(CrewBoardDto dto) {
		CrewBoard board = boardRepository.findById(dto.getCrewBoardIdx())
				.orElseThrow(() -> new IllegalArgumentException("해당 게시글이 없습니다."));
		board.update(dto.getTitle(), dto.getContent(), dto.getIsNotice());
	}
	
	@Override
	public CrewBoardDto getPostDetail(Long boardIdx) {
		boardRepository.updateViewCount(boardIdx);
		CrewBoard board = boardRepository.findById(boardIdx)
                .orElseThrow(() -> new IllegalArgumentException("해당 게시글이 존재하지 않습니다."));
        
		CrewBoardDto dto = CrewBoardDto.fromEntity(board);
        
        userRepository.findBoardUserInfoByUserIdx(board.getUserIdx()).ifPresent(info -> {
            dto.setAuthorNickname(info.getNickname());
            dto.setAuthorProfilePhoto(info.getProfilePhoto());
        });
        
        return dto;
	}

	@Override
	public Map<String, Object> getPostList(Long crewIdx, int page, int size) {
		Pageable pageable = PageRequest.of(page - 1, size);
	    
	    List<CrewBoard> posts = boardRepository.findByCrewIdx(crewIdx, pageable);
	    
	    List<CrewBoardDto> postList = posts.stream().map(post -> {
	        CrewBoardDto dto = CrewBoardDto.fromEntity(post);
	        
	        userRepository.findBoardUserInfoByUserIdx(post.getUserIdx()).ifPresent(info -> {
	            dto.setAuthorNickname(info.getNickname());
	            dto.setAuthorProfilePhoto(info.getProfilePhoto());
	        });
	        
	        return dto;
	    }).collect(Collectors.toList());
	    
	    long totalElements = boardRepository.countByCrewIdx(crewIdx);
	    int totalPages = (int) Math.ceil((double) totalElements / size);

	    Map<String, Object> result = new HashMap<>();
	    result.put("posts", postList);
	    result.put("totalPages", totalPages);
	    result.put("totalElements", totalElements);
	    result.put("currentPage", page);

	    return result;
	}

}
