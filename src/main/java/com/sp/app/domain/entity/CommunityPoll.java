package com.sp.app.domain.entity;

import java.time.LocalDateTime;
import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "community_poll")
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CommunityPoll {
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "poll_seq_gen")
	@SequenceGenerator(name = "poll_seq_gen", sequenceName = "community_poll_seq", allocationSize = 1)
	@Column(name = "poll_id")
	private Long pollId;
	
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "community_id")
    private Community community;

    @Column(nullable = false)
    private String title;

    @Column(name = "end_date")
    private LocalDateTime endDate;

    @Column(name = "multiple_choice")
    private boolean multipleChoice;

    @Column(name = "is_anonymous")
    private boolean isAnonymous;

    @OneToMany(mappedBy = "poll", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<PollOption> options;
}