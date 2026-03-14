<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>내 채팅방 | BATON</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<style>
    .chat-list-wrapper { max-width: 800px; margin: 50px auto; min-height: 600px; }
    .page-title { font-size: 24px; font-weight: 700; margin-bottom: 25px; color: #333; }
    
    .room-item { display: flex; align-items: center; background: #fff; padding: 20px; border: 1px solid #eaeaea; border-radius: 16px; margin-bottom: 15px; cursor: pointer; transition: all 0.2s ease; box-shadow: 0 2px 8px rgba(0,0,0,0.02); }
    .room-item:hover { border-color: #00B050; box-shadow: 0 4px 15px rgba(0,176,80,0.08); transform: translateY(-2px); }
    
    .profile-area { position: relative; margin-right: 20px; width: 65px; height: 65px; }
    .profile { width: 100%; height: 100%; border-radius: 50%; object-fit: cover; border: 1px solid #eee; }
    .trade-thumb { position: absolute; bottom: -5px; right: -5px; width: 30px; height: 30px; border-radius: 8px; border: 2px solid #fff; object-fit: cover; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
    
    .info-area { flex: 1; overflow: hidden; }
    .top-row { display: flex; justify-content: space-between; margin-bottom: 8px; align-items: center;}
    .nickname { font-weight: 700; font-size: 16px; color: #333; }
    .trade-title { font-size: 13px; color: #888; margin-left: 8px; font-weight: normal; }
    .date { font-size: 13px; color: #aaa; }
    
    .bottom-row { display: flex; justify-content: space-between; align-items: center; }
    .recent-msg { font-size: 14px; color: #555; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 85%; }
    .badge { background: #00B050; color: #fff; border-radius: 12px; padding: 3px 10px; font-size: 12px; font-weight: bold; }
    
    .empty-msg { text-align: center; color: #888; padding: 120px 0; font-size: 16px; background: #f8f9fa; border-radius: 16px; border: 1px dashed #eaeaea;}
    .empty-msg i { font-size: 50px; color: #ddd; display: block; margin-bottom: 15px; }

    .custom-context-menu { position: absolute; background: white; border: 1px solid #ddd; box-shadow: 0 4px 15px rgba(0,0,0,0.1); border-radius: 8px; padding: 8px 0; z-index: 1000; width: 160px; font-size: 14px; display: none; }
    .custom-context-menu .menu-item { padding: 10px 15px; cursor: pointer; color: #333; transition: background 0.2s; }
    .custom-context-menu .menu-item:hover { background: #f4f6f8; }
    
    .tab-container { display: flex; border-bottom: 2px solid #eaeaea; margin-bottom: 20px; }
    .tab-btn { flex: 1; padding: 15px 0; background: none; border: none; font-size: 16px; font-weight: 700; color: #888; cursor: pointer; transition: 0.3s; position: relative; }
    .tab-btn.active { color: #333; }
    .tab-btn.active::after { content: ''; position: absolute; bottom: -2px; left: 0; width: 100%; height: 3px; background: #00B050; border-radius: 3px 3px 0 0; }
    .tab-content { display: none; }
    .tab-content.active { display: block; }
    .notif-item { padding: 20px; border: 1px solid #eaeaea; border-radius: 16px; margin-bottom: 15px; cursor: pointer; transition: all 0.2s ease; box-shadow: 0 2px 8px rgba(0,0,0,0.02); background: #fff; }
    .notif-item.unread { background: #F2FAF8; }
    .notif-item:hover { border-color: #00B050; transform: translateY(-2px); box-shadow: 0 4px 15px rgba(0,176,80,0.08); }
    .notif-type { font-size: 12px; color: #00B050; font-weight: 700; margin-bottom: 5px; }
    .notif-content { font-size: 15px; color: #333; margin-bottom: 8px; word-break: break-all; line-height: 1.4; }
    .notif-date { font-size: 12px; color: #999; }
</style>
</head>
<body>
    <c:choose>
        <c:when test="${param.mode == 'popup'}">
            <style>
                body { background: #f4f6f8 !important; }
                .chat-list-wrapper { margin: 0 !important; max-width: none !important; min-height: auto !important; padding: 0 !important; }
                .page-title { display: none !important; }
                .popup-header { background: #fff; padding: 15px 20px; font-weight: bold; font-size: 16px; border-bottom: 1px solid #ddd; position: sticky; top: 0; z-index: 100; }
                .list-container { padding: 10px !important; display: flex !important; flex-direction: column !important; }
                .room-item { box-shadow: 0 2px 5px rgba(0,0,0,0.05) !important; padding: 15px !important; border: none !important; margin-bottom: 10px !important; border-radius: 12px !important; }
                .profile-area { width: 50px !important; height: 50px !important; margin-right: 15px !important; }
                .trade-thumb { display: none !important; }
                .top-row { margin-bottom: 5px !important; }
                .nickname { font-size: 15px !important; }
                .trade-title { display: none !important; }
                .date { font-size: 12px !important; }
                .recent-msg { font-size: 13px !important; }
                .badge { padding: 2px 8px !important; font-size: 11px !important; border-radius: 10px !important; }
                
            </style>
            <div class="popup-header">내 채팅방 목록</div>
        </c:when>
        <c:otherwise>
            <jsp:include page="/WEB-INF/views/layout/header.jsp" />
        </c:otherwise>
    </c:choose>

    <div class="container chat-list-wrapper">
        <h2 class="page-title">내 소식</h2>

        <div class="tab-container">
            <button class="tab-btn active" onclick="switchTab('chat')">채팅</button>
            <button class="tab-btn" onclick="switchTab('notif')">알림 <span id="notifTabBadge" class="badge" style="display:none; background:#FF4D4F; margin-left:4px;">0</span></button>
        </div>

        <div id="chatTab" class="tab-content active">

        <div class="list-container" id="listContainer">
            <c:if test="${empty list}">
                <div class="empty-msg">
                    <i class="ri-chat-3-line"></i>
                    진행 중인 대화가 없습니다.<br>새로운 이웃과 따뜻한 거래를 시작해보세요!
                </div>
            </c:if>

            <c:forEach var="room" items="${list}">
                <div class="room-item" id="room-${room.roomIdx}" 
                     data-room-idx="${room.roomIdx}" data-trade-idx="${room.tradeIdx}" data-user-idx="${room.userIdx}"
                     onclick="openChatRoom(${room.tradeIdx}, ${room.userIdx})">
                    <div class="profile-area">
                        <img src="${empty room.profilePhoto ? pageContext.request.contextPath += '/dist/images/person.png' : pageContext.request.contextPath += '/uploads/profile/' += room.profilePhoto}" class="profile" onerror="this.src='${pageContext.request.contextPath}/dist/images/person.png'">
                        <img src="${empty room.tradeSaveName ? pageContext.request.contextPath += '/dist/images/noimage.png' : pageContext.request.contextPath += '/uploads/trade/' += room.tradeSaveName}" class="trade-thumb" onerror="this.src='${pageContext.request.contextPath}/dist/images/noimage.png'">
                    </div>

                    <div class="info-area">
                        <div class="top-row">
                            <div style="display:flex; align-items:center;">
                                <span class="nickname">${room.nickname}</span>
                                <span class="trade-title">${room.tradeTitle}</span>
                            </div>
                            <span class="date" id="date-${room.roomIdx}">${room.recentDate}</span>
                        </div>
                        <div class="bottom-row">
                            <span class="recent-msg" id="msg-${room.roomIdx}">${empty room.recentMessage ? '대화가 없습니다.' : room.recentMessage}</span>
                            <span class="badge" id="badge-${room.roomIdx}" style="${room.unreadCount > 0 ? '' : 'display:none;'}">${room.unreadCount}</span>
                        </div>
                    </div>
                </div>
            </c:forEach>
            </div> 
        </div> 
        
	<div id="notifTab" class="tab-content">
	    <div style="display:flex; justify-content:flex-end; gap:8px; margin-bottom:10px;">
	        <button onclick="markAllAsRead()" style="background:#f0f0f0; border:none; padding:6px 12px; border-radius:6px; cursor:pointer; color:#555; font-size:13px;">모두 읽음</button>
	        <button onclick="deleteAllNotifications()" style="background:#ffebe9; border:none; padding:6px 12px; border-radius:6px; cursor:pointer; color:#e74c3c; font-size:13px;">모두 삭제</button>
	    </div>
	    <div class="list-container" id="pageNotifList">
	    </div>
	</div>
		
	<div id="contextMenu" class="custom-context-menu">
        <div class="menu-item" onclick="menuAction('open')">채팅방 열기</div>
        <div class="menu-item" style="color:#e74c3c;" onclick="menuAction('leave')">삭제하기</div>
    </div>

    <c:if test="${param.mode != 'popup'}">
        <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
    </c:if>

<script>
const myUserIdx = ${myUserIdx};
let stompClient = null;

function openChatRoom(tradeIdx, userIdx) {
    let url = '${pageContext.request.contextPath}/chat/room?tradeIdx=' + tradeIdx + '&toUserIdx=' + userIdx;
    
    <c:choose>
        <c:when test="${param.mode == 'popup'}">
            location.href = url;
        </c:when>
        <c:otherwise>
            window.open(url, 'chatRoom', 'width=450, height=700, left=200, top=100, scrollbars=yes, resizable=yes');
        </c:otherwise>
    </c:choose>
}

function connectList() {
    let socket = new SockJS('${pageContext.request.contextPath}/ws/chat');
    stompClient = Stomp.over(socket);
    stompClient.debug = null; 

    stompClient.connect({}, function (frame) {
        <c:forEach var="room" items="${list}">
            stompClient.subscribe('/topic/room/${room.roomIdx}', function (chat) {
                let message = JSON.parse(chat.body);
                if(message.msgType !== 4) {
                    updateRoomListUI(${room.roomIdx}, message);
                } else {
                    if(message.userIdx === myUserIdx) {
                        let badge = document.getElementById('badge-${room.roomIdx}');
                        if(badge) {
                            badge.innerText = '0';
                            badge.style.display = 'none';
                        }
                    }
                }
            });
        </c:forEach>

        stompClient.subscribe('/topic/alarms/' + myUserIdx, function(msg) {
            let data = msg.body;
            if(data.startsWith('room_deleted:')) {
                let deletedRoomIdx = data.split(':')[1];
                let roomEl = document.getElementById('room-' + deletedRoomIdx);
                if(roomEl) {
                    roomEl.remove();
                }
                
                let listContainer = document.getElementById('listContainer');
                if(listContainer.children.length === 0) {
                    listContainer.innerHTML = '<div class="empty-msg"><i class="ri-chat-3-line"></i>진행 중인 대화가 없습니다.</div>';
                }
            }
        });
    });
}

function updateRoomListUI(roomIdx, message) {
    let roomEl = document.getElementById('room-' + roomIdx);
    if(!roomEl) return;

    let msgEl = document.getElementById('msg-' + roomIdx);
    if(msgEl) msgEl.innerText = message.content;

    let now = new Date();
    let timeStr = String(now.getMonth()+1).padStart(2,'0') + "-" + String(now.getDate()).padStart(2,'0') + " " + String(now.getHours()).padStart(2, '0') + ':' + String(now.getMinutes()).padStart(2, '0');
    
    let dateEl = document.getElementById('date-' + roomIdx);
    if(dateEl) dateEl.innerText = timeStr;

    if(message.userIdx !== myUserIdx) {
        let badge = document.getElementById('badge-' + roomIdx);
        if(badge) {
            let count = parseInt(badge.innerText || '0') + 1;
            badge.innerText = count;
            badge.style.display = 'inline-block';
        }
    }

    let container = document.getElementById('listContainer');
    container.insertBefore(roomEl, container.firstChild);
}

let selectedTradeIdx = null, selectedUserIdx = null, selectedRoomIdx = null;

document.querySelectorAll('.room-item').forEach(item => {
    item.addEventListener('contextmenu', function(e) {
        e.preventDefault(); 
        
        selectedTradeIdx = this.dataset.tradeIdx;
        selectedUserIdx = this.dataset.userIdx;
        selectedRoomIdx = this.dataset.roomIdx;
        
        let menu = document.getElementById('contextMenu');
        menu.style.display = 'block';
        menu.style.left = e.pageX + 'px';
        menu.style.top = e.pageY + 'px';
    });
});

document.addEventListener('click', function(e) {
    let menu = document.getElementById('contextMenu');
    if(menu) menu.style.display = 'none';
});

function menuAction(action) {
    if(action === 'open') {
        openChatRoom(selectedTradeIdx, selectedUserIdx);
    } else if(action === 'leave') {
        if(!confirm('채팅방을 삭제하시겠습니까?')) return;
        
        const params = new URLSearchParams();
        params.append('roomIdx', selectedRoomIdx);
        
        fetch('${pageContext.request.contextPath}/chat/delete', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        })
        .then(response => response.json())
        .then(data => {
            if(data.state === 'true') {
                location.reload();
            }
        });
    }
}

window.onload = function() { 
    connectList();
    updateTabBadges();
};

function switchTab(tabId) {
    document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
    document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));

    if(tabId === 'chat') {
        document.querySelectorAll('.tab-btn')[0].classList.add('active');
        document.getElementById('chatTab').classList.add('active');
    } else {
        document.querySelectorAll('.tab-btn')[1].classList.add('active');
        document.getElementById('notifTab').classList.add('active');
        loadPageNotifications();
    }
}

function loadPageNotifications() {
    fetch('${pageContext.request.contextPath}/api/notification/list')
    .then(res => res.json())
    .then(data => {
        let list = document.getElementById('pageNotifList');
        list.innerHTML = '';
        if(!data || data.length === 0) {
            list.innerHTML = '<div class="empty-msg"><i class="ri-notification-3-line"></i><br>새로운 알림이 없습니다.</div>';
        } else {
            data.forEach(n => {
                let unreadClass = n.isRead === 0 ? 'unread' : '';
                let html = '<div class="notif-item ' + unreadClass + '" onclick="readPageNotif(' + n.notifIdx + ', \'' + n.url + '\')">' +
                           '<div class="notif-type">' + n.notifType + '</div>' +
                           '<div class="notif-content">' + n.content + '</div>' +
                           '<div class="notif-date">' + n.createdAt + '</div>' +
                           '</div>';
                list.insertAdjacentHTML('beforeend', html);
            });
        }
        updateTabBadges();
    });
}

function notifyParent() {
    if (window.opener && !window.opener.closed) {
        if(typeof window.opener.checkUnreadAlarms === 'function') window.opener.checkUnreadAlarms();
        if(typeof window.opener.fetchNotifications === 'function') window.opener.fetchNotifications();
    }
}

function readPageNotif(notifIdx, url) {
    fetch('${pageContext.request.contextPath}/api/notification/read', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'notifIdx=' + notifIdx
    }).then(() => {
        notifyParent(); 
        if(url && url !== 'null' && url !== '') location.href = '${pageContext.request.contextPath}' + url;
        else loadPageNotifications();
    });
}

function markAllAsRead() {
    fetch('${pageContext.request.contextPath}/api/notification/readAll', { method: 'POST' })
    .then(() => { 
        notifyParent(); 
        loadPageNotifications(); 
    });
}

function deleteAllNotifications() {
    if(!confirm('모든 알림을 삭제하시겠습니까?')) return;
    fetch('${pageContext.request.contextPath}/api/notification/deleteAll', { method: 'POST' })
    .then(() => { 
        notifyParent();
        loadPageNotifications(); 
    });
}
    
</script>
</body>
</html>