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
                <div class="chat-list-item" v-for="room in rooms" :key="room.chatRoomId" @click="goToRoom(room.chatRoomId, room.roomName)">
                    <div class="chat-crew-profile">{{ room.roomName.charAt(0) }}</div>
                    <div class="chat-room-info">
                        <div class="chat-room-name">{{ room.roomName }}</div>
                        <div class="chat-room-last-msg">{{ room.lastMessage || '대화 내역이 없습니다.' }}</div>
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
                        <h2 class="chat-crew-name">{{ currentRoomName }}</h2>
                    </div>
                </div>
				<div class="chat-header-actions">
		            <button class="chat-btn-action" @click="toggleParticipants" title="참여자 목록">
		                <i class="ri-group-line"></i>
		            </button>
		            <button class="chat-btn-action chat-btn-leave" @click="leaveRoom" title="방 나가기">
		                <i class="ri-logout-box-r-line"></i>
		            </button>
		            <button class="btn-close-chat" @click="$emit('close-chat')">
		                <i class="ri-close-line"></i>
		            </button>
		        </div>
            </header>

            <div class="chat-message-area" ref="messageArea">
                <div v-for="msg in messages" :key="msg.chatIdx" 
                     class="chat-message-row" 
                     :class="{'sent': msg.userIdx === currentUserIdx, 'received': msg.userIdx !== currentUserIdx}">
                    
                    <div v-if="msg.userIdx !== currentUserIdx" class="chat-user-avatar">
                        {{ msg.userNickname ? msg.userNickname.charAt(0) : '익' }}
                    </div>
                    
                    <div class="chat-message-content">
                        <div v-if="msg.userIdx !== currentUserIdx" class="chat-user-name">{{ msg.userNickname }}</div>
                        <div class="chat-bubble">
                            {{ msg.content }}
                        </div>
                    </div>
                    <span class="chat-time">{{ formatTime(msg.createdDate) }}</span>
                </div>
            </div>

            <div class="chat-input-area">
                <input type="text" class="chat-input-field" v-model="chatInput" @keyup.enter="sendMessage" placeholder="메시지를 입력하세요...">
                <button class="btn-send-message" @click="sendMessage">
                    <i class="ri-send-plane-fill"></i>
                </button>
            </div>
        </div>
		
		<div v-show="currentView === 'room'" 
             class="chat-participants-side-panel" 
             :class="{'active': showParticipants}">
             
            <div class="chat-participants-header">
                <h4 class="chat-participants-title">대화 참여자 ({{ participants.length }})</h4>
            </div>
            
            <ul class="chat-participants-list">
                <li v-for="p in participants" :key="p.userIdx" class="chat-participant-item">
                    <div class="chat-participant-avatar">{{ p.nickname ? p.nickname.charAt(0) : '익' }}</div>
                    <span class="chat-participant-name">{{ p.nickname }}</span>
                </li>
            </ul>
        </div>
    </div>
</template>