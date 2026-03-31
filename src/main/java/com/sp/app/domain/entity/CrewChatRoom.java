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
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "CREW_CHAT_ROOM")
@Getter
@Setter
@NoArgsConstructor
public class CrewChatRoom {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "CREW_CHAT_ROOM_SEQ")
    @SequenceGenerator(name = "CREW_CHAT_ROOM_SEQ", sequenceName = "CREW_CHAT_ROOM_SEQ", allocationSize = 1)
    @Column(name = "chat_room_id")
    private Long chatRoomId;

    @Column(name = "room_type", nullable = false, columnDefinition = "NUMBER(1)")
    private Integer roomType;

    @Column(name = "room_name", length = 200)
    private String roomName;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "reference_idx")
    private Crew crew; 

    @CreationTimestamp
    @Column(name = "created_date", updatable = false)
    private LocalDateTime createdDate;
    
    @Builder
    public CrewChatRoom(Integer roomType, String roomName, Crew crew) {
        this.roomType = roomType;
        this.roomName = roomName;
        this.crew = crew;
    }
}
