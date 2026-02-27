<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>커뮤니티 | BATON</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/community-list.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<main class="cm-main-container">
    <section class="cm-hero-section">
        <div class="container hero-inner">
            <div class="hero-text-box">
                <span class="sub-title">BATON COMMUNITY</span>
                <h1 class="main-title">우리 동네 <span class="highlight">커뮤니티</span></h1>
                <p class="desc">이웃들과 다양한 동네 소식을 나누고 질문해보세요.</p>
            </div>
            <div class="hero-search-box">
                <input type="text" id="cmSearchInput" placeholder="관심있는 소식이나 태그를 검색해보세요" value="${param.keyword}" onkeypress="if(event.keyCode==13) cmApplyFilter();">
                <button class="search-btn" onclick="cmApplyFilter()">검색</button>
            </div>
        </div>
    </section>

    <div class="content-wrapper">
        <div class="cm-toolbar">
            <div class="toolbar-top">
                <div class="filter-group cm-filter-list">
                    <button class="filter-btn active">전체</button>
                    <button class="filter-btn">동네질문</button>
                    <button class="filter-btn">동네맛집</button>
                    <button class="filter-btn">동네소식</button>
                    <button class="filter-btn">분실/실종</button>
                    <button class="filter-btn">일상</button>
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
                    <label class="toggle-switch-wrap">
                        <input type="checkbox" class="purple-switch" id="cmPhotoOnly">
                        <span class="toggle-label">사진 있는 글만</span>
                    </label>
                    <span class="divider">|</span>
                    <select class="detail-select sort-select">
                        <option value="latest">최신순</option>
                        <option value="popular">인기순</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="cm-content-area grid-mode" id="cmContentArea">
            <c:forEach var="i" begin="1" end="8">
                <div class="cm-item-card" onclick="location.href='#'">
                    <div class="card-visual">
                        <div class="card-img-box">
                            <img src="https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500" alt="community">
                        </div>
                        <div class="card-badge">동네소식</div>
                        <button type="button" class="card-wish" onclick="event.stopPropagation(); this.classList.toggle('active');">
                            <i class="ri-heart-3-line"></i>
                        </button>
                    </div>

                    <div class="card-body">
                        <h3 class="card-title">오늘 날씨가 너무 좋아서 산책 나왔어요! ☀️</h3>
                        <p class="card-text">공원에 사람들도 많고 꽃도 조금씩 피기 시작했네요. 다들 오늘 점심 드시고 가벼운 산책 어떠신가요? 기분이 너무 좋네요.</p>

                        <div class="card-meta">
                            <span class="meta-item"><i class="ri-map-pin-2-line"></i> 강남구 역삼동</span>
                            <span class="meta-item"><i class="ri-time-line"></i> 10분 전</span>
                        </div>

                        <div class="card-footer">
                            <div class="user-info">
                                <div class="user-avatar"><i class="ri-user-6-line"></i></div>
                                <span class="user-nick">동네이웃${i}</span>
                            </div>
                            <div class="stats-info">
                                <span><i class="ri-eye-line"></i> ${i * 7}</span>
                                <span><i class="ri-chat-1-line"></i> ${i}</span>
                                <span><i class="ri-heart-3-fill"></i> ${i + 2}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <div class="pagination-container">
            <button class="cm-page-btn" disabled>&#8249;</button>
            <button class="cm-page-btn active">1</button>
            <button class="cm-page-btn">2</button>
            <button class="cm-page-btn">3</button>
            <button class="cm-page-btn">&#8250;</button>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<button class="cm-fab" onclick="location.href='${pageContext.request.contextPath}/community/write'">
    <i class="ri-pencil-line"></i>
</button>

<script>
function cmSwitchView(mode) {
    const area = document.getElementById('cmContentArea');
    const gridBtn = document.getElementById('grid-view-btn');
    const listBtn = document.getElementById('list-view-btn');
    if (mode === 'grid') {
        area.classList.remove('list-mode');
        area.classList.add('grid-mode');
        gridBtn.classList.add('active');
        listBtn.classList.remove('active');
    } else {
        area.classList.remove('grid-mode');
        area.classList.add('list-mode');
        listBtn.classList.add('active');
        gridBtn.classList.remove('active');
    }
}
</script>
</body>
</html>