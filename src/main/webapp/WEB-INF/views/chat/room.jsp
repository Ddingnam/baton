<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>바톤 채팅방</title>
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<style>
    body, html { margin: 0; padding: 0; height: 100%; background: #fff; font-family: 'Noto Sans KR', sans-serif; }
    .chat-container { width: 100%; height: 100vh; display: flex; flex-direction: column; background: #fff; }
    .chat-header { display: flex; justify-content: space-between; align-items: center; padding: 15px 20px; font-size: 16px; background: #fff; position: relative; z-index: 10; border-bottom: 1px solid #f0f0f0;}
    .header-left i { font-size: 24px; cursor: pointer; color: #333; }
    .header-center { flex: 1; text-align: center; font-weight: 700; color: #333; }
    .header-right { width: 24px; } 
    .trade-banner { display: flex; padding: 12px 20px; background: #fafafa; border-bottom: 1px solid #eee; align-items: center; }
    .trade-thumb { width: 45px; height: 45px; border-radius: 8px; background: #ddd; margin-right: 12px; object-fit: cover; border: 1px solid #eee;}
    .trade-info { flex: 1; display: flex; flex-direction: column; }
    .trade-title { font-size: 14px; font-weight: bold; color: #333; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 250px;}
    .trade-date { font-size: 12px; color: #888; margin-top: 3px; }
    .alba-badge { display: inline-block; background: #e3f2fd; color: #1976d2; font-size: 11px; padding: 2px 6px; border-radius: 4px; margin-bottom: 4px; font-weight: 600; width: fit-content; }
    .chat-messages { flex: 1; overflow-y: auto; padding: 20px; background: #fff; } 
    .date-divider { text-align: center; margin: 20px 0; }
    .date-divider span { background: #f0f0f0; color: #666; font-size: 12px; padding: 5px 15px; border-radius: 15px; }
    .system-msg { text-align: center; margin-bottom: 20px; color: #888; font-size: 13px; }
    .msg-row { margin-bottom: 15px; display: flex; align-items: flex-end; }
    .msg-me { justify-content: flex-end; }
    .msg-other { justify-content: flex-start; }
    .msg-bubble { padding: 10px 14px; border-radius: 14px; max-width: 75%; word-break: break-all; font-size: 14px; line-height: 1.4; }
    .msg-me .msg-bubble { background: #00B050; color: #fff; border-bottom-right-radius: 4px; }
    .msg-other .msg-bubble { background: #f4f6f8; color: #333; border-bottom-left-radius: 4px; } 
    .msg-info { display: flex; flex-direction: column; justify-content: flex-end; margin: 0 6px; padding-bottom: 2px; }
    .msg-time { font-size: 11px; color: #999; }
    .unread-count { color: #00B050; font-weight: bold; font-size: 11px; text-align: right; margin-bottom: 2px; }
    .profile-img { width: 36px; height: 36px; border-radius: 50%; margin-right: 10px; object-fit: cover; border: 1px solid #eaeaea; }
    .nickname { font-size: 12px; margin-bottom: 4px; color: #555; }
    .chat-input-box { display: flex; padding: 15px; background: #fff; border-top: 1px solid #eee; align-items: center; }
    .chat-input-box textarea { flex: 1; padding: 12px 15px; border: 1px solid #f0f0f0; background: #f8f9fa; border-radius: 20px; outline: none; resize: none; overflow: hidden; height: 44px; line-height: 20px; font-family: inherit; font-size: 14px;}
    .chat-input-box textarea:focus { border-color: #00B050; background: #fff; }
    .chat-input-box button { width: 44px; height: 44px; margin-left: 10px; border: none; background: #00B050; color: white; border-radius: 50%; cursor: pointer; display: flex; justify-content: center; align-items: center; transition: 0.2s; }
  
	.alba-theme .msg-me .msg-bubble { background: #3182f6; color: #fff; } 
	.alba-theme .chat-input-box button { background: #3182f6; } 
	.alba-theme .unread-count { color: #3182f6; } 
	.alba-theme .trade-banner { background: #f0f7ff; border-bottom: 1px solid #dce9f9; } 
	.alba-theme .trade-info { flex-direction: row; align-items: center; justify-content: space-between; } 
	.alba-theme .alba-badge { background: #3182f6; color: #fff; padding: 3px 8px; border-radius: 4px; font-size: 11px; font-weight: 700; margin-right: 8px; }
	 
</style>
</head>
<body>
    <div class="chat-container ${not empty albaInfo ? 'alba-theme' : ''}">
        <div class="chat-header">
            <div class="header-left" onclick="goBack()">
                <i class="ri-arrow-left-s-line"></i>
            </div>
            <div class="header-center">${counterpartName}</div>
            <div class="header-right" style="position:relative;">
                <i class="ri-more-2-fill" style="font-size: 24px; cursor: pointer; color: #333;" onclick="toggleMenu()"></i>
                <div id="roomMenu" style="display:none; position:absolute; right:0; top:35px; background:#fff; border:1px solid #ddd; box-shadow:0 2px 10px rgba(0,0,0,0.1); border-radius:8px; z-index:100; width:120px;">
                    <div onclick="leaveRoom()" style="padding:12px 15px; color:#e74c3c; cursor:pointer; font-size:14px; text-align:center;">삭제하기</div>
                </div>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty tradeInfo}">
                <div class="trade-banner">
                    <c:choose>
                        <c:when test="${not empty tradeInfo.SAVENAME}">
                            <img src="${pageContext.request.contextPath}/uploads/trade/${tradeInfo.SAVENAME}" class="trade-thumb" onerror="this.src='${pageContext.request.contextPath}/dist/images/noimage.png'">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/dist/images/noimage.png" class="trade-thumb">
                        </c:otherwise>
                    </c:choose>
                    <div class="trade-info">
                        <span class="trade-title">${tradeInfo.TITLE}</span>
                        <span class="trade-date">작성일: ${tradeInfo.CREATEDDATE}</span>
                    </div>
                </div>
            </c:when>
            <c:when test="${not empty albaInfo}">
			    <div class="trade-banner">
			        <div class="trade-info">
			            <span class="alba-badge">알바 문의</span>
			            <span class="trade-title" style="font-size: 16px;">${albaInfo.TITLE}</span>
			            <div style="margin-top: 5px;">
			                <span style="color: #3182f6; font-weight: 700;">
			                    <i class="ri-money-dollar-circle-line"></i> ${albaInfo.PAY}원
			                </span>
			                <span class="trade-date" style="margin-left: 10px;">등록일: ${albaInfo.CREATEDDATE}</span>
			            </div>
			        </div>
			    </div>
			</c:when>
        </c:choose>

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
                                    <span class="unread-count"><c:if test="${chat.unreadCount > 0}">${chat.unreadCount}</c:if></span>
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

<script>
    const currentRoomIdx = ${roomIdx};
    const myUserIdx = ${userIdx};
    let stompClient = null;
    let currentDisplayDate = "${lastDate}";

    const urlParams = new URLSearchParams(window.location.search);
    const tradeIdx = urlParams.get('tradeIdx');
    const albaIdx = urlParams.get('albaIdx');

    function connect() {
        let socket = new SockJS('${pageContext.request.contextPath}/ws/chat');
        stompClient = Stomp.over(socket);
        stompClient.debug = null; 
        
        stompClient.connect({}, function (frame) {
            stompClient.subscribe('/topic/room/' + currentRoomIdx, function (chat) {
                let message = JSON.parse(chat.body);
                if(message.msgType === 4) {
                    if(message.userIdx !== myUserIdx) removeUnreadCounts();
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
        let timeStr = String(now.getHours()).padStart(2, '0') + ':' + String(now.getMinutes()).padStart(2,'0');

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
        if(isMe) html += '<div class="msg-info"><span class="unread-count">1</span><span class="msg-time">' + timeStr + '</span></div>';
        html += '<div class="msg-bubble">' + message.content.replace(/\n/g, '<br>') + '</div>';
        if(!isMe) html += '<div class="msg-info"><span class="msg-time">' + timeStr + '</span></div>';
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
    
    function goBack() {
        if(albaIdx) {
            location.href = '${pageContext.request.contextPath}/chat/albaList?albaIdx=' + albaIdx;
        } else if(tradeIdx) {
            location.href = '${pageContext.request.contextPath}/chat/tradeList?tradeIdx=' + tradeIdx;
        } else {
            location.href = '${pageContext.request.contextPath}/chat/list?mode=popup';
        }
    }
    
    function toggleMenu() {
        let menu = document.getElementById('roomMenu');
        menu.style.display = menu.style.display === 'none' ? 'block' : 'none';
    }

    function leaveRoom() {
        if(!confirm('채팅방을 삭제하시겠습니까?')) return;
        
        const params = new URLSearchParams();
        params.append('roomIdx', currentRoomIdx);
        
        fetch('${pageContext.request.contextPath}/chat/delete', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        })
        .then(response => response.json())
        .then(data => {
            if(data.state === 'true') goBack();
        });
    }

    window.onload = function() { connect(); };
</script>
</body>
</html>