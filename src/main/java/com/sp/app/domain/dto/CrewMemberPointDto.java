package com.sp.app.domain.dto;

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
public class CrewMemberPointDto {
    private Long userIdx;
    private String nickname;

    private long postCount;
    private long commentCount;
    private long scheduleCount;
    private long likeCount;

    private int totalPoint;

    public void calculateTotalPoint() {
        this.totalPoint = (int) (
            (this.postCount * 10) +
            (this.commentCount * 5) +
            (this.scheduleCount * 20) +
            (this.likeCount * 1)
        );
    }
}
