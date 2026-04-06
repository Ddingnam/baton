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
import jakarta.persistence.SequenceGenerator;
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
@Table(name = "COMMUNITY_REPLY")
public class CommunityReply {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "SEQ_COMMUNITY_REPLY")
    @SequenceGenerator(name = "SEQ_COMMUNITY_REPLY", sequenceName = "SEQ_COMMUNITY_REPLY", allocationSize = 1)
    @Column(name = "reply_id")
    private Long id;

    @Column(name = "member_idx", nullable = false)
    private Long memberIdx;

    @Column(name = "writer_nickname", length = 50)
    private String writerNickname;

    @Column(nullable = false, length = 4000)
    private String content;

    @Column(name = "parent_id")
    private Long parentId;

    @CreationTimestamp
    @Column(name = "reg_date", updatable = false)
    private LocalDateTime regDate;

    @Column(name = "is_deleted")
    @ColumnDefault("false")
    private boolean deleted;

    @Column(name = "is_hidden")
    @ColumnDefault("false")
    private boolean hidden;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "community_id")
    private Community community;
}