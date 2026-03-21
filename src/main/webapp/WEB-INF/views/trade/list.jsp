<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>중고거래 | BATON</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/trade/trade-list.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/vue@3/dist/vue.global.prod.js"></script>
<script>
    const CTX = '${pageContext.request.contextPath}';
</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<main class="trade-main-container">

    <div id="trade-list-app">

        <section class="trade-hero-section">
            <div class="container hero-inner">
                <div class="hero-text-box">
                    <span class="sub-title">BATON TRADE</span>
                    <h1 class="main-title">이웃과 함께하는 <span class="highlight">중고거래</span></h1>
                    <p class="desc">어떤 물건을 찾고 있나요? 동네에서 따뜻한 거래를 시작해보세요.</p>
                </div>
                <div class="hero-search-box">
                    <input type="text" placeholder="관심있는 상품과 태그를 검색해보세요"
                           v-model="keyword"
                           @keydown.enter="applyFilter">
                    <button class="search-btn" @click="applyFilter">검색</button>
                </div>
            </div>
        </section>

        <div class="content-wrapper">
            <div class="trade-toolbar">
                <div class="toolbar-top">
                    <div class="filter-group tl-filter-list">
                        <button class="filter-btn" :class="{ active: categoryIdx === '' }"
                                @click="setCategory('')">전체</button>
                        <button v-for="cat in categories" :key="cat.CATEGORYIDX"
                                class="filter-btn"
                                :class="{ active: categoryIdx === String(cat.CATEGORYIDX) }"
                                @click="setCategory(String(cat.CATEGORYIDX))">
                            {{ cat.CATEGORYNAME }}
                        </button>
                    </div>
                    <button class="btn-create-trade" @click="goTo('/trade/write')">
                        <i class="ri-add-line"></i> 판매하기
                    </button>
                </div>

                <div class="toolbar-bottom">
                    <div class="price-select-group">
                        <input type="number" class="tl-price-input" placeholder="최소 금액"
                               v-model="priceMin" min="0" @keydown.enter="applyFilter">
                        <span class="tl-price-sep">~</span>
                        <input type="number" class="tl-price-input" placeholder="최대 금액"
                               v-model="priceMax" min="0" @keydown.enter="applyFilter">
                        <button class="tl-price-apply" @click="applyFilter">적용</button>
                        <span class="tl-divider-thin"></span>
                        <div class="tl-radius-btns">
                            <button class="tl-radius-btn" :class="{ active: km === '1' }" @click="setKm('1')">내 동네만</button>
                            <button class="tl-radius-btn" :class="{ active: km === '3' }" @click="setKm('3')">가까운 동네</button>
                            <button class="tl-radius-btn" :class="{ active: km === '5' }" @click="setKm('5')">먼 동네까지</button>
                        </div>
                        <button class="tl-reset-btn" @click="resetFilters">
                            <i class="ri-refresh-line"></i> 초기화
                        </button>
                    </div>

                    <div class="action-group">
                        <label class="toggle-switch-wrap">
                            <input type="checkbox" class="green-switch"
                                   v-model="availableOnly" @change="applyFilter">
                            <span class="toggle-label">거래 가능만 보기</span>
                        </label>
                        <span class="divider">|</span>

                        <div class="custom-dropdown sort-dropdown" style="width:140px;"
                             :class="{ active: sortDropdownOpen }"
                             @click.stop="sortDropdownOpen = !sortDropdownOpen">
                            <div class="dropdown-selected">
                                <span>{{ sortLabel }}</span>
                                <i class="ri-arrow-down-s-line"></i>
                            </div>
                            <ul class="dropdown-menu">
                                <li :class="{ active: sort === 'newest' || sort === 'latest' }"
                                    @click.stop="setSort('newest')">최신순</li>
                                <li :class="{ active: sort === 'lowPrice' }"
                                    @click.stop="setSort('lowPrice')">낮은 가격순</li>
                                <li :class="{ active: sort === 'highPrice' }"
                                    @click.stop="setSort('highPrice')">높은 가격순</li>
                                <li :class="{ active: sort === 'hitCount' }"
                                    @click.stop="setSort('hitCount')">인기순</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <div class="tl-active-filters">
                <span v-for="chip in activeChips" :key="chip.label"
                      class="tl-filter-chip" @click="removeChip(chip)">
                    {{ chip.label }}
                    <svg width="10" height="10" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="3">
                        <path d="M18 6 6 18M6 6l12 12"/>
                    </svg>
                </span>
            </div>

            <div v-if="isLoading" class="tl-loading">
                <i class="ri-loader-4-line"></i>
            </div>

            <div v-else class="trade-grid tl-product-grid">

                <div v-if="products.length === 0" class="tl-empty-state">
                    <i class="ri-shopping-basket-line empty-icon"></i>
                    <p>아직 등록된 상품이 없어요</p>
                    <small>첫 번째 판매자가 되어보세요!</small>
                </div>

                <!-- 상품 카드 -->
                <div v-for="item in products" :key="item.productIdx"
                     class="trade-card tl-product-card"
                     @click="goTo('/trade/article?productIdx=' + item.productIdx)">

                    <div class="card-image-box tl-card-img" :class="{ 'no-image': !item.imgUrl }">
                        <img v-if="item.imgUrl" :src="item.imgUrl" :alt="item.title" loading="lazy">
                        <i v-else class="ri-camera-off-line placeholder-icon"></i>

                        <div class="badge-group">
                            <span v-if="item.productStatus === '새상품'" class="badge badge-new">새상품</span>
                            <span v-else-if="item.productStatus === '고장/파손'" class="badge badge-broken">파손</span>
                            <span v-else class="badge badge-used">{{ item.productStatus }}</span>

                            <span v-if="item.tradeStatus === '판매완료'" class="badge badge-sold">판매완료</span>
                            <span v-else-if="item.tradeStatus === '예약중'" class="badge badge-reserved">예약중</span>
                        </div>

                        <button type="button" class="wish-btn tl-wish-btn"
                                :class="{ active: item.isLiked }"
                                @click.stop="toggleWish($event, item)">
                            <i :class="item.isLiked ? 'ri-heart-3-fill' : 'ri-heart-3-line'"></i>
                        </button>
                    </div>

                    <div class="card-info tl-card-body">
                        <h3 class="card-title tl-card-title">{{ item.title }}</h3>
                        <div class="card-price tl-card-price" :class="{ free: item.price === 0 }">
                            {{ formatPrice(item.price) }}
                        </div>
                        <div class="card-details">
                            <div class="detail-item">
                                <i class="ri-map-pin-2-line"></i> {{ getTradePlace(item) }}
                            </div>
                            <div class="detail-item">
                                <i class="ri-time-line"></i> {{ formatTimeAgo(item.lastUpDate) }}
                            </div>
                        </div>
                        <div class="card-footer">
                            <div class="host-info">
                                <div class="host-avatar"><i class="ri-user-smile-line"></i></div>
                                <span class="host-name">{{ item.nickName }}</span>
                            </div>
                            <div class="interaction-info tl-card-stats">
                                <span><i class="ri-eye-line"></i> {{ item.hitCount }}</span>
                                <span><i class="ri-chat-3-line"></i> {{ item.chatCount }}</span>
                                <span><i class="ri-heart-3-line wish-icon"></i> {{ item.likeCount }}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div v-if="hasMore" class="more-btn-wrap">
                <button type="button" class="btn-more" @click="loadMore" :disabled="isLoadingMore">
                    <span v-if="isLoadingMore">로딩 중... <i class="ri-loader-4-line"></i></span>
                    <span v-else>더보기 <i class="ri-arrow-down-s-line"></i></span>
                </button>
            </div>

        </div>
    </div>

</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<button class="tl-fab" onclick="location.href=CTX+'/trade/write'">
    <i class="ri-pencil-line"></i>
</button>

<script src="${pageContext.request.contextPath}/dist/js/trade/trade-list.js"></script>
</body>
</html>
