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
import jakarta.persistence.Lob;
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
@Table(name = "CREW_SCHEDULE")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CrewSchedule {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "CREW_SCHEDULE_SEQ")
    @SequenceGenerator(name = "CREW_SCHEDULE_SEQ", sequenceName = "CREW_SCHEDULE_SEQ", allocationSize = 1)
    @Column(name = "schedule_idx")
    private Long scheduleIdx;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "crew_idx", nullable = false)
    private Crew crew;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_idx")
    private User user;

    @Column(name = "title", length = 300, nullable = false)
    private String title;

    @Lob
    @Column(name = "content")
    private String content;

    @Column(name = "start_date", nullable = false)
    private LocalDateTime startDate;

    @Column(name = "end_date")
    private LocalDateTime endDate;

    @Column(name = "location_name", length = 600)
    private String locationName;

    @Column(name = "lat", columnDefinition = "NUMBER(11, 8)")
    private Double lat;

    @Column(name = "lng", columnDefinition = "NUMBER(11, 8)")
    private Double lng;

    @ColumnDefault("0")
    @Column(name = "max_people")
    private Integer maxPeople;

    @CreationTimestamp
    @Column(name = "created_date", updatable = false)
    private LocalDateTime createdDate;
    
    @PrePersist
    public void prePersist() {
        this.maxPeople = this.maxPeople == null ? 0 : this.maxPeople;
    }
}
