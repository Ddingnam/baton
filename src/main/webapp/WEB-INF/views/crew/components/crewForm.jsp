<%@ page contentType="text/html; charset=UTF-8"%>
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/crew/crew_form.css">

<template id="crew-form-template">
    <div class="cf-container">
        <div class="cf-header">
            <div class="cf-header-content">
                <span class="cf-header-tag">Step 01. 정보 입력</span>
                <h2 class="cf-header-title">새로운 <span class="cf-highlight">모임</span>를 개설하세요</h2>
                <p class="cf-header-desc">상세한 정보를 입력할수록 멋진 이웃들이 더 많이 모여요.</p>
            </div>
        </div>

        <div class="cf-form-card" :class="{ 'cf-only-blur': isCategoryModalOpen || isRegionModalOpen }">
            <form @submit.prevent="submitForm">
                
                <div class="cf-group cf-profile-group">
                    <div class="cf-profile-uploader">
                        <div class="cf-profile-preview" :class="{ 'no-img': !previewUrl }">
                            <i v-if="!previewUrl" class="ri-image-add-line"></i>
                            <img v-else :src="previewUrl" class="cf-preview-img">
                        </div>
                        <div class="cf-uploader-overlay"><i class="ri-camera-switch-line"></i></div>
                        <input type="file" class="cf-file-input" @change="handleFileUpload" accept="image/*">
                        <button type="button" class="cf-profile-reset" @click.stop="resetProfileImage" v-if="previewUrl">
                            <i class="ri-close-line"></i>
                        </button>
                    </div>
                    <p class="cf-help-text cf-center-text">모임의 첫인상이 될 사진을 등록하세요.</p>
                </div>

                <div class="cf-group">
                    <label class="cf-label">모임 이름</label>
                    <input type="text" v-model="crewData.name" class="cf-input" placeholder="멋진 이름을 지어주세요">
                </div>

                <div class="cf-group">
                    <label class="cf-label">모임 카테고리 <span class="cf-label-sub">(최대 3개)</span></label>
                    <div class="cf-tag-container" @click="openCategoryModal">
                        <span v-if="selectedCategories.length === 0" class="cf-placeholder">카테고리를 선택해주세요</span>
                        <div v-for="(cat, index) in selectedCategories" :key="cat.idx" class="cf-badge">
                            <i :class="cat.icon" class="cf-badge-icon"></i>
                            <span class="cf-badge-text">{{ cat.name }}</span>
                            <button type="button" class="cf-badge-remove" @click.stop="removeCategory(index)">
                                <i class="ri-close-line"></i>
                            </button>
                        </div>
                        <i class="ri-arrow-right-s-line cf-tag-arrow"></i>
                    </div>
                </div>

                <div class="cf-group">
                    <label class="cf-label">가입 방식</label>
                    <div class="cf-radio-group">
                        <label class="cf-radio-item">
                            <input type="radio" v-model="crewData.joinType" value="F" @click.stop>
                            <div class="cf-radio-box">
                                <i class="ri-door-open-line cf-radio-icon"></i>
                                <span class="cf-radio-title">자유 가입</span>
                                <span class="cf-radio-desc">즉시 참여</span>
                            </div>
                        </label>
                        <label class="cf-radio-item">
                            <input type="radio" v-model="crewData.joinType" value="A" @click.stop>
                            <div class="cf-radio-box">
                                <i class="ri-shield-user-line cf-radio-icon"></i>
                                <span class="cf-radio-title">승인제 가입</span>
                                <span class="cf-radio-desc">방장 승인</span>
                            </div>
                        </label>
                    </div>
                </div>

                <div class="cf-row">
                    <div class="cf-group">
                        <label class="cf-label">최대 인원</label>
                        <div class="cf-number-wrapper">
                            <input type="number" v-model="crewData.maxMember" class="cf-input" min="2">
                        </div>
                    </div>
                    
                    <div class="cf-group">
                        <label class="cf-label">활동 지역<span class="cf-label-sub">(최대 3곳)</span></label>
                        <div class="cf-region-box" @click.stop="openRegionModal">
                            <span class="cf-placeholder">지역 추가하기</span>
                            <i class="ri-map-pin-add-line"></i>
                        </div>
                        
                        <div class="cf-region-badge-list" v-if="selectedRegions.length > 0">
                            <div v-for="(region, index) in selectedRegions" :key="index" class="cf-region-badge-full">
                                <span class="cf-region-badge-name">{{ region.fullName }}</span>
                                <button type="button" class="cf-region-badge-remove" @click.stop="removeRegion(index)">
                                    <i class="ri-close-line"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="cf-group">
                    <label class="cf-label">모임 소개</label>
                    <textarea v-model="crewData.description" class="cf-textarea" placeholder="상세 설명을 적어주세요."></textarea>
                </div>

                <div class="cf-actions">
                    <button type="button" class="cf-btn cf-btn-cancel" @click="$router.back()">취소</button>
                    <button type="submit" class="cf-btn cf-btn-submit">모임 개설하기</button>
                </div>
            </form>
        </div>

        <div class="cf-modal-overlay" v-if="isCategoryModalOpen" @click.self="isCategoryModalOpen = false">
		    <div class="cf-modal-content">
		        <div class="cf-modal-header">
		            <h3>카테고리 선택 <span class="cf-label-sub">({{ tempSelectedCategories.length }}/3)</span></h3>
		            <button type="button" @click="isCategoryModalOpen = false"><i class="ri-close-line"></i></button>
		        </div>
		        
		        <div class="cf-category-grid">
		            <div v-for="cat in categories" :key="cat.idx" 
		                 class="cf-cat-item" 
		                 :class="{ 'is-active': tempSelectedCategories.some(item => item.idx === cat.idx) }"
		                 @click="toggleTempCategory(cat)">
		                <i :class="cat.icon"></i>
		                <span>{{ cat.name }}</span>
		            </div>
		        </div>
		
		        <div class="cf-modal-footer">
		            <button type="button" class="cf-btn-confirm" @click="confirmCategorySelection">확인</button>
		        </div>
		    </div>
		</div>

        <div class="cf-modal-overlay" v-if="isRegionModalOpen" @click.self="closeRegionModal">
            <div class="cf-modal-content cf-region-modal">
                <div class="cf-modal-header">
                    <h3>활동 지역 선택</h3>
                    <button type="button" @click="closeRegionModal"><i class="ri-close-line"></i></button>
                </div>
                
                <div class="cf-region-columns">
                    <div class="cf-region-col">
                        <div v-if="sidoList.length === 0" class="cf-region-loading">로딩중...</div>
                        <div v-for="sido in sidoList" :key="sido.code" 
                             class="cf-region-item" 
                             :class="{ active: selectedSido && selectedSido.code === sido.code }"
                             @click="fetchSigungu(sido)">
                            {{ sido.displayName }}
                        </div>
                    </div>
                    
                    <div class="cf-region-col">
                        <div v-if="!selectedSido" class="cf-region-empty">시/도를<br>선택해주세요</div>
                        <div v-else-if="sigunguList.length === 0" class="cf-region-loading">로딩중...</div>
                        <div v-for="sgg in sigunguList" :key="sgg.code" 
                             class="cf-region-item" 
                             :class="{ active: selectedSigungu && selectedSigungu.code === sgg.code }"
                             @click="fetchDong(sgg)">
                            {{ sgg.displayName }}
                        </div>
                    </div>
                    
                    <div class="cf-region-col">
                        <div v-if="!selectedSigungu" class="cf-region-empty">시/군/구를<br>선택해주세요</div>
                        <div v-else-if="dongList.length === 0" class="cf-region-loading">로딩중...</div>
                        <div v-for="dong in dongList" :key="dong.code" 
                             class="cf-region-item"
                             @click="selectDong(dong)">
                            {{ dong.displayName }}
                        </div>
                    </div>
                </div>
                <p class="cf-help-text cf-center-text" style="margin-top:15px; font-size: 13px;">읍/면/동을 클릭하면 지역이 추가됩니다.</p>
            </div>
        </div>
    </div>
</template>