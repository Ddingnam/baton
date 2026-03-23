package com.sp.app.domain.dto;

import java.time.format.DateTimeFormatter;

import com.sp.app.domain.entity.CrewBoard;
import com.sp.app.service.MemberService;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CrewBoardDto {
	
    private Long crewBoardIdx;
    private Long crewIdx;
    private Long userIdx;
    private String authorNickname;
    private String title;
    private String content;
    private String isNotice;
    private String status;
    private Integer viewCount;
    private String createdDate;
    private String updatedDate;
    
    public static CrewBoardDto fromEntity(CrewBoard entity) {
        if (entity == null) return null;

        return CrewBoardDto.builder()
            .crewBoardIdx(entity.getCrewBoardIdx())
            .crewIdx(entity.getCrewIdx())
            .userIdx(entity.getUserIdx())
            .title(entity.getTitle())
            .content(entity.getContent())
            .isNotice(entity.getIsNotice())
            .status(entity.getStatus())
            .viewCount(entity.getViewCount())
            .createdDate(entity.getCreatedDate() != null ? 
                entity.getCreatedDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")) : null)
            .updatedDate(entity.getUpdatedDate() != null ? 
                entity.getUpdatedDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")) : null)
            .build();
    }
}
