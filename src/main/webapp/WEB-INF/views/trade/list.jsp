<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>중고거래 | 마켓</title>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
    :root {
        --primary: #FF6F0F;
        --primary-dark: #e55e00;
        --primary-light: #FFF3EC;
        --surface: #ffffff;
        --bg: #F7F8FA;
        --border: #E8EAED;
        --text-main: #1A1A1A;
        --text-sub: #72787F;
        --text-muted: #B0B8C1;
        --radius: 12px;
        --radius-sm: 8px;
        --shadow: 0 1px 3px rgba(0,0,0,0.08), 0 4px 16px rgba(0,0,0,0.05);
        --green: #00C471;
    }
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: 'Noto Sans KR', sans-serif; background: var(--bg); color: var(--text-main); min-height: 100vh; }
    a { text-decoration: none; color: inherit; }

    .app-header {
        position: sticky; top: 0; z-index: 100;
        background: var(--surface); border-bottom: 1px solid var(--border);
        height: 56px; display: flex; align-items: center;
        padding: 0 20px; gap: 12px;
    }
    .logo {
        font-size: 20px; font-weight: 700; color: var(--primary);
        letter-spacing: -0.5px; flex: 1;
    }
    .header-actions { display: flex; gap: 8px; align-items: center; }
    .icon-btn {
        width: 36px; height: 36px; border-radius: 50%;
        border: none; background: none; cursor: pointer;
        display: flex; align-items: center; justify-content: center;
        color: var(--text-main); transition: background .15s; font-size: 18px;
    }
    .icon-btn:hover { background: var(--bg); }

    .search-wrap {
        background: var(--surface); border-bottom: 1px solid var(--border);
        padding: 10px 20px;
    }
    .search-inner {
        max-width: 860px; margin: 0 auto;
        position: relative; display: flex; align-items: center;
    }
    .search-inner svg {
        position: absolute; left: 14px; color: var(--text-muted); flex-shrink: 0;
    }
    .search-inner input {
        width: 100%; padding: 10px 14px 10px 42px;
        border: 1.5px solid var(--border); border-radius: 100px;
        font-size: 14px; font-family: inherit; outline: none;
        background: var(--bg); color: var(--text-main);
        transition: border-color .2s, box-shadow .2s;
    }
    .search-inner input:focus {
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(255,111,15,0.12);
        background: var(--surface);
    }
    .search-inner input::placeholder { color: var(--text-muted); }

    .cat-scroll {
        background: var(--surface); border-bottom: 1px solid var(--border);
        overflow-x: auto; -webkit-overflow-scrolling: touch;
    }
    .cat-scroll::-webkit-scrollbar { display: none; }
    .cat-list {
        display: flex; gap: 0; padding: 0 20px;
        max-width: 860px; margin: 0 auto; list-style: none; min-width: max-content;
    }
    .cat-list li a {
        display: block; padding: 12px 16px;
        font-size: 14px; font-weight: 500; color: var(--text-sub);
        border-bottom: 2px solid transparent;
        white-space: nowrap; transition: color .15s, border-color .15s;
    }
    .cat-list li a:hover { color: var(--primary); }
    .cat-list li.active a { color: var(--primary); border-bottom-color: var(--primary); font-weight: 700; }

    .main-wrap { max-width: 860px; margin: 0 auto; padding: 20px 20px 100px; }

    .filter-bar {
        display: flex; align-items: center; justify-content: space-between;
        margin-bottom: 16px;
    }
    .result-count { font-size: 13px; color: var(--text-sub); }
    .result-count strong { color: var(--text-main); font-weight: 700; }
    .sort-select {
        padding: 7px 12px; border: 1.5px solid var(--border);
        border-radius: var(--radius-sm); font-size: 13px;
        font-family: inherit; background: var(--surface); color: var(--text-main);
        outline: none; cursor: pointer;
    }

    .product-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
        gap: 16px;
    }

    .product-card {
        background: var(--surface); border-radius: var(--radius);
        box-shadow: var(--shadow); overflow: hidden;
        transition: transform .2s, box-shadow .2s; cursor: pointer;
        display: flex; flex-direction: column;
    }
    .product-card:hover { transform: translateY(-3px); box-shadow: 0 6px 24px rgba(0,0,0,0.1); }

    .card-img {
        position: relative; aspect-ratio: 1/1; overflow: hidden;
        background: var(--bg);
    }
    .card-img img { width: 100%; height: 100%; object-fit: cover; transition: transform .3s; }
    .product-card:hover .card-img img { transform: scale(1.04); }
    .card-img .no-img {
        width: 100%; height: 100%;
        display: flex; align-items: center; justify-content: center;
        font-size: 40px; color: var(--text-muted);
    }

    .status-badge {
        position: absolute; top: 8px; left: 8px;
        padding: 3px 8px; border-radius: 4px;
        font-size: 11px; font-weight: 700; letter-spacing: .02em;
    }
    .badge-new { background: #E8F5E9; color: #2E7D32; }
    .badge-used { background: #E3F2FD; color: #1565C0; }
    .badge-broken { background: #FFEBEE; color: #C62828; }

    .wish-btn {
        position: absolute; bottom: 8px; right: 8px;
        width: 32px; height: 32px; border-radius: 50%;
        background: rgba(255,255,255,0.9); backdrop-filter: blur(4px);
        border: none; cursor: pointer; font-size: 16px;
        display: flex; align-items: center; justify-content: center;
        transition: transform .15s;
    }
    .wish-btn:hover { transform: scale(1.15); }
    .wish-btn.active { color: #e53935; }

    .sold-overlay {
        position: absolute; inset: 0;
        background: rgba(0,0,0,0.45);
        display: flex; align-items: center; justify-content: center;
    }
    .sold-overlay span {
        background: rgba(0,0,0,0.7); color: white;
        font-size: 14px; font-weight: 700;
        padding: 6px 14px; border-radius: 6px; letter-spacing: .04em;
    }

    .card-body { padding: 12px; flex: 1; display: flex; flex-direction: column; }
    .card-location {
        font-size: 11px; color: var(--text-muted); margin-bottom: 4px;
    }
    .card-title {
        font-size: 14px; font-weight: 600; color: var(--text-main);
        line-height: 1.4; margin-bottom: 8px;
        display: -webkit-box; -webkit-line-clamp: 2;
        -webkit-box-orient: vertical; overflow: hidden;
    }
    .card-price { font-size: 16px; font-weight: 700; color: var(--text-main); margin-top: auto; }
    .card-price.free { color: var(--green); }

    .card-footer {
        display: flex; align-items: center; justify-content: space-between;
        margin-top: 8px;
    }
    .card-time { font-size: 11px; color: var(--text-muted); }
    .card-stats { display: flex; gap: 8px; align-items: center; }
    .card-stats span { font-size: 11px; color: var(--text-muted); display: flex; align-items: center; gap: 2px; }

    .empty-state {
        text-align: center; padding: 80px 20px; color: var(--text-muted);
        grid-column: 1/-1;
    }
    .empty-state .empty-icon { font-size: 56px; margin-bottom: 16px; }
    .empty-state p { font-size: 15px; font-weight: 500; color: var(--text-sub); }
    .empty-state small { font-size: 13px; margin-top: 6px; display: block; }

    .pagination {
        display: flex; justify-content: center; align-items: center;
        gap: 6px; margin-top: 40px;
    }
    .page-btn {
        width: 36px; height: 36px; border-radius: var(--radius-sm);
        border: 1.5px solid var(--border); background: var(--surface);
        font-size: 14px; font-family: inherit; cursor: pointer;
        display: flex; align-items: center; justify-content: center;
        color: var(--text-sub); transition: all .15s;
    }
    .page-btn:hover { border-color: var(--primary); color: var(--primary); }
    .page-btn.active { background: var(--primary); border-color: var(--primary); color: white; font-weight: 700; }
    .page-btn:disabled { opacity: 0.4; cursor: default; }

    .fab {
        position: fixed; bottom: 24px; right: 24px;
        width: 56px; height: 56px; border-radius: 50%;
        background: var(--primary); color: white;
        border: none; font-size: 26px; cursor: pointer;
        box-shadow: 0 4px 16px rgba(255,111,15,0.45);
        display: flex; align-items: center; justify-content: center;
        transition: background .15s, transform .15s, box-shadow .15s;
        z-index: 50;
    }
    .fab:hover {
        background: var(--primary-dark); transform: scale(1.08);
        box-shadow: 0 6px 20px rgba(255,111,15,0.5);
    }
    .fab:active { transform: scale(0.97); }

    @media (max-width: 480px) {
        .product-grid { grid-template-columns: repeat(2, 1fr); gap: 10px; }
        .card-body { padding: 10px; }
        .card-price { font-size: 15px; }
    }
</style>
</head>
<body>

<header class="app-header">
    <span class="logo">🛍 마켓</span>
    <div class="header-actions">
        <button class="icon-btn" title="알림">🔔</button>
        <button class="icon-btn" title="채팅">💬</button>
        <button class="icon-btn" title="마이페이지">👤</button>
    </div>
</header>

<div class="search-wrap">
    <div class="search-inner">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
        </svg>
        <input type="text" id="searchInput" placeholder="어떤 물건을 찾고 있나요?" value="${param.keyword}">
    </div>
</div>

<nav class="cat-scroll">
    <ul class="cat-list">
        <li class="${empty param.categoryIdx ? 'active' : ''}">
            <a href="/trade/list">전체</a>
        </li>
        <li class="${param.categoryIdx == '1' ? 'active' : ''}">
            <a href="/trade/list?categoryIdx=1">📱 전자기기</a>
        </li>
        <li class="${param.categoryIdx == '2' ? 'active' : ''}">
            <a href="/trade/list?categoryIdx=2">👗 의류</a>
        </li>
        <li class="${param.categoryIdx == '3' ? 'active' : ''}">
            <a href="/trade/list?categoryIdx=3">💄 뷰티</a>
        </li>
        <li class="${param.categoryIdx == '4' ? 'active' : ''}">
            <a href="/trade/list?categoryIdx=4">⭐ 스타굿즈</a>
        </li>
        <li class="${param.categoryIdx == '5' ? 'active' : ''}">
            <a href="/trade/list?categoryIdx=5">🏠 가구/인테리어</a>
        </li>
        <li class="${param.categoryIdx == '6' ? 'active' : ''}">
            <a href="/trade/list?categoryIdx=6">📚 도서</a>
        </li>
        <li class="${param.categoryIdx == '7' ? 'active' : ''}">
            <a href="/trade/list?categoryIdx=7">🎮 게임</a>
        </li>
        <li class="${param.categoryIdx == '8' ? 'active' : ''}">
            <a href="/trade/list?categoryIdx=8">기타</a>
        </li>
    </ul>
</nav>

<main class="main-wrap">

    <!-- Filter bar -->
    <div class="filter-bar">
        <span class="result-count">
            <strong><c:out value="${not empty totalCount ? totalCount : '0'}"/></strong>개의 상품
        </span>
        <select class="sort-select" onchange="changeSort(this.value)">
            <option value="latest" ${param.sort == 'latest' || empty param.sort ? 'selected' : ''}>최신순</option>
            <option value="price_asc" ${param.sort == 'price_asc' ? 'selected' : ''}>낮은 가격순</option>
            <option value="price_desc" ${param.sort == 'price_desc' ? 'selected' : ''}>높은 가격순</option>
            <option value="popular" ${param.sort == 'popular' ? 'selected' : ''}>인기순</option>
        </select>
    </div>

    <div class="product-grid" id="productGrid">
        <c:choose>
            <c:when test="${not empty tradeList}">
                <c:forEach var="item" items="${tradeList}">
                    <a href="/trade/detail?tradeIdx=${item.tradeIdx}" class="product-card">
                        <div class="card-img">
                            <c:choose>
                                <c:when test="${not empty item.thumbUrl}">
                                    <img src="${item.thumbUrl}" alt="${item.title}" loading="lazy">
                                </c:when>
                                <c:otherwise>
                                    <div class="no-img">📷</div>
                                </c:otherwise>
                            </c:choose>

                            <c:choose>
                                <c:when test="${item.productStatus == '새상품'}">
                                    <span class="status-badge badge-new">새상품</span>
                                </c:when>
                                <c:when test="${item.productStatus == '고장/파손'}">
                                    <span class="status-badge badge-broken">파손</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge badge-used">${item.productStatus}</span>
                                </c:otherwise>
                            </c:choose>

                            <button type="button" class="wish-btn ${item.wishedByMe ? 'active' : ''}"
                                onclick="toggleWish(event, ${item.tradeIdx})">
                                ${item.wishedByMe ? '❤️' : '🤍'}
                            </button>

                            <c:if test="${item.tradeStatus == 'SOLD'}">
                                <div class="sold-overlay"><span>판매완료</span></div>
                            </c:if>
                        </div>

                        <div class="card-body">
                            <p class="card-location">📍 ${not empty item.tradePlace ? item.tradePlace : '장소 미정'}</p>
                            <p class="card-title">${item.title}</p>
                            <p class="card-price ${item.price == 0 ? 'free' : ''}">
                                <c:choose>
                                    <c:when test="${item.price == 0}">나눔</c:when>
                                    <c:otherwise><fmt:formatNumber value="${item.price}" pattern="#,###"/>원</c:otherwise>
                                </c:choose>
                            </p>
                            <div class="card-footer">
                                <span class="card-time">${item.timeAgo}</span>
                                <div class="card-stats">
                                    <span>🤍 ${item.wishCount}</span>
                                    <span>💬 ${item.chatCount}</span>
                                </div>
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </c:when>
            <c:otherwise>

                <div class="empty-state" id="emptyState">
                    <div class="empty-icon">🛒</div>
                    <p>아직 등록된 상품이 없어요</p>
                    <small>첫 번째 판매자가 되어보세요!</small>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <c:if test="${not empty pageInfo && pageInfo.totalPage > 1}">
        <div class="pagination">
            <button class="page-btn" onclick="goPage(${pageInfo.currentPage - 1})"
                ${pageInfo.currentPage <= 1 ? 'disabled' : ''}>
                ‹
            </button>
            <c:forEach begin="${pageInfo.startPage}" end="${pageInfo.endPage}" var="p">
                <button class="page-btn ${pageInfo.currentPage == p ? 'active' : ''}" onclick="goPage(${p})">${p}</button>
            </c:forEach>
            <button class="page-btn" onclick="goPage(${pageInfo.currentPage + 1})"
                ${pageInfo.currentPage >= pageInfo.totalPage ? 'disabled' : ''}>
                ›
            </button>
        </div>
    </c:if>

</main>

<button class="fab" onclick="location.href='/trade/write'" title="판매 글쓰기">+</button>

<script>

document.getElementById('searchInput').addEventListener('keydown', function(e) {
    if (e.key === 'Enter') {
        const keyword = this.value.trim();
        const url = new URL(location.href);
        if (keyword) url.searchParams.set('keyword', keyword);
        else url.searchParams.delete('keyword');
        url.searchParams.delete('page');
        location.href = url.toString();
    }
});

function changeSort(val) {
    const url = new URL(location.href);
    url.searchParams.set('sort', val);
    url.searchParams.delete('page');
    location.href = url.toString();
}

function goPage(page) {
    const url = new URL(location.href);
    url.searchParams.set('page', page);
    location.href = url.toString();
}

function toggleWish(e, tradeIdx) {
    e.preventDefault();
    e.stopPropagation();
    fetch(`/trade/wish?tradeIdx=${tradeIdx}`, { method: 'POST' })
        .then(res => res.json())
        .then(data => {
            const btn = e.currentTarget;
            btn.classList.toggle('active', data.wished);
            btn.textContent = data.wished ? '❤️' : '🤍';
        })
        .catch(() => alert('로그인이 필요합니다.'));
}
</script>
</body>
</html>