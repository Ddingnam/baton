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
    @Column(name = "crewBoardIdx")
    private Long crewBoardIdx;

    @Column(name = "crewIdx")
    private Long crewIdx;
    
    @Column(name = "userIdx")
    private Long userIdx;

    @Column(nullable = false)
    private String title;

    @Lob
    @Column(nullable = false)
    private String content;

    @Column(name = "isNotice", length = 1)
    private String isNotice = "N";

    private String status = "ACTIVE";
    
    @Column(name = "viewCount")
    private Integer viewCount = 0;

    @CreationTimestamp
    @Column(name = "createdDate")
    private LocalDateTime createdDate;

    @UpdateTimestamp
    @Column(name = "updatedDate")
    private LocalDateTime updatedDate;
    
    public void update(String title, String content, String isNotice) {
        this.title = title;
        this.content = content;
        this.isNotice = isNotice;
    }
}