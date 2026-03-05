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
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/trade/trade-list.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<main class="trade-main-container">
    <section class="trade-hero-section">
        <div class="container hero-inner">
            <div class="hero-text-box">
                <span class="sub-title">BATON TRADE</span>
                <h1 class="main-title">이웃과 함께하는 <span class="highlight">중고거래</span></h1>
                <p class="desc">어떤 물건을 찾고 있나요? 동네에서 따뜻한 거래를 시작해보세요.</p>
            </div>
            <div class="hero-search-box">
                <input type="text" id="tlSearchInput" placeholder="관심있는 상품과 태그를 검색해보세요" value="${param.keyword}" onkeypress="if(event.keyCode==13) tlApplyFilter();">
                <button class="search-btn" onclick="tlApplyFilter()">검색</button>
            </div>
        </div>
    </section>

    <div class="content-wrapper">
        <div class="trade-toolbar">
            <div class="toolbar-top">
                <div class="filter-group tl-filter-list">
                    <button class="filter-btn ${empty param.categoryIdx ? 'active' : ''}" onclick="tlSetCategory(''); return false;">전체</button>
				    <c:forEach var="vo" items="${categoryList}">
				        <button class="filter-btn ${param.categoryIdx == vo.CATEGORYIDX ? 'active' : ''}" 
				                onclick="tlSetCategory('${vo.CATEGORYIDX}'); return false;">
				            ${vo.CATEGORYNAME}
				        </button>
				    </c:forEach>
                </div>
                <button class="btn-create-trade" onclick="location.href='${pageContext.request.contextPath}/trade/write'">
                    <i class="ri-add-line"></i> 판매하기
                </button>
            </div>

            <div class="toolbar-bottom">
                <div class="price-select-group">
                    <input type="number" class="tl-price-input" id="tlPriceMin" placeholder="최소 금액" value="${param.priceMin}" min="0">
                    <span class="tl-price-sep">~</span>
                    <input type="number" class="tl-price-input" id="tlPriceMax" placeholder="최대 금액" value="${param.priceMax}" min="0">
                    <button class="tl-price-apply" onclick="tlApplyFilter()">적용</button>
                    <button class="tl-reset-btn" onclick="tlResetFilters()"><i class="ri-refresh-line"></i> 초기화</button>
                </div>

                <div class="action-group">
                    <label class="toggle-switch-wrap">
                        <input type="checkbox" class="green-switch" id="tlAvailableOnly" ${param.available == 'true' ? 'checked' : ''} onchange="tlApplyFilter()">
                        <span class="toggle-label">거래 가능만 보기</span>
                    </label>
                    <span class="divider">|</span>
                    <div class="custom-dropdown sort-dropdown" id="sortDropdown" style="width: 140px;">
				        <div class="dropdown-selected">
				            <span id="selectedSortText">
				                <c:choose>
				                    <c:when test="${param.sort == 'price_asc'}">낮은 가격순</c:when>
				                    <c:when test="${param.sort == 'price_desc'}">높은 가격순</c:when>
				                    <c:when test="${param.sort == 'popular'}">인기순</c:when>
				                    <c:otherwise>최신순</c:otherwise>
				                </c:choose>
				            </span>
				            <i class="ri-arrow-down-s-line"></i>
				        </div>
				        <ul class="dropdown-menu">
				            <li data-value="latest" class="${param.sort == 'latest' || empty param.sort ? 'active' : ''}">최신순</li>
				            <li data-value="price_asc" class="${param.sort == 'price_asc' ? 'active' : ''}">낮은 가격순</li>
				            <li data-value="price_desc" class="${param.sort == 'price_desc' ? 'active' : ''}">높은 가격순</li>
				            <li data-value="popular" class="${param.sort == 'popular' ? 'active' : ''}">인기순</li>
				        </ul>
				    </div>
                </div>
            </div>
        </div>

        <div class="tl-active-filters" id="tlActiveFilters"></div>

        <div class="trade-grid tl-product-grid">
            <c:choose>
                <c:when test="${not empty tradeList}">
                    <c:forEach var="item" items="${tradeList}">
                        <div class="trade-card tl-product-card" onclick="location.href='${pageContext.request.contextPath}/trade/article?productIdx=${item.productIdx}'">
                            <div class="card-image-box tl-card-img ${empty item.imgUrl ? 'no-image' : ''}">
                                <c:choose>
                                    <c:when test="${not empty item.imgUrl}">
                                        <img src="${item.imgUrl}" alt="${item.title}" loading="lazy">
                                    </c:when>
                                    <c:otherwise>
                                        <i class="ri-camera-off-line placeholder-icon"></i>
                                    </c:otherwise>
                                </c:choose>
                                
                                <div class="badge-group">
                                    <c:choose>
                                        <c:when test="${item.productStatus == '새상품'}">
                                            <span class="badge badge-new">새상품</span>
                                        </c:when>
                                        <c:when test="${item.productStatus == '고장/파손'}">
                                            <span class="badge badge-broken">파손</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-used">${item.productStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                    <c:choose>
                                        <c:when test="${item.tradeStatus == '판매완료'}">
                                            <span class="badge badge-sold">판매완료</span>
                                        </c:when>
                                        <c:when test="${item.tradeStatus == '예약중'}">
                                            <span class="badge badge-reserved">예약중</span>
                                        </c:when>
                                    </c:choose>
                                </div>

                                <button type="button" class="wish-btn tl-wish-btn ${item.isLiked ? 'active' : ''}" 
								        onclick="tlToggleWish(event, ${item.productIdx})">
								    <i class="${item.isLiked ? 'ri-heart-3-fill' : 'ri-heart-3-line'}"></i>
								</button>
                            </div>

                            <div class="card-info tl-card-body">
                                <h3 class="card-title tl-card-title">${item.title}</h3>
                                
                                <div class="card-price tl-card-price ${item.price == 0 ? 'free' : ''}">
                                    <c:choose>
                                        <c:when test="${item.price == 0}">나눔</c:when>
                                        <c:otherwise><fmt:formatNumber value="${item.price}" pattern="#,###"/>원</c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="card-details">
                                    <div class="detail-item"><i class="ri-map-pin-2-line"></i> ${not empty item.tradePlace ? item.tradePlace : '택배 거래'}</div>
                                    <div class="detail-item"><i class="ri-time-line"></i> ${item.createdDate}</div>
                                </div>

                                <div class="card-footer">
                                    <div class="host-info">
                                        <div class="host-avatar"><i class="ri-user-smile-line"></i></div>
                                        <span class="host-name">동네이웃</span>
                                    </div>
                                    <div class="interaction-info tl-card-stats">
                                        <span><i class="ri-eye-line"></i> ${item.hitCount}</span>
                                        <span><i class="ri-chat-3-line"></i> ${item.chatCount}</span>
                                        <span><i class="ri-heart-3-fill wish-icon"></i> ${item.likeCount}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="tl-empty-state">
                        <i class="ri-shopping-basket-line empty-icon"></i>
                        <p>아직 등록된 상품이 없어요</p>
                        <small>첫 번째 판매자가 되어보세요!</small>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <c:if test="${total_page > 1}">
            <div class="pagination-container tl-pagination">
                <button class="tl-page-btn" onclick="tlGoPage(${page - 1})" ${page <= 1 ? 'disabled' : ''}>&#8249;</button>
                <c:forEach begin="${pageInfo.startPage}" end="${pageInfo.endPage}" var="p">
                    <button class="tl-page-btn ${pageInfo.currentPage == p ? 'active' : ''}" onclick="tlGoPage(${p})">${p}</button>
                </c:forEach>
                <button class="tl-page-btn" onclick="tlGoPage(${pageInfo.currentPage + 1})" ${pageInfo.currentPage >= total_page ? 'disabled' : ''}>&#8250;</button>
            </div>
        </c:if>
    </div>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<button class="tl-fab" onclick="location.href='${pageContext.request.contextPath}/trade/write'">
    <i class="ri-pencil-line"></i>
</button>

<script src="${pageContext.request.contextPath}/dist/js/trade/trade-list.js"></script>
</body>
</html>