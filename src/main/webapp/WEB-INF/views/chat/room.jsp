<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>바톤 채팅방</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<style>
    .chat-wrapper { display: flex; justify-content: center; padding: 20px; background: #f4f6f8; }
    .chat-container { width: 100%; max-width: 500px; height: 750px; display: flex; flex-direction: column; background: #fff; border-radius: 16px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); overflow: hidden; }
    .chat-header { background: #fff; padding: 15px 20px; text-align: center; font-weight: 700; font-size: 16px; border-bottom: 1px solid #eaeaea; color: #333; position: relative; z-index: 10;}
    .chat-messages { flex: 1; overflow-y: auto; padding: 20px; background: #f9fbfc; }
    
    .date-divider { text-align: center; margin: 20px 0; }
    .date-divider span { background: rgba(0,0,0,0.1); color: #666; font-size: 12px; padding: 4px 12px; border-radius: 12px; }
    .system-msg { text-align: center; margin-bottom: 20px; color: #888; font-size: 13px; }

    .msg-row { margin-bottom: 15px; display: flex; align-items: flex-end; }
    .msg-me { justify-content: flex-end; }
    .msg-other { justify-content: flex-start; }
    
    .msg-bubble { padding: 10px 14px; border-radius: 14px; max-width: 75%; word-break: break-all; font-size: 14px; line-height: 1.4; box-shadow: 0 1px 2px rgba(0,0,0,0.05); }
    .msg-me .msg-bubble { background: #00B050; color: #fff; border-bottom-right-radius: 4px; }
  
    .msg-other .msg-bubble { background: #fff; color: #333; border: 1px solid #eaeaea; border-bottom-left-radius: 4px; }
    
    .msg-info { display: flex; flex-direction: column; justify-content: flex-end; margin: 0 6px; padding-bottom: 2px; }
    .msg-time { font-size: 11px; color: #999; }
    .unread-count { color: #00B050; font-weight: bold; font-size: 11px; text-align: right; margin-bottom: 2px; }
    
    .profile-img { width: 36px; height: 36px; border-radius: 50%; margin-right: 10px; object-fit: cover; border: 1px solid #eaeaea; }
    .nickname { font-size: 12px; margin-bottom: 4px; color: #555; }

    .chat-input-box { display: flex; padding: 15px; background: #fff; border-top: 1px solid #eaeaea; align-items: center; }
    .chat-input-box textarea { flex: 1; padding: 10px 15px; border: 1px solid #ddd; border-radius: 20px; outline: none; resize: none; overflow: hidden; height: 42px; line-height: 20px; font-family: inherit; }
    .chat-input-box button { width: 42px; height: 42px; margin-left: 10px; border: none; background: #00B050; color: white; border-radius: 50%; cursor: pointer; display: flex; justify-content: center; align-items: center; transition: 0.2s; }
    .chat-input-box button:hover { background: #008f40; }
</style>
</head>
<body>

    <div class="chat-wrapper">
        <div class="chat-container">
            <div class="chat-header">
                ${counterpartName}님과의 거래
            </div>
            
            <div class="chat-messages" id="chatArea">
                <div class="system-msg"><b>${counterpartName}</b>님과 대화를 시작합니다.</div>

                <c:set var="lastDate" value="" />
                
                <c:forEach var="chat" items="${chatList}">
                    <c:set var="msgDate" value="${fn:substring(chat.sendDate, 0, 10)}" />
                    <c:set var="msgTime" value="${fn:substring(chat.sendDate, 11, 16)}" />

                    <c:if test="${msgDate != lastDate}">
                        <div class="date-divider"><span>${msgDate}</span></div>
                        <c:set var="lastDate" value="${msgDate}" />
                    </c:if>

                    <div class="msg-row ${chat.userIdx == userIdx ? 'msg-me' : 'msg-other'}">
                        <c:if test="${chat.userIdx != userIdx}">
                            <img src="${pageContext.request.contextPath}/uploads/profile/${chat.profilePhoto}" class="profile-img" onerror="this.src='${pageContext.request.contextPath}/dist/images/person.png'">
                        </c:if>
                        <div>
                            <c:if test="${chat.userIdx != userIdx}">
                                <div class="nickname">${counterpartName}</div>
                            </c:if>
                            <div style="display: flex; align-items: flex-end;">
                                <c:if test="${chat.userIdx == userIdx}">
                                    <div class="msg-info">
                                        <span class="unread-count">
											<c:if test="${chat.unreadCount > 0}">${chat.unreadCount}</c:if>
										</span>
                                        <span class="msg-time">${msgTime}</span>
                                    </div>
                                </c:if>
                                <div class="msg-bubble">${chat.content}</div>
                                <c:if test="${chat.userIdx != userIdx}">
                                    <div class="msg-info">
                                        <span class="msg-time">${msgTime}</span>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="chat-input-box">
                <textarea id="chatInput" placeholder="메시지 보내기..." onkeydown="handleEnter(event)"></textarea>
                <button onclick="sendMessage()"><i class="ri-send-plane-fill" style="font-size:18px;"></i></button>
            </div>
        </div>
    </div>

<script>
    const currentRoomIdx = ${roomIdx};
    const myUserIdx = ${userIdx};
    let stompClient = null;
    let currentDisplayDate = "${lastDate}"; 

    function connect() {
        let socket = new SockJS('${pageContext.request.contextPath}/ws/chat');
        stompClient = Stomp.over(socket);
        stompClient.debug = null; 
        
        stompClient.connect({}, function (frame) {
            stompClient.subscribe('/topic/room/' + currentRoomIdx, function (chat) {
                let message = JSON.parse(chat.body);
                
                if(message.msgType === 4) {
                    if(message.userIdx !== myUserIdx) {
                        removeUnreadCounts();
                    }
                } else {
                    appendMessage(message);
                    sendReadEvent();
                }
            });
          
            sendReadEvent();
            scrollToBottom();
        });
    }

    function handleEnter(e) {
        if(e.keyCode === 13 && !e.shiftKey) {
            e.preventDefault(); 
            sendMessage();
        }
    }

    function sendMessage() {
        let input = document.getElementById("chatInput");
        let content = input.value.trim();
        if(!content) return;

        let messageModel = {
            roomIdx: currentRoomIdx,
            userIdx: myUserIdx,
            content: content,
            msgType: 1
        };
        
        stompClient.send("/app/chat/send", {}, JSON.stringify(messageModel));
        input.value = '';
        input.focus();
    }

    function sendReadEvent() {
        let readEvent = { roomIdx: currentRoomIdx, userIdx: myUserIdx, msgType: 4 };
        stompClient.send("/app/chat/read", {}, JSON.stringify(readEvent));
    }

    function appendMessage(message) {
        let chatArea = document.getElementById("chatArea");
        let isMe = (message.userIdx === myUserIdx);
   
        let now = new Date();
        let dateStr = now.getFullYear() + "-" + String(now.getMonth()+1).padStart(2,'0') + "-" + String(now.getDate()).padStart(2,'0');
        let timeStr = String(now.getHours()).padStart(2, '0') + ':' + String(now.getMinutes()).padStart(2, '0');

        if(currentDisplayDate !== dateStr) {
            let dateHtml = '<div class="date-divider"><span>' + dateStr + '</span></div>';
            chatArea.insertAdjacentHTML('beforeend', dateHtml);
            currentDisplayDate = dateStr;
        }

        let html = '<div class="msg-row ' + (isMe ? 'msg-me' : 'msg-other') + '">';
        
        if(!isMe) {
            let photoPath = message.profilePhoto ? '${pageContext.request.contextPath}/uploads/profile/' + message.profilePhoto : '${pageContext.request.contextPath}/dist/images/person.png';
            html += '<img src="' + photoPath + '" class="profile-img" onerror="this.src=\'${pageContext.request.contextPath}/dist/images/person.png\'">';
            html += '<div><div class="nickname">${counterpartName}</div>';
        } else {
            html += '<div>';
        }
        
        html += '<div style="display: flex; align-items: flex-end;">';
        
        if(isMe) {
            html += '<div class="msg-info"><span class="unread-count">1</span><span class="msg-time">' + timeStr + '</span></div>';
        }
        html += '<div class="msg-bubble">' + message.content.replace(/\n/g, '<br>') + '</div>'; // 줄바꿈 처리
        if(!isMe) {
            html += '<div class="msg-info"><span class="msg-time">' + timeStr + '</span></div>';
        }
        html += '</div></div></div>';
        
        chatArea.insertAdjacentHTML('beforeend', html);
        scrollToBottom();
    }

    function removeUnreadCounts() {
        let unreadElements = document.querySelectorAll('.unread-count');
        unreadElements.forEach(el => el.innerText = '');
    }

    function scrollToBottom() {
        let chatArea = document.getElementById("chatArea");
        chatArea.scrollTop = chatArea.scrollHeight;
    }

    window.onload = function() { connect(); };
</script>
</body>
</html>