<%@ page contentType="text/html; charset=UTF-8"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/crew/crew_detail_schedule.css">

<template id="crew-schedule-template">
    <div class="cs-schedule-container" v-if="crew">
        
        <div class="cs-header-card cs-glass-card">
            <header class="cs-main-header">
                <div class="cs-header-left">
                    <div class="cs-breadcrumb">
                        <span>Crew</span>
                        <i class="ri-arrow-right-s-line"></i>
                        <strong>Schedule</strong>
                    </div>
                    <h2 class="cs-header-title">모임 일정</h2>
                </div>
                
				<div class="cs-header-right">
				    <button v-if="myStatus && ['LEADER', 'SUB_LEADER'].includes(myStatus.role)"
				            class="cs-btn-primary" @click="openAddModal">
				        <i class="ri-add-line"></i> <span>일정 추가</span>
				    </button>
				</div>
            </header>
        </div>

        <div class="cs-glass-card cs-calendar-widget">
            <div class="cs-cal-header">
                <button class="cs-icon-btn" @click="prevMonth"><i class="ri-arrow-left-s-line"></i></button>
                <h3 class="cs-month-title">{{ currentYear }}년 {{ currentMonth }}월</h3>
                <button class="cs-icon-btn" @click="nextMonth"><i class="ri-arrow-right-s-line"></i></button>
            </div>
            
            <div class="cs-cal-grid">
                <div class="cs-weekday" v-for="day in weekdays" :key="day">{{ day }}</div>
                
                <div class="cs-day-cell"
                     v-for="(date, index) in calendarDays" 
                     :key="index"
                     :class="{
                         'is-prev-month': !date.isCurrentMonth,
                         'is-today': date.isToday,
                         'is-selected': isSelectedDate(date.fullDate)
                     }"
                     @click="selectDate(date.fullDate)">
                    
                    <span class="cs-day-number">{{ date.day }}</span>
                    <div v-if="date.hasSchedule" class="cs-schedule-dot"></div>
                </div>
            </div>
        </div>

        <div class="cs-glass-card cs-list-widget">
            <div class="cs-list-header">
                <h4><i class="ri-calendar-check-fill"></i> {{ formattedSelectedDate }} 일정</h4>
            </div>

            <div class="cs-schedule-list" v-if="dailySchedules && dailySchedules.length > 0">
                <div v-for="sch in dailySchedules" :key="sch.scheduleIdx" class="cs-schedule-item">
                    <div class="cs-sch-time">
                        <strong>{{ formatTime(sch.startDate) }}</strong>
                    </div>
                    <div class="cs-sch-info">
                        <h5 class="cs-sch-title">{{ sch.title }}</h5>
                        <span class="cs-sch-loc"><i class="ri-map-pin-line"></i> {{ sch.locationName || '장소 미정' }}</span>
                    </div>
                    <div class="cs-sch-meta">
                        <div class="cs-attend-count" :class="{'is-full': sch.maxPeople > 0 && sch.currentCount >= sch.maxPeople}">
                            {{ sch.currentCount }}
                            <span v-if="sch.maxPeople > 0">/ {{ sch.maxPeople }}</span>
                            <span v-else>/ 제한 없음</span>
                        </div>
                        <button class="cs-detail-btn" @click="openDetailModal(sch.scheduleIdx)">상세보기</button>
                    </div>
                </div>
            </div>
            
            <div v-else class="cs-no-schedule">
                <i class="ri-calendar-event-line"></i>
                <p>이 날은 예정된 모임이 없습니다.</p>
                <span class="cs-sub-text">첫 번째 모임의 호스트가 되어보세요!</span>
            </div>
        </div>
		
		<transition name="cs-modal-fade">
	        <div class="cs-modal-overlay" v-if="isModalOpen" @click.self="closeModal">
	            <div class="cs-modal-container cs-glass-card">
	                <header class="cs-modal-header">
	                    <h3><i class="ri-calendar-todo-fill"></i> 새 일정 추가</h3>
	                    <button class="cs-modal-close" @click="closeModal"><i class="ri-close-line"></i></button>
	                </header>
	                
	                <div class="cs-modal-body">
	                    <div class="cs-form-group">
	                        <label>일정 제목</label>
	                        <input type="text" v-model="scheduleForm.title" class="cs-modal-input" placeholder="모임의 주제를 적어주세요.">
	                    </div>
	
	                    <div class="cs-form-row">
	                        <div class="cs-form-group">
	                            <label>시작 일시</label>
	                            <input type="datetime-local" v-model="scheduleForm.startDate" class="cs-modal-input">
	                        </div>
	                        <div class="cs-form-group">
	                            <label>종료 일시</label>
	                            <input type="datetime-local" v-model="scheduleForm.endDate" class="cs-modal-input">
	                        </div>
	                    </div>
	
	                    <div class="cs-form-group">
	                        <label>장소 선택</label>
	                        <div class="cs-map-search-wrapper">
	                            <input type="text" v-model="searchKeyword" @keyup.enter="searchLocation" class="cs-search-input" placeholder="장소를 검색하세요 (예: 강남역 스타벅스)">
	                            <button type="button" class="cs-map-search-btn" @click="searchLocation"><i class="ri-search-line"></i></button>
	                        </div>
	                        
	                        <div id="cs-kakao-map" class="cs-map-view"></div>
	                        
	                        <input type="hidden" v-model="scheduleForm.lat">
	                        <input type="hidden" v-model="scheduleForm.lng">
	                        
	                        <input type="text" v-model="scheduleForm.locationName" class="cs-modal-input" placeholder="일정에 표시될 장소의 이름을 적어주세요." style="margin-top: 8px;">
	                    </div>
	
	                    <div class="cs-form-row">
	                        <div class="cs-form-group">
	                            <label>참여 정원 (0명은 무제한)</label>
	                            <input type="number" v-model="scheduleForm.maxPeople" class="cs-modal-input" min="0">
	                        </div>
	                    </div>
	
	                    <div class="cs-form-group">
	                        <label>상세 내용</label>
	                        <textarea v-model="scheduleForm.content" class="cs-modal-textarea" rows="3" placeholder="참여자들에게 전할 내용을 자유롭게 적어주세요."></textarea>
	                    </div>
	                </div>
	                
	                <footer class="cs-modal-footer">
	                    <button class="cs-btn-outline" @click="closeModal">취소</button>
	                    <button class="cs-btn-primary" @click="submitSchedule">{{ scheduleForm.scheduleIdx ? '일정 수정' : '일정 등록' }}</button>
	                </footer>
	            </div>
	        </div>
		</transition>
			
		<transition name="cs-md-fade">
		    <div class="cs-md-overlay" v-if="isDetailModalOpen" @click.self="closeDetailModal">
				<div class="cs-md-layout-wrapper">
			        <div class="cs-md-container">
						
						<div class="cs-side-card cs-glass-card">
			                <div class="cs-side-header">
			                    <h4>
			                        <i class="ri-group-fill"></i> 참석 멤버 
			                        <span class="cs-side-count">{{ selectedSchedule.currentCount || 0 }}</span>
			                    </h4>
			                </div>
			                
			                <ul class="cs-side-list" v-if="selectedSchedule.attendees && selectedSchedule.attendees.length > 0">
			                    <li v-for="user in selectedSchedule.attendees" :key="user.nickname" class="cs-side-item">
									<div class="cs-side-avatar">
									    <img v-if="user.profileImg" 
									         :src="'/uploads/member/' + user.profileImg" 
									         alt="profile">
									    
									    <div v-else class="cs-side-default-icon">
									        <i class="ri-user-smile-fill"></i>
									    </div>
									</div>
			                        <span class="cs-side-name">{{ user.nickname }} <i v-if="user.host" class="ri-vip-crown-fill"></i></span>
			                    </li>
			                </ul>
	
			                <div v-else class="cs-side-no-data">
			                    <i class="ri-user-add-line"></i>
			                    <p>아직 참석자가 없습니다.<br>첫 번째 멤버가 되어보세요!</p>
			                </div>
			            </div>
						
			            <header class="cs-md-header">
			                <h3><i class="ri-file-list-3-line"></i> 일정 상세보기</h3>
			            </header>
	
			            <div class="cs-md-body">
			                
			                <div class="cs-md-row">
			                    <span class="cs-md-label">제목</span>
			                    <span class="cs-md-data">{{ selectedSchedule.title }}</span>
			                </div>
	
			                <div class="cs-md-row">
			                    <span class="cs-md-label">내용</span>
			                    <div class="cs-md-content-box">{{ selectedSchedule.content || '' }}</div>
			                </div>
							
							<div class="cs-md-row">
			                    <span class="cs-md-label">주최</span>
			                    <span class="cs-md-data">{{ selectedSchedule.userNickname || '' }} </span>
			                </div>
	
			                <div class="cs-md-row">
			                    <span class="cs-md-label">참석 인원</span>
			                    <span class="cs-md-data" :class="(selectedSchedule.maxPeople > 0 && selectedSchedule.currentCount >= selectedSchedule.maxPeople) ? 'is-full' : 'attend'">
			                        {{ selectedSchedule.currentCount || 0 }} / 
			                        <template v-if="selectedSchedule.maxPeople > 0">{{ selectedSchedule.maxPeople }}</template>
			                        <template v-else>무제한</template>
			                    </span>
			                </div>
	
			                <div class="cs-md-row">
			                    <span class="cs-md-label">시간</span>
			                    <span class="cs-md-data">
			                        {{ formatDateTime(selectedSchedule.startDate) }} ~ {{ formatDateTime(selectedSchedule.endDate) }}
			                    </span>
			                </div>
	
							<div class="cs-md-row">
							    <span class="cs-md-label">장소</span>
							    <div class="cs-md-map-wrapper">
							        <span class="cs-md-data">{{ selectedSchedule.locationName || '장소 미정' }}</span>
							        <div id="cs-md-map" class="cs-md-map-view" v-show="selectedSchedule.lat"></div>
							    </div>
							</div>
			                
			            </div>
						
						<div v-if="currentUserIdx !== selectedSchedule.userIdx && new Date(selectedSchedule.startDate) < new Date()" 
						     class="cs-md-status-msg">
						    <i class="ri-information-line"></i> 종료된 일정은 참석 변경이 불가능합니다.
						</div>
	
						<footer class="cs-md-footer">
						    <template v-if="currentUserIdx === selectedSchedule.userIdx">
						        <button class="cs-btn-edit" @click="editSchedule(selectedSchedule.scheduleIdx)">
						            <i class="ri-edit-line"></i> 수정
						        </button>
						        <button class="cs-btn-delete" @click="deleteSchedule(selectedSchedule.scheduleIdx)">
						            <i class="ri-delete-bin-line"></i> 삭제
						        </button>
						    </template>
	
						    <template v-else>
						        <button v-if="selectedSchedule.attending" class="cs-btn-delete" @click="toggleVote(selectedSchedule.scheduleIdx)"
									:class="{'cs-btn-disabled': new Date(selectedSchedule.startDate) < new Date()}"
					                :disabled="new Date(selectedSchedule.startDate) < new Date()">
						            <i class="ri-close-line"></i> 참석 취소
						        </button>
						        
						        <button v-else class="cs-btn-primary" @click="toggleVote(selectedSchedule.scheduleIdx)"
									:class="{'cs-btn-disabled': new Date(selectedSchedule.startDate) < new Date()}"
								    :disabled="new Date(selectedSchedule.startDate) < new Date()">
						            <i class="ri-check-line"></i> 참석하기
						        </button>
						    </template>
	
						    <button class="cs-btn-outline" @click="closeDetailModal">
						        <i class="ri-close-line"></i> 닫기
						    </button>
						</footer>
			        </div>
				</div>
		    </div>
		</transition>
    </div>
</template>