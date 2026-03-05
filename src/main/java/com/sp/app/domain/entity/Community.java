package com.sp.app.domain.entity;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.CreationTimestamp;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OrderBy;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "community")
@Getter @Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Community {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "community_id")
    private Long id;

    @Column(nullable = false)
    private Long memberIdx;

    @Column(length = 50)
    private String writerNickname;

    @Column(nullable = false, length = 300)
    private String subject;

    @Lob
    @Column(columnDefinition = "TEXT")
    private String content;

    @Column(length = 50)
    private String category;

    @ColumnDefault("0")
    private int hitCount;

    @ColumnDefault("0")
    private int likeCount;

    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime regDate;

    private String placeName;
    private String address;
    private Double latitude;
    private Double longitude;

    @OneToMany(mappedBy = "community", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @Builder.Default
    @OrderBy("id ASC")
    private List<CommunityImage> images = new ArrayList<>();

    @OneToMany(mappedBy = "community", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @Builder.Default
    private List<CommunityHashTag> hashTags = new ArrayList<>();

    @OneToMany(mappedBy = "community", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<CommunityLike> likes = new ArrayList<>();

    @OneToMany(mappedBy = "community", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<CommunityScrap> scraps = new ArrayList<>();

    public void addImage(CommunityImage image) {
        this.images.add(image);
        image.setCommunity(this);
    }

    public void addHashTag(CommunityHashTag hashTag) {
        this.hashTags.add(hashTag);
        hashTag.setCommunity(this);
    }
    
    public void addLike(CommunityLike like) {
        this.likes.add(like);
        like.setCommunity(this);
    }
    
    public void addScrap(CommunityScrap scrap) {
        this.scraps.add(scrap);
        scrap.setCommunity(this);
    }
}