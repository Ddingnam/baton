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
    <title>커뮤니티 | BATON</title>
    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/community/community-list.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<main class="cm-main-container">
    <section class="cm-hero-section">
        <div class="hero-inner">
            <div class="hero-text-box">
                <span class="sub-title">BATON COMMUNITY</span>
                <h1 class="main-title">우리 동네 <span class="highlight">커뮤니티</span></h1>
                <p class="desc">이웃들과 다양한 동네 소식을 나누고 질문해보세요.</p>
            </div>
            
            <form name="searchForm" class="hero-search-box" action="${pageContext.request.contextPath}/community/list" method="get">
                <input type="hidden" name="category" value="${category}">
                <input type="hidden" name="sort" value="${sort}">
                <input type="hidden" name="page" value="1">
                <input type="text" name="kwd" id="cmSearchInput" placeholder="관심있는 소식이나 내용을 검색해보세요" value="${kwd}" autocomplete="off">
                <button type="button" class="search-btn" onclick="submitSearch()">검색</button>
            </form>
        </div>
    </section>

    <div class="content-wrapper">
        <div class="cm-toolbar">
            <div class="toolbar-top">
                <div class="filter-group">
                    <button type="button" class="filter-btn ${empty category ? 'active' : ''}" onclick="location.href='${pageContext.request.contextPath}/community/list'">전체</button>
                    <button type="button" class="filter-btn ${category == '동네질문' ? 'active' : ''}" onclick="filterByCategory('동네질문')">동네질문</button>
                    <button type="button" class="filter-btn ${category == '동네맛집' ? 'active' : ''}" onclick="filterByCategory('동네맛집')">동네맛집</button>
                    <button type="button" class="filter-btn ${category == '동네소식' ? 'active' : ''}" onclick="filterByCategory('동네소식')">동네소식</button>
                    <button type="button" class="filter-btn ${category == '분실/실종' ? 'active' : ''}" onclick="filterByCategory('분실/실종')">분실/실종</button>
                    <button type="button" class="filter-btn ${category == '일상' ? 'active' : ''}" onclick="filterByCategory('일상')">일상</button>
                </div>
                <button class="btn-create-cm" onclick="location.href='${pageContext.request.contextPath}/community/write'">
                    <i class="ri-pencil-line"></i> 글쓰기
                </button>
            </div>

            <div class="toolbar-bottom">
                <div class="view-switch-group">
                    <button type="button" class="view-btn active" id="grid-view-btn" onclick="cmSwitchView('grid')">
                        <i class="ri-grid-fill"></i> 칸으로 보기
                    </button>
                    <button type="button" class="view-btn" id="list-view-btn" onclick="cmSwitchView('list')">
                        <i class="ri-list-unordered"></i> 글로 보기
                    </button>
                </div>
                <div class="action-group">
                    <select class="detail-select sort-select" onchange="filterBySort(this.value)">
                        <option value="latest" ${sort == 'latest' ? 'selected' : ''}>최신순</option>
                        <option value="hit" ${sort == 'hit' ? 'selected' : ''}>조회순</option>
                        <option value="like" ${sort == 'like' ? 'selected' : ''}>좋아요순</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="cm-content-area grid-mode" id="cmContentArea">
            <c:if test="${empty list}">
                <div class="no-data-box">
                    <i class="ri-inbox-2-line"></i>
                    <p>등록된 게시글이 없습니다.</p>
                </div>
            </c:if>

            <c:forEach var="dto" items="${list}" varStatus="vs">
                <a href="${pageContext.request.contextPath}/community/article/${dto.id}?page=${page}" class="cm-item-card" style="animation-delay: ${vs.index * 0.05}s">
                    <div class="card-visual ${empty dto.imageFiles ? 'no-image' : ''}">
                        <c:choose>
                            <c:when test="${not empty dto.imageFiles}">
                                <img src="${pageContext.request.contextPath}/uploads/community/${dto.imageFiles[0]}" alt="thumbnail">
                            </c:when>
                            <c:otherwise>
                                <i class="ri-image-line"></i>
                            </c:otherwise>
                        </c:choose>
                        <span class="card-badge">${dto.category}</span>
                    </div>

                    <div class="card-body">
                        <h3 class="card-title">${dto.subject}</h3>
                        <p class="card-text">
                            <c:out value="${fn:substring(fn:replace(dto.content, '<br>', ' '), 0, 80)}${fn:length(dto.content) > 80 ? '...' : ''}" />
                        </p>

                        <div class="card-meta">
                            <c:if test="${not empty dto.placeName}">
                                <span class="meta-item"><i class="ri-map-pin-2-line"></i>${dto.placeName}</span>
                            </c:if>
                            <span class="meta-item">
                                <i class="ri-time-line"></i>
                                <c:set var="rawDate" value="${dto.regDate}" />
                                <c:out value="${fn:substring(rawDate, 0, 16).replace('T', ' ')}" />
                            </span>
                        </div>

                        <div class="card-footer">
                            <div class="user-info">
                                <div class="user-avatar"><i class="ri-user-6-line"></i></div>
                                <span class="user-nick">${dto.writerNickname}</span>
                            </div>
                            <div class="stats-info">
                                <span><i class="ri-eye-line"></i>${dto.hitCount}</span>
                                <span><i class="ri-heart-3-fill"></i>${dto.likeCount}</span>
                            </div>
                        </div>
                    </div>
                </a>
            </c:forEach>
        </div>

        <div class="pagination-container">
            ${dataCount == 0 ? "" : paging}
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<button class="cm-fab" id="cmFab" onclick="location.href='${pageContext.request.contextPath}/community/write'">
    <i class="ri-pencil-line"></i>
</button>

<script src="${pageContext.request.contextPath}/dist/js/community/community-list.js"></script>
</body>
</html>