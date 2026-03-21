package com.sp.app.admin.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AdminTodo {
    private Long todoIdx;
    private Long adminIdx;
    private String content;
    private int isDone;
    private int sortOrder;
    private String createdAt;
    private String updatedAt;
}