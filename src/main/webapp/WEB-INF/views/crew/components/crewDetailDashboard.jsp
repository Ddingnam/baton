<%@ page contentType="text/html; charset=UTF-8"%>
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/crew/crew_detail_main.css">

<template id="crew-dashboard-template">
    <div class="cd-dashboard-grid">
        
        <div class="cd-widget cd-glass-card cd-full-width">
            <div class="cd-widget-header">
                <h4><i class="ri-notification-3-line"></i> 필독 공지사항</h4>
                <button class="cd-icon-btn"><i class="ri-arrow-right-s-line"></i></button>
            </div>
            <div class="cd-notice-body">
                <p class="cd-notice-title">이번 주 모임 장소가 변경되었습니다. 꼭 확인해 주세요!</p>
                <span class="cd-notice-date">2026.03.22</span>
            </div>
        </div>

        <div class="cd-widget cd-glass-card cd-full-width">
            <div class="cd-widget-header">
                <h4><i class="ri-calendar-check-line"></i> 이번 주 일정</h4>
                <button class="cd-icon-btn"><i class="ri-add-line"></i></button>
            </div>
            <ul class="cd-schedule-list" v-if="schedules && schedules.length > 0">
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
            <div v-else class="cd-no-data">이번 주 예정된 일정이 없습니다.</div>
        </div>

        <div class="cd-dashboard-bottom-row">
            
            <div class="cd-widget cd-glass-card cd-weather-widget">
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

            <div class="cd-widget cd-glass-card cd-post-widget">
                <div class="cd-widget-header">
                    <h4><i class="ri-discuss-line"></i> 최근 올라온 이야기</h4>
                    <span class="cd-view-more" @click="$router.push(`/article/${crew.crewIdx}/board`)">
                        더보기 <i class="ri-arrow-right-s-line"></i>
                    </span>
                </div>
                <div class="cd-post-grid" v-if="recentPosts && recentPosts.length > 0">
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
                <div v-else class="cd-no-data">새로운 이야기가 없습니다.</div>
            </div>
            
        </div>
    </div>
</template>