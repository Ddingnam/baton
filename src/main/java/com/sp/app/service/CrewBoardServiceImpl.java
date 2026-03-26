package com.sp.app.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sp.app.domain.dto.CrewBoardDto;
import com.sp.app.domain.dto.CrewCommentDto;
import com.sp.app.domain.entity.CrewBoard;
import com.sp.app.domain.entity.CrewBoardLike;
import com.sp.app.domain.entity.CrewComment;
import com.sp.app.domain.entity.User;
import com.sp.app.repository.CrewBoardLikeRepository;
import com.sp.app.repository.CrewBoardRepository;
import com.sp.app.repository.CrewCommentRepository;
import com.sp.app.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional
public class CrewBoardServiceImpl implements CrewBoardService{

	private final UserRepository userRepository;
	private final CrewBoardRepository boardRepository;
	private final CrewCommentRepository commentRepository;
	private final CrewBoardLikeRepository likeRepository;
	
	@Override
	public Long savePost(CrewBoardDto dto) {
		User user = userRepository.findById(dto.getUserIdx())
	            .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 유저입니다. ID: " + dto.getUserIdx()));
		
		CrewBoard board = CrewBoard.builder()
                .crewIdx(dto.getCrewIdx())
                .user(user)
                .title(dto.getTitle())
                .content(dto.getContent())
                .isNotice(dto.getIsNotice())
                .build();
        
        return boardRepository.save(board).getCrewBoardIdx();
	}

	@Override
	public void updatePost(CrewBoardDto dto) {
		CrewBoard board = boardRepository.findById(dto.getCrewBoardIdx())
				.orElseThrow(() -> new IllegalArgumentException("해당 게시글이 없습니다."));
		
		if (!board.getUser().getUserIdx().equals(dto.getUserIdx())) {
	        throw new RuntimeException("본인이 작성한 글만 수정할 수 있습니다.");
	    }
		
		board.update(dto.getTitle(), dto.getContent(), dto.getIsNotice());
	}
	
	@Override
	public void deletePost(long crewBoardIdx, long userIdx) {
		CrewBoard board = boardRepository.findById(crewBoardIdx)
				.orElseThrow(() -> new IllegalArgumentException("해당 게시글이 없습니다."));
		
		if (board.getUser().getUserIdx() != userIdx) {
	        throw new RuntimeException("본인이 작성한 글만 삭제할 수 있습니다.");
	    }
		
		board.delete();
	}
	
	@Override
	public CrewBoardDto getPostDetail(Long boardIdx, Long userIdx) {
		boardRepository.updateViewCount(boardIdx);
		CrewBoard board = boardRepository.findById(boardIdx)
                .orElseThrow(() -> new IllegalArgumentException("해당 게시글이 존재하지 않습니다."));
		CrewBoardDto dto = CrewBoardDto.fromEntity(board);
		
		dto.setCommentCount(commentRepository.countByCrewBoardIdxAndIsDeleted(boardIdx, "N"));
		dto.setLikeCount(likeRepository.countByCrewBoardIdx(boardIdx));
		dto.setLiked(likeRepository.existsByCrewBoardIdxAndUserIdx(boardIdx, userIdx));
		
		
        return dto;
	}

	@Override
	public Map<String, Object> getPostList(Long crewIdx, Long userIdx, int page, int size) {
		Pageable pageable = PageRequest.of(page - 1, size);
	    
	    List<CrewBoard> posts = boardRepository.findActiveBoardsWithUser(crewIdx, pageable);
	    
	    List<CrewBoardDto> postList = posts.stream()
	            .map(post -> {
	            		CrewBoardDto dto = CrewBoardDto.fromEntity(post);
	            		dto.setCommentCount(commentRepository.countByCrewBoardIdxAndIsDeleted(post.getCrewBoardIdx(), "N"));
	                    dto.setLikeCount(likeRepository.countByCrewBoardIdx(post.getCrewBoardIdx()));
	                    dto.setLiked(likeRepository.existsByCrewBoardIdxAndUserIdx(post.getCrewBoardIdx(), userIdx));
	                    return dto;
		            }
	            )
	            .collect(Collectors.toList());
	    
	    long totalElements = boardRepository.countByCrewIdx(crewIdx);
	    int totalPages = (int) Math.ceil((double) totalElements / size);

	    Map<String, Object> result = new HashMap<>();
	    result.put("posts", postList);
	    result.put("totalPages", totalPages);
	    result.put("totalElements", totalElements);
	    result.put("currentPage", page);

	    return result;
	}
	
	@Override
	public Long saveComment(CrewCommentDto dto) {
		User user = userRepository.findById(dto.getUserIdx())
	            .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 유저입니다. ID: " + dto.getUserIdx()));
		
	    CrewComment comment = CrewComment.builder()
	            .crewBoardIdx(dto.getCrewBoardIdx())
	            .user(user)
	            .content(dto.getContent())
	            .build();

	    if (dto.getParentId() != null) {
	        CrewComment parent = commentRepository.findById(dto.getParentId())
	                .orElseThrow(() -> new RuntimeException("부모 댓글이 존재하지 않습니다."));
	        comment.setParent(parent);
	        parent.getChildren().add(comment);
	    }

	    return commentRepository.save(comment).getCommentId();
	}
	
	@Override
	public void updateComment(CrewCommentDto dto) {
		CrewComment comment = commentRepository.findById(dto.getCommentId())
				.orElseThrow(() -> new IllegalArgumentException("해당 댓글이 존재하지 않습니다."));
		
		if (!comment.getUser().getUserIdx().equals(dto.getUserIdx())) {
	        throw new RuntimeException("본인이 작성한 댓글만 수정할 수 있습니다.");
	    }
		
		comment.updateContent(dto.getContent());
	}
	
	@Override
	public void deleteComment(Long commentId, Long userIdx) {
	    CrewComment comment = commentRepository.findById(commentId)
	            .orElseThrow(() -> new IllegalArgumentException("해당 댓글이 존재하지 않습니다."));

	    if (!comment.getUser().getUserIdx().equals(userIdx)) {
	        throw new RuntimeException("본인이 작성한 댓글만 삭제할 수 있습니다.");
	    }

	    comment.delete();
	}
	
	@Override
	public Map<String, Object> getCommentList(Long boardIdx, int page, int size) {
	    Pageable pageable = PageRequest.of(page - 1, size);
	    List<CrewComment> parents = commentRepository.findActiveComments(boardIdx, "N", pageable);

	    List<CrewCommentDto> dtoList = parents.stream()
	            .map(CrewCommentDto::fromEntity)
	            .collect(Collectors.toList());

	    int totalCount = commentRepository.countByCrewBoardIdxAndIsDeleted(boardIdx, "N");
	    int totalPages = (int) Math.ceil((double) totalCount / size);

	    Map<String, Object> result = new HashMap<>();
	    result.put("comments", dtoList);
	    result.put("totalCount", totalCount);
	    result.put("currentPage", page);
	    result.put("totalPages", totalPages);
	    
	    return result;
	}
	
	@Override
	public Map<String, Object> toggleLike(Long boardIdx, Long userIdx) {
        Map<String, Object> result = new HashMap<>();
        
        Optional<CrewBoardLike> existingLike = likeRepository.findByCrewBoardIdxAndUserIdx(boardIdx, userIdx);

        if (existingLike.isPresent()) {
            likeRepository.delete(existingLike.get());
            result.put("status", "removed");
        } else {
            CrewBoardLike newLike = CrewBoardLike.builder()
                    .crewBoardIdx(boardIdx)
                    .userIdx(userIdx)
                    .build();
            
            likeRepository.save(newLike);
            result.put("status", "added");
        }

        long totalLikes = likeRepository.countByCrewBoardIdx(boardIdx);
        result.put("totalLikes", totalLikes);

        return result;
    }
	
	@Override
	public boolean isLikedByUser(Long boardIdx, Long userIdx) {
	    return likeRepository.existsByCrewBoardIdxAndUserIdx(boardIdx, userIdx);
	}

}
