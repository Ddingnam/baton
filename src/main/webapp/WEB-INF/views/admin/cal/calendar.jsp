<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>캘린더 · BATON Studio</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700;800;900&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@4.2.0/fonts/remixicon.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/calendar.css">
<script>
window.CTX='${pageContext.request.contextPath}';
</script>
<!-- CSRF -->
<meta name="_csrf"        content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
</head>
<body>
<div class="cp-shell">
    <aside class="cp-aside">
        <div class="cp-brand-wrap">
            <div class="cp-brand">
                <div class="cp-brand-icon"><i class="ri-calendar-2-fill"></i></div>
                <div>
                    <div class="cp-brand-name">캘린더</div>
                    <div class="cp-brand-sub">BATON STUDIO</div>
                </div>
            </div>
            <a class="cp-back-btn" href="${pageContext.request.contextPath}/admin">
                <i class="ri-arrow-left-line"></i>
                <span>대시보드로 돌아가기</span>
            </a>
        </div>

        <div class="cp-mini-cal-card">
            <div class="cp-mini-cal">
                <div class="cp-mini-nav">
                    <span class="cp-mini-month" id="miniMonthLabel"></span>
                    <div class="cp-mini-nav-btns">
                        <button class="cp-mini-nav-btn" id="miniPrev" title="이전 달"><i class="ri-arrow-left-s-line"></i></button>
                        <button class="cp-mini-nav-btn" id="miniNext" title="다음 달"><i class="ri-arrow-right-s-line"></i></button>
                    </div>
                </div>
                <div class="cp-mini-grid" id="miniGrid"></div>
            </div>
        </div>

        <div class="cp-aside-divider"></div>

        <div class="cp-upcoming-wrap">
            <div class="cp-upcoming">
                <div class="cp-upcoming-label">일정 목록 <span id="upcomingCount">0</span></div>
                <div id="upcomingList"></div>
            </div>
        </div>
    </aside>

    <div class="cp-main">
        <div class="cp-toolbar">
            <div class="cp-toolbar-left">
                <button class="cp-nav-btn" onclick="location.href='${pageContext.request.contextPath}/admin'" title="어드민 메인으로"><i class="ri-home-5-line"></i></button>
                <button class="cp-nav-btn" id="mainPrev" title="이전"><i class="ri-arrow-left-s-line"></i></button>
                <button class="cp-nav-btn" id="mainNext" title="다음"><i class="ri-arrow-right-s-line"></i></button>
                <span class="cp-toolbar-title" id="mainLabel"></span>
                <button class="cp-today-pill" id="btnToday">오늘</button>
            </div>
            <div class="cp-toolbar-right">
                <div class="cp-view-tabs">
                    <button class="cp-view-tab" data-view="month">월</button>
                    <button class="cp-view-tab active" data-view="week">주</button>
                    <button class="cp-view-tab" data-view="day">일</button>
                </div>
                <div class="cp-header-theme-wrap">
                    <button class="cp-header-theme-btn" id="headerThemeBtn" title="테마 변경">
                        <i class="ri-palette-line"></i>
                        <span class="cp-header-theme-preview" id="headerThemePreview"></span>
                    </button>
                    <div class="cp-header-theme-dropdown" id="headerThemeDropdown">
                        <div class="cp-header-theme-label">테마 색상</div>
                        <div class="cp-header-theme-dots" id="headerThemeDots">
                            <div class="header-theme-dot" data-theme="purple" style="background:#7C3AED" title="퍼플"></div>
                            <div class="header-theme-dot" data-theme="blue" style="background:#1D4ED8" title="오션 블루"></div>
                            <div class="header-theme-dot" data-theme="emerald" style="background:#059669" title="에메랄드"></div>
                            <div class="header-theme-dot" data-theme="sunset" style="background:#EA580C" title="선셋"></div>
                            <div class="header-theme-dot" data-theme="rose" style="background:#E11D48" title="로즈"></div>
                            <div class="header-theme-dot" data-theme="slate" style="background:#334155" title="슬레이트"></div>
                        </div>
                    </div>
                </div>
                <button class="cp-add-btn" id="btnAdd"><i class="ri-add-line"></i> 일정 추가</button>
            </div>
        </div>

        <div class="cp-month-view hidden" id="monthView">
            <div class="cp-month-head">
                <div class="cp-month-head-cell">일</div>
                <div class="cp-month-head-cell">월</div>
                <div class="cp-month-head-cell">화</div>
                <div class="cp-month-head-cell">수</div>
                <div class="cp-month-head-cell">목</div>
                <div class="cp-month-head-cell">금</div>
                <div class="cp-month-head-cell">토</div>
            </div>
            <div class="cp-month-grid" id="monthGrid"></div>
        </div>

        <div class="cp-week-view" id="weekView">
            <div class="cp-week-header" id="weekHeader"></div>
            <div class="cp-week-body" id="weekBody">
                <div class="cp-week-grid" id="weekGrid"></div>
            </div>
        </div>

        <div class="cp-day-view hidden" id="dayView">
            <div class="cp-day-header">
                <div class="cp-day-header-date" id="dayHeaderDate"></div>
                <div class="cp-day-header-dow" id="dayHeaderDow"></div>
            </div>
            <div class="cp-day-body" id="dayBody">
                <div class="cp-day-grid" id="dayGrid"></div>
            </div>
        </div>
    </div>
</div>

<div class="cp-modal-overlay" id="modalOverlay">
    <div class="cp-modal">
        <div class="cp-modal-header">
            <div class="cp-modal-header-top">
                <div class="cp-modal-header-label">
                    <span class="cp-modal-indicator" id="modalIndicator"></span>
                    <span class="cp-modal-header-title" id="modalTitle">새 일정</span>
                </div>
                <button class="cp-modal-close" id="closeModalBtn" title="닫기"><i class="ri-close-line"></i></button>
            </div>
            <div class="cp-modal-color-row" id="colorRow"></div>
        </div>
        <div class="cp-modal-body">
            <input type="text" class="cp-input-large" id="evTitle" placeholder="일정 제목을 입력하세요" autocomplete="off">
            <div class="cp-field mt-2">
                <label class="cp-field-label">일정 구분</label>
                <div class="cp-selectbox" id="evTypeSelect" data-value="basic" data-tone="basic" tabindex="0">
                    <input type="hidden" id="evType" value="basic">
                    <button type="button" class="cp-select-trigger" id="evTypeTrigger" aria-haspopup="listbox" aria-expanded="false">
                        <span class="cp-select-trigger-main">
                            <span class="cp-select-trigger-badge" id="evTypeBadge"></span>
                            <span class="cp-select-trigger-label" id="evTypeLabel">기본 일정</span>
                        </span>
                        <i class="ri-arrow-down-s-line"></i>
                    </button>
                    <div class="cp-select-menu" id="evTypeMenu" role="listbox">
                        <button type="button" class="cp-select-option active" data-value="basic" data-label="기본 일정" data-tone="basic">
                            <span class="cp-select-option-badge"></span>
                            <span><strong>기본 일정</strong><em>일반 업무와 약속</em></span>
                        </button>
                        <button type="button" class="cp-select-option" data-value="important" data-label="중요 일정" data-tone="important">
                            <span class="cp-select-option-badge"></span>
                            <span><strong>중요 일정</strong><em>마감, 회의, 필수 체크</em></span>
                        </button>
                        <button type="button" class="cp-select-option" data-value="sticker" data-label="스티커 / 기념일" data-tone="sticker">
                            <span class="cp-select-option-badge"></span>
                            <span><strong>스티커 / 기념일</strong><em>생일, 이벤트, 메모성 일정</em></span>
                        </button>
                    </div>
                </div>
            </div>
            <div class="cp-form-group cp-schedule-form mt-2">
                <div class="cp-allday-row cp-allday-inline">
                    <label class="cp-allday-label"><i class="ri-sun-line"></i> 종일</label>
                    <label class="cp-toggle">
                        <input type="checkbox" id="evAllDay">
                        <span class="cp-toggle-slider"></span>
                    </label>
                </div>
                <div class="cp-field">
                    <label class="cp-field-label">날짜</label>
                    <input type="text" class="cp-input cp-picker-input cp-date-input" id="evDate" readonly placeholder="날짜 선택">
                </div>
                <div class="cp-time-row" id="timeFieldsRow">
                    <div class="cp-field half">
                        <label class="cp-field-label">시작</label>
                        <input type="text" class="cp-input cp-picker-input cp-time-input" id="evStart" readonly placeholder="시작 시간">
                    </div>
                    <span class="cp-time-arrow"><i class="ri-arrow-right-line"></i></span>
                    <div class="cp-field half">
                        <label class="cp-field-label">종료</label>
                        <input type="text" class="cp-input cp-picker-input cp-time-input" id="evEnd" readonly placeholder="종료 시간">
                    </div>
                </div>
            </div>
            <div class="cp-field mt-2">
                <label class="cp-field-label"><i class="ri-sticky-note-line"></i> 메모</label>
                <textarea class="cp-textarea" id="evMemo" placeholder="메모 또는 설명 (선택 사항)"></textarea>
            </div>
        </div>
        <div class="cp-modal-footer">
            <div class="cp-modal-footer-left">
                <button class="cp-btn-danger hidden" id="evDeleteBtn"><i class="ri-delete-bin-line"></i> 삭제</button>
            </div>
            <button class="cp-btn-secondary" id="evCancelBtn">취소</button>
            <button class="cp-btn-primary" id="evSaveBtn">저장</button>
        </div>
    </div>
</div>

<div class="cp-confirm-overlay" id="confirmOverlay">
    <div class="cp-confirm-dialog">
        <div class="cp-confirm-icon"><i class="ri-delete-bin-6-line"></i></div>
        <div class="cp-confirm-title" id="confirmTitle">일정을 삭제할까요?</div>
        <div class="cp-confirm-desc" id="confirmDesc">삭제한 일정은 바로 목록에서 사라집니다.</div>
        <div class="cp-confirm-actions">
            <button type="button" class="cp-btn-secondary" id="confirmCancelBtn">취소</button>
            <button type="button" class="cp-btn-danger-solid" id="confirmOkBtn">삭제</button>
        </div>
    </div>
</div>

<div id="popoverContainer"></div>

<div class="cp-toast" id="cpToast">
    <i class="ri-checkbox-circle-fill"></i>
    <span id="cpToastMsg"></span>
</div>

<script src="${pageContext.request.contextPath}/dist/js/admin/calendar.js"></script>
<script>
window.CTX='${pageContext.request.contextPath}';
window.ADMIN_USER_IDX='${sessionScope.member.userIdx}';
(function(){
    var userIdx=window.ADMIN_USER_IDX||'default';
    var saved=localStorage.getItem('baton-admin-theme-'+userIdx)||localStorage.getItem('baton-admin-theme')||'purple';
    if(saved&&saved!=='purple') document.documentElement.setAttribute('data-theme',saved);
})();
(function(){
    var btn=document.getElementById('headerThemeBtn');
    var dropdown=document.getElementById('headerThemeDropdown');
    var preview=document.getElementById('headerThemePreview');
    var THEME_HEX={purple:'#7C3AED',blue:'#1D4ED8',emerald:'#059669',sunset:'#EA580C',rose:'#E11D48',slate:'#334155'};
    function syncPreview(){
        var t=document.documentElement.getAttribute('data-theme')||'purple';
        if(preview) preview.style.background=THEME_HEX[t]||THEME_HEX.purple;
    }
    syncPreview();
    if(btn&&dropdown){
        btn.addEventListener('click',function(e){
            e.stopPropagation();
            dropdown.classList.toggle('open');
            syncPreview();
        });
        document.addEventListener('click',function(e){
            if(!btn.contains(e.target)&&!dropdown.contains(e.target)) dropdown.classList.remove('open');
        });
    }
    window.syncHeaderThemePreview=syncPreview;
})();
</script>
</body>
</html>
