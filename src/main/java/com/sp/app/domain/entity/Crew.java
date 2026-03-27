package com.sp.app.domain.entity;

import java.time.LocalDateTime;

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
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Table(name = "CREW")
public class Crew {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "crew_seq")
    @SequenceGenerator(name = "crew_seq", sequenceName = "crew_seq", allocationSize = 1)
    @Column(name = "crewidx")
    private Long crewIdx;
    
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "useridx", nullable = false) 
    private User leader;

    @Column(nullable = false, length = 255)
    private String name;

    @Lob
    private String description;

    @Column(name = "logoimage", length = 500)
    private String logoImage;

    @Column(name = "maxmember", nullable = false)
    private Integer maxMember;

    @Column(name = "currentmember", nullable = false)
    @Builder.Default
    private Integer currentMember = 1;

    @Column(name = "jointype", nullable = false, length = 1)
    private String joinType;

    @Column(name = "chatroomid")
    private Long chatroomId;

    @Column(name = "viewcount")
    @Builder.Default
    private Integer viewCount = 0;

    @Column(name = "status", length = 1)
    @Builder.Default
    private String status = "Y";

    @Column(name = "createddate", updatable = false)
    @Builder.Default
    private LocalDateTime createdDate = LocalDateTime.now();
}

