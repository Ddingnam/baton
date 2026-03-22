package com.sp.app.model;

import lombok.Data;

@Data
public class JobProfile {
    private long   profileIdx;    // PROFILEIDX
    private long   userIdx;       // USERIDX
    private String photoUrl;      // PHOTOURL
    private String userName;      // NAME
    private String phone;         // TEL
    private String email;         // EMAIL
    private String gender;        // GENDER  (M/F)
    private String birth;         // BIRTH
    private String introduce;     // INTRODUCTION (CLOB)
    private String strengths;     // STRENGTHS
    private String additionalInfo;// ADDITIONALINFO
    private int    profileStatus; // PROFILESTATUS
    private String title;         // PROFILETITLE
    private String isDefault;     // ISDEFAULT (Y/N)
    private String isPublic;      // ISPUBLIC  (Y/N)
    private String createdDate;   // CREATEDDATE
    private String updatedDate;   // UPDATEDDATE
}
