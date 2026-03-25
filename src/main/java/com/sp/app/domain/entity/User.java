package com.sp.app.domain.entity;

import java.time.LocalDate;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Table(name = "Users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "user_seq")
    @SequenceGenerator(name = "user_seq", sequenceName = "user_seq", allocationSize = 1)
    @Column(name = "useridx")
    private Long userIdx;
    
    @Column(name = "userid", nullable = false, length = 100)
    private String userId;
    
    @Column(nullable = false)
    private String pwd;

    @Column(nullable = false, length = 50)
    private String name;

    @Column(nullable = false, length = 50)
    private String nickname;

    @Column(nullable = false, length = 100)
    private String email;
    
    @Column(nullable = false, length = 20)
    private String tel;
    
    @Column(name = "profile_photo", length = 1000)
    private String profilePhoto;
    
    @Column(nullable = false)
    private LocalDate birth;
    
    @Column(name = "score", columnDefinition = "NUMBER(5, 2) DEFAULT 0")
    private Double score;

    @Column(name = "userlevel")
    private Integer userLevel;

    @Column(name = "createddate")
    private LocalDateTime createdDate;
    
    @Column(name = "updateddate")
    private LocalDateTime updatedDate;

    @Column(name = "lastlogindate")
    private LocalDateTime lastLoginDate;

    @Column(name = "pwdfailcount")
    private Integer pwdFailCount;

    @Column(name = "status")
    private Integer status;

    private Long batonpoint;

    @Column(name = "isOnline")
    private Integer isOnline;
    
    @Column(length = 20)
    private String userTheme;
}

