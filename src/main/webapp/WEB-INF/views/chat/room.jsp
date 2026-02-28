<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>채팅방</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />

<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<style>
    .chat-wrapper { display: flex; justify-content: center; padding: 20px; }
    .chat-container { width: 100%; max-width: 600px; height: 700px; border: 1px solid #ddd; border-radius: 10px; display: flex; flex-direction: column; background: #fff; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
    .chat-header { background: #f8f9fa; padding: 15px; text-align: center; font-weight: bold; font-size: 16px; border-bottom: 1px solid #ddd; }
    .chat-messages { flex: 1; overflow-y: auto; padding: 15px; background: #b2c7d9; }
    .chat-input-box { display: flex; padding: 15px; background: #fff; border-top: 1px solid #ddd; }
    .chat-input-box input { flex: 1; padding: 10px; border: 1px solid #ccc; border-radius: 5px; outline: none; }
    .chat-input-box button { padding: 10px 20px; margin-left: 10px; border: none; background: #00B050; color: white; border-radius: 5px; cursor: pointer; font-weight: bold; }
    
    .msg-row { margin-bottom: 15px; display: flex; align-items: flex-end; }
    .msg-me { justify-content: flex-end; }
    .msg-other { justify-content: flex-start; }
    .msg-bubble { background: #fff; padding: 10px 15px; border-radius: 10px; max-width: 70%; word-break: break-all; font-size: 14px; }
    .msg-me .msg-bubble { background: #ffeb33; }
    .msg-time { font-size: 11px; color: #555; margin: 0 5px; }
    .unread-count { color: #fce205; font-weight: bold; font-size: 12px; margin: 0 5px; }
    .profile-img { width: 40px; height: 40px; border-radius: 50%; margin-right: 10px; object-fit: cover; }
    .nickname { font-size: 12px; margin-bottom: 4px; color: #333; }
</style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <div class="container d-flex" style="margin-top: 20px;">
        
        <jsp:include page="/WEB-INF/views/layout/left.jsp" />

        <main class="flex-grow-1 ms-3">
            <div class="chat-wrapper">
                <div class="chat-container">
                    <div class="chat-header">거래 채팅방</div>
                    
                    <div class="chat-messages" id="chatArea">
                        <c:forEach var="chat" items="${chatList}">
                            <div class="msg-row ${chat.userIdx == userIdx ? 'msg-me' : 'msg-other'}">
                                <c:if test="${chat.userIdx != userIdx}">
                                    <img src="${pageContext.request.contextPath}/uploads/profile/${chat.profilePhoto}" class="profile-img" onerror="this.src='${pageContext.request.contextPath}/dist/images/person.png'">
                                </c:if>
                                <div>
                                    <c:if test="${chat.userIdx != userIdx}">
                                        <div class="nickname">${chat.nickname}</div>
                                    </c:if>
                                    <div style="display: flex; align-items: flex-end;">
                                        <c:if test="${chat.userIdx == userIdx}">
                                            <span class="unread-count unread-${chat.msgIdx}">1</span>
                                            <span class="msg-time">${chat.sendDate}</span>
                                        </c:if>
                                        <div class="msg-bubble">${chat.content}</div>
                                        <c:if test="${chat.userIdx != userIdx}">
                                            <span class="msg-time">${chat.sendDate}</span>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="chat-input-box">
                        <input type="text" id="chatInput" placeholder="메시지를 입력하세요" onkeypress="if(event.keyCode==13) sendMessage();">
                        <button onclick="sendMessage()">전송</button>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
    const currentRoomIdx = ${roomIdx};
    const myUserIdx = ${userIdx};
    let stompClient = null;

    function connect() {
        let socket = new SockJS('${pageContext.request.contextPath}/ws/chat');
        stompClient = Stomp.over(socket);
        stompClient.debug = null; 
        
        stompClient.connect({}, function (frame) {
            stompClient.subscribe('/topic/room/' + currentRoomIdx, function (chat) {
                let message = JSON.parse(chat.body);
                if(message.msgType === 4) {
                    removeUnreadCounts();
                } else {
                    appendMessage(message);
                    sendReadEvent();
                }
            });

            sendReadEvent();
            scrollToBottom();
        });
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
    }

    function sendReadEvent() {
        let readEvent = {
            roomIdx: currentRoomIdx,
            userIdx: myUserIdx,
            msgType: 4
        };
        stompClient.send("/app/chat/read", {}, JSON.stringify(readEvent));
    }

    function appendMessage(message) {
        let chatArea = document.getElementById("chatArea");
        let isMe = (message.userIdx === myUserIdx);
        let now = new Date();
        let timeStr = now.getHours().toString().padStart(2, '0') + ':' + now.getMinutes().toString().padStart(2, '0');

        let html = '<div class="msg-row ' + (isMe ? 'msg-me' : 'msg-other') + '">';
        
        if(!isMe) {    
            let photoPath = message.profilePhoto ? '${pageContext.request.contextPath}/uploads/profile/' + message.profilePhoto : '${pageContext.request.contextPath}/dist/images/person.png';
            html += '<img src="' + photoPath + '" class="profile-img" onerror="this.src=\'${pageContext.request.contextPath}/dist/images/person.png\'">';
            html += '<div><div class="nickname">' + (message.nickname || '상대방') + '</div>';
        } else {
            html += '<div>';
        }
        
        html += '<div style="display: flex; align-items: flex-end;">';
        
        if(isMe) {
            html += '<span class="unread-count">1</span>';
            html += '<span class="msg-time">' + timeStr + '</span>';
        }
        
        html += '<div class="msg-bubble">' + message.content + '</div>';
        
        if(!isMe) {
            html += '<span class="msg-time">' + timeStr + '</span>';
        }
        
        html += '</div></div></div>';
        
        chatArea.insertAdjacentHTML('beforeend', html);
        scrollToBottom();
    }

    function removeUnreadCounts() {
        let unreadElements = document.querySelectorAll('.unread-count');
        unreadElements.forEach(el => {
            el.innerText = '';
        });
    }

    function scrollToBottom() {
        let chatArea = document.getElementById("chatArea");
        chatArea.scrollTop = chatArea.scrollHeight;
    }

    window.onload = function() {
        connect();
    };
</script>

</body>
</html>