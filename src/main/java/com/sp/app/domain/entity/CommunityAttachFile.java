package com.sp.app.domain.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "community_attach_file")
@Getter @Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CommunityAttachFile {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "community_attach_seq")
    @SequenceGenerator(name = "community_attach_seq", sequenceName = "community_attach_file_seq", allocationSize = 1)
    @Column(name = "attach_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "community_id", nullable = false)
    private Community community;

    @Column(nullable = false)
    private String originalFilename;

    @Column(nullable = false)
    private String saveFilename;

    @Column
    private long fileSize;
}