<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>내 채팅방 | BATON</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<style>

    body, html { 
        margin: 0; padding: 0; height: 100%; 
        font-family: 'Pretendard', sans-serif; 
        background: #F4F6F8; 
        color: #191F28;
    }
    
    * { box-sizing: border-box; }

    ::-webkit-scrollbar { width: 6px; }
    ::-webkit-scrollbar-thumb { background: #D1D6DB; border-radius: 10px; }
    ::-webkit-scrollbar-track { background: transparent; }

    .chat-list-wrapper { 
        margin: 0; max-width: 100%; min-height: 100vh; padding: 0; 
        background: #F4F6F8;
    }

    .tab-container { 
        display: flex; 
        background: #fff;
        padding: 0 20px;
        border-bottom: 1px solid rgba(0,0,0,0.05);
        position: sticky;
        top: 60px; 
        z-index: 90;
    }

    .popup-mode .tab-container {
        top: 0;
    }
    
    .tab-btn { 
        flex: 1; 
        padding: 16px 0; 
        background: none; 
        border: none; 
        font-size: 16px; 
        font-weight: 600; 
        color: #8B95A1; 
        cursor: pointer; 
        transition: all 0.2s ease; 
        position: relative;
    }
    
    .tab-btn:hover { color: #4E5968; }
    .tab-btn.active { color: #191F28; font-weight: 800; }
    
    .tab-btn.active::after { 
        content: ''; 
        position: absolute; 
        bottom: 0; left: 0; 
        width: 100%; height: 3px; 
        background: #3182F6; 
        border-radius: 3px 3px 0 0;
    }
    
    .tab-content { display: none; padding: 16px 20px; }
    .tab-content.active { display: block; animation: fadeIn 0.3s ease; }
    
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(5px); }
        to { opacity: 1; transform: translateY(0); }
    }

    .room-item { 
        display: flex; 
        align-items: center; 
        background: #fff; 
        padding: 18px; 
        border: 1px solid rgba(0,0,0,0.03); 
        border-radius: 16px; 
        margin-bottom: 12px; 
        cursor: pointer; 
        transition: all 0.2s cubic-bezier(0.25, 0.8, 0.25, 1); 
        box-shadow: 0 2px 8px rgba(0,0,0,0.02); 
    }
    
    .room-item:hover { 
        border-color: rgba(49, 130, 246, 0.2); 
        box-shadow: 0 6px 16px rgba(0,0,0,0.06); 
        transform: translateY(-2px); 
    }
    
    .profile-area { 
        position: relative; 
        margin-right: 16px; 
        width: 52px; 
        height: 52px; 
        flex-shrink: 0;
    }
    
    .profile { 
        width: 100%; height: 100%; 
        border-radius: 20px; 
        object-fit: cover; 
        border: 1px solid rgba(0,0,0,0.05); 
    }
    
    .trade-thumb { 
        position: absolute; 
        bottom: -4px; right: -4px; 
        width: 24px; height: 24px; 
        border-radius: 8px; 
        border: 2px solid #fff; 
        object-fit: cover; 
        box-shadow: 0 2px 6px rgba(0,0,0,0.1); 
    }
    
    .info-area { flex: 1; min-width: 0; }
    
    .top-row { 
        display: flex; 
        justify-content: space-between; 
        align-items: center; 
        margin-bottom: 6px; 
    }
    
    .nickname { font-weight: 700; font-size: 15px; color: #191F28; }
    .date { font-size: 12px; color: #8B95A1; font-weight: 500; }
    
    .bottom-row { 
        display: flex; 
        justify-content: space-between; 
        align-items: center; 
    }
    
    .recent-msg { 
        font-size: 14px; color: #4E5968; 
        white-space: nowrap; overflow: hidden; text-overflow: ellipsis; 
        max-width: 85%; 
    }
    
    .badge { 
        background: #FF4D4F; color: #fff; 
        border-radius: 12px; padding: 2px 8px; 
        font-size: 11px; font-weight: 800; 
        box-shadow: 0 2px 6px rgba(255, 77, 79, 0.3);
    }

    .notif-action-row {
        display: flex; justify-content: flex-end; gap: 8px; margin-bottom: 12px;
    }
    
    .notif-action-btn {
        background: #fff; border: 1px solid #E5E8EB; 
        padding: 6px 12px; border-radius: 8px; 
        cursor: pointer; color: #4E5968; font-size: 13px; font-weight: 600;
        transition: all 0.2s; box-shadow: 0 1px 3px rgba(0,0,0,0.02);
    }
    
    .notif-action-btn:hover { background: #F9FAFB; border-color: #D1D6DB; color: #191F28; }
    .notif-action-btn.danger:hover { color: #FF4D4F; border-color: #FF4D4F; background: #FFF1F0; }

    .notif-item { 
        padding: 18px; 
        border: 1px solid rgba(0,0,0,0.03); 
        border-radius: 16px; 
        margin-bottom: 12px; 
        cursor: pointer; 
        transition: all 0.2s ease; 
        box-shadow: 0 2px 8px rgba(0,0,0,0.02); 
        background: #fff; 
        position: relative;
        overflow: hidden;
    }
    
    .notif-item.unread { 
        background: #F0F6FF; 
        border-color: rgba(49, 130, 246, 0.1);
    }
    .notif-item.unread::before {
        content: ''; position: absolute; top: 0; left: 0; width: 4px; height: 100%; background: #3182F6;
    }
    
    .notif-item:hover { transform: translateY(-2px); box-shadow: 0 6px 16px rgba(0,0,0,0.05); }
    
    .notif-type { font-size: 12px; color: #3182F6; font-weight: 800; margin-bottom: 6px; }
    .notif-content { font-size: 14.5px; color: #191F28; margin-bottom: 8px; word-break: keep-all; line-height: 1.5; font-weight: 500; }
    .notif-date { font-size: 12px; color: #8B95A1; }

    .empty-msg { 
        text-align: center; color: #8B95A1; padding: 100px 0; font-size: 15px; 
        background: transparent; font-weight: 500; line-height: 1.6;
    }
    .empty-msg i { font-size: 48px; color: #D1D6DB; display: block; margin-bottom: 16px; }

    .custom-context-menu { 
        position: absolute; background: white; border: 1px solid rgba(0,0,0,0.08); 
        box-shadow: 0 10px 24px rgba(0,0,0,0.1); border-radius: 12px; padding: 8px 0; 
        z-index: 1000; width: 140px; font-size: 14px; display: none; overflow: hidden;
    }
    .custom-context-menu .menu-item { 
        padding: 12px 16px; cursor: pointer; color: #333D4B; font-weight: 600; transition: background 0.2s; 
    }
    .custom-context-menu .menu-item:hover { background: #F2F4F6; color: #191F28; }
</style>
</head>
<body class="${param.mode == 'popup' ? 'popup-mode' : ''}">
    
    <c:choose>
        <c:when test="${param.mode == 'popup'}">
            </c:when>
        <c:otherwise>
            <jsp:include page="/WEB-INF/views/layout/header.jsp" />
        </c:otherwise>
    </c:choose>

    <div class="chat-list-wrapper">
        <div class="tab-container">
            <button class="tab-btn active" onclick="switchTab('chat')">채팅</button>
            <button class="tab-btn" onclick="switchTab('notif')">
                알림 <span id="notifTabBadge" class="badge" style="display:none; margin-left:4px;">0</span>
            </button>
        </div>

        <div id="chatTab" class="tab-content active">
            <div class="list-container" id="listContainer">
                <c:if test="${empty list}">
                    <div class="empty-msg">
                        <i class="ri-chat-smile-3-line"></i>
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
                                <span class="nickname">${room.nickname}</span>
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
            <div class="notif-action-row">
                <button class="notif-action-btn" onclick="markAllAsRead()"><i class="ri-check-double-line"></i> 모두 읽음</button>
                <button class="notif-action-btn danger" onclick="deleteAllNotifications()"><i class="ri-delete-bin-line"></i> 비우기</button>
            </div>
            <div class="list-container" id="pageNotifList"></div>
        </div>
    </div>
    
    <div id="contextMenu" class="custom-context-menu">
        <div class="menu-item" onclick="menuAction('open')"><i class="ri-chat-forward-line" style="margin-right:6px;"></i> 채팅방 열기</div>
        <div class="menu-item" style="color:#FF4D4F;" onclick="menuAction('leave')"><i class="ri-delete-bin-line" style="margin-right:6px;"></i> 삭제하기</div>
    </div>

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
                if(roomEl) roomEl.remove();
                
                let listContainer = document.getElementById('listContainer');
                if(listContainer.children.length === 0) {
                    listContainer.innerHTML = '<div class="empty-msg"><i class="ri-chat-smile-3-line"></i><br>진행 중인 대화가 없습니다.</div>';
                }
            }
        });
    });
}

function updateRoomListUI(roomIdx, message) {
    let roomEl = document.getElementById('room-' + roomIdx);
    if(!roomEl) return;
    
    let msgEl = document.getElementById('msg-' + roomIdx);
    if(msgEl) msgEl.innerText = (message.msgType === 5) ? '(사진)' : message.content;

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
            if(data.state === 'true') location.reload();
        });
    }
}

window.onload = function() { 
    connectList();
    loadPageNotifications();
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
        
        let unreadCount = 0;
        
        if(!data || data.length === 0) {
            list.innerHTML = '<div class="empty-msg"><i class="ri-notification-4-line"></i><br>새로운 알림이 없습니다.</div>';
        } else {
            data.forEach(n => {
                if(n.isRead === 0) unreadCount++;
                
                let unreadClass = n.isRead === 0 ? 'unread' : '';
                let html = '<div class="notif-item ' + unreadClass + '" onclick="readPageNotif(' + n.notifIdx + ', \'' + n.url + '\')">' +
                           '<div class="notif-type"><i class="ri-notification-3-fill" style="margin-right:4px;"></i>' + n.notifType + '</div>' +
                           '<div class="notif-content">' + n.content + '</div>' +
                           '<div class="notif-date">' + n.createdAt + '</div>' +
                           '</div>';
                list.insertAdjacentHTML('beforeend', html);
            });
        }
        
        let badge = document.getElementById('notifTabBadge');
        if(unreadCount > 0) {
            badge.innerText = unreadCount;
            badge.style.display = 'inline-block';
        } else {
            badge.style.display = 'none';
        }
        notifyParent();
    });
}

function notifyParent() {
    if (window.opener && !window.opener.closed) {
        if(typeof window.opener.checkUnreadAlarms === 'function') window.opener.checkUnreadAlarms();
    }
}

function readPageNotif(notifIdx, url) {
    fetch('${pageContext.request.contextPath}/api/notification/read', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'notifIdx=' + notifIdx
    }).then(() => {
        if(url && url !== 'null' && url !== '') {
            if (window.opener && !window.opener.closed) {
                window.opener.location.href = '${pageContext.request.contextPath}' + url;
                window.close(); 
            } else {
                location.href = '${pageContext.request.contextPath}' + url;
            }
        }
        else loadPageNotifications();
    });
}

function markAllAsRead() {
    fetch('${pageContext.request.contextPath}/api/notification/readAll', { method: 'POST' })
    .then(() => { loadPageNotifications(); });
}

function deleteAllNotifications() {
    if(!confirm('모든 알림을 비우시겠습니까?')) return;
    fetch('${pageContext.request.contextPath}/api/notification/deleteAll', { method: 'POST' })
    .then(() => { loadPageNotifications(); });
}
</script>
</body>
</html>