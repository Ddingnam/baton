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
                    <p class="cl-welcome-desc">원하는 모임이 없나요? 직접 리더가 되어 새로운 인연을 만들어보세요.</p>
                </div>
                <div class="cl-welcome-actions">
                    <button class="cl-guide-btn primary" @click="$router.push('/write')">모임 개설하기</button>
                </div>
            </div>

			<div class="cl-glass-toolbar">
			    
			    <div class="cl-filter-row">
			        <div class="cl-filter-label">카테고리</div>
			        <div class="cl-filter-content">
			            <div class="cl-carousel-wrapper">
			                <button class="cl-carousel-nav left" @click="scrollTags('left')">
			                    <i class="ri-arrow-left-s-line"></i>
			                </button>
			                
			                <div class="cl-filter-container" ref="tagCarousel">
			                    <div class="cl-filter-group">
			                        <button class="cl-filter-btn" :class="{ active: params.categoryIdx === 0 }" @click="changeCategory(0)">전체</button>
			                        <button class="cl-filter-btn" :class="{ active: params.categoryIdx === 1 }" @click="changeCategory(1)">스터디</button>
			                        <button class="cl-filter-btn" :class="{ active: params.categoryIdx === 2 }" @click="changeCategory(2)">운동</button>
			                        <button class="cl-filter-btn" :class="{ active: params.categoryIdx === 3 }" @click="changeCategory(3)">독서</button>
			                        <button class="cl-filter-btn" :class="{ active: params.categoryIdx === 4 }" @click="changeCategory(4)">맛집/카페</button>
			                        <button class="cl-filter-btn" :class="{ active: params.categoryIdx === 5 }" @click="changeCategory(5)">산책/반려동물</button>
			                        <button class="cl-filter-btn" :class="{ active: params.categoryIdx === 6 }" @click="changeCategory(6)">공예/만들기</button>
			                        <button class="cl-filter-btn" :class="{ active: params.categoryIdx === 7 }" @click="changeCategory(7)">음악/악기</button>
			                        <button class="cl-filter-btn" :class="{ active: params.categoryIdx === 8 }" @click="changeCategory(8)">게임/오락</button>
			                        <button class="cl-filter-btn" :class="{ active: params.categoryIdx === 9 }" @click="changeCategory(9)">자유 주제</button>
			                    </div>
			                </div>

			                <button class="cl-carousel-nav right" @click="scrollTags('right')">
			                    <i class="ri-arrow-right-s-line"></i>
			                </button>
			            </div>
			        </div>
			    </div>

			    <div class="cl-filter-row cl-split-row">
			        <div class="cl-filter-col">
			            <div class="cl-filter-label">가입방식</div>
			            <div class="cl-filter-content">
			                <div class="cl-join-type-filter">
			                    <button class="cl-filter-btn" :class="{ active: params.joinType === 'all' }" @click="changeJoinType('all')">전체</button>
			                    <button class="cl-filter-btn" :class="{ active: params.joinType === 'F' }" @click="changeJoinType('F')">자유가입</button>
			                    <button class="cl-filter-btn" :class="{ active: params.joinType === 'A' }" @click="changeJoinType('A')">승인제</button>
			                </div>
			            </div>
			        </div>

			        <div class="cl-filter-col">
			            <div class="cl-filter-label">거리</div>
			            <div class="cl-filter-content">
			                <div class="cl-distance-filter">
			                    <button class="cl-filter-btn" :class="{ active: params.distance === 'local' }" @click="changeDistance('local')">내 동네</button>
			                    <button class="cl-filter-btn" :class="{ active: params.distance === 'near' }" @click="changeDistance('near')">가까운 동네</button>
			                    <button class="cl-filter-btn" :class="{ active: params.distance === 'far' }" @click="changeDistance('far')">먼 동네</button>
			                </div>
			            </div>
			        </div>
			    </div>

			    <div class="cl-filter-row cl-footer-row">
			        <div class="cl-filter-label">적용옵션</div>
			        <div class="cl-filter-content cl-flex-between">
			            
			            <div class="cl-active-filters">
			                <template v-if="activeFilters.length > 0">
			                    <span class="cl-active-badge" v-for="filter in activeFilters" :key="filter.id">
			                        <button class="cl-badge-remove" @click="removeFilter(filter.id)">
			                            <i class="ri-close-line"></i>
			                        </button>
			                        {{ filter.text }}
			                    </span>
			                </template>
			                <template v-else>
			                    <span class="cl-no-filter-text">선택된 추가 필터가 없습니다.</span>
			                </template>
			            </div>

			            <div class="cl-filter-controls">
			                <label class="cl-toggle-switch-wrap"> 
			                    <input type="checkbox" class="cl-pink-switch" v-model="params.isRecruiting" @change="resetAndFetch"> 
			                    <span class="cl-toggle-label">모집 중만 보기</span>
			                </label> 
			                <span class="cl-divider">|</span> 
			                <select class="cl-detail-select cl-sort-select" v-model="params.sortType" @change="resetAndFetch">
			                    <option value="latest">최신순</option>
			                    <option value="popular">인기순</option>
			                </select>
			            </div>
			        </div>
			    </div>
			</div>

            <div class="cl-grid-container" v-if="crews.length > 0">
                <div class="cl-card" v-for="crew in crews" :key="crew.crewIdx" @click="$router.push('/article/' + crew.crewIdx)">
                    <div class="cl-image-section">
                        <div class="cl-thumbnail no-img">
                        </div>
                        <div class="cl-badge-wrapper">
                            <span class="cl-status-badge recruiting">모집중</span>
                        </div>
                        <button class="cl-wish-btn" @click.stop="toggleWish(crew.crewIdx)">
                            <i class="ri-heart-fill"></i>
                        </button>
                        <div class="cl-host-profile">
						    <div class="cl-host-img">
						        <template v-if="crew.logoImage">
						            <img :src="'/uploads/crew/' + crew.logoImage" :alt="crew.crewName" loading="lazy">
						        </template>
						        <template v-else>
						            <i class="ri-team-fill"></i>
						        </template>
						    </div>
						</div>
                    </div>

                    <div class="cl-content-section">
                        <h3 class="cl-title">{{ crew.name }}</h3>
                        <div class="cl-meta-top">
                            <span class="cl-region" v-if="crew.regions && crew.regions.length > 0">
                                {{ crew.regions[0].sido }} {{ crew.regions[0].sigungu }}
                            </span> 
                            <span class="cl-date-dot"></span>
                            <span class="cl-created-date">개설 {{ crew.createdDate }}</span>
                        </div>
                        <div class="cl-tags">
                            <span v-for="(cat, idx) in crew.categories" :key="idx">{{ cat.name }}</span>
                        </div>
                        <div class="cl-member-status">
                            <div class="cl-member-count">
                                <strong>{{ crew.currentMember || 0 }}</strong><span> / {{ crew.maxMember }}명 참여중</span>
                            </div>
                            <div class="cl-progress-bg">
                                <div class="cl-progress-fill" :style="{ width: (crew.currentMember / crew.maxMember * 100) + '%' }"></div>
                            </div>
                        </div>
                        <div class="cl-footer">
                            <span class="cl-host-name">{{ crew.hostNickname || '리더' }}</span>
                        </div>
                    </div>
                </div>
            </div>
			
			<div ref="loadTrigger" class="cl-load-trigger" v-show="crews.length > 0 && !isLastPage">
			    <div v-if="isLoading" class="cl-loading-spinner">
			        <i class="ri-loader-4-line"></i> 로딩 중...
			    </div>
			</div>
            
			<div v-if="!isLoading && crews.length === 0 && totalCount === 0" class="cl-empty-state">
			    <div class="cl-empty-inner">
			        <div class="cl-empty-icon-box">
			            <i class="ri-search-eye-line"></i>
			        </div>
			        <div class="cl-empty-text-group">
			            <h3 class="cl-empty-title">찾으시는 모임이 없어요</h3>
			            <p class="cl-empty-desc">필터를 조정하거나 다른 키워드로 검색해 보세요.</p>
			        </div>
			        <button class="cl-reset-btn" @click="resetFilters">필터 초기화하기</button>
			    </div>
			</div>
			
        </div>
    </div>
</template>