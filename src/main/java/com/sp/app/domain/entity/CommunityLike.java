package com.sp.app.domain.entity;

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
@Table(name = "COMMUNITY_LIKE", 
       uniqueConstraints = {
           @UniqueConstraint(columnNames = {"community_id", "member_idx"})
       })
public class CommunityLike {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "SEQ_COMMUNITY_LIKE")
    @SequenceGenerator(name = "SEQ_COMMUNITY_LIKE", sequenceName = "SEQ_COMMUNITY_LIKE", allocationSize = 1)
    @Column(name = "like_id")
    private Long id;

    @Column(name = "member_idx", nullable = false)
    private Long memberIdx;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "community_id")
    private Community community;
}