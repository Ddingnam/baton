<%@ page contentType="text/html; charset=UTF-8"%>
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/crew/crew_detail_main.css">

<template id="crew-detail-template">
    <div class="cd-page-container">
        <div v-if="crew" class="cd-content-wrapper">
            <div class="cd-layout-container">
                
                <aside class="cd-sidebar">
                    
                    <div class="cd-profile-card cd-glass-card">
                        <div class="cd-profile-wrapper">
                            <img :src="'/uploads/crew/' + crew.logoImage" alt="모임 프로필" class="cd-profile-img">
                        </div>
                        
                        <h2 class="cd-crew-title">{{ crew.name }}</h2>
                        
                        <div class="cd-category-tags">
                            <span v-for="cat in crew.categories" :key="cat.categoryId" class="cd-cat-badge">
                                {{ cat.name }}
                            </span>
                        </div>

                        <div class="cd-region-list-container" v-if="crew.regions && crew.regions.length > 0">
                            <div v-for="(reg, index) in crew.regions" :key="index" class="cd-region-tag">
                                <span>{{ reg.fullAddress }}</span>
                            </div>
                        </div>
                        
                        <div class="cd-details-table">
                            <div class="cd-detail-row">
                                <span class="cd-detail-label">리더</span>
                                <span class="cd-detail-value">{{ crew.hostNickname || '리더' }}</span>
                            </div>
                            <div class="cd-detail-row">
                                <span class="cd-detail-label">가입방식</span>
                                <span class="cd-detail-value">{{ crew.joinType === 'A' ? '승인제' : '자유가입' }}</span>
                            </div>
                            <div class="cd-detail-row">
                                <span class="cd-detail-label">생성일자</span>
                                <span class="cd-detail-value">{{ crew.createDate || '2026.03.22' }}</span>
                            </div>
                        </div>
                        
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
    
                    <nav class="cd-tab-card cd-glass-card cd-tab-nav">
                        <router-link :to="'/article/' + crew.crewIdx + '/dashboard'" class="cd-tab-btn" active-class="active">
                            <i class="ri-dashboard-fill"></i> 대시보드
                        </router-link>
                        
                        <router-link :to="'/article/' + crew.crewIdx + '/board'" class="cd-tab-btn" active-class="active">
                            <i class="ri-clipboard-fill"></i> 게시판
                        </router-link>
                        
                        <router-link :to="'/article/' + crew.crewIdx + '/schedule'" class="cd-tab-btn" active-class="active">
                            <i class="ri-calendar-event-fill"></i> 일정
                        </router-link>
                        
						<router-link v-if="myStatus && myStatus.role === 'LEADER'" 
					                 :to="'/article/' + crew.crewIdx + '/admin'" 
					                 class="cd-tab-btn" active-class="active">
					        <i class="ri-settings-3-fill"></i> 관리
					    </router-link>
                    </nav>
    
                    <div class="cd-action-card cd-glass-card cd-sidebar-footer"
						v-if="!myStatus || (myStatus && myStatus.role !== 'LEADER')">
                        <button class="cd-action-btn" 
						        :class="buttonClass"
						        :disabled="isJoinDisabled"
						        @click="handleButtonClick">
						    {{ joinButtonText }}
						</button>
                    </div>
                
                </aside>
    
                <main class="cd-main-content">
                    <router-view v-slot="{ Component }" v-if="!isLoading && crew">
                        <transition name="cd-fade" mode="out-in">
                            <component 
                                :is="Component" 
                                :crew="crew"
                                :my-status="myStatus"
								:current-user-idx="${sessionScope.member.userIdx}">/>
                        </transition>
                    </router-view>
                </main>
            </div>
        </div>
        
        <div v-else class="cd-loading-state">
            <i class="ri-loader-4-line cd-spin"></i>
            <p>데이터를 불러오고 있습니다...</p>
        </div>
		
		<transition name="cd-fade">
		    <div class="cm-cd-overlay" v-if="isJoinModalOpen" @click.self="closeJoinModal">
		        <div class="cm-cd-container cd-glass-card">
		            
		            <header class="cm-cd-header">
		                <h3 class="cm-cd-title">
		                    <i class="ri-mail-send-line"></i> 가입 신청하기
		                </h3>
		                <button class="cm-cd-close" @click="closeJoinModal">
		                    <i class="ri-close-line"></i>
		                </button>
		            </header>
		            
		            <div class="cm-cd-body">
		                <label class="cm-cd-label">가입 사유 및 인사말</label>
		                <textarea v-model="joinReason" 
		                          class="cm-cd-textarea" 
		                          placeholder="가입 사유와 간단한 인사말을 적어주세요."></textarea>
		            </div>
		            
		            <footer class="cm-cd-footer">
		                <button class="cm-cd-btn cm-cd-btn-cancel" @click="closeJoinModal">취소</button>
		                <button class="cm-cd-btn cm-cd-btn-submit" @click="submitJoinApplication">신청 보내기</button>
		            </footer>
		            
		        </div>
		    </div>
		</transition>
    </div>
</template>