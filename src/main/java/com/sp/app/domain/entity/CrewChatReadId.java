package com.sp.app.domain.entity;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class CrewChatReadId implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long chatRoom;
    private Long user;
}