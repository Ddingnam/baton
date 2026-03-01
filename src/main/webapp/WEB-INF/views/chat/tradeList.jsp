<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>채팅 목록</title>
<style>
    body { font-family: 'Noto Sans KR', sans-serif; background: #f4f6f8; margin: 0; padding: 0; }
    .header { background: #fff; padding: 15px 20px; font-weight: bold; font-size: 16px; border-bottom: 1px solid #ddd; position: sticky; top: 0; z-index: 100;}
    .list-container { padding: 10px; }
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
</style>
</head>
<body>
    <div class="header">이 거래글의 채팅 목록</div>
    <div class="list-container">
        <c:if test="${empty list}">
            <div class="empty-msg">아직 이 거래글에 대한 채팅이 없습니다.</div>
        </c:if>
        <c:forEach var="room" items="${list}">
            <div class="room-item" onclick="location.href='${pageContext.request.contextPath}/chat/room?tradeIdx=${room.tradeIdx}&toUserIdx=${room.userIdx}'">
                <img src="${empty room.profilePhoto ? pageContext.request.contextPath += '/dist/images/person.png' : pageContext.request.contextPath += '/uploads/profile/' += room.profilePhoto}" class="profile" onerror="this.src='${pageContext.request.contextPath}/dist/images/person.png'">
                <div class="info">
                    <div class="top-row">
                        <span class="nickname">${room.nickname}</span>
                        <span class="date">${room.recentDate}</span>
                    </div>
                    <div class="bottom-row">
                        <span class="recent-msg">${empty room.recentMessage ? '대화가 없습니다.' : room.recentMessage}</span>
                        <c:if test="${room.unreadCount > 0}">
                            <span class="badge">${room.unreadCount}</span>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</body>
</html>