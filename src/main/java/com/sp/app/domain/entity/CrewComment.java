package com.sp.app.domain.entity;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.Lob;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OrderBy;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "CREWCOMMENTS")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CrewComment {
	
	@Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "CREW_COMMENT_SEQ")
    @SequenceGenerator(name = "CREW_COMMENT_SEQ", sequenceName = "CREW_COMMENT_SEQ", allocationSize = 1)
    private Long commentId;

    private Long crewBoardIdx;
    
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "userIdx", nullable = false) 
    private User user;
    
    @Lob
    private String content;

    @Builder.Default
    private String isDeleted = "N";
    
    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parentCommentId")
    private CrewComment parent;

    @Builder.Default
    @OneToMany(mappedBy = "parent", cascade = CascadeType.ALL)
    @OrderBy("createdAt ASC")
    private List<CrewComment> children = new ArrayList<>();

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
    
    public void updateContent(String content) {
        this.content = content;
        this.updatedAt = LocalDateTime.now();
    }
    
    public void delete() {
        this.isDeleted = "Y";
    }
}
