<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>BATON Studio · 직원 채팅</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@500;700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_chat.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
</head>
<body>

<div class="agency-layout" id="agencyLayout">
    <jsp:include page="/WEB-INF/views/admin/layout/left.jsp"/>

    <main class="agency-main chat-main-wrap">
        <div class="chat-layout">

            <div class="chat-rooms-panel">
                <div class="chat-panel-head">
                    <span class="chat-panel-title">직원 채팅</span>
                </div>

                <div class="chat-search-wrap">
                    <i class="ri-search-2-line"></i>
                    <input type="text" class="chat-search" id="roomSearch" placeholder="채널 검색">
                </div>

                <div class="chat-section-label">채널</div>

                <c:forEach var="room" items="${roomList}">
                    <div class="chat-room-item ${room.roomIdx == currentRoomIdx ? 'active' : ''}"
                         data-roomidx="${room.roomIdx}"
                         data-roomname="${room.roomName}">
                        <div class="chat-room-icon"><i class="ri-hashtag"></i></div>
                        <div class="chat-room-info">
                            <span class="chat-room-name">${room.roomName}</span>
                            <span class="chat-room-preview" id="preview-${room.roomIdx}">
                                <c:choose>
                                    <c:when test="${not empty room.recentMessage}">${room.recentMessage}</c:when>
                                    <c:otherwise>최근 메시지 없음</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <c:if test="${room.unreadCount > 0}">
                            <div class="chat-room-badge" id="badge-${room.roomIdx}">${room.unreadCount}</div>
                        </c:if>
                    </div>
                </c:forEach>

                <div class="chat-conn-status">
                    <span class="conn-dot disconnected" id="connDot"></span>
                    <span class="conn-label" id="connLabel">연결 중...</span>
                </div>
            </div>

            <div class="chat-main">
                <div class="chat-main-head">
                    <div class="chat-main-head-left">
                        <button class="chat-sidebar-toggle" id="chatSidebarToggle">
                            <i class="ri-menu-4-fill"></i>
                        </button>
                        <div class="chat-head-icon"><i class="ri-hashtag"></i></div>
                        <div>
                            <div class="chat-head-name" id="headRoomName">${currentRoomName}</div>
                            <div class="chat-head-sub">채널</div>
                        </div>
                    </div>
                    <div class="chat-main-head-right">
                        <button class="chat-head-btn" id="msgSearchBtn" title="메시지 검색">
                            <i class="ri-search-2-line"></i>
                        </button>
                        <button class="chat-head-btn active-head-btn" id="memberPanelToggle" title="멤버 목록">
                            <i class="ri-group-fill"></i>
                        </button>
                    </div>
                </div>

                <div class="chat-search-bar" id="msgSearchBar" style="display:none;">
                    <i class="ri-search-2-line"></i>
                    <input type="text" id="msgSearchInput" placeholder="메시지 검색...">
                    <button id="msgSearchClose"><i class="ri-close-line"></i></button>
                </div>

                <div class="chat-messages" id="chatArea">
                    <c:if test="${empty chatList}">
                        <div class="chat-empty-state" id="emptyState">
                            <i class="ri-chat-smile-3-line"></i>
                            <p>첫 메시지를 보내보세요!</p>
                        </div>
                    </c:if>

                    <c:set var="lastDate" value=""/>
                    <c:forEach var="chat" items="${chatList}">
                        <c:set var="msgDate" value="${fn:substring(chat.sendDate, 0, 10)}"/>
                        <c:set var="msgTime" value="${fn:substring(chat.sendDate, 11, 16)}"/>

                        <c:if test="${msgDate != lastDate}">
                            <div class="chat-date-divider"><span>${msgDate}</span></div>
                            <c:set var="lastDate" value="${msgDate}"/>
                        </c:if>

                        <c:choose>
                            <c:when test="${chat.userIdx == myUserIdx}">
                                <div class="chat-msg-group mine">
                                    <div class="chat-msg-body">
                                        <div class="chat-msg-meta right">
                                            <span class="chat-msg-time">${msgTime}</span>
                                            <span class="chat-msg-name">${myNickname}</span>
                                        </div>
                                        <div class="chat-bubble mine">${chat.content}</div>
                                    </div>
                                    <div class="chat-avt me">${fn:substring(myNickname, 0, 2)}</div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="chat-msg-group">
                                    <div class="chat-avt">${fn:substring(chat.nickname, 0, 2)}</div>
                                    <div class="chat-msg-body">
                                        <div class="chat-msg-meta">
                                            <span class="chat-msg-name">${chat.nickname}</span>
                                            <span class="chat-msg-time">${msgTime}</span>
                                        </div>
                                        <div class="chat-bubble">${chat.content}</div>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <div class="chat-typing-indicator" id="typingIndicator" style="display:none;">
                        <div class="typing-dots"><span></span><span></span><span></span></div>
                        <span class="typing-label" id="typingLabel"></span>
                    </div>
                </div>

                <div class="chat-input-area">
                    <div class="chat-input-wrap">
                        <label class="chat-attach-btn" title="파일 첨부">
                            <i class="ri-attachment-2"></i>
                            <input type="file" id="fileInput" style="display:none;" accept="image/*,.pdf,.doc,.docx,.xls,.xlsx">
                        </label>
                        <input type="text" class="chat-input" id="chatInput"
                               placeholder="#${currentRoomName}에 메시지 보내기"
                               autocomplete="off" autofocus maxlength="500">
                        <div class="chat-input-right">
                            <span class="char-counter" id="charCounter" style="display:none;"></span>
                            <button class="chat-emoji-btn" id="emojiBtn" title="이모지">
                                <i class="ri-emoji-sticker-line"></i>
                            </button>
                            <button class="chat-send-btn" id="chatSend">
                                <i class="ri-send-plane-fill"></i>
                            </button>
                        </div>
                    </div>
                    <div class="file-preview-bar" id="filePreviewBar" style="display:none;">
                        <i class="ri-file-line"></i>
                        <span id="filePreviewName"></span>
                        <button id="filePreviewRemove"><i class="ri-close-line"></i></button>
                    </div>
                    <div class="emoji-picker" id="emojiPicker" style="display:none;">
                        <span>😊</span><span>👍</span><span>🎉</span><span>❤️</span><span>😂</span>
                        <span>🔥</span><span>👏</span><span>💯</span><span>🙏</span><span>✅</span>
                        <span>⚠️</span><span>📌</span><span>📋</span><span>💬</span><span>🚀</span>
                        <span>😅</span><span>🤔</span><span>😎</span><span>🥳</span><span>😴</span>
                    </div>
                </div>
            </div>

            <div class="chat-member-panel" id="memberPanel">
                <div class="chat-member-head">
                    멤버
                    <span class="member-count-badge">${fn:length(memberList)}</span>
                </div>
                <div class="chat-member-section-label">전체 직원</div>
                <c:forEach var="member" items="${memberList}">
                    <div class="chat-member-item" id="member-${member.userIdx}">
                        <div class="chat-dm-avt ${member.userIdx == myUserIdx ? 'online' : 'away'}"
                             id="avt-${member.userIdx}">
                            ${fn:substring(member.nickname, 0, 2)}
                        </div>
                        <div class="chat-member-info">
                            <span class="chat-member-name">
                                ${member.nickname}<c:if test="${member.userIdx == myUserIdx}"> (나)</c:if>
                            </span>
                            <span class="chat-member-role">${member.authority}</span>
                        </div>
                    </div>
                </c:forEach>
            </div>

        </div>
    </main>
</div>

<script>
var CHAT_CTX      = '${pageContext.request.contextPath}';
var CHAT_MY_IDX   = Number('${myUserIdx}');
var CHAT_MY_NAME  = '${myNickname}';
var CHAT_ROOM_IDX = Number('${currentRoomIdx}');
</script>
<script src="${pageContext.request.contextPath}/dist/js/admin/admin_chat.js"></script>

</body>
</html>