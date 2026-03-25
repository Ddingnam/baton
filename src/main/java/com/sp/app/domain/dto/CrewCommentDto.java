package com.sp.app.domain.dto;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import com.sp.app.common.MyUtil;
import com.sp.app.domain.entity.CrewComment;

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
public class CrewCommentDto {

    private Long commentId;
    private Long crewBoardIdx;
    private Long userIdx;
    private Long parentId;
    private String content;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String isDeleted;
    
    @Builder.Default
    private List<CrewCommentDto> children = new ArrayList<>();
    
    private String authorNickname;
    private String authorProfilePhoto;
    
    private String formattedDate;

    public static CrewCommentDto fromEntity(CrewComment entity) {
        if (entity == null) return null;

        return CrewCommentDto.builder()
                .commentId(entity.getCommentId())
                .crewBoardIdx(entity.getCrewBoardIdx())
                .userIdx(entity.getUser().getUserIdx())
                .content(entity.getContent())
                .createdAt(entity.getCreatedAt())
                .updatedAt(entity.getUpdatedAt())
                .isDeleted(entity.getIsDeleted())
                .children(entity.getChildren().stream()
                        .map(CrewCommentDto::fromEntity)
                        .collect(Collectors.toList()))
                .authorNickname(entity.getUser().getNickname())
                .authorProfilePhoto(entity.getUser().getProfilePhoto())
                .formattedDate(MyUtil.formatRelativeDate(entity.getCreatedAt()))
                .build();
    }
}