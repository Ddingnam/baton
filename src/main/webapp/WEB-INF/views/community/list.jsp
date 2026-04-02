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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/community/community-user-profile.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<main class="cm-main-container">
    <section class="cm-hero-section">
        <div class="hero-inner">
            <div class="hero-text-box">
                <span class="sub-title">BATON COMMUNITY</span>
                <h1 class="main-title">우리 동네 <span class="highlight">커뮤니티</span></h1>
  
                <c:choose>
                    <c:when test="${not empty dongName}">
                        <p class="desc"><strong>${dongName}</strong> 이웃들과 소식을 나누고 질문해보세요.</p>
                    </c:when>
              
                    <c:otherwise>
                        <p class="desc">이웃들과 다양한 동네 소식을 나누고 질문해보세요.</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <form name="searchForm" class="hero-search-box" action="${pageContext.request.contextPath}/community/list" method="get">
                <input type="hidden" name="category" value="${category}">
                <input type="hidden" name="sort" value="${sort}">
                <input type="hidden" name="page" value="1">
                <input type="hidden" name="schType" id="schTypeInput" value="${empty schType ? 'all' : schType}">
                <input type="text" name="kwd" id="cmSearchInput" placeholder="관심있는 소식이나 내용을 검색해보세요" value="${schType == 'tag' ? '' : kwd}" autocomplete="off">
                <button type="button" class="search-btn" onclick="submitSearch()">검색</button>
            </form>
        </div>
    </section>

    <div class="content-wrapper">

        
        <div class="cm-welcome-card">
            <div class="cm-welcome-content">
                <span class="cm-welcome-sub">이웃과 함께하는 커뮤니티</span>
                <h2 class="cm-welcome-title">우리 동네 이야기를 <span class="cm-welcome-highlight">지금 바로</span> 나눠보세요!</h2>
                <p class="cm-welcome-desc">궁금한 것은 물어보고, 알고 싶은 것은 찾아보세요.</p>
            </div>
            <div class="cm-welcome-actions">
                <button class="cm-guide-btn primary" onclick="goToWrite()">
                    <i class="ri-pencil-line"></i> 글쓰기
                </button>
            </div>
        </div>

        
        <div class="cm-glass-toolbar">

            
            <div class="cm-filter-row">
                <div class="cm-filter-label">카테고리</div>
                <div class="cm-filter-content">
                    <div class="cm-carousel-wrapper">
                        <button type="button" class="cm-carousel-nav cm-carousel-left" onclick="scrollCategoryTags('left')">
                            <i class="ri-arrow-left-s-line"></i>
                        </button>
                        <div class="cm-filter-container" id="categoryCarousel">
                            <div class="cm-filter-group">
                                <button type="button" class="cm-filter-btn ${empty category ? 'active' : ''}" onclick="filterByCategory('')">전체</button>
                                <button type="button" class="cm-filter-btn ${category == '일상' ? 'active' : ''}" onclick="filterByCategory('일상')">일상</button>
                                <button type="button" class="cm-filter-btn ${category == '동네질문' ? 'active' : ''}" onclick="filterByCategory('동네질문')">동네질문</button>
                                <button type="button" class="cm-filter-btn ${category == '동네맛집' ? 'active' : ''}" onclick="filterByCategory('동네맛집')">동네맛집</button>
                                <button type="button" class="cm-filter-btn ${category == '같이해요' ? 'active' : ''}" onclick="filterByCategory('같이해요')">같이해요</button>
                                <button type="button" class="cm-filter-btn ${category == '분실/실종' ? 'active' : ''}" onclick="filterByCategory('분실/실종')">분실/실종</button>
                                <button type="button" class="cm-filter-btn ${category == '동네사건사고' ? 'active' : ''}" onclick="filterByCategory('동네사건사고')">동네사건사고</button>
                                <button type="button" class="cm-filter-btn ${category == '생활정보' ? 'active' : ''}" onclick="filterByCategory('생활정보')">생활정보</button>
                                <button type="button" class="cm-filter-btn ${category == '취미생활' ? 'active' : ''}" onclick="filterByCategory('취미생활')">취미생활</button>
                            </div>
                        </div>
                        <button type="button" class="cm-carousel-nav cm-carousel-right" onclick="scrollCategoryTags('right')">
                            <i class="ri-arrow-right-s-line"></i>
                        </button>
                    </div>
                </div>
            </div>

            
            <div class="cm-filter-row">
                <div class="cm-filter-label">해시태그</div>
                <div class="cm-filter-content cm-hashtag-row-content">
                    <div class="cm-hashtag-search-wrap">
                        <span class="cm-hashtag-symbol">#</span>
                        <input type="text" class="cm-hashtag-input" id="hashtagInput"
                               placeholder="태그명으로 검색하세요"
                               value="${schType == 'tag' ? kwd : ''}"
                               onkeydown="if(event.key==='Enter'){submitHashtagSearch();}">
                        <button type="button" class="cm-hashtag-btn" onclick="submitHashtagSearch()">검색</button>
                    </div>
                    <c:if test="${schType == 'tag' && not empty kwd}">
                        <span class="cm-active-tag-chip">
                            <i class="ri-hashtag"></i>${kwd}
                            <button type="button" class="cm-tag-chip-remove" onclick="clearHashtagSearch()"><i class="ri-close-line"></i></button>
                        </span>
                    </c:if>
                </div>
            </div>

            
            <div class="cm-filter-row cm-last-row">
                <div class="cm-filter-label">적용옵션</div>
                <div class="cm-filter-content cm-flex-between">

                    
                    <div class="cm-applied-chips-area">
                        <c:choose>
                            <c:when test="${(not empty category) || (schType == 'tag' && not empty kwd)}">
                                <div class="cm-applied-chips">
                                    <c:if test="${not empty category}">
                                        <span class="cm-applied-chip">
                                            <button type="button" class="cm-chip-remove" onclick="filterByCategory('')">
                                                <i class="ri-close-line"></i>
                                            </button>
                                            ${category}
                                        </span>
                                    </c:if>
                                    <c:if test="${schType == 'tag' && not empty kwd}">
                                        <span class="cm-applied-chip cm-applied-chip--tag">
                                            <button type="button" class="cm-chip-remove" onclick="clearHashtagSearch()">
                                                <i class="ri-close-line"></i>
                                            </button>
                                            #${kwd}
                                        </span>
                                    </c:if>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <span class="cm-no-filter-text">선택된 추가 필터가 없습니다.</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    
                    <div class="cm-view-controls">
                        <div class="view-switch-group">
                            <button type="button" class="view-btn active" id="grid-view-btn" onclick="cmSwitchView('grid')">
                                <i class="ri-grid-fill"></i> 칸으로 보기
                            </button>
                            <button type="button" class="view-btn" id="list-view-btn" onclick="cmSwitchView('list')">
                                <i class="ri-list-unordered"></i> 글로 보기
                            </button>
                        </div>
                        <span class="cm-ctrl-divider">|</span>
                        <select class="detail-select sort-select" onchange="filterBySort(this.value)">
                            <option value="latest" ${sort == 'latest' ? 'selected' : ''}>최신순</option>
                            <option value="hit" ${sort == 'hit' ? 'selected' : ''}>조회순</option>
                            <option value="like" ${sort == 'like' ? 'selected' : ''}>좋아요순</option>
                        </select>
                    </div>

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

                    <c:set var="thumbUrl" value="" />
                    <c:if test="${not empty dto.content}">
                        <c:set var="imgTag" value='src="' />
                        <c:set var="startIdx" value="${fn:indexOf(dto.content, imgTag)}" />
                        <c:if test="${startIdx >= 0}">
                            <c:set var="afterSrc" value="${fn:substring(dto.content, startIdx + 5, fn:length(dto.content))}" />
                            <c:set var="endIdx" value="${fn:indexOf(afterSrc, '\"')}" />
                            <c:if test="${endIdx >= 0}">
                                <c:set var="thumbUrl" value="${fn:substring(afterSrc, 0, endIdx)}" />
                            </c:if>
                        </c:if>
                    </c:if>

                    <div class="card-visual ${empty thumbUrl ? 'no-image' : ''}">
                        <c:choose>
                            <c:when test="${not empty thumbUrl}">
                                <img src="${thumbUrl}" alt="thumbnail">
                            </c:when>
                            <c:otherwise>
                                <i class="ri-image-line"></i>
                            </c:otherwise>
                        </c:choose>
                        <span class="card-badge">
                            <c:set var="cat" value="${dto.category}"/>
                            <c:choose>
                                <c:when test="${cat == '동네질문'}">동네질문</c:when>
                                <c:when test="${cat == '동네맛집'}">동네맛집</c:when>
                                <c:when test="${cat == '같이해요'}">같이해요</c:when>
                                <c:when test="${cat == '분실/실종'}">분실/실종</c:when>
                                <c:when test="${cat == '동네사건사고'}">동네사건사고</c:when>
                                <c:when test="${cat == '생활정보'}">생활정보</c:when>
                                <c:when test="${cat == '취미생활'}">취미생활</c:when>
                                <c:otherwise>일상</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <div class="card-body">
                        <h3 class="card-title">${dto.subject}</h3>
                        <p class="card-text" id="cardText_${dto.id}"></p>
                        <script>
                        (function(){
                            var tmp = document.createElement('div');
                            tmp.innerHTML = `<c:out value="${dto.content}" escapeXml="false"/>`;
                            var text = (tmp.innerText || tmp.textContent || '').split('\n')[0].trim();
                            var el = document.getElementById('cardText_${dto.id}');
                            if(el) el.innerText = text;
                        })();
                        </script>

                        <div class="card-meta">
                            <c:if test="${not empty dto.placeName}">
                                <span class="meta-item"><i class="ri-map-pin-2-line"></i>${dto.placeName}</span>
                            </c:if>
                            <c:if test="${not empty dto.dong}">
                                <span class="meta-item"><i class="ri-community-line"></i>${dto.dong}</span>
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
                                <span class="user-nick"
                                      onclick="event.preventDefault(); event.stopPropagation(); openProfileModal('${dto.memberIdx}');">
                                    ${dto.writerNickname}
                                </span>
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

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
    const contextPath = "${pageContext.request.contextPath}";
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
<script src="${pageContext.request.contextPath}/dist/js/community/community-list.js"></script>
</body>
</html>
