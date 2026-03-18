<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/crew/crew_list.css">

<template id="crew-list-template">
    <div>
        <div class="cl-content-wrapper">
            
            <div class="cl-welcome-card">
                <div class="cl-welcome-content">
                    <span class="cl-welcome-sub">함께하면 더 즐거운 커뮤니티</span>
                    <h2 class="cl-welcome-title">취향이 맞는 사람들과 <span class="cl-highlight">오늘 바로</span> 모여보세요!</h2>
                    <p class="cl-welcome-desc">원하는 모임이 없나요? 직접 크루장이 되어 새로운 인연을 만들어보세요.</p>
                </div>
                <div class="cl-welcome-actions">
                    <button class="cl-guide-btn secondary" @click="openGuide">이용 가이드</button>
                    <button class="cl-guide-btn primary" @click="$router.push('/write')">모임 개설하기</button>
                </div>
            </div>

            <div class="cl-toolbar">
                <div class="cl-toolbar-top">
                    <div class="cl-carousel-wrapper">
                        <button class="cl-carousel-nav left" @click="scrollTags('left')">
                            <i class="ri-arrow-left-s-line"></i>
                        </button>
                        
                        <div class="cl-filter-container" ref="tagCarousel">
                            <div class="cl-filter-group">
                                <button class="cl-filter-btn active">전체</button>
                                <button class="cl-filter-btn">스터디</button>
                                <button class="cl-filter-btn">독서</button>
                                <button class="cl-filter-btn">운동</button>
                                <button class="cl-filter-btn">여행</button>
                                <button class="cl-filter-btn">취미/게임</button>
                                <button class="cl-filter-btn">문화/예술</button>
                                <button class="cl-filter-btn">맛집/카페</button>
                                <button class="cl-filter-btn">가족/육아</button>
                                <button class="cl-filter-btn">반려동물</button>
                                <button class="cl-filter-btn">자기계발</button>
                                <button class="cl-filter-btn">코딩/IT</button>
                                <button class="cl-filter-btn">경제/재테크</button>
                                <button class="cl-filter-btn">기타</button>
                            </div>
                        </div>

                        <button class="cl-carousel-nav right" @click="scrollTags('right')">
                            <i class="ri-arrow-right-s-line"></i>
                        </button>
                    </div>
                </div>

                <div class="cl-toolbar-bottom">
                    <div class="cl-action-group">
                        <label class="cl-toggle-switch-wrap"> 
                            <input type="checkbox" class="cl-pink-switch" checked> 
                            <span class="cl-toggle-label">모집 중만 보기</span>
                        </label> 
                        <span class="cl-divider">|</span> 
                        <select class="cl-detail-select cl-sort-select">
                            <option>최신순</option>
                            <option>인기순</option>
                            <option>마감임박순</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="cl-grid-container">
                <c:forEach var="i" begin="1" end="6">
                    <div class="cl-card" @click="$router.push('/article/${i}')">
                        <div class="cl-image-section">
                            <div class="cl-thumbnail no-img">
                                <i class="ri-image-line"></i>
                            </div>
                            <div class="cl-badge-wrapper">
                                <span class="cl-status-badge recruiting">모집중</span>
                            </div>
                            <button class="cl-wish-btn" @click.stop="toggleWish(${i})">
                                <i class="ri-heart-fill"></i>
                            </button>
                            <div class="cl-host-profile">
                                <div class="cl-host-img">
                                    <i class="ri-user-fill"></i>
                                </div>
                            </div>
                        </div>

                        <div class="cl-content-section">
                            <h3 class="cl-title">한강 야간 러닝 크루 '비상'</h3>
                            <div class="cl-meta-top">
                                <span class="cl-region">서울 강남구</span> 
                                <span class="cl-date-dot"></span>
                                <span class="cl-created-date">개설 2024.03.12</span>
                            </div>
                            <div class="cl-tags">
                                <span>#러닝</span><span>#초보환영</span><span>#오운완</span>
                            </div>
                            <div class="cl-member-status">
                                <div class="cl-member-count">
                                    <strong>12</strong><span> / 20명</span>
                                </div>
                                <div class="cl-progress-bg">
                                    <div class="cl-progress-fill" style="width: 60%;"></div>
                                </div>
                            </div>
                            <div class="cl-footer">
                                <span class="cl-host-name">런닝조아</span>
                                <div class="cl-activity">
                                    <i class="ri-flashlight-line"></i> 방금 전 활동
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="cl-pagination-container">${paging}</div>
        </div>
    </div>
</template>