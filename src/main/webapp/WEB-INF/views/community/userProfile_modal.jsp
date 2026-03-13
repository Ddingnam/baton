<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="modal-header border-0 pb-0">
    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
</div>

<div class="modal-body p-0">
    <div class="up-modal-content">
        <div class="up-header-card mx-0 shadow-none border-0">
            <div class="up-cover"></div>
            <div class="up-header-body">
                <div class="up-avatar-row">
                    <div class="up-avatar">
                        <img src="${pageContext.request.contextPath}/dist/images/avatar/${profileMemberIdx}.png"
                             alt="${profileNickname}"
                             onerror="this.style.display='none'">
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
                        <span id="modalJoinDate" data-date="${joinDate}"></span>
                        <i class="ri-checkbox-blank-circle-fill up-meta-sep-icon"></i>
                        <span>가입함</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="up-stat-row px-4 mt-2">
            <div class="up-stat">
                <div class="up-stat-icon"><i class="ri-edit-2-line"></i></div>
                <strong data-stat="${postCount}">${postCount}</strong>
                <span>작성한 글</span>
            </div>
            <div class="up-stat">
                <div class="up-stat-icon"><i class="ri-chat-3-line"></i></div>
                <strong data-stat="${replyCount}">${replyCount}</strong>
                <span>작성한 댓글</span>
            </div>
            <div class="up-stat">
                <div class="up-stat-icon"><i class="ri-heart-3-line"></i></div>
                <strong data-stat="${totalLikes}">${totalLikes}</strong>
                <span>받은 좋아요</span>
            </div>
        </div>

        <div class="up-activity-card mx-0 border-0 shadow-none">
            <div class="up-tabs">
                <button class="up-tab on" data-panel="panel-posts-modal">
                    작성한 글<c:if test="${postCount > 0}"> · ${postCount}</c:if>
                </button>
                <button class="up-tab" data-panel="panel-replies-modal">
                    남긴 댓글<c:if test="${replyCount > 0}"> · ${replyCount}</c:if>
                </button>
            </div>

            <div class="up-panel on" id="panel-posts-modal">
                <div class="up-list" id="modalPostList">
                    <c:choose>
                        <c:when test="${empty postList}">
                            <div class="up-empty">
                                <i class="ri-article-line"></i>
                                <p>아직 작성한 글이 없어요</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="post" items="${postList}">
                                <div class="up-row" onclick="location.href='${pageContext.request.contextPath}/community/article/${post.id}'">
                                    <div class="up-row-info">
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
            </div>

            <div class="up-panel" id="panel-replies-modal">
                <div class="up-list" id="modalReplyList">
                    <div class="up-loading">
                        <div class="up-spinner"></div>
                        <span>불러오는 중</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    if (typeof initUserProfileModal === 'function') {
        initUserProfileModal('${profileMemberIdx}');
    }
</script>