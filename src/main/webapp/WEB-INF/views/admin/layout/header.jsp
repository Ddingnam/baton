<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="adminMember" value="${sessionScope.member}"/>
<c:set var="adminName" value="${empty adminMember.name ? '관리자' : adminMember.name}"/>
<c:set var="adminNickname" value="${empty adminMember.nickname ? adminName : adminMember.nickname}"/>
<c:set var="adminEmail" value="${empty adminMember.email ? '' : adminMember.email}"/>
<c:set var="adminAvatarText" value="${fn:length(adminNickname) >= 2 ? fn:substring(adminNickname, 0, 2) : adminNickname}"/>
<c:set var="adminRoleCode" value="${adminMember.userLevel >= 99 ? 'admin' : 'emp'}"/>
<c:set var="adminRoleLabel" value="${adminMember.userLevel >= 99 ? 'ADMIN' : 'EMP'}"/>

<header class="agency-header">
    <div class="head-left">
        <button id="sidebarToggle" class="toggle-icon"><i class="ri-menu-4-fill"></i></button>
    </div>

    <div class="head-center" id="systemUtilityTrigger">
        <span id="systemClock"></span>
    </div>

    <div class="head-right">
        <div class="noti-btn" id="notiTrigger">
            <i class="ri-notification-3-fill"></i>
            <div class="noti-ring" id="notiRing"></div>
            <span class="noti-count-badge" id="notiCountBadge" style="display:none;"></span>
        </div>

        <div class="user-avt-btn" id="profileTrigger">${adminAvatarText}</div>

        <div class="pop-modal" id="profileModal">
            <div class="sq-user">
                <div class="sq-avt" id="profileQuickAvatar">${adminAvatarText}</div>
                <div class="sq-info">
                    <span class="sq-name" id="profileQuickName">${adminNickname}</span>
                    <span class="sq-role" id="profileQuickRole">${adminRoleCode}</span>
                </div>
            </div>
            <div class="sq-grid">
                <div class="sq-box" onclick="window.open('${pageContext.request.contextPath}/')">
                    <i class="ri-window-fill"></i>사이트
                </div>
                <div class="sq-box" id="setupTrigger">
                    <i class="ri-equalizer-fill"></i>설정
                </div>
                <div class="sq-box" id="myProfileTrigger">
                    <i class="ri-user-settings-fill"></i>프로필
                </div>
                <div class="sq-box red" onclick="location.href='${pageContext.request.contextPath}/admin/login'">
                    <i class="ri-shut-down-line"></i>로그아웃
                </div>
            </div>
        </div>

        <div class="pop-modal noti-modal" id="notiModal">
            <div class="noti-modal-head">
                <div style="display:flex;align-items:center;">
                    <span class="noti-modal-title">알림</span>
                    <span class="noti-modal-count" id="notiModalCount" style="display:none;"></span>
                </div>
                <button class="noti-read-all" id="notiReadAll">
                    <i class="ri-check-double-line"></i> 모두 읽음
                </button>
            </div>
            <div class="noti-list" id="notiList"></div>
            <div class="noti-footer">
                <a href="${pageContext.request.contextPath}/admin/notifications" class="noti-all-link">
                    전체 보기 <i class="ri-arrow-right-line"></i>
                </a>
                <button onclick="document.getElementById('profileModal').classList.remove('show');document.getElementById('setupTrigger').click();setTimeout(function(){document.querySelector('.fm-nav-item[data-tab=notifications]').click();},100);"
                    style="border:none;background:var(--base-bg);font-size:11px;color:var(--text-light);cursor:pointer;display:flex;align-items:center;gap:4px;font-weight:700;padding:5px 10px;border-radius:20px;transition:all 0.2s;">
                    <i class="ri-settings-3-line"></i> 알림 설정
                </button>
            </div>
        </div>
    </div>
</header>

<div class="huge-modal" id="systemUtilityModal">

    <div class="wg-hero">
        <div style="position:relative;z-index:1;">
            <div class="wg-hero-label">BATON STUDIO</div>
            <div class="wg-hero-time" id="modalHeroTime">00:00</div>
        </div>
        <div class="wg-hero-right">
            <div class="wg-hero-date" id="modalHeroDate">날짜</div>
            <div class="wg-hero-status">
                <span class="wg-hero-status-dot"></span>시스템 정상
            </div>
        </div>
        <div class="wg-hero-orb wg-hero-orb-1"></div>
        <div class="wg-hero-orb wg-hero-orb-2"></div>
    </div>

    <div class="wg-cols">

        <div class="wg-panel" style="border-right:1px solid #F1F5F9;">
            <div class="wg-panel-head">
                <span id="modalMonth" class="wg-panel-title"></span>
                <div class="cal-nav">
                    <button class="cal-nav-btn" id="calPrev"><i class="ri-arrow-left-s-line"></i></button>
                    <button class="cal-nav-btn" id="calToday"><i class="ri-calendar-event-fill" style="color:var(--color-purple);"></i></button>
                    <button class="cal-nav-btn" id="calNext"><i class="ri-arrow-right-s-line"></i></button>
                </div>
            </div>
            <div class="cal-wrap" id="miniCalGrid"></div>

            <div class="cal-memo-panel" id="calMemoPanel">
                <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:8px;">
                    <div class="cal-memo-date-label" id="calMemoDateLabel"></div>
                    <span id="calMemoBadge" style="font-size:10px;font-weight:700;color:#94A3B8;"></span>
                </div>
                <div id="calMemoPreview" style="display:none;background:#F5F3FF;border:1px solid #DDD6FE;border-radius:8px;padding:10px 12px;margin-bottom:8px;"></div>
                <textarea class="cal-memo-input" id="calMemoInput" placeholder="메모할 일정을 적어주세요"></textarea>
                <div class="cal-memo-actions">
                    <button type="button" class="cal-memo-clear" id="calMemoClear">지우기</button>
                    <button type="button" class="cal-memo-save" id="calMemoSave">저장</button>
                </div>
            </div>
        </div>

        <div class="wg-right-col">

            <div class="wg-panel">
                <div class="wg-panel-head">
                    <span class="wg-panel-title">팀 현황</span>
                    <span class="team-count-badge">5명</span>
                </div>
                <div class="team-rows">
                    <div class="t-row">
                        <div class="t-avt">OD</div>
                        <div class="t-info">오다은</div>
                        <div class="t-status-pill online"><span class="t-status-dot"></span>온라인</div>
                    </div>
                    <div class="t-row">
                        <div class="t-avt">JY</div>
                        <div class="t-info">이지영</div>
                        <div class="t-status-pill online"><span class="t-status-dot"></span>온라인</div>
                    </div>
                    <div class="t-row">
                        <div class="t-avt">HN</div>
                        <div class="t-info">최하늘</div>
                        <div class="t-status-pill online"><span class="t-status-dot"></span>온라인</div>
                    </div>
                    <div class="t-row">
                        <div class="t-avt">MN</div>
                        <div class="t-info t-away">정명남</div>
                        <div class="t-status-pill away"><span class="t-status-dot"></span>자리비움</div>
                    </div>
                    <div class="t-row">
                        <div class="t-avt">HS</div>
                        <div class="t-info t-away">함형서</div>
                        <div class="t-status-pill away"><span class="t-status-dot"></span>자리비움</div>
                    </div>
                </div>
            </div>

            <div class="wg-panel" style="flex:1;">
                <div class="wg-panel-head">
                    <span class="wg-panel-title">오늘 할 일</span>
                    <span class="team-count-badge" id="todoCount">0건</span>
                </div>
                <div class="todo-list" id="todoList"></div>
                <div class="todo-add-row">
                    <input type="text" class="todo-add-input" id="todoInput" placeholder="할 일 추가...">
                    <button type="button" class="todo-add-btn" id="todoAddBtn"><i class="ri-add-line"></i></button>
                </div>
            </div>

        </div>
    </div>

</div>

<script>
    if (typeof window.CTX === 'undefined') {
        window.CTX = '${pageContext.request.contextPath}';
    }
</script>

<div class="fullscreen-overlay" id="setupOverlay">
    <div class="fullscreen-modal" id="setupModal">
        <div class="fm-sidebar">
            <div class="fm-brand">설정</div>
            <nav class="fm-nav">
                <button class="fm-nav-item active" data-tab="system">
                    <i class="ri-settings-4-fill"></i>시스템
                </button>
                <button class="fm-nav-item" data-tab="appearance">
                    <i class="ri-palette-fill"></i>컬러 테마
                </button>
                <button class="fm-nav-item" data-tab="permissions">
                    <i class="ri-shield-user-fill"></i>권한 관리
                </button>
                <button class="fm-nav-item" data-tab="notifications">
                    <i class="ri-notification-4-fill"></i>알림 설정
                </button>
            </nav>
        </div>
        <div class="fm-content">
            <button class="fm-close" id="setupClose"><i class="ri-close-line"></i></button>

            <div class="fm-tab active" id="tab-system">
                <h2 class="fm-tab-title">시스템 설정</h2>
                <p class="fm-tab-desc">BATON Studio 운영 환경을 구성합니다.</p>
                <div class="fm-section">
                    <div class="fm-field">
                        <label class="fm-label">사이트명</label>
                        <input type="text" class="fm-input" value="BATON" placeholder="사이트명 입력">
                    </div>
                    <div class="fm-field">
                        <label class="fm-label">관리자 이메일</label>
                        <input type="email" class="fm-input" value="admin@baton.kr" placeholder="이메일 주소">
                    </div>
                    <div class="fm-field">
                        <label class="fm-label">세션 만료 시간</label>
                        <select class="fm-input">
                            <option>30분</option>
                            <option selected>1시간</option>
                            <option>2시간</option>
                            <option>무제한</option>
                        </select>
                    </div>
                    <div class="fm-field">
                        <label class="fm-label">유지보수 모드</label>
                        <div class="fm-toggle-row">
                            <span class="fm-toggle-desc">활성화 시 일반 사용자 접근이 차단됩니다.</span>
                            <label class="fm-toggle">
                                <input type="checkbox">
                                <span class="fm-toggle-track"></span>
                            </label>
                        </div>
                    </div>
                </div>
                <div class="fm-actions">
                    <button class="btn-pill btn-gradient">변경사항 저장</button>
                </div>
            </div>

            <div class="fm-tab" id="tab-appearance">
                <h2 class="fm-tab-title">컬러 테마</h2>
                <p class="fm-tab-desc">관리자 페이지의 색상 테마를 변경합니다.</p>
                <div class="fm-section">
                    <div class="fm-field">
                        <label class="fm-label">테마 선택</label>
                        <div class="theme-grid" id="themeGrid">
                            <div class="theme-card active" data-theme="purple">
                                <div class="theme-preview" style="background:linear-gradient(135deg,#7C3AED,#EC4899);"></div>
                                <span class="theme-name">퍼플 (기본)</span>
                            </div>
                            <div class="theme-card" data-theme="blue">
                                <div class="theme-preview" style="background:linear-gradient(135deg,#1D4ED8,#06B6D4);"></div>
                                <span class="theme-name">오션 블루</span>
                            </div>
                            <div class="theme-card" data-theme="emerald">
                                <div class="theme-preview" style="background:linear-gradient(135deg,#059669,#3B82F6);"></div>
                                <span class="theme-name">에메랄드</span>
                            </div>
                            <div class="theme-card" data-theme="sunset">
                                <div class="theme-preview" style="background:linear-gradient(135deg,#C2410C,#EA580C,#F59E0B);"></div>
                                <span class="theme-name">선셋</span>
                            </div>
                            <div class="theme-card" data-theme="rose">
                                <div class="theme-preview" style="background:linear-gradient(135deg,#BE185D,#F43F5E);"></div>
                                <span class="theme-name">로즈</span>
                            </div>
                            <div class="theme-card" data-theme="slate">
                                <div class="theme-preview" style="background:linear-gradient(135deg,#334155,#64748B);"></div>
                                <span class="theme-name">슬레이트</span>
                            </div>
                        </div>
                    </div>
                    <div class="fm-field">
                        <label class="fm-label">다크 모드</label>
                        <div class="fm-toggle-row">
                            <span class="fm-toggle-desc">준비 중인 기능입니다.</span>
                            <label class="fm-toggle">
                                <input type="checkbox" disabled>
                                <span class="fm-toggle-track disabled"></span>
                            </label>
                        </div>
                    </div>
                </div>
                <div class="fm-actions">
                    <button class="btn-pill btn-gradient" id="saveThemeBtn">변경사항 저장</button>
                </div>
            </div>

            <div class="fm-tab" id="tab-permissions">
                <h2 class="fm-tab-title">권한 관리</h2>
                <p class="fm-tab-desc">관리자 등급별 접근 권한을 확인합니다.</p>
                <div class="fm-section">
                    <div class="perm-table-wrap">
                        <table class="perm-table">
                            <thead>
                                <tr>
                                    <th>등급</th>
                                    <th>설명</th>
                                    <th>현재 인원</th>
                                    <th>상태</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><span class="perm-badge super">Super Admin</span></td>
                                    <td>모든 권한 보유</td>
                                    <td>1명</td>
                                    <td><span class="tag tag-green">활성</span></td>
                                </tr>
                                <tr>
                                    <td><span class="perm-badge manager">Manager</span></td>
                                    <td>회원/거래 관리</td>
                                    <td>3명</td>
                                    <td><span class="tag tag-green">활성</span></td>
                                </tr>
                                <tr>
                                    <td><span class="perm-badge cs">CS Staff</span></td>
                                    <td>고객센터 담당</td>
                                    <td>2명</td>
                                    <td><span class="tag tag-blue">대기</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="fm-tab" id="tab-notifications">
                <h2 class="fm-tab-title">알림 설정</h2>
                <p class="fm-tab-desc">수신할 알림 유형과 방식을 설정합니다.</p>

                <div class="fm-section">
                    <p class="noti-set-section-label">수신 유형</p>
                    <div class="noti-set-grid">

                        <div class="noti-set-card">
                            <div class="noti-set-icon" style="background:linear-gradient(135deg,#F97316,#EF4444);">
                                <i class="ri-error-warning-fill"></i>
                            </div>
                            <div class="noti-set-info">
                                <span class="noti-set-name">신규 신고</span>
                                <span class="noti-set-desc">커뮤니티·거래</span>
                            </div>
                            <label class="fm-toggle"><input type="checkbox" class="fm-noti-toggle" data-ntype="REPORT" checked><span class="fm-toggle-track"></span></label>
                        </div>

                        <div class="noti-set-card">
                            <div class="noti-set-icon" style="background:linear-gradient(135deg,#7C3AED,#A855F7);">
                                <i class="ri-refund-2-fill"></i>
                            </div>
                            <div class="noti-set-info">
                                <span class="noti-set-name">환불 요청</span>
                                <span class="noti-set-desc">미처리 환불</span>
                            </div>
                            <label class="fm-toggle"><input type="checkbox" class="fm-noti-toggle" data-ntype="REFUND" checked><span class="fm-toggle-track"></span></label>
                        </div>

                        <div class="noti-set-card">
                            <div class="noti-set-icon" style="background:linear-gradient(135deg,#6366F1,#3B82F6);">
                                <i class="ri-question-answer-fill"></i>
                            </div>
                            <div class="noti-set-info">
                                <span class="noti-set-name">1:1 문의</span>
                                <span class="noti-set-desc">미답변 문의</span>
                            </div>
                            <label class="fm-toggle"><input type="checkbox" class="fm-noti-toggle" data-ntype="INQUIRY" checked><span class="fm-toggle-track"></span></label>
                        </div>

                        <div class="noti-set-card">
                            <div class="noti-set-icon" style="background:linear-gradient(135deg,#6366F1,#3B82F6);">
                                <i class="ri-coin-fill"></i>
                            </div>
                            <div class="noti-set-info">
                                <span class="noti-set-name">결제·충전</span>
                                <span class="noti-set-desc">포인트·결제</span>
                            </div>
                            <label class="fm-toggle"><input type="checkbox" class="fm-noti-toggle" data-ntype="PAYMENT" checked><span class="fm-toggle-track"></span></label>
                        </div>

                        <div class="noti-set-card">
                            <div class="noti-set-icon" style="background:linear-gradient(135deg,#7C3AED,#6366F1);">
                                <i class="ri-chat-3-fill"></i>
                            </div>
                            <div class="noti-set-info">
                                <span class="noti-set-name">채팅</span>
                                <span class="noti-set-desc">팀·1:1 채팅</span>
                            </div>
                            <label class="fm-toggle"><input type="checkbox" class="fm-noti-toggle" data-ntype="CHAT" checked><span class="fm-toggle-track"></span></label>
                        </div>

                        <div class="noti-set-card">
                            <div class="noti-set-icon" style="background:linear-gradient(135deg,#0EA5E9,#10B981);">
                                <i class="ri-user-add-fill"></i>
                            </div>
                            <div class="noti-set-info">
                                <span class="noti-set-name">신규 회원</span>
                                <span class="noti-set-desc">가입자 발생</span>
                            </div>
                            <label class="fm-toggle"><input type="checkbox" class="fm-noti-toggle" data-ntype="MEMBER"><span class="fm-toggle-track"></span></label>
                        </div>

                        <div class="noti-set-card">
                            <div class="noti-set-icon" style="background:linear-gradient(135deg,#7C3AED,#EC4899);">
                                <i class="ri-task-fill"></i>
                            </div>
                            <div class="noti-set-info">
                                <span class="noti-set-name">할 일·캘린더</span>
                                <span class="noti-set-desc">일정·메모</span>
                            </div>
                            <label class="fm-toggle"><input type="checkbox" class="fm-noti-toggle" data-ntype="TODO" checked><span class="fm-toggle-track"></span></label>
                        </div>

                        <div class="noti-set-card">
                            <div class="noti-set-icon" style="background:linear-gradient(135deg,#F97316,#EF4444);">
                                <i class="ri-shield-flash-fill"></i>
                            </div>
                            <div class="noti-set-info">
                                <span class="noti-set-name">시스템</span>
                                <span class="noti-set-desc">서버·점검·오류</span>
                            </div>
                            <label class="fm-toggle"><input type="checkbox" class="fm-noti-toggle" data-ntype="SYSTEM" checked><span class="fm-toggle-track"></span></label>
                        </div>

                    </div>
                </div>

                <div class="fm-section" style="margin-top:20px;">
                    <p class="noti-set-section-label">알림 방식</p>
                    <div class="noti-method-grid">

                        <div class="noti-method-card">
                            <div class="noti-method-icon" style="background:linear-gradient(135deg,#7C3AED,#A855F7);">
                                <i class="ri-volume-up-fill"></i>
                            </div>
                            <span class="noti-method-name">알림음</span>
                            <span class="noti-method-desc">새 알림 도착 시 소리</span>
                            <label class="fm-toggle"><input type="checkbox" class="fm-noti-toggle" data-ntype="sound"><span class="fm-toggle-track"></span></label>
                        </div>

                        <div class="noti-method-card">
                            <div class="noti-method-icon" style="background:linear-gradient(135deg,#7C3AED,#EC4899);">
                                <i class="ri-notification-4-fill"></i>
                            </div>
                            <span class="noti-method-name">브라우저 알림</span>
                            <span class="noti-method-desc">탭 밖에서도 팝업</span>
                            <label class="fm-toggle"><input type="checkbox" class="fm-noti-toggle" data-ntype="browser"><span class="fm-toggle-track"></span></label>
                        </div>

                    </div>
                </div>

                <div class="fm-actions">
                    <button class="btn-pill btn-gradient" id="notiSettingsSaveBtn">변경사항 저장</button>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="fullscreen-overlay" id="profileOverlay">
    <div class="fullscreen-modal profile-modal-wrap" id="profileFullModal">
        <div class="fm-sidebar">
            <div class="fm-brand">프로필</div>
            <nav class="fm-nav">
                <button class="fm-nav-item active" data-ptab="info">
                    <i class="ri-user-fill"></i>내 정보
                </button>
                <button class="fm-nav-item" data-ptab="password">
                    <i class="ri-lock-password-fill"></i>비밀번호
                </button>
                <button class="fm-nav-item" data-ptab="grade">
                    <i class="ri-shield-star-fill"></i>권한 등급
                </button>
            </nav>
        </div>
        <div class="fm-content">
            <button class="fm-close" id="profileFullClose"><i class="ri-close-line"></i></button>

            <div class="fm-tab active" id="ptab-info">
                <h2 class="fm-tab-title">내 정보 수정</h2>
                <p class="fm-tab-desc">프로필 사진과 이름, 닉네임을 변경합니다.</p>
                <div class="fm-section">
                    <div class="profile-avatar-edit">
                        <div class="profile-av-circle" id="profileAvatarCircle">${adminAvatarText}</div>
                        <div class="profile-av-actions">
                            <button class="btn-pill btn-light" type="button" id="profilePhotoBtn" style="font-size:13px;padding:8px 16px;">사진 변경</button>
                            <button class="btn-text" type="button" id="profilePhotoClearBtn" style="font-size:13px;">삭제</button>
                            <input type="file" id="profilePhotoInput" accept="image/*" style="display:none;">
                        </div>
                    </div>
                    <div class="fm-field">
                        <label class="fm-label">이름</label>
                        <input type="text" class="fm-input" id="profileNameInput" value="${adminName}" placeholder="이름 입력">
                    </div>
                    <div class="fm-field">
                        <label class="fm-label">닉네임</label>
                        <input type="text" class="fm-input" id="profileNicknameInput" value="${adminNickname}" placeholder="닉네임 입력">
                    </div>
                    <div class="fm-field">
                        <label class="fm-label">이메일</label>
                        <input type="email" class="fm-input" id="profileEmailInput" value="${adminEmail}" placeholder="이메일">
                    </div>
                </div>
                <div class="fm-actions">
                    <button class="btn-pill btn-gradient" type="button" id="profileSaveBtn">저장하기</button>
                </div>
            </div>

            <div class="fm-tab" id="ptab-password">
                <h2 class="fm-tab-title">비밀번호 변경</h2>
                <p class="fm-tab-desc">보안을 위해 주기적으로 비밀번호를 변경하세요.</p>
                <div class="fm-section">
                    <div class="fm-field">
                        <label class="fm-label">현재 비밀번호</label>
                        <input type="password" class="fm-input" id="currentPasswordInput" placeholder="현재 비밀번호 입력">
                    </div>
                    <div class="fm-field">
                        <label class="fm-label">새 비밀번호</label>
                        <input type="password" class="fm-input" id="newPasswordInput" placeholder="새 비밀번호 입력">
                    </div>
                    <div class="fm-field">
                        <label class="fm-label">비밀번호 확인</label>
                        <input type="password" class="fm-input" id="confirmPasswordInput" placeholder="새 비밀번호 재입력">
                    </div>
                </div>
                <div class="fm-actions">
                    <button class="btn-pill btn-gradient" type="button" id="passwordSaveBtn">변경하기</button>
                </div>
            </div>

            <div class="fm-tab" id="ptab-grade">
                <h2 class="fm-tab-title">내 권한 등급</h2>
                <p class="fm-tab-desc">현재 계정에 부여된 권한 정보입니다.</p>
                <div class="fm-section">
                    <div class="grade-card">
                        <div class="grade-icon"><i class="ri-shield-star-fill"></i></div>
                        <div class="grade-info">
                            <span class="grade-title">${adminRoleLabel}</span>
                            <span class="grade-desc">${adminMember.userLevel >= 99 ? '모든 메뉴 접근 및 설정 변경 가능' : '업무 채널과 운영 메뉴에 접근 가능'}</span>
                        </div>
                    </div>
                    <div class="perm-list">
                        <div class="perm-row"><i class="ri-check-line"></i><span>회원 관리 (조회/제재/탈퇴 처리)</span></div>
                        <div class="perm-row"><i class="ri-check-line"></i><span>거래 및 커뮤니티 관리</span></div>
                        <div class="perm-row"><i class="ri-check-line"></i><span>고객센터 문의 답변</span></div>
                        <div class="perm-row"><i class="ri-check-line"></i><span>시스템 설정 변경</span></div>
                        <div class="perm-row"><i class="ri-check-line"></i><span>관리자 권한 부여/회수</span></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    window.ADMIN_PROFILE = {
        name: '${fn:escapeXml(adminName)}',
        nickname: '${fn:escapeXml(adminNickname)}',
        email: '${fn:escapeXml(adminEmail)}',
        roleCode: '${adminRoleCode}',
        roleLabel: '${adminRoleLabel}'
    };
</script>
