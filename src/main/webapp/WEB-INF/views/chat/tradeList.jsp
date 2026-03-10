<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>채팅 목록</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<style>
    body { font-family: 'Noto Sans KR', sans-serif; background: #f4f6f8; margin: 0; padding: 0; }
    .header { background: #fff; padding: 15px 20px; font-weight: bold; font-size: 16px; border-bottom: 1px solid #ddd; position: sticky; top: 0; z-index: 100;}
    .list-container { padding: 10px; display: flex; flex-direction: column; }
    .room-item { display: flex; align-items: center; background: #fff; padding: 15px; border-radius: 12px; margin-bottom: 10px; cursor: pointer; box-shadow: 0 2px 5px rgba(0,0,0,0.05); transition: 0.2s;}
    .room-item:hover { background: #f9f9f9; }
    .profile { width: 50px; height: 50px; border-radius: 50%; object-fit: cover; margin-right: 15px; border: 1px solid #eee; }
    .info { flex: 1; overflow: hidden; }
    .top-row { display: flex; justify-content: space-between; margin-bottom: 5px; }
    .nickname { font-weight: bold; font-size: 15px; color: #333; }
    .date { font-size: 12px; color: #999; }
    .bottom-row { display: flex; justify-content: space-between; align-items: center; }
    .recent-msg { font-size: 13px; color: #666; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 85%; }
    .badge { background: #00B050; color: #fff; border-radius: 10px; padding: 2px 8px; font-size: 11px; font-weight: bold; }
    .empty-msg { text-align: center; color: #888; margin-top: 50px; font-size: 14px;}
    .custom-context-menu { position: absolute; background: white; border: 1px solid #ddd; box-shadow: 0 4px 15px rgba(0,0,0,0.1); border-radius: 8px; padding: 8px 0; z-index: 1000; width: 160px; font-size: 14px; display: none; }
    .custom-context-menu .menu-item { padding: 10px 15px; cursor: pointer; color: #333; transition: background 0.2s; }
    .custom-context-menu .menu-item:hover { background: #f4f6f8; }
</style>
</head>
<body>
    <div class="header">이 거래글의 채팅 목록</div>
    
    <div class="list-container" id="listContainer">
        <c:if test="${empty list}">
            <div class="empty-msg">아직 이 거래글에 대한 채팅이 없습니다.</div>
        </c:if>
        
        <c:forEach var="room" items="${list}">
            <div class="room-item" id="room-${room.roomIdx}" 
                 data-room-idx="${room.roomIdx}" data-trade-idx="${room.tradeIdx}" data-user-idx="${room.userIdx}"
                 onclick="location.href='${pageContext.request.contextPath}/chat/room?tradeIdx=${room.tradeIdx}&toUserIdx=${room.userIdx}'">
                
                <img src="${empty room.profilePhoto ? pageContext.request.contextPath += '/dist/images/person.png' : pageContext.request.contextPath += '/uploads/profile/' += room.profilePhoto}" class="profile" onerror="this.src='${pageContext.request.contextPath}/dist/images/person.png'">
                
                <div class="info">
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

    <div id="contextMenu" class="custom-context-menu">
        <div class="menu-item" onclick="menuAction('open')">채팅방 열기</div>
        <div class="menu-item" style="color:#e74c3c;" onclick="menuAction('leave')">삭제하기</div>
    </div>

<script>
    const myUserIdx = ${myUserIdx};
    let stompClient = null;

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

        document.getElementById('msg-' + roomIdx).innerText = message.content;

        let now = new Date();
        let timeStr = String(now.getMonth()+1).padStart(2,'0') + "-" + String(now.getDate()).padStart(2,'0') + " " + String(now.getHours()).padStart(2, '0') + ':' + String(now.getMinutes()).padStart(2, '0');
        document.getElementById('date-' + roomIdx).innerText = timeStr;

        if(message.userIdx !== myUserIdx) {
            let badge = document.getElementById('badge-' + roomIdx);
            let count = parseInt(badge.innerText || '0') + 1;
            badge.innerText = count;
            badge.style.display = 'inline-block';
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
            location.href = '${pageContext.request.contextPath}/chat/room?tradeIdx=' + selectedTradeIdx + '&toUserIdx=' + selectedUserIdx;
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

    window.onload = function() { connectList(); };
</script>
</body>
</html>