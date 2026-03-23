<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>바톤 채팅방</title>
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/report/report-modal.css">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>

<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<style>
    body, html { margin: 0; padding: 0; height: 100%; background: #fff; font-family: 'Noto Sans KR', sans-serif; }
    .chat-container { width: 100%; height: 100vh; display: flex; flex-direction: column; background: #fff; }
    .chat-header { display: flex; justify-content: space-between; align-items: center; padding: 15px 20px; font-size: 16px; background: #fff; position: relative; z-index: 10; border-bottom: 1px solid #f0f0f0;}
    .header-left i { font-size: 24px; cursor: pointer; color: #333; }
    .header-center { flex: 1; text-align: center; font-weight: 700; color: #333; }
    .header-right { width: 24px; } 

    .trade-banner { display: flex; flex-direction: column; padding: 14px 20px; background: #fafafa; border-bottom: 1px solid #eee; }
    .trade-banner-info-wrap { display: flex; align-items: center; width: 100%; }
    .trade-thumb { width: 45px; height: 45px; border-radius: 8px; background: #ddd; margin-right: 12px; object-fit: cover; border: 1px solid #eee;}
    .trade-info { flex: 1; display: flex; flex-direction: column; }
    .trade-title { font-size: 14px; font-weight: bold; color: #333; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 250px;}
    .trade-date { font-size: 12px; color: #888; margin-top: 3px; }
    
    .review-btn-wrap { margin-top: 12px; width: 100%; }
    .review-btn { width: 100%; padding: 10px; background: #fff; border: 1px solid #00B98D; color: #00B98D; border-radius: 8px; font-size: 13px; font-weight: 700; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 6px; transition: 0.2s; }
    .review-btn:hover { background: #E6F8F3; }

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
</style>
</head>
<body>
    <div class="chat-container">
        <div class="chat-header">
            <div class="header-left" onclick="goBack()">
                <i class="ri-arrow-left-s-line"></i>
            </div>
            <div class="header-center">${counterpartName}</div>
            <div class="header-right" style="position:relative;">
                
                <i class="ri-more-2-fill" style="font-size: 24px; cursor: pointer; color: #333;" onclick="toggleMenu()"></i>
                <div id="roomMenu" style="display:none; position:absolute; right:0; top:35px; background:#fff; border:1px solid #eee; box-shadow:0 4px 16px rgba(0,0,0,0.10); border-radius:12px; z-index:100; width:130px; overflow:hidden;">
                    <div onclick="leaveRoom()" style="padding:13px 16px; color:#555; cursor:pointer; font-size:14px; font-weight:600; text-align:center; transition:background 0.15s;" onmouseover="this.style.background='#f5f5f5'" onmouseout="this.style.background='transparent'">삭제하기</div>
                    <c:if test="${not empty counterpartIdx}">
                    <div style="height:1px; background:#f0f0f0; margin:0 12px;"></div>
                    <div onclick="openReportModal('CHAT', ${roomIdx}, ${counterpartIdx})" style="padding:13px 16px; color:#FF4D4F; cursor:pointer; font-size:14px; font-weight:600; text-align:center; transition:background 0.15s;" onmouseover="this.style.background='#FFF1F0'" onmouseout="this.style.background='transparent'">신고하기</div>
                    </c:if>
                </div>
            </div>
        </div>
        
        <c:if test="${not empty tradeInfo}">
            <div class="trade-banner">
                <div class="trade-banner-info-wrap">
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
                
                <c:if test="${tradeInfo.TRADESTATUS == '판매완료'}">
                    <div class="review-btn-wrap">
                        <c:set var="myRole" value="${userIdx == tradeInfo.SELLERIDX ? 'SELLER' : 'BUYER'}" />
                        <button type="button" class="review-btn" onclick="location.href='${pageContext.request.contextPath}/review/write?productIdx=${tradeInfo.PRODUCTIDX}&role=${myRole}'">
                            <i class="ri-edit-2-line"></i> 거래 후기 남기기
                        </button>
                    </div>
                </c:if>
            </div>
        </c:if>

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
                            
                            <c:choose>
                                <c:when test="${chat.msgType == 5}">
                                    <div class="msg-bubble" style="background: transparent; padding: 0;">
                                        <img src="${pageContext.request.contextPath}/uploads/chat/${chat.content}" style="max-width: 200px; border-radius: 14px; border: 1px solid #eee;">
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="msg-bubble">${fn:replace(chat.content, '\\n', '<br>')}</div>
                                </c:otherwise>
                            </c:choose>
                            
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
            <i class="ri-attachment-line" style="font-size: 24px; color: #888; cursor: pointer; margin-right: 12px; transition: color 0.2s;" onmouseover="this.style.color='#00B98D'" onmouseout="this.style.color='#888'" onclick="document.getElementById('chatImageFile').click()"></i>
            <input type="file" id="chatImageFile" style="display:none;" accept="image/*" onchange="uploadChatImage()">
            
            <textarea id="chatInput" placeholder="메시지 보내기..." onkeydown="handleEnter(event)"></textarea>
            <button onclick="sendMessage()"><i class="ri-send-plane-fill" style="font-size:18px;"></i></button>
        </div>
    </div>

<script>
    window.contextPath = "${pageContext.request.contextPath}";
    const currentRoomIdx = ${roomIdx};
    const myUserIdx = ${userIdx};
    const counterpartName = "${counterpartName}";
    let currentDisplayDate = "${lastDate}";
</script>
<script src="${pageContext.request.contextPath}/dist/js/chat/chat.js"></script>

<script>
    if (typeof showBatonToast === 'undefined') {
        (function() {
            const style = document.createElement('style');
            style.textContent = `
                #chat-toast-container { position: fixed; top: 24px; left: 50%; transform: translateX(-50%); z-index: 9999999; display: flex; flex-direction: column; align-items: center; gap: 10px; pointer-events: none; }
                .chat-toast-item { display: flex; align-items: center; gap: 10px; padding: 14px 28px; background: rgba(25, 31, 40, 0.95); backdrop-filter: blur(10px); color: #fff; border-radius: 100px; box-shadow: 0 8px 24px rgba(0,0,0,0.25); border: 1px solid rgba(255,255,255,0.1); min-width: 200px; justify-content: center; font-size: 15px; font-weight: 600; letter-spacing: -0.3px; animation: chatToastIn 0.4s cubic-bezier(0.16,1,0.3,1) forwards; }
                .chat-toast-item .ct-icon { font-size: 18px; color: #3182F6; }
                .chat-toast-item.hide { animation: chatToastOut 0.4s cubic-bezier(0.16,1,0.3,1) forwards !important; }
                @keyframes chatToastIn  { from { opacity:0; transform:translateY(-20px); } to { opacity:1; transform:translateY(0); } }
                @keyframes chatToastOut { from { opacity:1; transform:translateY(0); }   to { opacity:0; transform:translateY(-10px); } }
            `;
            document.head.appendChild(style);

            function getContainer() {
                let c = document.getElementById('chat-toast-container');
                if (!c) { c = document.createElement('div'); c.id = 'chat-toast-container'; document.body.appendChild(c); }
                return c;
            }

            window.showBatonToast = function(message) {
                const container = getContainer();
                const item = document.createElement('div');
                item.className = 'chat-toast-item';
                item.innerHTML = '<i class="ri-information-line ct-icon"></i><span>' + message + '</span>';
                container.appendChild(item);
                setTimeout(() => {
                    item.classList.add('hide');
                    setTimeout(() => { if (item.parentNode) item.remove(); }, 400);
                }, 2500);
            };
        })();
    }
    
    function goBack() {
        const urlParams = new URLSearchParams(window.location.search);
        const tradeIdx = urlParams.get('tradeIdx');
        let ref = document.referrer;
        
        if (ref.indexOf('/chat/tradeList') !== -1) {
            location.href = '${pageContext.request.contextPath}/chat/tradeList?tradeIdx=' + tradeIdx;
        } else {
            location.href = '${pageContext.request.contextPath}/chat/list?mode=popup';
        }
    }
    
    function toggleMenu() {
        let menu = document.getElementById('roomMenu');
        menu.style.display = menu.style.display === 'none' ? 'block' : 'none';
    }

    function leaveRoom() { document.getElementById('chatDeleteModal').style.display = 'flex'; }

    function confirmLeaveRoom() {
        document.getElementById('chatDeleteModal').style.display = 'none';
        const params = new URLSearchParams();
        params.append('roomIdx', currentRoomIdx);
        fetch('${pageContext.request.contextPath}/chat/delete', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        })
        .then(response => response.json())
        .then(data => { if(data.state === 'true') { goBack(); } });
    }

    function cancelLeaveRoom() { document.getElementById('chatDeleteModal').style.display = 'none'; }
    window.onload = function() { connect(); };
</script>
<script src="${pageContext.request.contextPath}/dist/js/report/report-modal.js"></script>

<div id="reportModal" class="report-modal-overlay" style="display:none;">
    <div class="report-modal-sheet">
        <div class="report-modal-head">
            <span class="report-modal-title"><i class="ri-alarm-warning-line"></i> 신고하기</span>
            <button type="button" class="report-modal-close" onclick="closeReportModal()"><i class="ri-close-line"></i></button>
        </div>
        <div class="report-modal-body">
            <p class="report-modal-desc">신고 사유를 선택해주세요. 허위 신고는 제재를 받을 수 있습니다.</p>
            <div class="report-type-list">
                <label class="report-type-item"><input type="radio" name="reportType" value="스팸"><span class="report-type-label"><i class="ri-spam-line"></i> 스팸 / 광고</span></label>
                <label class="report-type-item"><input type="radio" name="reportType" value="욕설/비방"><span class="report-type-label"><i class="ri-emotion-unhappy-line"></i> 욕설 / 비방</span></label>
                <label class="report-type-item"><input type="radio" name="reportType" value="음란물"><span class="report-type-label"><i class="ri-eye-off-line"></i> 음란물 / 불건전</span></label>
                <label class="report-type-item"><input type="radio" name="reportType" value="사기"><span class="report-type-label"><i class="ri-error-warning-line"></i> 사기 / 허위 정보</span></label>
                <label class="report-type-item"><input type="radio" name="reportType" value="개인정보침해"><span class="report-type-label"><i class="ri-user-forbid-line"></i> 개인정보 침해</span></label>
                <label class="report-type-item"><input type="radio" name="reportType" value="기타"><span class="report-type-label"><i class="ri-more-line"></i> 기타</span></label>
            </div>
            <div class="report-content-wrap">
                <textarea id="reportContent" class="report-content-input" placeholder="추가로 전달할 내용이 있으면 입력해주세요. (선택)" maxlength="300"></textarea>
                <span class="report-content-count"><span id="reportContentCount">0</span>/300</span>
            </div>
        </div>
        <div class="report-modal-foot">
            <button type="button" class="report-btn-cancel" onclick="closeReportModal()">취소</button>
            <button type="button" class="report-btn-submit" onclick="submitReport()">신고 접수</button>
        </div>
        <input type="hidden" id="reportDomainType" value="">
        <input type="hidden" id="reportTargetIdx" value="">
        <input type="hidden" id="reportedUserIdx" value="">
    </div>
</div>

<style>
#chatDeleteModal { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.45); backdrop-filter: blur(6px); z-index: 9999; align-items: center; justify-content: center; animation: fadeInModal 0.18s ease; }
@keyframes fadeInModal { from { opacity: 0; } to   { opacity: 1; } }
.chat-delete-dialog { background: #fff; border-radius: 20px; padding: 28px 24px 20px; width: 300px; text-align: center; box-shadow: 0 20px 60px rgba(0,0,0,0.18); animation: slideUpDialog 0.22s cubic-bezier(0.16,1,0.3,1); }
@keyframes slideUpDialog { from { transform: translateY(16px) scale(0.97); opacity: 0; } to   { transform: translateY(0) scale(1); opacity: 1; } }
.chat-delete-dialog .dialog-icon { width: 52px; height: 52px; border-radius: 50%; background: #FFF1F0; display: flex; align-items: center; justify-content: center; margin: 0 auto 16px; font-size: 24px; color: #FF4D4F; }
.chat-delete-dialog .dialog-title { font-size: 16px; font-weight: 800; color: #111827; margin-bottom: 8px; letter-spacing: -0.3px; }
.chat-delete-dialog .dialog-desc { font-size: 13px; color: #6B7280; line-height: 1.6; margin-bottom: 22px; }
.chat-delete-dialog .dialog-btns { display: flex; gap: 8px; }
.chat-delete-dialog .btn-cancel-dialog { flex: 1; padding: 12px; border-radius: 12px; border: 1.5px solid #E5E7EB; background: #F9FAFB; font-size: 14px; font-weight: 600; color: #6B7280; cursor: pointer; font-family: inherit; transition: all 0.15s; }
.chat-delete-dialog .btn-cancel-dialog:hover { background: #F3F4F6; }
.chat-delete-dialog .btn-confirm-dialog { flex: 1; padding: 12px; border-radius: 12px; border: none; background: #FF4D4F; font-size: 14px; font-weight: 700; color: #fff; cursor: pointer; font-family: inherit; transition: all 0.15s; }
.chat-delete-dialog .btn-confirm-dialog:hover { background: #E53935; transform: translateY(-1px); }
</style>

<div id="chatDeleteModal" onclick="if(event.target===this) cancelLeaveRoom()">
    <div class="chat-delete-dialog">
        <div class="dialog-icon"><i class="ri-delete-bin-line"></i></div>
        <p class="dialog-title">채팅방을 삭제할까요?</p>
        <p class="dialog-desc">삭제한 채팅방은 복구할 수 없어요.<br>대화 내용도 함께 사라집니다.</p>
        <div class="dialog-btns">
            <button class="btn-cancel-dialog" onclick="cancelLeaveRoom()">취소</button>
            <button class="btn-confirm-dialog" onclick="confirmLeaveRoom()">삭제하기</button>
        </div>
    </div>
</div>

</body>
</html>