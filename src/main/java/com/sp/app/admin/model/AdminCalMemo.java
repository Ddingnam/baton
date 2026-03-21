package com.sp.app.admin.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AdminCalMemo {
    private Long memoIdx;
    private Long adminIdx;
    private String memoDate;
    private String content;
    private String createdAt;
    private String updatedAt;
}