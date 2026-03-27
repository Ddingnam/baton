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
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "CREWMEMBER")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CrewMember {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "CREW_MEMBER_SEQ")
    @SequenceGenerator(name = "CREW_MEMBER_SEQ", sequenceName = "CREW_MEMBER_SEQ", allocationSize = 1)
    private Long crewMemberIdx;

    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "crewIdx", nullable = false) 
    private Crew crew;

    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "userIdx", nullable = false) 
    private User user;

    @Column(length = 20)
    @Builder.Default
    private String role = "MEMBER";

    @Column(length = 20)
    @Builder.Default
    private String status = "WAIT";

    private LocalDateTime joinedDate;

    @Column(length = 2000)
    private String applicationReason;
}
