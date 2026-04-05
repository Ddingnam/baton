<%@ page contentType="text/html; charset=UTF-8"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/crew/crew_detail_admin.css">

<template id="crew-admin-template">
    <div class="ca-admin-container" v-if="crew">
        
		<div class="ca-glass-card ca-header-card">
		    <header class="ca-main-header">
		        <div class="ca-header-left">
		            <div class="ca-breadcrumb">
		                <span>Crew</span>
		                <i class="ri-arrow-right-s-line"></i>
		                <strong>Admin</strong>
		            </div>
		            <h2 class="ca-header-title">모임 관리</h2>
		        </div>
		    </header>
		    
		    <div class="ca-tab-wrapper">
		        <button class="ca-tab-btn" :class="{ 'is-active': currentTab === 'info' }" @click="switchTab('info')">
		            <i class="ri-information-line"></i> 기본 정보 수정
		        </button>
		        <button class="ca-tab-btn" :class="{ 'is-active': currentTab === 'members' }" @click="switchTab('members')">
		            <i class="ri-group-line"></i> 멤버 관리
		        </button>
		        <button class="ca-tab-btn" v-if="editForm.joinType === 'A'" :class="{ 'is-active': currentTab === 'apps' }" @click="switchTab('apps')">
		            <i class="ri-user-add-line"></i> 가입 신청 현황 
		            <span class="ca-badge" v-if="pendingApps.length > 0">{{ pendingApps.length }}</span>
		        </button>
				<button class="ca-tab-btn" :class="{ 'is-active': currentTab === 'history' }" @click="switchTab('history')">
				    <i class="ri-history-line"></i> 활동 기록
				</button>
		    </div>
		</div>

        <div v-show="currentTab === 'info'" class="ca-glass-card ca-content-card">
            <h3 class="ca-section-title">모임 정보 설정</h3>
			
			<div class="ca-form-row ca-row-center">
		        <div class="ca-form-group ca-profile-group">
		            <div class="ca-profile-uploader">
		                <div class="ca-profile-preview" :class="{ 'no-img': !previewUrl && !crew.mainImg }">
		                    <i v-if="!previewUrl && !crew.mainImg" class="ri-image-add-line"></i>
		                    <img v-else :src="previewUrl || '/uploads/crew/' + crew.mainImg" class="ca-preview-img">
		                </div>
		                <div class="ca-uploader-overlay"><i class="ri-camera-switch-line"></i></div>
		                <input type="file" class="ca-file-input" @change="handleFileUpload" accept="image/*">
		                <button type="button" class="ca-profile-reset" @click.stop="resetProfileImage" v-if="previewUrl">
		                    <i class="ri-close-line"></i>
		                </button>
		            </div>
		        </div>
		    </div>
            
			<div class="ca-form-row">
		        <div class="ca-form-group">
		            <label>모임 이름</label>
		            <input type="text" v-model="editForm.crewName" class="ca-input" placeholder="모임 이름을 입력하세요">
		        </div>
		        <div class="ca-form-group">
		            <label>최대 정원 (명)</label>
		            <input type="number" v-model="editForm.maxMember" class="ca-input" min="1">
		        </div>
		    </div>

			<div class="ca-form-row">
		        <div class="ca-form-group">
		            <label>가입 방식</label>
		            <select v-model="editForm.joinType" class="ca-select">
		                <option value="F">자유 가입 (누구나 바로 가입)</option>
		                <option value="A">승인제 (리더가 승인 후 가입)</option>
		            </select>
		        </div>
		        <div class="ca-form-group">
		            <label>모집 상태</label>
		            <select v-model="editForm.status" class="ca-select">
		                <option value="1">🟢 모집 중</option>
		                <option value="0">🔴 모집 마감</option>
		            </select>
		        </div>
		    </div>

		    <div class="ca-form-group">
		        <label>모임 소개</label>
		        <textarea v-model="editForm.description" class="ca-textarea" rows="5" placeholder="모임의 목적, 활동 시간, 분위기 등을 자유롭게 소개해 주세요."></textarea>
		    </div>

            <div class="ca-action-footer">
                <button class="ca-btn-primary" @click="updateCrewInfo"><i class="ri-save-line"></i> 변경사항 저장</button>
            </div>

            <div class="ca-danger-zone">
                <h4><i class="ri-error-warning-fill"></i> Danger Zone</h4>
                <p>모임을 폐쇄하면 더 이상 멤버들이 활동할 수 없으며, 복구가 불가능합니다.</p>
                <button class="ca-btn-danger" @click="closeCrew">모임 폐쇄하기</button>
            </div>
        </div>

		<div v-show="currentTab === 'members'" class="ca-glass-card ca-content-card">
		    <h3 class="ca-section-title">현재 활동 중인 멤버 ({{ activeMembers.length }}명)</h3>
		    <div class="ca-list-container" v-if="activeMembers.length > 0">
		        <div v-for="member in activeMembers" :key="member.userIdx" class="ca-list-item">
		            <div class="ca-user-info">
		                <div class="ca-avatar">
		                    <img v-if="member.profileImg" :src="'/uploads/member/' + member.profileImg" alt="profile">
		                    <i v-else class="ri-user-smile-fill"></i>
		                </div>
		                <div class="ca-user-meta">
		                    <strong>{{ member.nickname }} <i v-if="member.role === 'LEADER'" class="ri-vip-crown-fill" style="color: #FFB800;"></i></strong>
		                    <span>가입일: {{ member.formattedDate }}</span>
		                </div>
		            </div>
		            <div class="ca-user-actions">
		                <button class="ca-btn-detail" @click="openMemberModal(member)">상세보기</button>
		            </div>
		        </div>
		    </div>
		</div>

		<div v-show="currentTab === 'apps'" class="ca-glass-card ca-content-card">
		    <h3 class="ca-section-title">가입 대기 중인 인원 ({{ pendingApps.length }}명)</h3>
		    <div class="ca-list-container" v-if="pendingApps.length > 0">
		        <div v-for="app in pendingApps" :key="app.userIdx" class="ca-list-item">
		            <div class="ca-user-info">
		                <div class="ca-avatar">
		                    <img v-if="app.profileImg" :src="'/uploads/member/' + app.profileImg" alt="profile">
		                    <i v-else class="ri-user-smile-fill"></i>
		                </div>
		                <div class="ca-user-meta">
		                    <strong>{{ app.nickname }}</strong>
		                </div>
		            </div>
		            <div class="ca-user-actions">
		                <button class="ca-btn-detail" @click="openAppModal(app)">상세보기</button>
		            </div>
		        </div>
		    </div>
		</div>
		
		<div v-show="currentTab === 'history'" class="ca-glass-card ca-content-card">
		    <h3 class="ca-section-title">모임 타임라인</h3>
		    <div class="ca-history-list" v-if="historyList.length > 0">
		        <div v-for="log in historyList" :key="log.historyIdx" class="ca-history-item">
		            <div class="ca-history-date">{{ log.logDate }}</div>
		            <div class="ca-history-content">
		                <span class="ca-history-user"><strong>{{ log.nickname }}</strong> 님이</span>
		                <span class="ca-history-status" :class="log.changedStatus.toLowerCase()">
		                    {{ formatStatus(log.changedStatus) }}
		                </span>
		                <span class="ca-history-actor" v-if="log.actorNickname"> ( 처리자 : {{ log.actorNickname }} )</span>
		                <p class="ca-history-reason" v-if="log.reason">{{ log.reason }}</p>
		            </div>
		        </div>
		    </div>
		    <div v-else class="ca-empty-state">
		        <p>기록된 활동 이력이 없습니다.</p>
		    </div>
		</div>

		<transition name="cam-fade">
		    <div class="cam-overlay" v-if="isMemberModalOpen" @click.self="closeMemberModal">
		        <div class="cam-container">
		            <header class="cam-header">
		                <h3>멤버 상세 정보</h3>
		                <button class="cam-close-btn" @click="closeMemberModal"><i class="ri-close-line"></i></button>
		            </header>
		            
		            <div class="cam-body" v-if="selectedMember">
		                <div class="cam-profile-sec">
		                    <img v-if="selectedMember.profileImg" :src="'/uploads/member/' + selectedMember.profileImg">
		                    <div v-else class="cam-default-img"><i class="ri-user-smile-fill"></i></div>
		                    <h4>{{ selectedMember.nickname }}</h4>
		                    <p class="cam-join-date">가입일: {{ selectedMember.formattedDate }}</p>
		                </div>
		                
		                <div class="cam-info-group">
		                    <label>모임 역할 부여</label>
		                    <select v-model="selectedMember.role" class="cam-select" :disabled="selectedMember.role === 'LEADER'">
		                        <option value="MEMBER">일반 멤버 (MEMBER)</option>
		                        <option value="SUB_LEADER">부방장 (SUB_LEADER)</option>
		                        <option value="LEADER" disabled>방장 (LEADER)</option>
		                    </select>
		                </div>
		            </div>

		            <footer class="cam-footer">
		                <button v-if="selectedMember && selectedMember.role !== 'LEADER'" class="cam-btn-danger" @click="kickMember(selectedMember.userIdx, selectedMember.nickname)">강제 퇴장</button>
		                <div style="flex:1;"></div>
		                <button class="cam-btn-outline" @click="closeMemberModal">닫기</button>
		                <button v-if="selectedMember && selectedMember.role !== 'LEADER'" class="cam-btn-primary" @click="updateMemberRole">변경사항 저장</button>
		            </footer>
		        </div>
		    </div>
		</transition>

		<transition name="cam-fade">
		    <div class="cam-overlay" v-if="isAppModalOpen" @click.self="closeAppModal">
		        <div class="cam-container">
		            <header class="cam-header">
		                <h3>가입 신청 상세</h3>
		                <button class="cam-close-btn" @click="closeAppModal"><i class="ri-close-line"></i></button>
		            </header>
		            
		            <div class="cam-body" v-if="selectedApp">
		                <div class="cam-profile-sec">
		                    <img v-if="selectedApp.profileImg" :src="'/uploads/member/' + selectedApp.profileImg">
		                    <div v-else class="cam-default-img"><i class="ri-user-smile-fill"></i></div>
		                    <h4>{{ selectedApp.nickname }}</h4>
		                    <p class="cam-join-date">신청일: {{ selectedApp.applyDate }}</p>
		                </div>
		                
		                <div class="cam-info-group">
		                    <label>가입 사유 및 인사말</label>
		                    <div class="cam-reason-box">
		                        {{ selectedApp.applicationReason || '작성된 가입 사유가 없습니다.' }}
		                    </div>
		                </div>
		            </div>

		            <footer class="cam-footer" style="gap: 10px;">
		                <button class="cam-btn-success" style="flex:1;" @click="handleApplication(selectedApp.userIdx, 'APPROVE')"><i class="ri-check-line"></i> 승인</button>
		                <button class="cam-btn-danger" style="flex:1;" @click="handleApplication(selectedApp.userIdx, 'REJECT')">거절</button>
		                <button class="cam-btn-outline" style="flex:1;" @click="closeAppModal">닫기</button>
		            </footer>
		        </div>
		    </div>
		</transition>

    </div>
</template>