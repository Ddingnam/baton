<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/WEB-INF/views/layout/headerResources.jsp" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>${alba.title} | BATON 알바</title>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<link href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/alba/alba-article.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<main class="daangn-layout">
    <section class="gallery-section">
        <div class="main-image-wrap">
            <c:choose>
                <c:when test="${not empty imageList}">
                    <img id="mainImage" src="${pageContext.request.contextPath}${imageList[0].imgUrl}" alt="${alba.title}">
                </c:when>
                <c:when test="${not empty alba.imgUrl}">
                     <img id="mainImage" src="${pageContext.request.contextPath}${alba.imgUrl}" alt="${alba.title}">
                </c:when>
                <c:otherwise>
                    <div class="no-image-placeholder">
                        <i class="ri-store-2-line"></i>
                    </div>
                </c:otherwise>
            </c:choose>

            <c:if test="${alba.recruitStatus == '모집완료'}">
                <div class="status-overlay">
                    <span class="status-overlay-badge">모집완료</span>
                </div>
            </c:if>
        </div>
        <c:if test="${not empty imageList && imageList.size() > 1}">
            <div class="image-indicators">
                <c:forEach var="item" items="${imageList}" varStatus="st">
                    <button type="button" class="indicator-dot ${st.index == 0 ? 'active' : ''}" onclick="Gallery.selectThumb(${st.index})"></button>
                </c:forEach>
            </div>
        </c:if>
    </section>

    <div class="content-container">
        <section class="profile-section" onclick="location.href='${pageContext.request.contextPath}/member/profile?userIdx=${employerUserIdx}'">
            <div class="profile-left">
                <div class="profile-image">
                    <img src="${pageContext.request.contextPath}/dist/images/default_profile.png" alt="프로필">
                </div>
                <div class="profile-info">
                    <div class="profile-name">${alba.nickName}</div>
                    <div class="profile-region">
                        <c:choose>
                            <c:when test="${not empty regionName}">${regionName}</c:when>
                            <c:otherwise>동네 정보 없음</c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            <div class="profile-right">
                <div class="trust-score">
                    <span class="score-value">응답률 98%</span>
                    <span class="score-label">이력서 피드백 확률 높음</span>
                </div>
            </div>
        </section>

        <section class="article-header">
            <div class="badges">
                <span class="badge category-badge">${alba.categoryName}</span>
                <span class="badge status-badge">${alba.recruitStatus}</span>
            </div>
            <h1 class="article-title">${alba.title}</h1>
            <div class="article-meta">등록일 ${alba.createdDate}</div>
        </section>

        <section class="conditions-section">
            <h2 class="section-title">근무 조건</h2>
            <div class="condition-grid">
                <div class="cond-item pay-highlight">
                    <div class="cond-icon"><i class="ri-money-cny-circle-fill"></i></div>
                    <div class="cond-text">
                        <span class="label">급여</span>
                        <span class="value navy-text">${alba.wageType} <fmt:formatNumber value="${alba.wage}" pattern="#,###"/>원</span>
                    </div>
                </div>
                <div class="cond-item">
                    <div class="cond-icon"><i class="ri-calendar-event-line"></i></div>
                    <div class="cond-text">
                        <span class="label">근무기간/요일</span>
                        <span class="value">${alba.workPeriod} · ${alba.workDays}</span>
                    </div>
                </div>
                <div class="cond-item">
                    <div class="cond-icon"><i class="ri-time-line"></i></div>
                    <div class="cond-text">
                        <span class="label">근무시간</span>
                        <span class="value">
    						${alba.workHours} 
    					<c:if test="${alba.timeNegotiable == 'Y'}">(시간협의)</c:if>
						</span>
                    </div>
                </div>
            </div>
        </section>

        <section class="trust-badges-section">
            <h2 class="section-title">안심할 수 있는 일자리에요</h2>
            <ul class="trust-list">
                <li><i class="ri-check-double-line"></i> <span>알바 인증 완료</span></li>
                <li><i class="ri-file-paper-2-line"></i> <span>근로계약서 작성 약속</span></li>
                <li><i class="ri-shield-check-line"></i> <span>4대 사회보험 가입</span></li>
            </ul>
        </section>

        <section class="description-section">
            <h2 class="section-title">상세 요강</h2>
            <p class="article-text">${alba.content}</p>
            
            <c:if test="${not empty tagList}">
                <div class="tag-list">
                    <c:forEach var="tag" items="${tagList}">
                        <span class="tag-chip">#${tag}</span>
                    </c:forEach>
                </div>
            </c:if>
            
            <div class="article-stats">
                <span>조회 ${alba.hitCount}</span> · <span>관심 ${alba.likeCount}</span> · <span>지원 ${alba.chatCount}</span>
            </div>
        </section>

        <c:if test="${not empty alba.workPlace}">
            <section class="location-section">
                <h2 class="section-title">근무 지역</h2>
                <div class="location-box">
                    <i class="ri-map-pin-2-fill"></i>
                    <span class="address-text">${alba.workPlace}</span>
                    <button class="btn-copy" onclick="copyAddress('${alba.workPlace}')">복사</button>
                </div>
                </section>
        </c:if>

        <section class="safety-warning">
            <div class="warning-header">
                <i class="ri-error-warning-fill"></i> 지원 전 주의사항
            </div>
            <p><strong>채권추심 고액알바 및 통장, 비밀번호 요구</strong>는 보이스피싱 사기 범죄일 수 있습니다. 가담 시 사기방조죄로 처벌받을 수 있으니 절대 응하지 마세요.</p>
        </section>

        <sec:authorize access="isAuthenticated()">
            <sec:authentication property="principal.member.userIdx" var="loggedInUserId" />
            <c:if test="${loggedInUserId == dto.userIdx}">
                <section class="owner-manage-section">
                    <h2 class="section-title">내 공고 관리</h2>
                    <div class="manage-grid">
                        <button type="button" class="btn-manage" onclick="StatusModule.open()"><i class="ri-loop-left-line"></i> 상태 변경</button>
                        <button type="button" class="btn-manage" onclick="PullUpModule.execute(${alba.albaIdx})"><i class="ri-arrow-up-circle-line"></i> 끌어올리기</button>
                        <button type="button" class="btn-manage" onclick="location.href='${pageContext.request.contextPath}/alba/update?postingIdx=${dto.postingIdx}&page=${page}'">
    					<i class="ri-edit-line"></i> 수정
						</button>
                        <button type="button" class="btn-manage danger" onclick="confirmDelete(${alba.albaIdx})"><i class="ri-delete-bin-line"></i> 삭제</button>
                    </div>
                </section>
            </c:if>
        </sec:authorize>
    </div>
</main>

<div class="bottom-fixed-bar">
    <div class="bottom-inner">
        <div class="bottom-left">
           <button class="btn-wish ${isWished ? 'active' : ''}" id="wishBtnLarge" onclick="WishModule.toggle()">
    		<i class="${isWished ? 'ri-heart-3-fill' : 'ri-heart-3-line'}"></i>
		   </button>
        </div>
        <div class="bottom-right">
            <sec:authorize access="isAnonymous()">
                <button class="btn-action btn-call" onclick="location.href='tel:${alba.tel}'"><i class="ri-phone-fill"></i> 전화/문자</button>
                <button class="btn-action btn-apply" onclick="location.href='${pageContext.request.contextPath}/member/login'">온라인 지원</button>
            </sec:authorize>

            <sec:authorize access="isAuthenticated()">
                <c:choose>
                    <c:when test="${loggedInUserId == alba.userIdx}">
                        <button class="btn-action btn-apply full-width" onclick="window.open('${pageContext.request.contextPath}/chat/albaList?albaIdx=${alba.albaIdx}', 'chatList', 'width=450, height=850')">
                            지원 내역 보기 (${alba.chatCount})
                        </button>
                    </c:when>
                    <c:when test="${alba.recruitStatus == '모집완료'}">
                        <button class="btn-action btn-apply disabled full-width" disabled>모집이 완료되었습니다</button>
                    </c:when>
                    <c:otherwise>
                        <button class="btn-action btn-call" onclick="location.href='tel:${alba.tel}'"><i class="ri-phone-fill"></i> 전화/문자</button>
                        <button class="btn-action btn-apply" onclick="window.open('${pageContext.request.contextPath}/chat/room?albaIdx=${alba.albaIdx}&toUserIdx=${alba.userIdx}', 'chatRoom', 'width=450, height=850')">
                            온라인 지원
                        </button>
                    </c:otherwise>
                </c:choose>
            </sec:authorize>
        </div>
    </div>
</div>

<div id="statusModal" class="modal-overlay" onclick="StatusModule.close()">
    <div class="modal-content" onclick="event.stopPropagation()">
        <div class="modal-header">
            <h3>상태 변경</h3>
            <button type="button" class="close-modal" onclick="StatusModule.close()"><i class="ri-close-line"></i></button>
        </div>
        <div class="status-options">
            <button type="button" class="status-opt ${alba.recruitStatus == '모집중' ? 'active' : ''}" onclick="StatusModule.update('${alba.albaIdx}', '모집중')">모집중</button>
            <button type="button" class="status-opt ${alba.recruitStatus == '모집완료' ? 'active' : ''}" onclick="StatusModule.update('${alba.albaIdx}', '모집완료')">모집완료</button>
        </div>
    </div>
</div>

<div class="toast" id="toast"></div>
<div id="articleData" data-alba-idx="${alba.albaIdx}" data-wished="${isWished}" style="display:none"></div>

<script src="${pageContext.request.contextPath}/dist/js/alba/alba-article.js"></script>
</body>
</html>