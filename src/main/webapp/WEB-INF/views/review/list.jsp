<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>받은 거래 후기 | BATON</title>
    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
    <link href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css" rel="stylesheet">
    <style>
        .review-list-wrap { max-width: 700px; margin: 40px auto; padding: 0 20px; font-family: 'Pretendard', sans-serif; }
        .rl-title { font-size: 1.4rem; font-weight: 700; margin-bottom: 30px; border-bottom: 2px solid #212529; padding-bottom: 15px; }
        .review-item { border-bottom: 1px solid #e9ecef; padding: 25px 0; }
        .ri-header { display: flex; align-items: center; margin-bottom: 15px; }
        .ri-avatar { width: 40px; height: 40px; border-radius: 50%; background: #e9ecef; margin-right: 12px; object-fit: cover; }
        .ri-info { flex: 1; }
        .ri-name { font-weight: 700; font-size: 1rem; color: #212529; }
        .ri-meta { font-size: 0.85rem; color: #868e96; margin-top: 2px; }
        .ri-tags { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 12px; }
        .tag-badge { background: #f1f3f5; color: #495057; font-size: 0.85rem; padding: 4px 10px; border-radius: 4px; font-weight: 500; }       
        .ri-content { font-size: 0.95rem; color: #343a40; line-height: 1.5; white-space: pre-wrap; }
        .empty-review { text-align: center; padding: 50px 0; color: #adb5bd; font-size: 1.1rem; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="review-list-wrap">
    <h2 class="rl-title">${currentType == 'SENT' ? '보낸 거래 후기' : '받은 거래 후기'}</h2>

    <c:if test="${empty reviewList}">
        <div class="empty-review">
            <i class="ri-chat-1-line" style="font-size: 3rem; display: block; margin-bottom: 10px;"></i>
            아직 받은 거래 후기가 없어요.
        </div>
    </c:if>

    <div class="review-list">
        <c:forEach var="review" items="${reviewList}">
            <div class="review-item">
                <div class="ri-header">
                    <c:choose>
                        <c:when test="${not empty review.profilePhoto}">
                            <img src="${pageContext.request.contextPath}/uploads/profile/${review.profilePhoto}" class="ri-avatar" alt="profile">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/dist/images/avatar.png" class="ri-avatar" alt="default">
                        </c:otherwise>
                    </c:choose>
                    
                    <div class="ri-info">
                        <div class="ri-name">${review.writerNickname}</div>
                        <div class="ri-meta">${review.writerAddr} · ${review.timeAgo}</div>
                    </div>
                </div>

                <c:if test="${not empty review.reviewTags}">
                    <div class="ri-tags">
                        <c:forEach var="tag" items="${fn:split(review.reviewTags, ',')}">
                            <span class="tag-badge">${tag}</span>
                        </c:forEach>
                    </div>
                </c:if>

                <c:if test="${not empty review.content}">
                    <div class="ri-content">${review.content}</div>
                </c:if>
            </div>
        </c:forEach>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</body>
</html>