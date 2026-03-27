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
@Table(name = "CREWMEMBER_HISTORY")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CrewMemberHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "crew_member_history_seq")
    @SequenceGenerator(name = "crew_member_history_seq", sequenceName = "crew_member_history_seq", allocationSize = 1)
    private Long crewmemberHistoryIdx;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "crewMemberIdx", nullable = false)
    private CrewMember crewMember;

    @Column(length = 20, nullable = false)
    private String changedStatus;

    @Builder.Default
    private LocalDateTime logDate = LocalDateTime.now(); // 기본값 현재 시간

    @Column(length = 2000)
    private String reason;

    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "actorIdx", nullable = false) 
    private User actor;
}
