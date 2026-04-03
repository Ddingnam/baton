<%@ page contentType="text/html; charset=UTF-8"%>
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/crew/crew_detail_main.css">

<template id="crew-dashboard-template">
    <div class="cd-dashboard-grid" v-if="crew">
        
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

        <div class="cd-widget cd-glass-card cd-span-7">
		    <div class="cd-widget-header">
		        <h4><i class="ri-leaf-line"></i> 모임 소개</h4>
		    </div>
		    <div class="cd-intro-body">
		        <div class="cd-intro-desc-container">
		            <p class="cd-intro-description">
		                {{ crew.description || '배턴을 통해 만난 우리 동네 개발자들의 모임입니다. 매주 함께 성장하고 있어요.' }}
		            </p>
		        </div>
		    </div>
		</div>

        <div class="cd-widget cd-glass-card cd-span-3">
		    <div class="cd-widget-header">
		        <h4><i class="ri-fire-line"></i> 활력 지수</h4>
		    </div>
		    <div class="cd-vitality-body">
		        <div class="cd-vitality-main">
		            <div class="cd-vitality-score">85<span style="font-size:20px;">℃</span></div>
		            <span class="cd-vitality-status">매우 활발 🔥</span>
		        </div>
		
		        <div class="cd-vitality-gauge-wrapper">
		            <div class="cd-vitality-gauge">
		                <div class="cd-vitality-fill" style="width: 85%;"></div>
		            </div>
		        </div>
		    </div>
		</div>

        <div class="cd-widget cd-glass-card cd-full-width">
            <div class="cd-widget-header">
                <h4><i class="ri-calendar-check-line"></i> 이번 주 일정</h4>
                <button class="cd-icon-btn"  @click="goToSchedule()"><i class="ri-add-line"></i></button>
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

        <div class="cd-widget cd-glass-card cd-post-widget cd-span-6-double">
		    <div class="cd-widget-header">
		        <h4><i class="ri-discuss-line"></i> 최근 올라온 이야기</h4>
		        <span class="cd-view-more" @click="$router.push({ name: 'crew-board-list', params: { crewIdx: crew.crewIdx } })">
		            더보기 <i class="ri-arrow-right-s-line"></i>
		        </span>
		    </div>
		
		    <div class="cd-post-list-vertical" v-if="recentPosts && recentPosts.length > 0">
		        <div v-for="post in recentPosts.slice(0, 3)" :key="post.id" class="cd-post-item"
		        @click="goToBoardDetail(post.crewBoardIdx)" style="cursor: pointer;">
		            <div class="cd-post-header">
		                <span class="cd-post-author">{{ post.authorNickname }}</span>
		                <span class="cd-post-time">{{ post.formattedDate }}</span>
		            </div>
		            
		            <strong class="cd-post-title">{{ post.title }}</strong>
		            
		            <div class="cd-post-meta">
		                <span><i class="ri-chat-3-line"></i> {{ post.commentCount || 0 }}</span>
		                <span><i class="ri-heart-3-fill"></i> {{ post.likeCount || 0 }}</span>
		            </div>
		        </div>
		    </div>
		    <div v-else class="cd-no-data">새로운 이야기가 없습니다.</div>
		</div>

        <div class="cd-widget cd-glass-card cd-span-4" style="padding: 20px;">
            <div class="cd-widget-header" style="margin-bottom: 10px;">
                <h4><i class="ri-sun-cloudy-line"></i> 주간 날씨</h4>
            </div>
            <div class="cd-weather-carousel">
                <div class="cd-weather-mini-card" v-for="n in 6" :key="n">
                    <div>화</div>
                    <i class="ri-sun-fill"></i>
                    <div>20°</div>
                </div>
            </div>
        </div>

        <div class="cd-widget cd-glass-card cd-span-4" style="padding: 20px;">
            <div class="cd-widget-header" style="margin-bottom: 10px;">
                <h4><i class="ri-vip-crown-line"></i> 활동왕</h4>
            </div>
            <div class="cd-slot-container">
                <div class="cd-slot-wrapper">
                    <div class="cd-slot-item"><span>🥇</span> <strong>김자바</strong> <small>(15개)</small></div>
                    <div class="cd-slot-item"><span>🥈</span> <strong>데브옵스꿈나무</strong> <small>(12개)</small></div>
                    <div class="cd-slot-item"><span>🥉</span> <strong>쿼리마스터</strong> <small>(9개)</small></div>
                </div>
            </div>
        </div>
        
    </div>
</template>