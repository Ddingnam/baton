package com.sp.app.domain.entity;

import java.time.LocalDateTime;
import org.hibernate.annotations.CreationTimestamp;

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
import jakarta.persistence.UniqueConstraint;
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
@Table(name = "COMMUNITY_SCRAP",
       uniqueConstraints = {
           @UniqueConstraint(columnNames = {"community_id", "member_idx"})
       })
public class CommunityScrap {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "SEQ_COMMUNITY_SCRAP")
    @SequenceGenerator(name = "SEQ_COMMUNITY_SCRAP", sequenceName = "SEQ_COMMUNITY_SCRAP", allocationSize = 1)
    @Column(name = "scrap_id")
    private Long id;

    @Column(name = "member_idx", nullable = false)
    private Long memberIdx;

    @CreationTimestamp
    @Column(name = "scrap_date")
    private LocalDateTime scrapDate;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "community_id")
    private Community community;
}