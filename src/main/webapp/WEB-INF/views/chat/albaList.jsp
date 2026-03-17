<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>알바 지원 내역</title>
<link href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<style>
    /* 기본 초기화 */
    * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Pretendard', sans-serif; }
    body { background: #f8f9fa; }
    
    /* 상단 헤더 */
    .header { background: #fff; padding: 15px 20px; border-bottom: 1px solid #e9ecef; position: sticky; top: 0; z-index: 10; display: flex; align-items: center; }
    .btn-back { background: none; border: none; font-size: 24px; color: #333; cursor: pointer; margin-right: 15px; }
    .header-title { font-size: 18px; font-weight: 700; color: #111; }
    
    /* 채팅 목록 */
    .chat-list { list-style: none; }
    .chat-item { display: flex; align-items: center; padding: 15px 20px; background: #fff; border-bottom: 1px solid #f1f3f5; cursor: pointer; transition: background 0.2s; }
    .chat-item:hover { background: #f8f9fa; }
    
    /* 프로필 및 텍스트 */
    .profile-img { width: 50px; height: 50px; border-radius: 50%; object-fit: cover; margin-right: 15px; background: #e9ecef; }
    .chat-info { flex: 1; overflow: hidden; }
    .chat-top { display: flex; justify-content: space-between; margin-bottom: 5px; }
    .nickname { font-size: 15px; font-weight: 700; color: #212529; }
    .time { font-size: 12px; color: #adb5bd; }
    .recent-msg { font-size: 14px; color: #495057; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    
    /* 안읽은 메시지 배지 */
    .unread-badge { background: #ff6b6b; color: #fff; font-size: 11px; font-weight: 700; padding: 2px 6px; border-radius: 10px; margin-left: 8px; }
    
    /* 빈 목록 */
    .empty-list { text-align: center; padding: 50px 20px; color: #868e96; font-size: 15px; }
</style>
</head>
<body>

    <div class="header">
        <button class="btn-back" onclick="window.close()"><i class="ri-close-line"></i></button>
        <div class="header-title">알바 지원 문의 (${list.size()})</div>
    </div>

    <ul class="chat-list">
        <c:choose>
            <c:when test="${empty list}">
                <div class="empty-list">
                    <i class="ri-chat-3-line" style="font-size: 40px; display: block; margin-bottom: 10px;"></i>
                    아직 도착한 알바 지원/문의가 없습니다.
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="dto" items="${list}">
                    <li class="chat-item" onclick="location.href='${pageContext.request.contextPath}/chat/albaRoom?albaIdx=${albaIdx}&toUserIdx=${dto.userIdx}'">
                        <c:choose>
                            <c:when test="${not empty dto.profilePhoto}">
                                <img src="${pageContext.request.contextPath}/uploads/photo/${dto.profilePhoto}" class="profile-img" alt="프로필">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/dist/images/person.png" class="profile-img" alt="기본프로필">
                            </c:otherwise>
                        </c:choose>
                        
                        <div class="chat-info">
                            <div class="chat-top">
                                <span class="nickname">
                                    ${dto.nickname}
                                    <c:if test="${dto.unreadCount > 0}">
                                        <span class="unread-badge">${dto.unreadCount}</span>
                                    </c:if>
                                </span>
                                <span class="time">${dto.recentDate}</span>
                            </div>
                            <div class="recent-msg">
                                ${empty dto.recentMessage ? '대화가 시작되었습니다.' : dto.recentMessage}
                            </div>
                        </div>
                    </li>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </ul>

</body>
</html>