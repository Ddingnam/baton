package com.sp.app.domain.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "follow")
public class Follow {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "followIdx")
    private Long followIdx;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "followerIdx", nullable = false)
    private User follower;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "followingIdx", nullable = false)
    private User following;

    @Column(name = "followDate", nullable = false, updatable = false)
    private LocalDateTime followDate;

    @Builder
    public Follow(User follower, User following) {
        this.follower = follower;
        this.following = following;
        this.followDate = LocalDateTime.now();
    }
}
