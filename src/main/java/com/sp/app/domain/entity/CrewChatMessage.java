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
import jakarta.persistence.Lob;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "CREW_CHAT_MESSAGE")
@Getter
@Setter
@NoArgsConstructor
public class CrewChatMessage {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "CREW_CHAT_MSG_SEQ")
    @SequenceGenerator(name = "CREW_CHAT_MSG_SEQ", sequenceName = "CREW_CHAT_MSG_SEQ", allocationSize = 1)
    @Column(name = "chat_idx")
    private Long chatIdx;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "chat_room_id", nullable = false)
    private CrewChatRoom chatRoom;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_idx", nullable = false)
    private User user;

    @Lob
    @Column(name = "content", nullable = false)
    private String content;

    @Column(name = "msg_type", nullable = false, columnDefinition = "NUMBER(1) DEFAULT 1")
    private Integer msgType;

    @CreationTimestamp
    @Column(name = "created_date", nullable = false, updatable = false)
    private LocalDateTime createdDate;

    @Builder
    public CrewChatMessage(CrewChatRoom chatRoom, User user, String content, Integer msgType) {
        this.chatRoom = chatRoom;
        this.user = user;
        this.content = content;
        this.msgType = (msgType != null) ? msgType : 1;
    }
}
