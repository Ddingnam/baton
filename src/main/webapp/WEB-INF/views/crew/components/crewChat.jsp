<%@ page contentType="text/html; charset=UTF-8"%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/crew/crew_chat.css">

<template id="crew-chat-template">
    <div class="chat-panel-container">
        
        <div v-if="currentView === 'list'" class="chat-view-wrapper">
            <header class="chat-header">
                <h2 class="chat-header-title">크루 채팅</h2>
                <button class="btn-close-chat" @click="$emit('close-chat')">
                    <i class="ri-close-line"></i>
                </button>
            </header>

            <div class="chat-list-area">
                <div class="chat-list-item" @click="goToRoom(1)">
                    <div class="chat-crew-profile">B</div>
                    <div class="chat-room-info">
                        <div class="chat-room-name">BATON 메인 크루</div>
                        <div class="chat-room-last-msg">저는 8시 이후로 가능할 것 같습니다! 어디서 뵐까요?</div>
                    </div>
                </div>
                
                <div class="chat-list-item" @click="goToRoom(2)">
                    <div class="chat-crew-profile" style="background: var(--text-main);">런</div>
                    <div class="chat-room-info">
                        <div class="chat-room-name">한강 야간 러닝 크루</div>
                        <div class="chat-room-last-msg">오늘 비도 오는데 모임 취소할까요?</div>
                    </div>
                </div>
            </div>
        </div>

        <div v-else class="chat-view-wrapper">
            <header class="chat-header">
                <button class="btn-back" @click="goToList">
                    <i class="ri-arrow-left-s-line"></i>
                </button>
                <div class="chat-header-info">
                    <div class="chat-crew-meta">
                        <h2 class="chat-crew-name">BATON 메인 크루</h2>
                    </div>
                </div>
                <button class="btn-close-chat" @click="$emit('close-chat')">
                    <i class="ri-close-line"></i>
                </button>
            </header>

            <div class="chat-message-area">
                <div class="chat-message-row received">
                    <div class="chat-user-avatar">이웃</div>
                    <div class="chat-message-content">
                        <div class="chat-user-name">동네이웃1</div>
                        <div class="chat-bubble">
                            안녕하세요! 오늘 저녁에 다들 시간 어떠신가요?
                        </div>
                    </div>
                    <span class="chat-time">오후 6:30</span>
                </div>

                <div class="chat-message-row sent">
                    <div class="chat-message-content">
                        <div class="chat-bubble">
                            저는 8시 이후로 가능할 것 같습니다! 어디서 뵐까요?
                        </div>
                    </div>
                    <span class="chat-time">오후 6:35</span>
                </div>
            </div>

            <div class="chat-input-area">
                <input type="text" class="chat-input-field" placeholder="메시지를 입력하세요...">
                <button class="btn-send-message">
                    <i class="ri-send-plane-fill"></i>
                </button>
            </div>
        </div>

    </div>
</template>