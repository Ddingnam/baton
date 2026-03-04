package com.sp.app.domain.dto;

import java.time.LocalDateTime;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CommunityDto {
    private Long id;
    private Long memberIdx;
    private String writerNickname;
    
    private String subject;
    private String content;
    private String category;
    
    private String placeName;
    private String address;
    private Double latitude;
    private Double longitude;

    private int hitCount;
    private int likeCount;
    private int replyCount;
    private int scrapCount;
    
    private LocalDateTime regDate;
    private LocalDateTime updateDate;

    private List<String> tags;
    private List<String> imageFiles;
}