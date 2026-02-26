<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>중고거래 | BATON</title>
<%@ include file="/WEB-INF/views/layout/headerResources.jsp" %>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/trade-list.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="tl-page-wrap">

    <aside class="tl-sidebar">
        <button class="tl-mobile-filter-btn" onclick="tlMobileFilter()">
            ⚙️ 필터
        </button>
        
        <div class="tl-sidebar-section">
            <div class="tl-sidebar-card" id="tlCard1">
                <div class="tl-sidebar-head">필터</div>
                <div class="tl-status-filter">
                    <div class="tl-status-toggle">
                        <span>거래 가능만 보기</span>
                        <label class="tl-toggle-switch">
                            <input type="checkbox" id="tlAvailableOnly"
                                ${param.available == 'true' ? 'checked' : ''}
                                onchange="tlApplyFilter()">
                            <span class="tl-toggle-track"></span>
                        </label>
                    </div>
                </div>
            </div>
        </div>

        <div class="tl-sidebar-section">
            <div class="tl-sidebar-card" id="tlCard2">
                <div class="tl-sidebar-head">카테고리</div>
                <ul class="tl-filter-list">
                    <li class="${empty param.categoryIdx ? 'active' : ''}">
                        <a href="#" onclick="tlSetCategory(''); return false;">
                            <span class="tl-fi-dot"></span> 전체
                        </a>
                    </li>
                    <li class="${param.categoryIdx == '1' ? 'active' : ''}">
                        <a href="#" onclick="tlSetCategory('1'); return false;">
                            <span class="tl-fi-dot"></span> 📱 전자기기
                        </a>
                    </li>
                    <li class="${param.categoryIdx == '2' ? 'active' : ''}">
                        <a href="#" onclick="tlSetCategory('2'); return false;">
                            <span class="tl-fi-dot"></span> 👗 의류
                        </a>
                    </li>
                    <li class="${param.categoryIdx == '3' ? 'active' : ''}">
                        <a href="#" onclick="tlSetCategory('3'); return false;">
                            <span class="tl-fi-dot"></span> 💄 뷰티
                        </a>
                    </li>
                    <li class="${param.categoryIdx == '4' ? 'active' : ''}">
                        <a href="#" onclick="tlSetCategory('4'); return false;">
                            <span class="tl-fi-dot"></span> ⭐ 스타굿즈
                        </a>
                    </li>
                    <li class="${param.categoryIdx == '5' ? 'active' : ''}">
                        <a href="#" onclick="tlSetCategory('5'); return false;">
                            <span class="tl-fi-dot"></span> 🏠 가구/인테리어
                        </a>
                    </li>
                    <li class="${param.categoryIdx == '6' ? 'active' : ''}">
                        <a href="#" onclick="tlSetCategory('6'); return false;">
                            <span class="tl-fi-dot"></span> 📚 도서
                        </a>
                    </li>
                    <li class="${param.categoryIdx == '7' ? 'active' : ''}">
                        <a href="#" onclick="tlSetCategory('7'); return false;">
                            <span class="tl-fi-dot"></span> 🎮 게임
                        </a>
                    </li>
                    <li class="${param.categoryIdx == '8' ? 'active' : ''}">
                        <a href="#" onclick="tlSetCategory('8'); return false;">
                            <span class="tl-fi-dot"></span> 기타
                        </a>
                    </li>
                </ul>
            </div>
        </div>

        <div class="tl-sidebar-section">
            <div class="tl-sidebar-card" id="tlCard3">
                <div class="tl-sidebar-head">가격대</div>
                <div class="tl-price-range">
                    <div class="tl-price-row">
                        <input type="number" class="tl-price-input" id="tlPriceMin"
                            placeholder="최소" value="${param.priceMin}" min="0">
                        <span class="tl-price-sep">~</span>
                        <input type="number" class="tl-price-input" id="tlPriceMax"
                            placeholder="최대" value="${param.priceMax}" min="0">
                    </div>
                    <button class="tl-price-apply" onclick="tlApplyFilter()">가격 적용</button>
                </div>
            </div>
        </div>

        <button class="tl-reset-btn" onclick="tlResetFilters()">✕ 필터 초기화</button>

    </aside>

    <main class="tl-content">
		
		<div class="tl-content-header-filters">
            <div class="tl-search-field">
                <i class="ri-search-line tl-search-icon"></i>
                <input type="text" id="tlSearchInput" placeholder="어떤 물건을 찾고 있나요?" value="${param.keyword}">
            </div>
            
            <div class="tl-header-actions">                
                <button class="tl-write-btn" onclick="location.href='${pageContext.request.contextPath}/trade/write'">
                    + 판매하기
                </button>
            </div>
        </div>
		
        <div class="tl-title-row">
            <h1 class="tl-page-title">
                중고거래
                <small><c:out value="${not empty totalCount ? totalCount : '0'}"/>개의 상품</small>
            </h1>
            <select class="tl-sort-select" onchange="tlChangeSort(this.value)">
                <option value="latest"     ${param.sort == 'latest'     || empty param.sort ? 'selected' : ''}>최신순</option>
                <option value="price_asc"  ${param.sort == 'price_asc'  ? 'selected' : ''}>낮은 가격순</option>
                <option value="price_desc" ${param.sort == 'price_desc' ? 'selected' : ''}>높은 가격순</option>
                <option value="popular"    ${param.sort == 'popular'    ? 'selected' : ''}>인기순</option>
            </select>
        </div>

        <div class="tl-active-filters" id="tlActiveFilters"></div>

        <div class="tl-product-grid">
            <c:choose>
                <c:when test="${not empty tradeList}">
                    <c:forEach var="item" items="${tradeList}">
                        <a href="${pageContext.request.contextPath}/trade/article?productIdx=${item.productIdx}"
                            class="tl-product-card">
                            <div class="tl-card-img">
                                <c:choose>
                                    <c:when test="${not empty item.imgUrl}">
                                        <img src="${item.imgUrl}" alt="${item.title}" loading="lazy">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="tl-no-img">📷</div>
                                    </c:otherwise>
                                </c:choose>
                                <c:choose>
                                    <c:when test="${item.productStatus == '새상품'}">
                                        <span class="tl-status-badge tl-badge-new">새상품</span>
                                    </c:when>
                                    <c:when test="${item.productStatus == '고장/파손'}">
                                        <span class="tl-status-badge tl-badge-broken">파손</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="tl-status-badge tl-badge-used">${item.productStatus}</span>
                                    </c:otherwise>
                                </c:choose>
                                <button type="button"
                                    class="tl-wish-btn ${not empty item.likeByMe ? 'active' : ''}"
                                    onclick="tlToggleWish(event, ${item.productIdx})">
                                    ${item.likeByMe ? '❤️' : '🤍'}
                                </button>
                                <c:if test="${item.tradeStatus == 'SOLD'}">
                                    <div class="tl-sold-overlay"><span>판매완료</span></div>
                                </c:if>
                            </div>
                            <div class="tl-card-body">
                                <p class="tl-card-location">📍 ${not empty item.tradePlace ? item.tradePlace : '장소 미정'}</p>
                                <p class="tl-card-title">${item.title}</p>
                                <p class="tl-card-price ${item.price == 0 ? 'free' : ''}">
                                    <c:choose>
                                        <c:when test="${item.price == 0}">나눔</c:when>
                                        <c:otherwise><fmt:formatNumber value="${item.price}" pattern="#,###"/>원</c:otherwise>
                                    </c:choose>
                                </p>
                                <div class="tl-card-footer">
                                    <span class="tl-card-time">${item.createdDate}</span>
                                    <div class="tl-card-stats">
                                        <span>🤍 ${item.likeCount}</span>
                                        <span>💬 ${item.chatCount}</span>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="tl-empty-state">
                        <div class="tl-empty-icon">🛒</div>
                        <p>아직 등록된 상품이 없어요</p>
                        <small>첫 번째 판매자가 되어보세요!</small>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <c:if test="${not empty pageInfo && pageInfo.totalPage > 1}">
            <div class="tl-pagination">
                <button class="tl-page-btn"
                    onclick="tlGoPage(${pageInfo.currentPage - 1})"
                    ${pageInfo.currentPage <= 1 ? 'disabled' : ''}>&#8249;</button>
                <c:forEach begin="${pageInfo.startPage}" end="${pageInfo.endPage}" var="p">
                    <button class="tl-page-btn ${pageInfo.currentPage == p ? 'active' : ''}"
                        onclick="tlGoPage(${p})">${p}</button>
                </c:forEach>
                <button class="tl-page-btn"
                    onclick="tlGoPage(${pageInfo.currentPage + 1})"
                    ${pageInfo.currentPage >= pageInfo.totalPage ? 'disabled' : ''}>&#8250;</button>
            </div>
        </c:if>

    </main>
</div>

<!-- 모바일 FAB -->
<button class="tl-fab"
    onclick="location.href='${pageContext.request.contextPath}/trade/write'">
    ✏️ 판매하기
</button>

<script src="${pageContext.request.contextPath}/dist/js/trade-list.js"></script>
</body>
</html>
