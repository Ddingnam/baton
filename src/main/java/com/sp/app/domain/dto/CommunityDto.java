package com.sp.app.domain.dto;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

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
public class CommunityDto {
    private Long id;
    private Long memberIdx;
    private String writerNickname;
    private String subject;
    private String content;
    private String category;
    private int hitCount;
    private int likeCount;
    private LocalDateTime regDate;
    
    private String placeName;
    private String address;
    private Double latitude;
    private Double longitude;
    
    private List<MultipartFile> uploadFiles;
    
    private List<String> imageFiles;
    private List<String> tags;
    
    private boolean userLiked;
    private boolean userScraped;
    
    private String pollTitle; 
    private List<String> pollOptions;
    private String pollEndDate;
    private Boolean pollMultiple;
    private Boolean pollAnonymous;

    private boolean temporary;
}