<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<template id="tpl-trade-list">
	<div>
        <section class="trade-hero-section">
            <div class="container hero-inner">
                <div class="hero-text-box">
                    <span class="sub-title">BATON TRADE</span>
                    <h1 class="main-title">이웃과 함께하는 <span class="highlight">중고거래</span></h1>
                    <p class="desc">어떤 물건을 찾고 있나요? 동네에서 따뜻한 거래를 시작해보세요.</p>
                </div>
                <div class="hero-search-box">
                    <input type="text" placeholder="관심있는 상품과 태그를 검색해보세요"
                           :value="keyword"
                           @input="e => { keyword = e.target.value; debounce(); }"
                           @keydown.enter="applyFilter">
                    <button class="search-btn" @click="applyFilter">검색</button>
                </div>
            </div>
        </section>

        <div class="tl-content-wrapper">

            <div class="tl-welcome-card">
                <div class="tl-welcome-content">
                    <span class="tl-welcome-sub">함께하면 더 즐거운 중고거래</span>
                    <h2 class="tl-welcome-title">원하는 물건을 <span class="tl-highlight">지금 바로</span> 찾아보세요!</h2>
                    <p class="tl-welcome-desc">원하는 물건이 없나요? 직접 판매자가 되어 새로운 인연을 만들어보세요.</p>
                </div>
                <div class="tl-welcome-actions">
                    <button class="tl-guide-btn primary" @click="$router.push('/write')">
                        <i class="ri-add-line"></i> 판매하기
                    </button>
                </div>
            </div>

            <div class="tl-glass-toolbar">

                <div class="tl-filter-row">
                    <div class="tl-filter-label">카테고리</div>
                    <div class="tl-filter-content">
                        <div class="tl-carousel-wrapper">
                            <button class="tl-carousel-nav left" @click="scrollTags('left')"><i class="ri-arrow-left-s-line"></i></button>
                            <div class="tl-filter-container" ref="tagCarousel">
                                <div class="tl-filter-group">
                                    <button class="tl-filter-btn" :class="{ active: categoryIdx === '' }" @click="setCategory('')">전체</button>
                                    <button v-for="cat in categories" :key="cat.CATEGORYIDX"
                                            class="tl-filter-btn" :class="{ active: categoryIdx === String(cat.CATEGORYIDX) }"
                                            @click="setCategory(String(cat.CATEGORYIDX))">
                                            {{ cat.CATEGORYNAME }}
                                    </button>
                                </div>
                            </div>
                            <button class="tl-carousel-nav right" @click="scrollTags('right')"><i class="ri-arrow-right-s-line"></i></button>
                        </div>
                    </div>
                </div>

                <div class="tl-filter-row">
                    <div class="tl-filter-label">상세 조건</div>
                    <div class="tl-filter-content">
                        <div class="tl-split-row">
                            <div class="tl-filter-col">
                                <div class="tl-price-group">
                                    <input type="number" class="tl-price-input" placeholder="최소 금액" v-model="priceMin" min="0" @keydown.enter="applyFilter">
                                    <span class="tl-price-sep">~</span>
                                    <input type="number" class="tl-price-input" placeholder="최대 금액" v-model="priceMax" min="0" @keydown.enter="applyFilter">
                                    <button class="tl-price-apply" @click="applyFilter">적용</button>
                                </div>
                            </div>
                            <div class="tl-filter-col tl-distance-col">
                                <div class="tl-distance-filter">
                                    <button class="tl-filter-btn" :class="{ active: km === '1' }" @click="setKm('1')">내 동네만</button>
                                    <button class="tl-filter-btn" :class="{ active: km === '3' }" @click="setKm('3')">가까운 동네</button>
                                    <button class="tl-filter-btn" :class="{ active: km === '5' }" @click="setKm('5')">먼 동네까지</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="tl-filter-row">
                    <div class="tl-filter-label">적용옵션</div>
                    <div class="tl-filter-content tl-flex-between">
                        <div class="tl-active-filters-inline">
                            <span v-if="activeChips.length === 0" class="tl-no-filter-text">선택된 추가 필터가 없습니다.</span>
                            <span v-for="chip in activeChips" :key="chip.label" class="tl-active-badge" @click="removeChip(chip)">
                                <button class="tl-badge-remove"><i class="ri-close-line"></i></button>
                                {{ chip.label }}
                            </span>
                        </div>
                        <div class="tl-filter-controls">
                            <label class="tl-toggle-switch-wrap">
                                <input type="checkbox" class="tl-green-switch" v-model="availableOnly" @change="applyFilter">
                                <span class="tl-toggle-label">거래 가능만 보기</span>
                            </label>
                            <span class="tl-divider">|</span>
                            <div class="tl-custom-dropdown" :class="{ active: sortDropdownOpen }"
                                 @click.stop="sortDropdownOpen = !sortDropdownOpen">
                                <div class="tl-dropdown-selected">
                                    <span>{{ sortLabel }}</span>
                                    <i class="ri-arrow-down-s-line"></i>
                                </div>
                                <ul class="tl-dropdown-menu">
                                    <li :class="{ active: sort === 'newest' || sort === 'latest' }" @click.stop="setSort('newest')">최신순</li>
                                    <li :class="{ active: sort === 'lowPrice' }" @click.stop="setSort('lowPrice')">낮은 가격순</li>
                                    <li :class="{ active: sort === 'highPrice' }" @click.stop="setSort('highPrice')">높은 가격순</li>
                                    <li :class="{ active: sort === 'hitCount' }" @click.stop="setSort('hitCount')">인기순</li>
                                </ul>
                            </div>
                            <span class="tl-divider">|</span>
                            <button class="tl-reset-inline-btn" @click="resetFilters">
                                <i class="ri-refresh-line"></i> 초기화
                            </button>
                        </div>
                    </div>
                </div>

            </div>

            <div class="tl-grid-area">
            <div v-if="isLoading" class="tl-loading"><i class="ri-loader-4-line"></i></div>
            <div v-else class="trade-grid tl-product-grid">
                <div v-if="products.length === 0" class="tl-empty-state">
                    <i class="ri-shopping-basket-line empty-icon"></i>
                    <p>아직 등록된 상품이 없어요</p>
                    <small>첫 번째 판매자가 되어보세요!</small>
                </div>
                <div v-for="item in products" :key="item.productIdx"
                     class="trade-card tl-product-card"
                     @click="$router.push('/article/' + item.productIdx)">
                    <div class="card-image-box tl-card-img" :class="{ 'no-image': !item.imgUrl }">
                        <img v-if="item.imgUrl" :src="item.imgUrl" :alt="item.title"
                             loading="lazy" @error="item.imgUrl = null">
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
                        <div class="card-price tl-card-price" :class="{ free: item.price === 0 }">{{ formatPrice(item.price) }}</div>
                        <div class="card-details">
                            <div class="detail-item"><i class="ri-map-pin-2-line"></i> {{ getTradePlace(item) }}</div>
                            <div class="detail-item"><i class="ri-time-line"></i> {{ formatTimeAgo(item.lastUpDate) }}</div>
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

        <button class="tl-fab" @click="$router.push('/write')"><i class="ri-pencil-line"></i></button>
    </div>

</template>
