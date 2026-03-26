package com.sp.app.domain.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "CREWBOARDLIKES")
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CrewBoardLike {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "CREW_BOARD_LIKE_SEQ")
    @SequenceGenerator(name = "CREW_BOARD_LIKE_SEQ", sequenceName = "CREW_BOARD_LIKE_SEQ", allocationSize = 1)
    private Long likeIdx;

    @Column(name = "CREW_BOARD_IDX", nullable = false)
    private Long crewBoardIdx;

    @Column(name = "USER_IDX", nullable = false)
    private Long userIdx;

    @Builder
    public CrewBoardLike(Long crewBoardIdx, Long userIdx) {
        this.crewBoardIdx = crewBoardIdx;
        this.userIdx = userIdx;
    }
}