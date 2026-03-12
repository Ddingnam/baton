package com.sp.app.domain.dto;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

public class MypageCommunityDto {

    @Getter
    @Setter 
    @Builder
    @NoArgsConstructor 
    @AllArgsConstructor
    public static class ReplyDto {
        private Long replyId;
        private String content;
        private LocalDateTime regDate;
        private Long communityId;
        private String communitySubject;
        private boolean parentReply;
    }

    @Getter 
    @Setter 
    @Builder
    @NoArgsConstructor 
    @AllArgsConstructor
    public static class VoteDto {
        private Long pollId;
        private String pollTitle;
        private String pollEndDate;
        private boolean expired;
        private Long communityId;
        private String communitySubject;
        private String myOptions;
        private long totalVotes;
    }
}