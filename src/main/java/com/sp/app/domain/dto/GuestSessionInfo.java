package com.sp.app.domain.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class GuestSessionInfo {
    private String authCode;
    private Long authCodeTime;
    private String targetEmail;
    private boolean isVerified; 
    private String verifiedEmail;

    private String completeUserId;
    private String completeNickname;

    private Long findUserIdx;
    
    private String linkedUserId;
    private String linkedUserEmail;
    
    private SnsUserDto snsUserDto;
    
    public void resetEmailAuth(String email, String code) {
        this.targetEmail = email;
        this.authCode = code;
        this.authCodeTime = System.currentTimeMillis();
        this.isVerified = false;
        this.verifiedEmail = null;
    }
    
    public void clearAll() {
        this.authCode = null;
        this.authCodeTime = null;
        this.targetEmail = null;
        this.isVerified = false;
        this.verifiedEmail = null;
        this.completeUserId = null;
        this.completeNickname = null;
        this.findUserIdx = null;
        this.linkedUserId = null;
        this.linkedUserEmail = null;
        this.snsUserDto = null;
    }
}
