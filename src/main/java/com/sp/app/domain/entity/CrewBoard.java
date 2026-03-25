package com.sp.app.domain.entity;

import java.time.LocalDateTime;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.Lob;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "CREWBOARD")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CrewBoard {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "CREW_BOARD_SEQ")
    @SequenceGenerator(name = "CREW_BOARD_SEQ", sequenceName = "CREW_BOARD_SEQ", allocationSize = 1)
    private Long crewBoardIdx;

    private Long crewIdx;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "userIdx", nullable = false)
    private User user;

    @Column(nullable = false)
    private String title;

    @Lob
    @Column(nullable = false)
    private String content;

    @Builder.Default
    @Column(length = 1)
    private String isNotice = "N";

    @Builder.Default
    private String status = "ACTIVE";
    
    @Builder.Default
    private Integer viewCount = 0;

    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime createdDate;

    @UpdateTimestamp
    private LocalDateTime updatedDate;
    
    public void update(String title, String content, String isNotice) {
        this.title = title;
        this.content = content;
        this.isNotice = isNotice;
        this.updatedDate = LocalDateTime.now();
    }
    
    public void delete() {
        this.status = "DELETED";
    }
}