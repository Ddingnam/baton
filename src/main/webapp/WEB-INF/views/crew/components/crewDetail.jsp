<%@ page contentType="text/html; charset=UTF-8"%>
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/crew/crew_detail.css">

<template id="crew-detail-template">
    <div class="cd-content-wrapper">
        <div class="cd-layout-container">
            
            <aside class="cd-sidebar cd-glass-card">
                <div class="cd-profile-section">
                    <div class="cd-profile-wrapper">
                        <img :src="crew.logoImage || 'https://via.placeholder.com/300'" alt="크루 프로필" class="cd-profile-img">
                    </div>
                    
                    <div class="cd-tags">
                        <span v-for="tag in crew.tags" :key="tag">{{ tag }}</span>
                    </div>
                    
                    <h2 class="cd-crew-title">{{ crew.name }}</h2>
                    <p class="cd-crew-desc">{{ crew.description }}</p>
                    
                    <div class="cd-member-status">
                        <div class="cd-member-count">
                            <span>현재 참여 인원</span>
                            <strong>{{ crew.currentMember }} / {{ crew.maxMember }}명</strong>
                        </div>
                        <div class="cd-progress-bg">
                            <div class="cd-progress-fill" :style="{ width: (crew.currentMember / crew.maxMember * 100) + '%' }"></div>
                        </div>
                    </div>
                </div>

                <nav class="cd-tab-nav">
                    <button class="cd-tab-btn" :class="{ active: currentTab === 'dashboard' }" @click="currentTab = 'dashboard'">
                        <i class="ri-dashboard-fill"></i> 대시보드
                    </button>
                    <button class="cd-tab-btn" :class="{ active: currentTab === 'board' }" @click="currentTab = 'board'">
                        <i class="ri-clipboard-fill"></i> 게시판
                    </button>
                    <button class="cd-tab-btn" :class="{ active: currentTab === 'schedule' }" @click="currentTab = 'schedule'">
                        <i class="ri-calendar-event-fill"></i> 일정
                    </button>
                    <button class="cd-tab-btn" :class="{ active: currentTab === 'chat' }" @click="currentTab = 'chat'">
                        <i class="ri-chat-smile-3-fill"></i> 채팅
                    </button>
                </nav>

                <div class="cd-sidebar-footer">
                    <button class="cd-action-btn primary">모임 가입하기</button>
                </div>
            </aside>

            <main class="cd-main-content">
                <transition name="cd-fade" mode="out-in">
                    
                    <div v-if="currentTab === 'dashboard'" class="cd-dashboard-grid" key="dash">
                        
                        <div class="cd-hero-card cd-glass-card cd-full-width">
                            <div class="cd-hero-content">
                                <span class="cd-hero-sub">DASHBOARD</span>
                                <h3 class="cd-hero-title">오늘도 즐거운 모임 되세요! 🙌</h3>
                                <p class="cd-hero-desc">
                                    이번 주에는 <span class="cd-highlight">{{ schedules.length }}개</span>의 일정이 예정되어 있어요.<br>
                                    크루원들과 함께 활기찬 한 주를 만들어보세요.
                                </p>
                            </div>
                            <div class="cd-hero-actions">
                                <button class="cd-action-btn secondary">일정 만들기</button>
                                <button class="cd-action-btn primary">게시글 작성</button>
                            </div>
                        </div>

                        <div class="cd-widget cd-glass-card">
                            <div class="cd-widget-header">
                                <h4><i class="ri-sun-cloudy-line"></i> 지역 날씨</h4>
                            </div>
                            <div class="cd-weather-body">
                                <i class="ri-sun-fill" style="font-size: 50px; color: #FFA000;"></i>
                                <div class="cd-weather-info">
                                    <span class="cd-temp">18°C</span>
                                    <span class="cd-weather-text">맑음 · 활동하기 좋아요</span>
                                </div>
                            </div>
                        </div>

                        <div class="cd-widget cd-glass-card cd-wide-widget">
                            <div class="cd-widget-header">
                                <h4><i class="ri-calendar-check-line"></i> 다가오는 일정</h4>
                                <button class="cd-icon-btn"><i class="ri-add-line"></i></button>
                            </div>
                            <ul class="cd-schedule-list">
                                <li v-for="sch in schedules" :key="sch.id" class="cd-schedule-item">
                                    <div class="cd-sch-date">
                                        <span class="day">{{ sch.day }}</span>
                                        <span class="month">{{ sch.month }}</span>
                                    </div>
                                    <div class="cd-sch-info">
                                        <strong>{{ sch.title }}</strong>
                                        <span>{{ sch.time }} · {{ sch.location }}</span>
                                    </div>
                                    <div class="cd-status-badge">예정</div>
                                </li>
                            </ul>
                        </div>

                        <div class="cd-widget cd-glass-card cd-full-width">
                            <div class="cd-widget-header">
                                <h4><i class="ri-discuss-line"></i> 최근 올라온 이야기</h4>
                                <span class="cd-view-more" @click="currentTab = 'board'">더보기 <i class="ri-arrow-right-s-line"></i></span>
                            </div>
                            <div class="cd-post-grid">
                                <div v-for="post in recentPosts" :key="post.id" class="cd-post-item">
                                    <div class="cd-post-header">
                                        <span class="cd-post-author">{{ post.author }}</span>
                                        <span class="cd-post-time">{{ post.time }}</span>
                                    </div>
                                    <strong class="cd-post-title">{{ post.title }}</strong>
                                    <div class="cd-post-meta">
                                        <span><i class="ri-heart-3-line"></i> {{ post.likes }}</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                    <div v-else class="cd-placeholder cd-glass-card" :key="currentTab">
                        <i class="ri-tools-line"></i>
                        <h2>{{ currentTab.toUpperCase() }} 준비 중입니다.</h2>
                    </div>
                </transition>
            </main>
        </div>
    </div>
</template>