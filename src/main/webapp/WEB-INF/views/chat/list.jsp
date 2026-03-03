<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>내 채팅방 | BATON</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />

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
</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <div class="container chat-list-wrapper">
        <h2 class="page-title">내 채팅방 목록</h2>

        <div class="list-container" id="listContainer">
            <c:if test="${empty list}">
                <div class="empty-msg">
                    <i class="ri-chat-3-line"></i>
                    진행 중인 대화가 없습니다.<br>새로운 이웃과 따뜻한 거래를 시작해보세요!
                </div>
            </c:if>

            <c:forEach var="room" items="${list}">
                <div class="room-item" id="room-${room.roomIdx}" onclick="openChatRoom(${room.tradeIdx}, ${room.userIdx})">
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

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

    <script>
        const myUserIdx = ${myUserIdx};
        let stompClient = null;

        function openChatRoom(tradeIdx, userIdx) {
            let url = '${pageContext.request.contextPath}/chat/room?tradeIdx=' + tradeIdx + '&toUserIdx=' + userIdx;
            window.open(url, 'chatRoom', 'width=450, height=700, left=200, top=100, scrollbars=yes, resizable=yes');
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

        window.onload = function() { 
            connectList(); 
        };
    </script>
</body>
</html>