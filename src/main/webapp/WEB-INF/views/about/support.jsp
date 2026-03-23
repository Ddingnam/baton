<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>고객센터 | Baton</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css"/>
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/about/support.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<main id="support-app">

    <section class="support-hero">
        <div class="hero-bg">
            <div class="hero-orb orb-1"></div>
            <div class="hero-orb orb-2"></div>
            <div class="hero-grid"></div>
        </div>
        <div class="hero-inner">
            <div class="hero-badge">
                <i class="ri-customer-service-2-line"></i>
                <span>바톤 고객센터</span>
            </div>
            <h1 class="hero-title">무엇을 도와드릴까요?</h1>
            <p class="hero-sub">이웃과의 거래, 바톤이 함께 해결해드릴게요.</p>

            <div class="search-wrap">
                <div class="search-box" :class="{ focused: searchFocused }">
                    <i class="ri-search-line search-icon"></i>
                    <input
                        type="text"
                        v-model="searchQuery"
                        placeholder="궁금한 내용을 검색해보세요 (예: 환불, 안전결제, 배송)"
                        autocomplete="off"
                        @focus="searchFocused = true"
                        @blur="searchFocused = false"
                        @input="onSearch"/>
                    <button class="search-clear" v-if="searchQuery" @click="clearSearch">
                        <i class="ri-close-line"></i>
                    </button>
                </div>
                <div class="search-results" v-if="searchQuery && searchResults.length > 0">
                    <div
                        class="search-result-item"
                        v-for="(item, idx) in searchResults"
                        :key="idx"
                        @mousedown.prevent="clickSearchResult(item)">
                        
                        <i class="ri-question-line"></i>
                        <span v-html="highlightText(item.q)"></span>
                        <i class="ri-arrow-right-s-line result-arrow"></i>
                    </div>
                </div>
                <div class="search-results" v-if="searchQuery && searchResults.length === 0">
                    <div class="search-no-result">
                        <i class="ri-search-eye-line"></i>
                        <span>검색 결과가 없어요. AI 챗봇에게 질문해보세요!</span>
                    </div>
                </div>
            </div>

            <div class="quick-tags">
                <button
                    class="quick-tag"
                    v-for="tag in quickTags"
                    :key="tag"
                    @click="setQuickTag(tag)">{{ tag }}
                </button>
            </div>
        </div>
    </section>

    <section class="support-categories">
        <div class="support-container">
            <div class="section-label">카테고리</div>
            <h2 class="section-title">어떤 도움이 필요하신가요?</h2>
            <div class="category-grid">
                <button
                    class="cat-card"
                    :class="{ active: selectedCat === cat.key }"
                    v-for="cat in categories"
                    :key="cat.key"
                    @click="selectCat(cat.key)">
                    
                    <div class="cat-icon" :style="{ background: cat.color }">
                        <i :class="cat.icon"></i>
                    </div>
                    <div class="cat-info">
                        <div class="cat-name">{{ cat.name }}</div>
                        <div class="cat-count">{{ getFaqCount(cat.key) }}개 항목</div>
                    </div>
                    <i class="ri-arrow-right-s-line cat-arrow"></i>
                </button>
            </div>
        </div>
    </section>

    <section class="support-faq">
        <div class="support-container">
            <div class="faq-header">
                <div class="section-label">자주 묻는 질문</div>
                <h2 class="section-title">{{ catTitle }}</h2>
                <div class="faq-tabs">
                    <button
                        class="faq-tab"
                        :class="{ active: selectedCat === cat.key }"
                        v-for="cat in categories"
                        :key="cat.key"
                        @click="selectCat(cat.key)">
                        {{ cat.key === 'all' ? '전체' : cat.name }}
                    </button>
                </div>
            </div>

            <div class="faq-list">
                <div
                    class="faq-item"
                    :class="{ open: openIdx === idx }"
                    v-for="(item, idx) in filteredFaqs"
                    :key="idx"
                    @click="toggleFaq(idx)">
                    
                    <div class="faq-q">
                        <div class="faq-q-inner">
                            <span class="faq-badge" :style="{ background: badgeMap[item.category].color }">
                                {{ badgeMap[item.category].label }}
                            </span>
                            <span class="faq-q-text">{{ item.q }}</span>
                        </div>
                        <i class="ri-add-line faq-toggle-icon"></i>
                    </div>
                    <transition name="faq-slide">
                        <div class="faq-a" v-if="openIdx === idx">
                            <div class="faq-a-inner">
                                <i class="ri-information-line faq-a-icon"></i>
                                <p>{{ item.a }}</p>
                            </div>
                        </div>
                    </transition>
                </div>

                <div class="faq-empty" v-if="filteredFaqs.length === 0">
                    <i class="ri-inbox-line"></i>
                    <p>해당 카테고리의 FAQ가 없어요.</p>
                </div>
            </div>
        </div>
    </section>

    <section class="support-contact">
        <div class="support-container">
            <div class="section-label">문의하기</div>
            <h2 class="section-title">원하는 답변을 찾지 못하셨나요?</h2>
            <div class="contact-grid">
                <div class="contact-card ai-card" @click="openChatbot">
                    <div class="contact-badge-top">추천</div>
                    <div class="contact-icon ai-icon"><i class="ri-robot-2-line"></i></div>
                    <h3 class="contact-title">AI 챗봇 상담</h3>
                    <p class="contact-desc">24시간 언제든지 바톤 AI 가이드에게 질문하세요. 결제, 배송, 거래 분쟁 모두 빠르게 안내해드려요.</p>
                    <div class="contact-cta"><span>채팅 시작하기</span><i class="ri-arrow-right-line"></i></div>
                </div>
                <div class="contact-card email-card">
                    <div class="contact-icon email-icon"><i class="ri-mail-line"></i></div>
                    <h3 class="contact-title">이메일 문의</h3>
                    <p class="contact-desc">복잡한 분쟁이나 정산 문제는 이메일로 문의주세요. 영업일 기준 1~2일 내에 답변드려요.</p>
                    <div class="contact-info">support@baton.com</div>
                    <div class="contact-cta"><span>이메일 보내기</span><i class="ri-arrow-right-line"></i></div>
                </div>
                <div class="contact-card notice-card">
                    <div class="contact-icon notice-icon"><i class="ri-megaphone-line"></i></div>
                    <h3 class="contact-title">공지사항</h3>
                    <p class="contact-desc">서비스 업데이트, 정책 변경, 점검 일정 등 바톤의 최신 소식을 확인하세요.</p>
                    <div class="contact-cta"><span>공지 보러가기</span><i class="ri-arrow-right-line"></i></div>
                </div>
            </div>
        </div>
    </section>

</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>

<script src="https://unpkg.com/vue@3/dist/vue.global.prod.js"></script>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>
<script src="${pageContext.request.contextPath}/dist/js/about/support.js"></script>

</body>
</html>
