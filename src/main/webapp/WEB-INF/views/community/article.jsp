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
<title>${dto.subject} | BATON</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link href="https://cdn.quilljs.com/1.3.7/quill.snow.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/community/community-article.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/community/community-user-profile.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/report/report-modal.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoMapKey}&libraries=services&autoload=false"></script>
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="article-layout">
    <div class="article-container">
        <div class="article-header">
            <div class="category-badge">
                <c:set var="cat" value="${dto.category}"/>
                <c:choose>
                    <c:when test="${cat == '1' || cat == '일상'}">일상</c:when>
                    <c:when test="${cat == '2' || cat == '동네질문'}">동네질문</c:when>
                    <c:when test="${cat == '3' || cat == '동네맛집'}">동네맛집</c:when>
                    <c:when test="${cat == '4' || cat == '같이해요'}">같이해요</c:when>
                    <c:when test="${cat == '5' || cat == '분실/실종'}">분실/실종</c:when>
                    <c:when test="${cat == '6' || cat == '동네사건사고'}">동네사건사고</c:when>
                    <c:when test="${cat == '7' || cat == '생활정보'}">생활정보</c:when>
                    <c:when test="${cat == '8' || cat == '취미생활'}">취미생활</c:when>
                    <c:otherwise>일상</c:otherwise>
                </c:choose>
            </div>
            <h1 class="article-subject">${dto.subject}</h1>

            <div class="profile-box">
                <div class="profile-img">
                    <img src="${pageContext.request.contextPath}/dist/images/avatar.png" alt="프로필">
                </div>
                <div class="profile-info">
                    <a href="javascript:void(0);" onclick="openProfileModal('${dto.memberIdx}')" class="nickname">${dto.writerNickname}</a>
                    <div class="meta">
                        <span id="articleRegDate" data-date="${dto.regDate}"></span>
                        <span class="dot">·</span>
                        <span>조회 ${dto.hitCount}</span>
                    </div>
                </div>

                <c:if test="${sessionScope.member.userIdx == dto.memberIdx}">
                    <div class="more-btn-wrapper">
                        <button type="button" class="btn-more" onclick="toggleMenu()">
                            <i class="ri-more-fill"></i>
                        </button>
                        <div class="dropdown-menu" id="dropdownMenu">
                            <button type="button" onclick="checkAndEdit('${dto.id}', '${page}')">수정</button>
                            <button type="button" class="danger" onclick="deleteArticle('${dto.id}')">삭제</button>
                        </div>
                    </div>
                </c:if>
                <c:if test="${sessionScope.member.userIdx != dto.memberIdx}">
                    <button type="button" class="btn-report-article"
                            onclick="openReportModal('COMMUNITY', ${dto.id}, ${dto.memberIdx})"
                            title="신고하기">
                        <i class="ri-alarm-warning-line"></i>
                    </button>
                </c:if>
            </div>
        </div>

        <div class="divider"></div>

        <div class="article-body">
            <c:if test="${not empty dto.pollTitle}">
                <div class="poll-card" id="pollSection" data-poll-id="${dto.id}">
                    <div class="poll-header">
                        <span class="poll-badge">투표</span>
                        <h3 class="poll-title">${dto.pollTitle}</h3>
                        <div class="poll-meta">
                            <span id="pollEndDate" data-date="${dto.pollEndDate}"></span>
                            <span class="dot">·</span>
                            <span>${dto.pollMultiple ? '복수선택' : '단일선택'}</span>
                        </div>
                    </div>
                    <div class="poll-content" id="pollOptionsBox">
                        <div class="loading-spinner"><i class="ri-loader-4-line ri-spin"></i> 투표 로딩중...</div>
                    </div>
                    <div class="poll-footer">
                        <div style="display:flex;gap:8px;align-items:center;">
                            <button type="button" class="btn-vote-submit" id="btnVoteSubmit" style="display:none;">투표하기</button>
                            <button type="button" class="btn-vote-cancel" id="btnVoteCancel" style="display:none;">투표 취소</button>
                        </div>
                        <span class="total-votes" id="totalVotesDisplay">0명 참여</span>
                    </div>
                </div>
            </c:if>

            <div class="content-text ql-editor">
                ${dto.content}
            </div>

            <c:if test="${dto.latitude != null && dto.latitude != 0}">
                <div class="map-card">
                    <div class="map-header"
                         style="cursor:pointer;"
                         onclick="window.open('https://map.kakao.com/link/map/${dto.placeName},${dto.latitude},${dto.longitude}', '_blank')"
                         title="카카오맵에서 보기">
                        <i class="ri-map-pin-fill"></i>
                        <div class="place-info">
                            <strong>${dto.placeName}</strong>
                            <span>${dto.address}</span>
                        </div>
                        <i class="ri-external-link-line" style="margin-left:auto; color:var(--text-3); font-size:14px;"></i>
                    </div>
                    <div id="map" class="map-view"
                         data-lat="${dto.latitude}" data-lng="${dto.longitude}">
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty dto.attachFileInfos}">
                <div class="attach-section">
                    <div class="attach-section-title">
                        <i class="ri-attachment-2"></i>
                        <span>첨부파일 <em>${fn:length(dto.attachFileInfos)}개</em></span>
                    </div>
                    <ul class="attach-download-list">
                        <c:forEach var="af" items="${dto.attachFileInfos}">
                            <li>
                                <a href="${pageContext.request.contextPath}/community/download?filename=${af.saveFilename}&originalFilename=${af.originalFilename}" class="attach-download-item" download>
                                    <i class="ri-file-download-line attach-dl-icon"></i>
                                    <span class="attach-dl-name">${af.originalFilename}</span>
                                    <span class="attach-dl-size"><fmt:formatNumber value="${af.fileSize / 1024}" maxFractionDigits="1"/>KB</span>
                                </a>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>

            <c:if test="${not empty dto.tags}">
                <div class="tag-list">
                    <c:forEach var="tag" items="${dto.tags}">
                        <span class="tag-chip">#${tag}</span>
                    </c:forEach>
                </div>
            </c:if>
        </div>

        <div class="article-actions">
            <button type="button" class="action-btn ${isUserLiked ? 'active' : ''}" id="btnLike" onclick="toggleLike('${dto.id}')">
                <i class="${isUserLiked ? 'ri-heart-3-fill' : 'ri-heart-3-line'}"></i>
                <span id="likeCount">${dto.likeCount}</span>
                <span>좋아요</span>
            </button>
            <button type="button" class="action-btn ${isUserScraped ? 'active' : ''}" id="btnScrap" onclick="toggleScrap('${dto.id}')">
                <i class="${isUserScraped ? 'ri-bookmark-fill' : 'ri-bookmark-line'}"></i>
                <span>스크랩</span>
            </button>
            <button type="button" class="action-btn" onclick="location.href='${pageContext.request.contextPath}/community/list?${query}'">
                <i class="ri-list-check-2"></i> 목록
            </button>
        </div>

        <div class="divider thick"></div>

        <div class="reply-section">
            <h3 class="reply-title">댓글 <span class="highlight" id="replyCount">0</span></h3>

            <div class="reply-input-box">
                <textarea id="replyContent" placeholder="이웃에게 따뜻한 댓글을 남겨주세요." class="input-reply"></textarea>
                <div class="input-bottom">
                    <button type="button" class="btn-reply-submit" onclick="sendReply('${dto.id}')">등록</button>
                </div>
            </div>

            <div id="replyList" class="reply-list"></div>
        </div>
    </div>
</div>

<div id="profileModal">
    <div class="modal-dialog">
        <div class="modal-content" id="profileModalContent">
            <div class="up-modal-loading" id="profileModalLoading">
                <div class="up-modal-sk-cover"></div>
                <div class="up-modal-sk-body">
                    <div class="up-modal-sk-avatar"></div>
                    <div class="up-modal-sk-line w60"></div>
                    <div class="up-modal-sk-line w40"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="toast-container" id="toastContainer"></div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
    const contextPath = "${pageContext.request.contextPath}";
    window.contextPath = contextPath;
    const communityId = "${dto.id}";
    const currentMemberIdx = "${sessionScope.member.userIdx}";
    const currentPage = "${page}";

    function openProfileModal(memberIdx) {
        const modalEl   = document.getElementById('profileModal');
        const contentEl = document.getElementById('profileModalContent');
        const loadingEl = document.getElementById('profileModalLoading');

        [...contentEl.children].forEach(el => {
            if (el.id !== 'profileModalLoading') el.remove();
        });
        if (loadingEl) loadingEl.style.display = '';

        modalEl.classList.add('open');
        document.body.style.overflow = 'hidden';

        modalEl.onclick = function(e) {
            if (e.target === modalEl) closeProfileModal();
        };

        fetch(contextPath + '/community/user/' + encodeURIComponent(memberIdx))
            .then(r => {
                if (!r.ok) throw new Error('server error');
                return r.text();
            })
            .then(html => {
                if (loadingEl) loadingEl.style.display = 'none';
                const frag = document.createRange().createContextualFragment(html);
                contentEl.appendChild(frag);
            })
            .catch(() => {
                contentEl.innerHTML = '<div style="padding:40px;text-align:center;color:#888;">프로필을 불러오지 못했어요 😢</div>';
            });
    }

    function closeProfileModal() {
        document.getElementById('profileModal').classList.remove('open');
        document.body.style.overflow = '';
    }

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') closeProfileModal();
    });
</script>
<script src="${pageContext.request.contextPath}/dist/js/community/community-user-profile.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/community/community-article.js"></script>
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

</body>
</html>
