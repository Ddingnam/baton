<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>BATON Studio · 채팅</title>
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

            
            <div class="chat-rooms-panel" id="chatRoomsPanel">

                <div class="chat-panel-head">
                    <div class="chat-workspace-name">
                        <div class="chat-ws-icon"><i class="ri-baton-line" style="font-size:13px;">B</i></div>
                        <span>BATON Studio</span>
                    </div>
                    <button class="chat-head-icon-btn" id="newDmBtn" title="새 DM">
                        <i class="ri-message-3-line"></i>
                    </button>
                </div>

                <div class="chat-search-wrap">
                    <i class="ri-search-2-line"></i>
                    <input type="text" class="chat-search" id="roomSearch" placeholder="채널 · 멤버 검색">
                </div>

                
                <div class="chat-section-header" id="channelSectionHeader">
                    <button class="chat-section-toggle" id="channelToggle">
                        <i class="ri-arrow-down-s-line"></i>
                    </button>
                    <span class="chat-section-label-text">채널</span>
                    <button class="chat-section-add" id="addChannelBtn" title="채널 추가">
                        <i class="ri-add-line"></i>
                    </button>
                </div>
                <div class="chat-section-body" id="channelList">
                    <c:forEach var="room" items="${roomList}">
                        <div class="chat-room-item ${room.roomIdx == currentRoomIdx ? 'active' : ''} channel-item"
                             data-roomidx="${room.roomIdx}" data-roomname="${room.roomName}" data-type="channel">
                            <span class="chat-room-hash"><i class="ri-hashtag"></i></span>
                            <span class="chat-room-name">${room.roomName}</span>
                            <c:if test="${room.unreadCount > 0}">
                                <span class="chat-room-badge" id="badge-${room.roomIdx}">${room.unreadCount}</span>
                            </c:if>
                            <c:if test="${myUserLevel >= 99}">
                                <button class="channel-manage-btn" data-roomidx="${room.roomIdx}" data-roomname="${room.roomName}" title="채널 관리">
                                    <i class="ri-settings-3-line"></i>
                                </button>
                            </c:if>
                        </div>
                    </c:forEach>
                </div>

                
                <div class="chat-section-header" id="dmSectionHeader">
                    <button class="chat-section-toggle" id="dmToggle">
                        <i class="ri-arrow-down-s-line"></i>
                    </button>
                    <span class="chat-section-label-text">다이렉트 메시지</span>
                    <button class="chat-section-add" id="newDmBtn2" title="새 DM 시작">
                        <i class="ri-add-line"></i>
                    </button>
                </div>
                <div class="chat-section-body" id="dmList">
                    <c:forEach var="dm" items="${dmList}">
                        <div class="chat-room-item ${dm.roomIdx == currentRoomIdx ? 'active' : ''} dm-item"
                             data-roomidx="${dm.roomIdx}" data-roomname="${dm.nickname}" data-type="dm">
                            <div class="chat-dm-avt-wrap">
                                <div class="chat-dm-avt-sm" id="avt-dm-${dm.userIdx}">${fn:substring(dm.nickname, 0, 2)}</div>
                                <span class="chat-dm-status-dot" id="status-${dm.userIdx}"></span>
                            </div>
                            <div class="chat-room-info">
                                <span class="chat-room-name">${dm.nickname}</span>
                                <c:if test="${not empty dm.recentMessage}">
                                    <span class="chat-room-preview" id="preview-${dm.roomIdx}">${fn:substring(dm.recentMessage,0,20)}</span>
                                </c:if>
                            </div>
                            <c:if test="${dm.unreadCount > 0}">
                                <span class="chat-room-badge" id="badge-${dm.roomIdx}">${dm.unreadCount}</span>
                            </c:if>
                        </div>
                    </c:forEach>
                    <c:if test="${empty dmList}">
                        <div class="chat-dm-empty">
                            <span>+ 버튼으로 DM을 시작해보세요</span>
                        </div>
                    </c:if>
                </div>

                <div class="chat-conn-status">
                    <span class="conn-dot disconnected" id="connDot"></span>
                    <span class="conn-label" id="connLabel">연결 중...</span>
                </div>

                
                <div class="chat-my-profile">
                    <div class="chat-my-avt">${fn:substring(myNickname, 0, 2)}</div>
                    <div class="chat-my-info">
                        <span class="chat-my-name">${myNickname}</span>
                        <span class="chat-my-status"><span class="status-dot-green"></span>온라인</span>
                    </div>
                    <button class="chat-my-mute" title="마이크"><i class="ri-mic-line"></i></button>
                </div>
            </div>

            
            <div class="chat-main" id="chatMain">

                <div class="chat-main-head">
                    <div class="chat-main-head-left">
                        <button class="chat-sidebar-toggle" id="chatSidebarToggle">
                            <i class="ri-menu-4-fill"></i>
                        </button>
                        <c:choose>
                            <c:when test="${currentRoomType == 'dm'}">
                                <div class="chat-head-dm-avt">${fn:substring(currentRoomName, 0, 2)}</div>
                            </c:when>
                            <c:otherwise>
                                <div class="chat-head-icon"><i class="ri-hashtag"></i></div>
                            </c:otherwise>
                        </c:choose>
                        <div>
                            <div class="chat-head-name" id="headRoomName">${currentRoomName}</div>
                            <div class="chat-head-sub" id="headRoomSub">
                                <c:choose>
                                    <c:when test="${currentRoomType == 'dm'}">다이렉트 메시지</c:when>
                                    <c:otherwise>채널</c:otherwise>
                                </c:choose>
                            </div>
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
                    
                    <c:if test="${not empty currentRoomName and currentRoomType == 'channel'}">
                        <div class="chat-welcome-banner">
                            <div class="chat-welcome-icon"><i class="ri-hashtag"></i></div>
                            <h3>${currentRoomName} 에 오신 것을 환영합니다!</h3>
                            <p>이 채널의 시작입니다. 팀과 자유롭게 소통해보세요 🎉</p>
                        </div>
                    </c:if>
                    <c:if test="${not empty currentRoomName and currentRoomType == 'dm'}">
                        <div class="chat-welcome-banner dm-banner">
                            <div class="chat-welcome-dm-avt">${fn:substring(currentRoomName, 0, 2)}</div>
                            <h3>${currentRoomName}</h3>
                            <p>이 대화는 나와 <strong>${currentRoomName}</strong>님만 볼 수 있어요.</p>
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
                               placeholder="<c:choose><c:when test='${currentRoomType == &quot;dm&quot;}'>${currentRoomName}에게 메시지 보내기</c:when><c:otherwise>#${currentRoomName}에 메시지 보내기</c:otherwise></c:choose>"
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
                    멤버 <span class="member-count-badge">${fn:length(memberList)}</span>
                </div>
                <div class="chat-member-section-label">전체 직원</div>
                <c:forEach var="member" items="${memberList}">
                    <div class="chat-member-item" id="member-${member.userIdx}"
                         data-useridx="${member.userIdx}" data-nickname="${member.nickname}">
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
                        <c:if test="${member.userIdx != myUserIdx}">
                            <button class="chat-dm-start-btn" data-useridx="${member.userIdx}" title="DM 보내기">
                                <i class="ri-send-plane-line"></i>
                            </button>
                        </c:if>
                    </div>
                </c:forEach>
            </div>

        </div>
    </main>
</div>

<div class="chat-modal-overlay" id="channelManageOverlay" style="display:none;">
    <div class="chat-modal" style="width:520px;">
        <div class="chat-modal-head">
            <div style="display:flex;align-items:center;gap:8px;">
                <i class="ri-hashtag" style="color:var(--color-purple);"></i>
                <span id="manageChannelName">채널 관리</span>
                <span style="font-size:11px;font-weight:700;background:linear-gradient(135deg,#7C3AED,#EC4899);color:#fff;padding:2px 8px;border-radius:20px;">ADMIN</span>
            </div>
            <button class="chat-modal-close" id="channelManageClose"><i class="ri-close-line"></i></button>
        </div>
        <div class="chat-modal-body" style="padding:0;">
            
            <div style="display:flex;border-bottom:1px solid var(--border-color);">
                <button class="channel-manage-tab active" data-tab="members" style="flex:1;padding:12px;border:none;background:none;font-size:13px;font-weight:700;color:var(--color-purple);border-bottom:2px solid var(--color-purple);cursor:pointer;">멤버 관리</button>
                <button class="channel-manage-tab" data-tab="settings" style="flex:1;padding:12px;border:none;background:none;font-size:13px;font-weight:600;color:var(--text-sub);cursor:pointer;">채널 설정</button>
            </div>
            
            <div id="manageTabMembers" style="padding:16px 20px;">
                <p style="font-size:11px;font-weight:800;letter-spacing:0.06em;text-transform:uppercase;color:var(--text-sub);margin-bottom:10px;">현재 멤버</p>
                <div id="currentMemberList" style="display:flex;flex-direction:column;gap:4px;max-height:180px;overflow-y:auto;margin-bottom:16px;"></div>
                <p style="font-size:11px;font-weight:800;letter-spacing:0.06em;text-transform:uppercase;color:var(--text-sub);margin-bottom:10px;">멤버 추가</p>
                <div id="nonMemberList" style="display:flex;flex-direction:column;gap:4px;max-height:160px;overflow-y:auto;"></div>
            </div>
            
            <div id="manageTabSettings" style="padding:16px 20px;display:none;">
                <label class="chat-modal-label">채널 이름 변경</label>
                <div class="chat-modal-input-wrap" style="margin-bottom:16px;">
                    <i class="ri-hashtag"></i>
                    <input type="text" id="renameChannelInput" class="chat-modal-input" placeholder="새 채널 이름" maxlength="30">
                </div>
                <button onclick="doRenameChannel()" style="width:100%;padding:10px;border-radius:10px;border:none;background:var(--grad-primary);color:#fff;font-size:13px;font-weight:700;cursor:pointer;margin-bottom:20px;font-family:inherit;">
                    이름 변경
                </button>
                <div style="border-top:1px solid var(--border-color);padding-top:16px;">
                    <p style="font-size:13px;font-weight:700;color:#EF4444;margin-bottom:8px;">위험 구역</p>
                    <p style="font-size:12px;color:var(--text-light);margin-bottom:12px;">채널을 삭제하면 모든 메시지와 멤버 정보가 영구 삭제됩니다.</p>
                    <button onclick="doDeleteChannel()" style="width:100%;padding:10px;border-radius:10px;border:1.5px solid #FEE2E2;background:#FEF2F2;color:#EF4444;font-size:13px;font-weight:700;cursor:pointer;font-family:inherit;">
                        <i class="ri-delete-bin-line"></i> 채널 삭제
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="chat-modal-overlay" id="addChannelOverlay" style="display:none;">
    <div class="chat-modal" style="width:460px;">

        <div class="chat-modal-head">
            <div style="display:flex;align-items:center;gap:10px;">
                <button class="ch-step-back" id="channelStepBack" style="display:none;width:28px;height:28px;border:none;background:var(--base-bg);border-radius:8px;color:var(--text-sub);cursor:pointer;display:none;align-items:center;justify-content:center;font-size:15px;flex-shrink:0;">
                    <i class="ri-arrow-left-line"></i>
                </button>
                <span id="channelModalTitle">채널 만들기</span>
                <span class="ch-step-indicator" id="channelStepIndicator">1 / 2</span>
            </div>
            <button class="chat-modal-close" id="addChannelClose"><i class="ri-close-line"></i></button>
        </div>

        <div id="channelStep1">
            <div class="chat-modal-body">
                <label class="chat-modal-label">채널 이름</label>
                <div class="chat-modal-input-wrap">
                    <i class="ri-hashtag"></i>
                    <input type="text" id="newChannelName" class="chat-modal-input" placeholder="예: 마케팅, 이슈관리" maxlength="30">
                </div>
                <p class="chat-modal-hint">소문자, 하이픈(-) 사용을 권장합니다.</p>
            </div>
            <div class="chat-modal-actions">
                <button class="chat-modal-cancel" id="addChannelCancel">취소</button>
                <button class="chat-modal-confirm" id="addChannelNext">
                    다음 <i class="ri-arrow-right-line"></i>
                </button>
            </div>
        </div>

        <div id="channelStep2" style="display:none;">
            <div class="chat-modal-body" style="padding-bottom:8px;">
                <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:10px;">
                    <label class="chat-modal-label" style="margin:0;">멤버 초대</label>
                    <span class="ch-invite-count" id="channelInviteCount">0명 선택</span>
                </div>
                <div class="chat-modal-input-wrap" style="margin-bottom:12px;">
                    <i class="ri-search-2-line"></i>
                    <input type="text" id="channelMemberSearch" class="chat-modal-input" placeholder="이름으로 검색">
                </div>
                <div class="ch-member-pick-list" id="channelMemberPickList">
                    <c:forEach var="member" items="${memberList}">
                        <div class="ch-member-pick-row" data-useridx="${member.userIdx}" data-nickname="${member.nickname}">
                            <div class="ch-pick-avt">${fn:substring(member.nickname, 0, 2)}</div>
                            <div class="ch-pick-info">
                                <span class="ch-pick-name">${member.nickname}</span>
                                <span class="ch-pick-role">${member.authority}</span>
                            </div>
                            <div class="ch-pick-check"><i class="ri-check-line"></i></div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            <div class="chat-modal-actions" style="border-top:1.5px solid var(--border-color);padding-top:14px;">
                <button class="chat-modal-cancel" id="addChannelSkip" style="color:var(--text-light);">건너뛰기</button>
                <button class="chat-modal-confirm" id="addChannelConfirm">
                    <i class="ri-add-line"></i> 채널 만들기
                </button>
            </div>
        </div>

    </div>
</div>

<div class="chat-modal-overlay" id="newDmOverlay" style="display:none;">
    <div class="chat-modal">
        <div class="chat-modal-head">
            <span>DM 보내기</span>
            <button class="chat-modal-close" id="newDmClose"><i class="ri-close-line"></i></button>
        </div>
        <div class="chat-modal-body">
            <label class="chat-modal-label">멤버 선택</label>
            <div class="chat-dm-member-list" id="dmMemberList">
                <c:forEach var="member" items="${memberList}">
                    <c:if test="${member.userIdx != myUserIdx}">
                        <div class="chat-dm-member-row" data-useridx="${member.userIdx}" data-nickname="${member.nickname}">
                            <div class="chat-dm-avt-sm">${fn:substring(member.nickname, 0, 2)}</div>
                            <span>${member.nickname}</span>
                            <span class="chat-dm-member-role">${member.authority}</span>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<script>
var CHAT_CTX      = '${pageContext.request.contextPath}';
var CHAT_MY_IDX   = Number('${myUserIdx}');
var CHAT_MY_NAME  = '${myNickname}';
var CHAT_ROOM_IDX = Number('${currentRoomIdx}');
var CHAT_ROOM_TYPE  = '${currentRoomType}';
var CHAT_MY_LEVEL  = Number('${myUserLevel}');
</script>
<script src="${pageContext.request.contextPath}/dist/js/admin/admin_main.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/admin/admin_chat.js"></script>
</body>
</html>
