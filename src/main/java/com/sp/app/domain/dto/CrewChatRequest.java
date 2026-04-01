package com.sp.app.domain.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

public class CrewChatRequest {

    // 1. 채팅방 생성 요청 (POST /api/chat/rooms)
    @Getter @Setter
    @NoArgsConstructor
    public static class Create {
        private Long crewIdx;     // 방이 속할 크루 ID
        private String roomName; // 채팅방 이름
        private Integer roomType; // 방 타입 (예: 1:공식, 2:번개 등)
    }

    // 2. 메시지 전송 요청 (POST /api/chat/rooms/{roomId}/messages)
    @Getter @Setter
    @NoArgsConstructor
    public static class Message {
        private Long userIdx;     // 보낸 사람 ID
        private String content;  // 메시지 내용
        private Integer msgType; // 메시지 타입 (1:텍스트, 2:이미지 등)
    }

    // 3. 읽음 지점 갱신 요청 (PUT /api/chat/rooms/{roomId}/read)
    @Getter @Setter
    @NoArgsConstructor
    public static class UpdateRead {
        private Long userIdx;        // 읽은 사람 ID
        private Long lastChatIdx;   // 마지막으로 읽은 메시지 ID
    }
}