package com.sp.app.domain.entity;

import java.time.LocalDateTime;

import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.CreationTimestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "CREW_SCHEDULE_VOTE")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CrewScheduleVote {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "CREW_SCHEDULE_VOTE_SEQ")
    @SequenceGenerator(name = "CREW_SCHEDULE_VOTE_SEQ", sequenceName = "CREW_SCHEDULE_VOTE_SEQ", allocationSize = 1)
    @Column(name = "vote_idx")
    private Long voteIdx;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "schedule_idx", nullable = false)
    private CrewSchedule schedule;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_idx", nullable = false)
    private User user;

    @ColumnDefault("'ATTEND'")
    @Column(name = "status", length = 20, nullable = false)
    private String status;

    @CreationTimestamp
    @Column(name = "voted_date", updatable = false)
    private LocalDateTime votedDate;

    @PrePersist
    public void prePersist() {
        this.status = this.status == null ? "ATTEND" : this.status;
    }
}
