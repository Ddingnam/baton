<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${profileNickname} | BATON</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main/main.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/community/community-user-profile.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="up-page">

    <div class="up-header-card">
        <div class="up-cover"></div>
        <div class="up-header-body">
            <div class="up-avatar-row">
                <div class="up-avatar">
                    <img
                        src="${pageContext.request.contextPath}/dist/images/avatar/${profileMemberIdx}.png"
                        alt="${profileNickname}"
                        onerror="this.style.display='none'"
                    >
                    <c:if test="${empty param.img || param.img == 'none'}">
                        <c:out value="${fn:substring(profileNickname, 0, 1)}" />
                    </c:if>
                </div>
                <c:if test="${sessionScope.member.userIdx == profileMemberIdx}">
                    <span class="up-my-badge">내 프로필</span>
                </c:if>
            </div>

            <div class="up-user-info">
                <h2 class="up-name">${profileNickname}</h2>
                <p class="up-bio">반갑습니다! 커뮤니티에서 활동 중인 ${profileNickname}입니다.</p>
                <div class="up-meta">
                    <i class="ri-calendar-2-line"></i>
                    <span id="joinDate" data-date="${joinDate}"></span>
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

        <div class="up-card-header">
            <h3>커뮤니티 활동</h3>
            <a href="${pageContext.request.contextPath}/community/list" class="up-go-link">
                커뮤니티 가기 <i class="ri-arrow-right-s-line"></i>
            </a>
        </div>

        <div class="up-tabs">
            <button class="up-tab on" data-panel="panel-posts">
                작성한 글<c:if test="${postCount > 0}"> · ${postCount}</c:if>
            </button>
            <button class="up-tab" data-panel="panel-replies">
                남긴 댓글<c:if test="${replyCount > 0}"> · ${replyCount}</c:if>
            </button>
        </div>

        <div class="up-panel on" id="panel-posts">
            <div class="up-list" id="postList">
                <c:choose>
                    <c:when test="${empty postList}">
                        <div class="up-empty">
                            <i class="ri-article-line"></i>
                            <p>아직 작성한 글이 없어요</p>
                            <a href="${pageContext.request.contextPath}/community/write" class="up-go-link">
                                첫 글 쓰러 가기 <i class="ri-arrow-right-s-line"></i>
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="post" items="${postList}">
                            <div class="up-row"
                                 onclick="location.href='${pageContext.request.contextPath}/community/article/${post.id}'">
                                <div class="up-row-info">
                                    <c:if test="${not empty post.category}">
                                        <span class="up-row-cat">
                                            <c:choose>
                                                <c:when test="${post.category == '1' || post.category == '일상'}">일상</c:when>
                                                <c:when test="${post.category == '2' || post.category == '동네질문'}">동네질문</c:when>
                                                <c:when test="${post.category == '3' || post.category == '동네맛집'}">동네맛집</c:when>
                                                <c:when test="${post.category == '4' || post.category == '같이해요'}">같이해요</c:when>
                                                <c:when test="${post.category == '5' || post.category == '분실·실종'}">분실·실종</c:when>
                                                <c:when test="${post.category == '6' || post.category == '동네사건사고'}">동네사건사고</c:when>
                                                <c:when test="${post.category == '7' || post.category == '생활정보'}">생활정보</c:when>
                                                <c:when test="${post.category == '8' || post.category == '취미생활'}">취미생활</c:when>
                                                <c:otherwise>${post.category}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </c:if>
                                    <p class="up-row-title">${post.subject}</p>
                                    <div class="up-row-stats">
                                        <span><i class="ri-eye-line"></i> ${post.hitCount}</span>
                                        <span><i class="ri-heart-3-line"></i> ${post.likeCount}</span>
                                        <span data-date="${post.regDate}"></span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:if test="${postCount > 10}">
                <div class="up-more-wrap" id="moreBtnWrap">
                    <button class="up-more-btn" id="moreBtn" onclick="loadMorePosts()">
                        더 보기
                    </button>
                </div>
            </c:if>
        </div>
        <div class="up-panel" id="panel-replies">
            <div class="up-list" id="replyList">
                <div class="up-loading">
                    <div class="up-spinner"></div>
                    <span>불러오는 중</span>
                </div>
            </div>
        </div>

    </div>

</div>

<div class="up-toast-wrap" id="toastContainer"></div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
    const contextPath       = "${pageContext.request.contextPath}";
    const profileMemberIdx  = "${profileMemberIdx}";
</script>
<script src="${pageContext.request.contextPath}/dist/js/community/community-user-profile.js"></script>
</body>
</html>