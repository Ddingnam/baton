package com.sp.app.domain.dto;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter 
@Setter
@Builder 
@NoArgsConstructor
@AllArgsConstructor
public class CommunityReplyDto {
	private Long id;
	private Long communityId;
	
	private Long memberIdx;
	private String writerNickname;
	
	private String content;
	private LocalDateTime regDate;

	private Long parentId;
	private String parentNickname;
	private int depth;

	@JsonProperty("isDeleted")
	private boolean deleted;

	@JsonProperty("isHidden")
	private boolean hidden;
}