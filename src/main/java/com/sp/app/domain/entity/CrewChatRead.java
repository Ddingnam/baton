package com.sp.app.domain.entity;

import java.time.LocalDateTime;

import org.hibernate.annotations.CreationTimestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "CREW_CHAT_READ")
@IdClass(CrewChatReadId.class)
@Getter
@Setter
@NoArgsConstructor
public class CrewChatRead {

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "chat_room_id")
    private CrewChatRoom chatRoom;

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_idx")
    private User user;

    @Column(name = "last_read_chat_idx", nullable = false, columnDefinition = "NUMBER DEFAULT 0")
    private Long lastReadChatIdx = 0L;
    
    @CreationTimestamp
    @Column(name = "joined_date", nullable = false, updatable = false)
    private LocalDateTime joinedDate;

    @Builder
    public CrewChatRead(CrewChatRoom chatRoom, User user, Long lastReadChatIdx) {
        this.chatRoom = chatRoom;
        this.user = user;
        this.lastReadChatIdx = (lastReadChatIdx != null) ? lastReadChatIdx : 0L;
    }

    public void updateLastReadChatIdx(Long chatIdx) {
        this.lastReadChatIdx = chatIdx;
    }
}
