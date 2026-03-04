package com.sp.app.domain.entity;


import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "COMMUNITY")
public class Community {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "community_id")
    private Long id;

    @Column(name = "member_idx", nullable = false)
    private Long memberIdx; 

    @Column(name = "writer_nickname", length = 50)
    private String writerNickname;

    @Column(nullable = false, length = 300)
    private String subject;

    @Lob
    @Column(nullable = false)
    private String content;

    @Column(length = 20)
    private String category;

    @ColumnDefault("0")
    private int hitCount;

    @ColumnDefault("0")
    private int likeCount;

    @ColumnDefault("0")
    private int replyCount;

    private String placeName;
    private String address;
    private Double latitude;
    private Double longitude;

    @Builder.Default
    @OneToMany(mappedBy = "community", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CommunityImage> images = new ArrayList<>();

    @Builder.Default
    @OneToMany(mappedBy = "community", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CommunityHashTag> hashTags = new ArrayList<>();

    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime regDate;

    @UpdateTimestamp
    private LocalDateTime updateDate;

    
    public void addImage(CommunityImage image) {
        this.images.add(image);
        image.setCommunity(this);
    }
    
    public void addHashTag(CommunityHashTag tag) {
        this.hashTags.add(tag);
        tag.setCommunity(this);
    }
}