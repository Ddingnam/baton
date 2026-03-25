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

    @import url('https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css');
    
    body, html { margin: 0; padding: 0; height: 100%; background: #F9FAFB; font-family: 'Pretendard', sans-serif; }
    .chat-container { width: 100%; height: 100vh; display: flex; flex-direction: column; background: #fff; max-width: 100%; position: relative; }

    .chat-header { 
        display: flex; justify-content: space-between; align-items: center; 
        padding: 16px 20px; font-size: 17px; background: rgba(255, 255, 255, 0.95); 
        backdrop-filter: blur(10px); position: sticky; top: 0; z-index: 50; 
        border-bottom: 1px solid rgba(0,0,0,0.05); 
    }
    .header-left i { font-size: 26px; cursor: pointer; color: #191F28; transition: color 0.2s; }
    .header-left i:hover { color: #3182F6; }
    .header-center { flex: 1; text-align: center; font-weight: 800; color: #191F28; letter-spacing: -0.3px; }
    .header-right { width: 26px; } 

    .trade-banner { 
        display: flex; flex-direction: column; padding: 16px 20px; 
        background: #fff; border-bottom: 1px solid rgba(0,0,0,0.05); 
        box-shadow: 0 4px 12px rgba(0,0,0,0.02); z-index: 40;
    }
    .trade-banner-info-wrap { display: flex; align-items: center; width: 100%; cursor: pointer; }
    .trade-thumb { 
        width: 48px; height: 48px; border-radius: 12px; background: #F2F4F6; 
        margin-right: 14px; object-fit: cover; border: 1px solid rgba(0,0,0,0.05);
    }
    .trade-info { flex: 1; display: flex; flex-direction: column; justify-content: center; }
    .trade-title { font-size: 15px; font-weight: 700; color: #191F28; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 250px; margin-bottom: 2px; }
    .trade-date { font-size: 13px; color: #8B95A1; font-weight: 500; }

    .review-btn-wrap { margin-top: 14px; width: 100%; }
    .review-btn { 
        width: 100%; padding: 12px; background: #F2F4F6; color: #191F28; 
        border: none; border-radius: 12px; font-size: 14px; font-weight: 700; 
        cursor: pointer; display: flex; align-items: center; justify-content: center; 
        gap: 6px; transition: all 0.2s cubic-bezier(0.25, 0.8, 0.25, 1); 
    }
    .review-btn:hover { background: #00B98D; color: #fff; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0, 185, 141, 0.2); }

    .chat-messages { flex: 1; overflow-y: auto; padding: 24px 20px; background: #F9FAFB; } 
    .chat-messages::-webkit-scrollbar { width: 6px; }
    .chat-messages::-webkit-scrollbar-thumb { background: #D1D6DB; border-radius: 10px; }
    
    .date-divider { text-align: center; margin: 24px 0; }
    .date-divider span { 
        background: rgba(0,0,0,0.05); color: #6B7684; font-size: 12px; font-weight: 600; 
        padding: 6px 16px; border-radius: 20px; backdrop-filter: blur(4px);
    }
    .system-msg { text-align: center; margin-bottom: 24px; color: #8B95A1; font-size: 13px; font-weight: 500; }
    
    .msg-row { margin-bottom: 18px; display: flex; align-items: flex-end; }
    .msg-me { justify-content: flex-end; }
    .msg-other { justify-content: flex-start; }

    .msg-bubble { 
        padding: 12px 16px; border-radius: 20px; max-width: 70%; 
        word-break: break-all; font-size: 14.5px; line-height: 1.5; font-weight: 500;
        box-shadow: 0 2px 8px rgba(0,0,0,0.03);
    }
    .msg-me .msg-bubble { background: #3182F6; color: #fff; border-bottom-right-radius: 4px; }
    .msg-other .msg-bubble { background: #fff; color: #191F28; border-bottom-left-radius: 4px; border: 1px solid rgba(0,0,0,0.03); } 
    
    .msg-info { display: flex; flex-direction: column; justify-content: flex-end; margin: 0 8px; padding-bottom: 4px; }
    .msg-time { font-size: 11px; color: #8B95A1; font-weight: 500; }
    .unread-count { color: #3182F6; font-weight: 800; font-size: 12px; text-align: right; margin-bottom: 2px; }
    
    .profile-img { width: 38px; height: 38px; border-radius: 40%; margin-right: 12px; object-fit: cover; border: 1px solid rgba(0,0,0,0.05); background: #fff; }
    .nickname { font-size: 13px; font-weight: 600; margin-bottom: 6px; color: #4E5968; }
    
    .image-preview-container { display: none; padding: 15px 20px; background: #fff; border-top: 1px solid rgba(0,0,0,0.05); position: relative; }
    .preview-box { position: relative; display: inline-block; }
    .preview-box img { height: 70px; border-radius: 12px; border: 1px solid rgba(0,0,0,0.08); object-fit: cover; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
    .preview-delete-btn { position: absolute; top: -8px; right: -8px; background: rgba(25, 31, 40, 0.8); color: #fff; border-radius: 50%; width: 24px; height: 24px; display: flex; align-items: center; justify-content: center; font-size: 14px; cursor: pointer; z-index: 10; transition: 0.2s; }
    .preview-delete-btn:hover { background: #FF4D4F; }

    .chat-input-box { display: flex; padding: 14px 20px; background: #fff; border-top: 1px solid rgba(0,0,0,0.05); align-items: flex-end; }
    
    .chat-input-box textarea { 
        flex: 1; padding: 14px 18px; border: 1px solid #E5E8EB; background: #F2F4F6; 
        border-radius: 24px; outline: none; resize: none; 
        overflow-y: hidden; height: 48px; max-height: 120px; 
        line-height: 20px; font-family: inherit; font-size: 15px; color: #191F28; box-sizing: border-box;
        transition: border-color 0.2s, background-color 0.2s;
    }
    .chat-input-box textarea::-webkit-scrollbar { width: 0px; background: transparent; } 
    
    .chat-input-box textarea:focus { border-color: #3182F6; background: #fff; box-shadow: 0 4px 12px rgba(49, 130, 246, 0.1); overflow-y: auto; }
    .chat-input-box textarea:focus::-webkit-scrollbar { width: 4px; }
    
    .chat-input-box button { 
        width: 48px; height: 48px; margin-left: 12px; border: none; background: #3182F6; 
        color: white; border-radius: 50%; cursor: pointer; display: flex; justify-content: center; 
        align-items: center; transition: all 0.2s cubic-bezier(0.25, 0.8, 0.25, 1); flex-shrink: 0; 
        box-shadow: 0 4px 12px rgba(49, 130, 246, 0.25);
    }
    .chat-input-box button:hover { transform: translateY(-2px); background: #1B64DA; box-shadow: 0 6px 16px rgba(49, 130, 246, 0.35); }
    .chat-input-box button:active { transform: translateY(0); }
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
                <i class="ri-more-2-fill" style="font-size: 24px; cursor: pointer; color: #191F28;" onclick="toggleMenu()"></i>
                <div id="roomMenu" style="display:none; position:absolute; right:0; top:40px; background:#fff; border:1px solid #E5E8EB; box-shadow:0 10px 30px rgba(0,0,0,0.1); border-radius:16px; z-index:100; width:140px; overflow:hidden;">
                    <div onclick="leaveRoom()" style="padding:14px 16px; color:#4E5968; cursor:pointer; font-size:14px; font-weight:600; text-align:center; transition:background 0.2s;" onmouseover="this.style.background='#F2F4F6'" onmouseout="this.style.background='transparent'">삭제하기</div>
                    <c:if test="${not empty counterpartIdx}">
                    <div style="height:1px; background:#F2F4F6; margin:0 12px;"></div>
                    <div onclick="openReportModal('CHAT', ${roomIdx}, ${counterpartIdx})" style="padding:14px 16px; color:#FF4D4F; cursor:pointer; font-size:14px; font-weight:600; text-align:center; transition:background 0.2s;" onmouseover="this.style.background='#FFF1F0'" onmouseout="this.style.background='transparent'">신고하기</div>
                    </c:if>
                </div>
            </div>
        </div>
        
        <c:if test="${not empty tradeInfo}">
            <div class="trade-banner">
                <div class="trade-banner-info-wrap" onclick="location.href='${pageContext.request.contextPath}/trade/article?productIdx=${tradeInfo.PRODUCTIDX}'">
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
                        <span class="trade-date">작성일: ${tradeInfo.CREATEDDATE} · <strong><fmt:formatNumber value="${tradeInfo.PRICE}" pattern="#,###"/>원</strong></span>
                    </div>
                </div>
                
                <c:if test="${tradeInfo.TRADESTATUS == '판매완료'}">
                    <div class="review-btn-wrap">
                        <c:set var="myRole" value="${userIdx == tradeInfo.SELLERIDX ? 'SELLER' : 'BUYER'}" />
                        <button type="button" class="review-btn" onclick="location.href='${pageContext.request.contextPath}/review/write?productIdx=${tradeInfo.PRODUCTIDX}&role=${myRole}&mode=popup'">
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
                                    <div class="msg-bubble" style="background: transparent; padding: 0; box-shadow: none;">
                                        <img src="${pageContext.request.contextPath}/uploads/chat/${chat.content}" style="max-width: 220px; border-radius: 16px; border: 1px solid rgba(0,0,0,0.05); box-shadow: 0 4px 12px rgba(0,0,0,0.08);">
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

        <div id="imagePreviewContainer" class="image-preview-container">
            <div class="preview-box">
                <div class="preview-delete-btn" onclick="clearSelectedImage()"><i class="ri-close-line"></i></div>
                <img id="imagePreview" src="">
            </div>
        </div>

        <div class="chat-input-box">
            <i class="ri-attachment-line" style="font-size: 26px; color: #8B95A1; cursor: pointer; margin-right: 14px; margin-bottom: 10px; transition: color 0.2s;" onmouseover="this.style.color='#3182F6'" onmouseout="this.style.color='#8B95A1'" onclick="document.getElementById('chatImageFile').click()"></i>
            <input type="file" id="chatImageFile" style="display:none;" accept="image/*" onchange="handleImageSelect(event)">
            
            <textarea id="chatInput" placeholder="메시지를 입력하세요" onkeydown="handleEnter(event)" oninput="autoResize(this)"></textarea>
            
            <button onclick="handleSendButtonClick()" style="margin-bottom: 0px;"><i class="ri-arrow-up-line" style="font-size:24px; font-weight:800;"></i></button>
        </div>
    </div>

<script>
    window.contextPath = "${pageContext.request.contextPath}";
    const currentRoomIdx = ${roomIdx};
    const myUserIdx = ${userIdx};
    const counterpartName = "${counterpartName}";
    let currentDisplayDate = "${lastDate}";

    function autoResize(textarea) {
        textarea.style.height = '48px'; 
        let scrollHeight = textarea.scrollHeight;
        if(scrollHeight > 48) {
            textarea.style.height = Math.min(scrollHeight, 120) + 'px'; 
            textarea.style.overflowY = scrollHeight > 120 ? 'auto' : 'hidden';
        }
    }
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