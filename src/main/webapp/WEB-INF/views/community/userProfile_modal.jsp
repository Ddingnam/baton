<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="up-modal-wrap">

    <button type="button" class="up-modal-close" onclick="closeProfileModal()" aria-label="Close">
        <i class="ri-close-line"></i>
    </button>

    <div class="up-header-card">
        <div class="up-cover"></div>
        <div class="up-header-body">
            <div class="up-avatar-row">
                <div class="up-avatar">
                    <img src="${pageContext.request.contextPath}/dist/images/avatar/${profileMemberIdx}.png"
                         alt="${profileNickname}"
                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                    <span class="up-avatar-initial" style="display:none;">
                        <c:out value="${fn:substring(profileNickname, 0, 1)}" />
                    </span>
                </div>
                <c:if test="${sessionScope.member.userIdx == profileMemberIdx}">
                    <span class="up-my-badge">내 프로필</span>
                </c:if>
            </div>

            <div class="up-user-info">
                <h2 class="up-name">${profileNickname}</h2>
                <div class="up-meta">
                    <i class="ri-calendar-2-line"></i>
                    <span>${joinDate}</span>
                    <i class="ri-checkbox-blank-circle-fill up-meta-sep-icon"></i>
                    <span>가입함</span>
                </div>
            </div>
        </div>
    </div>

    <div class="up-stat-row">
        <div class="up-stat">
            <div class="up-stat-icon"><i class="ri-edit-2-line"></i></div>
            <strong data-stat="${postCount}">0</strong>
            <span>작성한 글</span>
        </div>
        <div class="up-stat">
            <div class="up-stat-icon"><i class="ri-chat-3-line"></i></div>
            <strong data-stat="${replyCount}">0</strong>
            <span>작성한 댓글</span>
        </div>
        <div class="up-stat">
            <div class="up-stat-icon"><i class="ri-heart-3-line"></i></div>
            <strong data-stat="${totalLikes}">0</strong>
            <span>받은 좋아요</span>
        </div>
    </div>

    <div class="up-activity-card">

        <div class="up-tabs">
            <button class="up-tab on" data-panel="panel-posts-modal">
                작성한 글<c:if test="${postCount > 0}"> <em class="up-tab-count">${postCount}</em></c:if>
            </button>
            <button class="up-tab" data-panel="panel-replies-modal">
                남긴 댓글<c:if test="${replyCount > 0}"> <em class="up-tab-count">${replyCount}</em></c:if>
            </button>
        </div>

        <div class="up-panel on" id="panel-posts-modal">
            <div class="up-list" id="postList">
                <c:choose>
                    <c:when test="${empty postList}">
                        <div class="up-empty">
                            <i class="ri-article-line"></i>
                            <p>아직 작성한 글이 없어요</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="post" items="${postList}">
                            <div class="up-row"
                                 onclick="location.href='${pageContext.request.contextPath}/community/article/${post.id}'">
                                <div class="up-row-info">
                                    <span class="up-row-cat">
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
                                    <p class="up-row-title">${post.subject}</p>
                                    <div class="up-row-stats">
                                        <span><i class="ri-eye-line"></i> ${post.hitCount}</span>
                                        <span><i class="ri-heart-3-line"></i> ${post.likeCount}</span>
                                        <span>
                                            <c:if test="${not empty post.regDate}">
                                                <c:set var="rd" value="${fn:substring(post.regDate, 0, 10)}" />
                                                ${fn:replace(rd, '-', '.')}
                                            </c:if>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>


        </div>

        <div class="up-panel" id="panel-replies-modal">
            <div class="up-list" id="replyList"></div>
        </div>

    </div>
</div>

<script>
(function () {
    if (typeof initUserProfileModal === 'function') {
        initUserProfileModal('${profileMemberIdx}');
    }
})();
</script>
