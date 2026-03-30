<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="adminMember" value="${sessionScope.member}"/>
<c:set var="adminName" value="${empty adminMember.name ? '관리자' : adminMember.name}"/>
<c:set var="adminNickname" value="${empty adminMember.nickname ? adminName : adminMember.nickname}"/>
<c:set var="adminEmail" value="${empty adminMember.email ? '' : adminMember.email}"/>
<c:set var="adminAvatarText" value="${fn:length(adminNickname) >= 2 ? fn:substring(adminNickname, 0, 2) : adminNickname}"/>
<c:set var="adminAvatarUrl" value="${empty adminMember.avatar ? '' : pageContext.request.contextPath.concat('/uploads/profile/').concat(adminMember.avatar)}"/>
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

        <div class="user-avt-btn" id="profileTrigger" <c:if test="${not empty adminAvatarUrl}">style="background-image:url('${adminAvatarUrl}');background-size:cover;background-position:center;color:transparent;font-size:0;"</c:if>>${adminAvatarText}</div>

        <div class="pop-modal" id="profileModal">
            <div class="sq-user">
                <div class="sq-avt" id="profileQuickAvatar" <c:if test="${not empty adminAvatarUrl}">style="background-image:url('${adminAvatarUrl}');background-size:cover;background-position:center;color:transparent;font-size:0;"</c:if>>${adminAvatarText}</div>
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
                    <button class="cal-nav-btn" id="calToday" title="풀스크린 캘린더 열기">
					    <i class="ri-calendar-event-fill" style="color:var(--color-purple);"></i>
					</button>
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
                    <span class="team-count-badge" id="teamCountBadge">-</span>
                </div>
                <div class="team-rows" id="teamRows">
                    <div style="padding:16px;text-align:center;color:#94A3B8;font-size:12px;font-weight:600;">불러오는 중...</div>
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

<div class="fullscreen-overlay" id="calendarFullOverlay" style="display:none;">
    <div class="fullscreen-modal cal-full-modal" id="calendarFullModal">
        <div class="fm-sidebar">
            <div class="fm-brand" style="display:flex;align-items:center;gap:8px;">
                <i class="ri-calendar-2-fill" style="color:var(--color-purple);"></i>캘린더
            </div>
            <div style="padding:16px 12px 8px;">
                <div style="font-size:11px;font-weight:800;letter-spacing:0.06em;text-transform:uppercase;color:var(--text-light);margin-bottom:10px;">이번 달 메모</div>
                <div id="calFullMemoList" style="display:flex;flex-direction:column;gap:6px;max-height:400px;overflow-y:auto;"></div>
            </div>
        </div>
        <div class="fm-content" style="padding:32px 40px;overflow-y:auto;">
            <button class="fm-close" id="calFullClose"><i class="ri-close-line"></i></button>

            <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:28px;">
                <div style="display:flex;align-items:center;gap:16px;">
                    <button id="calFullPrev" style="width:36px;height:36px;border-radius:10px;border:1.5px solid var(--border-color);background:var(--card-bg);color:var(--text-sub);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:16px;transition:all 0.15s;">
                        <i class="ri-arrow-left-s-line"></i>
                    </button>
                    <h2 id="calFullMonthLabel" style="font-size:22px;font-weight:900;color:var(--text-main);margin:0;min-width:140px;text-align:center;"></h2>
                    <button id="calFullNext" style="width:36px;height:36px;border-radius:10px;border:1.5px solid var(--border-color);background:var(--card-bg);color:var(--text-sub);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:16px;transition:all 0.15s;">
                        <i class="ri-arrow-right-s-line"></i>
                    </button>
                </div>
                <button id="calFullToday" style="padding:8px 18px;border-radius:20px;border:none;background:var(--grad-primary);color:#fff;font-size:13px;font-weight:700;cursor:pointer;font-family:inherit;">
                    오늘
                </button>
            </div>

            <div class="cal-full-grid-head">
                <div>일</div><div>월</div><div>화</div><div>수</div><div>목</div><div>금</div><div>토</div>
            </div>
            <div class="cal-full-grid" id="calFullGrid"></div>

            <div class="cal-full-edit-panel" id="calFullEditPanel" style="display:none;">
                <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:12px;">
                    <div style="font-size:15px;font-weight:800;color:var(--text-main);" id="calFullEditDateLabel"></div>
                    <button id="calFullEditClose" style="width:28px;height:28px;border:none;background:var(--base-bg);border-radius:8px;cursor:pointer;color:var(--text-sub);font-size:16px;display:flex;align-items:center;justify-content:center;">
                        <i class="ri-close-line"></i>
                    </button>
                </div>
                <textarea id="calFullEditInput" class="cal-memo-input" placeholder="이 날의 일정이나 메모를 적어보세요..." style="width:100%;min-height:100px;resize:vertical;"></textarea>
                <div style="display:flex;gap:8px;justify-content:flex-end;margin-top:8px;">
                    <button id="calFullEditClear" class="cal-memo-clear">지우기</button>
                    <button id="calFullEditSave" class="cal-memo-save">저장</button>
                </div>
            </div>
        </div>
    </div>
</div>

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

                <style>
                /* ── 권한 관리 리뉴얼 (테마 CSS 변수 완전 연동) ── */
                .perm-cards { display:flex; flex-direction:column; gap:12px; margin-bottom:24px; }
                .perm-role-card {
                    display:flex; align-items:center; gap:16px;
                    padding:16px 18px; border-radius:16px;
                    border:2px solid transparent;
                    background:var(--base-bg);
                    transition:all 0.2s;
                    position:relative; overflow:hidden;
                }
                .perm-role-card.is-mine {
                    border-color:var(--color-purple);
                    background:var(--color-purple-light);
                }
                .perm-role-card.is-mine::before {
                    content:''; position:absolute; inset:0;
                    background:var(--grad-primary);
                    opacity:0.06; border-radius:14px; pointer-events:none;
                }
                .perm-role-icon {
                    width:46px; height:46px; border-radius:14px;
                    display:flex; align-items:center; justify-content:center;
                    font-size:20px; flex-shrink:0;
                }
                .perm-role-icon.admin { background:var(--grad-primary); color:#fff; }
                .perm-role-icon.emp   { background:linear-gradient(135deg,#3B82F6,#06B6D4); color:#fff; }
                .perm-role-body { flex:1; min-width:0; }
                .perm-role-top { display:flex; align-items:center; gap:8px; margin-bottom:4px; }
                .perm-role-name { font-size:14px; font-weight:900; color:var(--text-main); letter-spacing:0.03em; }
                .perm-role-level {
                    font-size:11px; font-weight:700; padding:2px 9px; border-radius:20px;
                    background:var(--base-bg); color:var(--text-sub);
                    border:1px solid var(--border-color);
                }
                .perm-role-desc { font-size:12px; font-weight:600; color:var(--text-light); line-height:1.5; }
                .perm-mine-badge {
                    display:inline-flex; align-items:center; gap:5px;
                    padding:5px 12px; border-radius:20px;
                    background:var(--grad-primary);
                    color:#fff; font-size:11px; font-weight:800; white-space:nowrap; flex-shrink:0;
                }
                .perm-mine-badge i { font-size:12px; }
                .perm-dash { width:22px; height:2px; background:var(--border-color); border-radius:2px; flex-shrink:0; }
                .perm-section-label {
                    font-size:11px; font-weight:800; letter-spacing:0.07em;
                    text-transform:uppercase; color:var(--text-light);
                    margin-bottom:10px;
                }
                .perm-grid { display:flex; flex-direction:column; gap:7px; }
                .perm-item {
                    display:flex; align-items:center; gap:11px;
                    padding:10px 14px; border-radius:12px;
                    background:var(--base-bg);
                    border:1px solid var(--border-color);
                }
                .perm-item.granted .perm-check { background:var(--grad-primary); }
                .perm-item.denied  { opacity:.5; }
                .perm-item.denied  .perm-check { background:var(--border-color); }
                .perm-check {
                    width:22px; height:22px; border-radius:8px; flex-shrink:0;
                    display:flex; align-items:center; justify-content:center;
                    font-size:13px; color:#fff; transition:all 0.2s;
                }
                .perm-item-label { font-size:13px; font-weight:600; color:var(--text-main); }
                .perm-item.denied .perm-item-label { color:var(--text-light); }
                </style>

                <div class="perm-cards">
                    <%-- ADMIN 카드 --%>
                    <div class="perm-role-card <c:if test="${adminMember.userLevel >= 99}">is-mine</c:if>">
                        <div class="perm-role-icon admin"><i class="ri-shield-star-fill"></i></div>
                        <div class="perm-role-body">
                            <div class="perm-role-top">
                                <span class="perm-role-name">ADMIN</span>
                                <span class="perm-role-level">Lv. 99</span>
                            </div>
                            <div class="perm-role-desc">모든 메뉴 접근 · 설정 변경 · 권한 부여</div>
                        </div>
                        <c:choose>
                            <c:when test="${adminMember.userLevel >= 99}">
                                <span class="perm-mine-badge"><i class="ri-checkbox-circle-fill"></i>현재 등급</span>
                            </c:when>
                            <c:otherwise>
                                <span class="perm-dash"></span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <%-- EMP 카드 --%>
                    <div class="perm-role-card <c:if test="${adminMember.userLevel < 99}">is-mine</c:if>">
                        <div class="perm-role-icon emp"><i class="ri-user-settings-fill"></i></div>
                        <div class="perm-role-body">
                            <div class="perm-role-top">
                                <span class="perm-role-name">EMP</span>
                                <span class="perm-role-level">Lv. 51</span>
                            </div>
                            <div class="perm-role-desc">회원 · 콘텐츠 · 신고 관리 · 채팅 접근</div>
                        </div>
                        <c:choose>
                            <c:when test="${adminMember.userLevel < 99}">
                                <span class="perm-mine-badge"><i class="ri-checkbox-circle-fill"></i>현재 등급</span>
                            </c:when>
                            <c:otherwise>
                                <span class="perm-dash"></span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="perm-section-label">내 접근 권한</div>
                <div class="perm-grid">
                    <div class="perm-item granted">
                        <div class="perm-check"><i class="ri-check-line"></i></div>
                        <span class="perm-item-label">회원 관리 (조회 · 제재 · 탈퇴 처리)</span>
                    </div>
                    <div class="perm-item granted">
                        <div class="perm-check"><i class="ri-check-line"></i></div>
                        <span class="perm-item-label">동네생활 · 신고 전체 관리</span>
                    </div>
                    <div class="perm-item granted">
                        <div class="perm-check"><i class="ri-check-line"></i></div>
                        <span class="perm-item-label">결제 · 에스크로 관리</span>
                    </div>
                    <div class="perm-item <c:choose><c:when test="${adminMember.userLevel >= 99}">granted</c:when><c:otherwise>denied</c:otherwise></c:choose>">
                        <div class="perm-check"><i class="<c:choose><c:when test="${adminMember.userLevel >= 99}">ri-check-line</c:when><c:otherwise>ri-close-line</c:otherwise></c:choose>"></i></div>
                        <span class="perm-item-label">시스템 설정 변경</span>
                    </div>
                    <div class="perm-item <c:choose><c:when test="${adminMember.userLevel >= 99}">granted</c:when><c:otherwise>denied</c:otherwise></c:choose>">
                        <div class="perm-check"><i class="<c:choose><c:when test="${adminMember.userLevel >= 99}">ri-check-line</c:when><c:otherwise>ri-close-line</c:otherwise></c:choose>"></i></div>
                        <span class="perm-item-label">관리자 권한 부여 / 회수</span>
                    </div>
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
                        <div class="profile-av-circle" id="profileAvatarCircle" data-photo-deleted="false" <c:if test="${not empty adminAvatarUrl}">style="background-image:url('${adminAvatarUrl}');background-size:cover;background-position:center;color:transparent;font-size:0;"</c:if>>${adminAvatarText}</div>
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
                        <input type="email" class="fm-input" id="profileEmailInput" value="${adminEmail}" placeholder="이메일" readonly>
                        <div style="margin-top:8px;font-size:12px;color:#94A3B8;font-weight:600;">이메일은 관리자 계정 보안을 위해 수정할 수 없습니다.</div>
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
        avatarUrl: '${fn:escapeXml(adminAvatarUrl)}',
        roleCode: '${adminRoleCode}',
        roleLabel: '${adminRoleLabel}'
    };
</script>
