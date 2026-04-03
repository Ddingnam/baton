<%@ page contentType="text/html; charset=UTF-8"%>
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/crew/crew_detail_main.css">

<template id="crew-dashboard-template">
    <div class="cd-dashboard-grid" v-if="crew">
        
		<div class="cd-widget cd-glass-card cd-full-width">
		    <div class="cd-widget-header">
		        <h4><i class="ri-notification-3-line"></i> 필독 공지사항</h4>
		    </div>
		    
		    <div class="cd-notice-body">
		        <div v-if="noticePosts && noticePosts.length > 0" class="cd-notice-slot-container">
		            <div class="cd-notice-slot-wrapper" :class="'items-' + noticePosts.length">
		                
		                <div v-for="notice in noticePosts" :key="notice.crewBoardIdx" 
		                     class="cd-notice-slot-item" 
		                     @click="goToBoardDetail(notice.crewBoardIdx)">
		                    <div class="cd-notice-content">
		                        <span class="cd-notice-badge">공지</span>
		                        <p class="cd-notice-title">{{ notice.title }}</p>
		                    </div>
		                    <span class="cd-notice-date">{{ notice.formattedDate || '최근' }}</span>
		                </div>

		                <div v-if="noticePosts.length > 1" 
		                     class="cd-notice-slot-item" 
		                     @click="goToBoardDetail(noticePosts[0].crewBoardIdx)">
		                    <div class="cd-notice-content">
		                        <span class="cd-notice-badge">공지</span>
		                        <p class="cd-notice-title">{{ noticePosts[0].title }}</p>
		                    </div>
		                    <span class="cd-notice-date">{{ noticePosts[0].formattedDate || '최근' }}</span>
		                </div>
		                
		            </div>
		        </div>

		        <div v-else class="cd-no-notice">
		            <p>등록된 공지사항이 없습니다.</p>
		        </div>
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
		            <div class="cd-vitality-score">{{ vitalityScore }}<span style="font-size:20px;">℃</span></div>
		            <span class="cd-vitality-status">{{ vitalityStatus }}</span>
		        </div>

		        <div class="cd-vitality-gauge-wrapper">
		            <div class="cd-vitality-gauge">
		                <div class="cd-vitality-fill" :style="{ width: vitalityScore + '%' }"></div>
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
		        <div v-for="post in recentPosts" :key="post.crewBoardIdx" class="cd-post-item"
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
		        <div class="cd-slot-wrapper" :class="'items-' + topRankers.length" v-if="topRankers && topRankers.length > 0">
		            
		            <div class="cd-slot-item" v-for="(ranker, index) in topRankers" :key="ranker.userIdx">
		                <span>{{ getMedal(index) }}</span> 
		                <strong>{{ ranker.nickname }}</strong> 
		                <small>({{ ranker.totalPoint }}P)</small>
		            </div>

		            <div class="cd-slot-item" v-if="topRankers.length > 1">
		                <span>{{ getMedal(0) }}</span> 
		                <strong>{{ topRankers[0].nickname }}</strong> 
		                <small>({{ topRankers[0].totalPoint }}P)</small>
		            </div>
		            
		        </div>
		        
		        <div v-else class="cd-slot-item">
		            <p style="margin: 0; font-size: 13px; color: #8B95A1;">아직 활동 내역이 없습니다.</p>
		        </div>
		    </div>
		</div>
        
    </div>
</template>