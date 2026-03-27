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
    <style>
        .cm-main-container {
            background: #f5f6f8;
        }
        .cm-hero-section {
            padding: 78px 0 56px;
            background: #fff;
        }
        .hero-text-box .sub-title {
            color: #ff6f7d;
            letter-spacing: 2px;
        }
        .hero-text-box .main-title {
            font-size: 58px;
            line-height: 1.14;
            letter-spacing: -1.8px;
            margin: 14px 0 18px;
        }
        .hero-text-box .desc {
            font-size: 17px;
            color: #6b7280;
        }
        .main-title .highlight {
            color: #ff7f8f;
        }
        .hero-search-box {
            max-width: 640px;
            border: 1px solid #d9dde3;
            box-shadow: none;
            padding: 6px 6px 6px 22px;
        }
        .hero-search-box:focus-within {
            border-color: #101828;
            box-shadow: 0 0 0 4px rgba(17, 24, 39, 0.06);
        }
        .search-btn {
            min-width: 86px;
            background: #111827;
            border-radius: 999px;
            padding: 13px 24px;
        }
        .search-btn:hover {
            background: #0b1220;
            transform: none;
        }
        .content-wrapper {
            max-width: 1280px;
            margin-top: 38px;
        }
        .cm-curation-section {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 24px;
            padding: 42px 58px;
            border-radius: 30px;
            background: linear-gradient(90deg, #ffffff 0%, #ffffff 74%, #fff2f4 100%);
            border: 1px solid #eceef2;
            box-shadow: 0 14px 32px rgba(15, 23, 42, 0.04);
            margin-bottom: 26px;
        }
        .cm-curation-copy {
            flex: 1;
        }
        .cm-curation-copy .eyebrow {
            display: inline-block;
            margin-bottom: 14px;
            color: #ff7f8f;
            font-size: 15px;
            font-weight: 800;
            letter-spacing: -0.2px;
        }
        .cm-curation-copy h2 {
            margin: 0;
            font-size: 28px;
            line-height: 1.35;
            letter-spacing: -0.8px;
            color: #111827;
            font-weight: 800;
        }
        .cm-curation-copy h2 .point {
            color: #ff7f8f;
        }
        .cm-curation-copy p {
            margin: 14px 0 0;
            color: #6b7280;
            font-size: 16px;
            font-weight: 600;
        }
        .cm-curation-actions {
            display: flex;
            align-items: center;
            gap: 14px;
            flex-shrink: 0;
        }
        .cm-curation-actions .ghost-btn,
        .cm-curation-actions .dark-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 128px;
            height: 54px;
            padding: 0 24px;
            border-radius: 18px;
            font-size: 16px;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.2s ease;
        }
        .cm-curation-actions .ghost-btn {
            color: #4b5563;
            background: rgba(255,255,255,0.74);
            border: 1px solid #e5e7eb;
        }
        .cm-curation-actions .dark-btn {
            color: #fff;
            background: #111827;
            box-shadow: 0 14px 28px rgba(17, 24, 39, 0.16);
        }
        .cm-curation-actions .ghost-btn:hover,
        .cm-curation-actions .dark-btn:hover {
            transform: translateY(-1px);
        }
        .cm-toolbar {
            margin-bottom: 36px;
            opacity: 1;
            animation: none;
            border-radius: 28px;
            background: #fff;
            border: 1px solid #eceef2;
            box-shadow: 0 14px 32px rgba(15, 23, 42, 0.04);
            padding: 10px 28px 8px;
        }
        .toolbar-top {
            display: block;
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }
        .cm-filter-row {
            display: flex;
            align-items: center;
            gap: 22px;
            padding: 18px 0;
            border-bottom: 1px solid #f0f2f5;
        }
        .cm-filter-row:last-of-type {
            border-bottom: none;
        }
        .cm-filter-row.is-options {
            justify-content: space-between;
            padding-top: 16px;
            padding-bottom: 16px;
        }
        .cm-filter-title {
            width: 88px;
            min-width: 88px;
            color: #4b5563;
            font-size: 16px;
            font-weight: 700;
            letter-spacing: -0.3px;
            text-align: left;
        }
        .cm-filter-content {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            flex: 1;
            min-width: 0;
        }
        .cm-chip-arrow {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 28px;
            height: 28px;
            border: none;
            background: transparent;
            color: #8b95a1;
            font-size: 22px;
            padding: 0;
            cursor: default;
        }
        .filter-btn {
            min-height: 40px;
            padding: 0 18px;
            border-radius: 999px;
            border: 1px solid #d9dde3;
            background: #fff;
            color: #5b6472;
            font-size: 15px;
            font-weight: 700;
            box-shadow: none;
            transform: none !important;
        }
        .filter-btn.active,
        .filter-btn:hover {
            border-color: #ff7f8f;
            background: #ff7f8f;
            color: #fff;
            box-shadow: none;
        }
        .toolbar-bottom {
            justify-content: flex-end;
            padding: 0 0 12px;
        }
        .view-switch-group {
            display: none;
        }
        .action-group {
            gap: 14px;
        }
        .detail-select {
            height: 40px;
            border-radius: 12px;
            border: 1px solid #d9dde3;
            color: #4b5563;
            font-weight: 700;
        }
        .cm-option-note {
            color: #98a2b3;
            font-size: 14px;
            font-weight: 600;
        }
        .cm-toggle-wrap {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            color: #374151;
            font-size: 15px;
            font-weight: 700;
        }
        .cm-toggle-wrap input {
            appearance: none;
            width: 34px;
            height: 20px;
            border-radius: 999px;
            background: #ff8795;
            position: relative;
            outline: none;
            border: none;
            pointer-events: none;
        }
        .cm-toggle-wrap input::after {
            content: '';
            position: absolute;
            top: 2px;
            left: 16px;
            width: 16px;
            height: 16px;
            border-radius: 50%;
            background: #fff;
            box-shadow: 0 1px 2px rgba(15, 23, 42, 0.18);
        }
        @media (max-width: 1024px) {
            .hero-text-box .main-title {
                font-size: 42px;
            }
            .cm-curation-section {
                padding: 34px 28px;
            }
            .cm-filter-row {
                align-items: flex-start;
                flex-direction: column;
                gap: 14px;
            }
            .cm-filter-title {
                width: auto;
                min-width: 0;
            }
            .cm-filter-row.is-options {
                flex-direction: column;
                align-items: flex-start;
            }
        }
        @media (max-width: 768px) {
            .cm-hero-section {
                padding: 52px 0 36px;
            }
            .hero-text-box .main-title {
                font-size: 34px;
            }
            .hero-search-box {
                max-width: 100%;
            }
            .cm-curation-section {
                flex-direction: column;
                align-items: flex-start;
                padding: 28px 22px;
                border-radius: 24px;
            }
            .cm-curation-actions {
                width: 100%;
            }
            .cm-curation-actions .ghost-btn,
            .cm-curation-actions .dark-btn {
                flex: 1;
                min-width: 0;
            }
            .cm-toolbar {
                padding: 6px 18px;
                border-radius: 22px;
            }
            .cm-filter-content {
                gap: 8px;
            }
            .filter-btn {
                min-height: 36px;
                padding: 0 14px;
                font-size: 14px;
            }
            .toolbar-bottom {
                padding-bottom: 10px;
            }
        }
    </style>
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
                <input type="text" name="kwd" id="cmSearchInput" placeholder="관심있는 소식이나 내용을 검색해보세요" value="${kwd}" autocomplete="off">
                <button type="button" class="search-btn" onclick="submitSearch()">검색</button>
            </form>
        </div>
    </section>

    <div class="content-wrapper">
        <section class="cm-curation-section">
            <div class="cm-curation-copy">
                <span class="eyebrow">함께하면 더 즐거운 커뮤니티</span>
                <h2>취향이 맞는 사람들과 <span class="point">오늘 바로</span> 모여보세요!</h2>
                <p>원하는 주제가 있나요? 우리 동네 이웃들과 소식과 관심사를 가볍게 나눠보세요.</p>
            </div>
            <div class="cm-curation-actions">
                <a href="${pageContext.request.contextPath}/crew/list" class="ghost-btn">이용 가이드</a>
                <a href="javascript:goToWrite();" class="dark-btn">글 작성하기</a>
            </div>
        </section>

        <div class="cm-toolbar">
            <div class="toolbar-top">
                <div class="cm-filter-row">
                    <div class="cm-filter-title">카테고리</div>
                    <div class="cm-filter-content">
                        <span class="cm-chip-arrow"><i class="ri-arrow-left-s-line"></i></span>
                        <button type="button" class="filter-btn ${empty category ? 'active' : ''}" onclick="filterByCategory('')">전체</button>
                        <button type="button" class="filter-btn ${category == '일상' ? 'active' : ''}" onclick="filterByCategory('일상')">일상</button>
                        <button type="button" class="filter-btn ${category == '동네질문' ? 'active' : ''}" onclick="filterByCategory('동네질문')">동네질문</button>
                        <button type="button" class="filter-btn ${category == '동네맛집' ? 'active' : ''}" onclick="filterByCategory('동네맛집')">동네맛집</button>
                        <button type="button" class="filter-btn ${category == '같이해요' ? 'active' : ''}" onclick="filterByCategory('같이해요')">같이해요</button>
                        <button type="button" class="filter-btn ${category == '분실/실종' ? 'active' : ''}" onclick="filterByCategory('분실/실종')">분실/실종</button>
                        <button type="button" class="filter-btn ${category == '동네사건사고' ? 'active' : ''}" onclick="filterByCategory('동네사건사고')">동네사건사고</button>
                        <button type="button" class="filter-btn ${category == '생활정보' ? 'active' : ''}" onclick="filterByCategory('생활정보')">생활정보</button>
                        <button type="button" class="filter-btn ${category == '취미생활' ? 'active' : ''}" onclick="filterByCategory('취미생활')">취미생활</button>
                        <span class="cm-chip-arrow"><i class="ri-arrow-right-s-line"></i></span>
                    </div>
                </div>

                <div class="cm-filter-row is-options">
                    <div class="cm-filter-title">적용옵션</div>
                    <div class="cm-option-note">선택한 추가 필터가 없습니다.</div>
                    <div class="action-group">
                        <label class="cm-toggle-wrap">
                            <input type="checkbox" checked>
                            <span>최신 글만 보기</span>
                        </label>
                        <select class="detail-select sort-select" onchange="filterBySort(this.value)">
                            <option value="latest" ${sort == 'latest' ? 'selected' : ''}>최신순</option>
                            <option value="hit" ${sort == 'hit' ? 'selected' : ''}>조회순</option>
                            <option value="like" ${sort == 'like' ? 'selected' : ''}>좋아요순</option>
                        </select>
                        <button class="btn-create-cm" onclick="goToWrite()">
                            <i class="ri-pencil-line"></i> 글쓰기
                        </button>
                    </div>
                </div>
            </div>

            <div class="toolbar-bottom"></div>
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
                            <c:choose>
                                <c:when test="${dto.category == 1 || dto.category == '1' || dto.category == '일상'}">일상</c:when>
                                <c:when test="${dto.category == 2 || dto.category == '2' || dto.category == '동네질문'}">동네질문</c:when>
                                <c:when test="${dto.category == 3 || dto.category == '3' || dto.category == '동네맛집'}">동네맛집</c:when>
                                <c:when test="${dto.category == 4 || dto.category == '4' || dto.category == '같이해요'}">같이해요</c:when>
                                <c:when test="${dto.category == 5 || dto.category == '5' || dto.category == '분실/실종'}">분실/실종</c:when>
                                <c:when test="${dto.category == 6 || dto.category == '6' || dto.category == '동네사건사고'}">동네사건사고</c:when>
                                <c:when test="${dto.category == 7 || dto.category == '7' || dto.category == '생활정보'}">생활정보</c:when>
                                <c:when test="${dto.category == 8 || dto.category == '8' || dto.category == '취미생활'}">취미생활</c:when>
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
                            var text = (tmp.innerText || tmp.textContent || '').replace(/\s+/g,' ').trim();
                            var el = document.getElementById('cardText_${dto.id}');
                            if(el) el.innerText = text.length > 80 ? text.substring(0,80)+'...' : text;
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