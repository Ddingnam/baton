<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="upm-wrap">

    <button type="button" class="upm-close" onclick="closeProfileModal()">
        <i class="ri-close-line"></i>
    </button>

    <div class="upm-top">
        <div class="upm-avatar">
            <img src="${pageContext.request.contextPath}/dist/images/avatar/${profileMemberIdx}.png"
                 alt="${profileNickname}"
                 onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
            <span class="upm-avatar-initial" style="display:none;">
                <c:out value="${fn:substring(profileNickname, 0, 1)}" />
            </span>
        </div>
        <div class="upm-info">
            <div class="upm-name-row">
                <h2 class="upm-name">${profileNickname}</h2>
                <c:if test="${sessionScope.member.userIdx == profileMemberIdx}">
                    <span class="upm-me-badge">나</span>
                </c:if>
            </div>
            <span class="upm-join">${joinDate} 가입</span>
        </div>
    </div>

    <div class="upm-stats">
        <div class="upm-stat-item">
            <strong data-stat="${postCount}">0</strong>
            <span>게시글</span>
        </div>
        <div class="upm-stat-divider"></div>
        <div class="upm-stat-item">
            <strong data-stat="${replyCount}">0</strong>
            <span>댓글</span>
        </div>
        <div class="upm-stat-divider"></div>
        <div class="upm-stat-item">
            <strong data-stat="${totalLikes}">0</strong>
            <span>받은 좋아요</span>
        </div>
    </div>

    <div class="upm-tabs">
        <button class="upm-tab on" data-panel="panel-posts-modal">
            작성한 글<c:if test="${postCount > 0}"><em class="upm-tab-cnt">${postCount}</em></c:if>
        </button>
        <button class="upm-tab" data-panel="panel-replies-modal">
            남긴 댓글<c:if test="${replyCount > 0}"><em class="upm-tab-cnt">${replyCount}</em></c:if>
        </button>
    </div>

    <div class="upm-panel on" id="panel-posts-modal">
        <div id="postList">
            <c:choose>
                <c:when test="${empty postList}">
                    <div class="upm-empty">
                        <i class="ri-article-line"></i>
                        <p>아직 작성한 글이 없어요</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="post" items="${postList}">
                        <div class="upm-row" onclick="location.href='${pageContext.request.contextPath}/community/article/${post.id}'">
                            <span class="upm-cat">
                                <c:choose>
                                    <c:when test="${post.category == '1' || post.category == '일상'}">일상</c:when>
                                    <c:when test="${post.category == '2' || post.category == '동네질문'}">동네질문</c:when>
                                    <c:when test="${post.category == '3' || post.category == '동네맛집'}">동네맛집</c:when>
                                    <c:when test="${post.category == '4' || post.category == '같이해요'}">같이해요</c:when>
                                    <c:when test="${post.category == '5' || post.category == '분실/실종'}">분실/실종</c:when>
                                    <c:when test="${post.category == '6' || post.category == '동네사건사고'}">동네사건사고</c:when>
                                    <c:when test="${post.category == '7' || post.category == '생활정보'}">생활정보</c:when>
                                    <c:when test="${post.category == '8' || post.category == '취미생활'}">취미생활</c:when>
                                    <c:otherwise>${post.category}</c:otherwise>
                                </c:choose>
                            </span>
                            <p class="upm-row-title">${post.subject}</p>
                            <div class="upm-row-meta">
                                <span><i class="ri-eye-line"></i>${post.hitCount}</span>
                                <span><i class="ri-heart-3-line"></i>${post.likeCount}</span>
                                <c:if test="${not empty post.regDate}">
                                    <span>${fn:replace(fn:substring(post.regDate, 0, 10), '-', '.')}</span>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="upm-panel" id="panel-replies-modal">
        <div id="replyList"></div>
    </div>

</div>

<script>
(function () {
    if (typeof initUserProfileModal === 'function') {
        initUserProfileModal('${profileMemberIdx}');
    }
})();
</script>
