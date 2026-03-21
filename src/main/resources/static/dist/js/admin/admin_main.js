document.addEventListener("DOMContentLoaded", () => {

    const BASE = (typeof window.CTX !== 'undefined' ? window.CTX : '');

    const sidebarToggle = document.getElementById('sidebarToggle');
    const mainSidebar = document.querySelector('.agency-sidebar');
    if (sidebarToggle && mainSidebar) {
        sidebarToggle.addEventListener('click', () => {
            mainSidebar.classList.toggle('hidden');
            setTimeout(() => { if (window.dashChart) window.dashChart.resize(); }, 400);
        });
    }

    document.querySelectorAll('.nav-box.has-child > .nav-btn').forEach(header => {
        header.addEventListener('click', function(e) {
            e.preventDefault();
            const parentBox = this.parentElement;
            document.querySelectorAll('.nav-box.has-child').forEach(box => {
                if (box !== parentBox) box.classList.remove('open');
            });
            parentBox.classList.toggle('open');
        });
    });

    const triggerProfile = document.getElementById('profileTrigger');
    const modalProfile   = document.getElementById('profileModal');
    const triggerUtility = document.getElementById('systemUtilityTrigger');
    const modalUtility   = document.getElementById('systemUtilityModal');
    const triggerNoti    = document.getElementById('notiTrigger');
    const modalNoti      = document.getElementById('notiModal');

    function closeAllPopups() {
        [modalProfile, modalUtility, modalNoti].forEach(m => m && m.classList.remove('show'));
    }

    if (triggerProfile && modalProfile) {
        triggerProfile.addEventListener('click', e => {
            e.stopPropagation();
            const wasOpen = modalProfile.classList.contains('show');
            closeAllPopups();
            if (!wasOpen) modalProfile.classList.add('show');
        });
    }

    if (triggerUtility && modalUtility) {
        triggerUtility.addEventListener('click', e => {
            e.stopPropagation();
            const wasOpen = modalUtility.classList.contains('show');
            closeAllPopups();
            if (!wasOpen) { modalUtility.classList.add('show'); loadCalMonth(); }
        });
    }

    if (triggerNoti && modalNoti) {
        triggerNoti.addEventListener('click', e => {
            e.stopPropagation();
            const wasOpen = modalNoti.classList.contains('show');
            closeAllPopups();
            if (!wasOpen) modalNoti.classList.add('show');
        });
    }

    document.addEventListener('click', e => {
        const inModal   = [modalProfile, modalUtility, modalNoti].some(m => m && m.contains(e.target));
        const inTrigger = [triggerProfile, triggerUtility, triggerNoti].some(t => t && t.contains(e.target));
        if (!inModal && !inTrigger) closeAllPopups();
    });


    const NOTI_TYPE_MAP = {
        'CALENDAR':  { icon: 'ri-calendar-check-line',  bg: 'bg-purple' },
        'TODO':      { icon: 'ri-task-line',             bg: 'bg-purple' },
        'TODO_DONE': { icon: 'ri-checkbox-circle-line',  bg: 'bg-green'  },
        'REPORT':    { icon: 'ri-error-warning-fill',    bg: 'bg-orange' },
        'PAYMENT':   { icon: 'ri-refund-2-fill',         bg: 'bg-purple' },
        'MEMBER':    { icon: 'ri-user-add-fill',         bg: 'bg-green'  },
        'default':   { icon: 'ri-notification-3-fill',   bg: 'bg-blue'   }
    };
    function notiIcon(t) { return (NOTI_TYPE_MAP[t] || NOTI_TYPE_MAP['default']).icon; }
    function notiBg(t)   { return (NOTI_TYPE_MAP[t] || NOTI_TYPE_MAP['default']).bg; }

    function notiTimeAgo(createdAt) {
        if (!createdAt) return '';
        try {
            const d    = new Date(createdAt.replace(' ', 'T'));
            const diff = Math.floor((Date.now() - d.getTime()) / 1000);
            if (diff < 60)    return '방금 전';
            if (diff < 3600)  return Math.floor(diff / 60) + '분 전';
            if (diff < 86400) return Math.floor(diff / 3600) + '시간 전';
            return Math.floor(diff / 86400) + '일 전';
        } catch(e) { return ''; }
    }

    let notiList = [];

    function renderNotiModal() {
        const listEl = document.getElementById('notiList');
        if (!listEl) return;
        if (!notiList.length) {
            listEl.innerHTML = '<div style="padding:28px 20px;text-align:center;color:#CBD5E1;"><i class="ri-notification-off-line" style="font-size:28px;display:block;margin-bottom:8px;"></i><span style="font-size:13px;font-weight:600;">알림이 없습니다</span></div>';
            return;
        }
        listEl.innerHTML = notiList.map(n => {
            const unread = n.isRead === 0;
            return '<div class="noti-item' + (unread ? ' unread' : '') + '" data-nid="' + n.notifIdx + '">' +
                '<div class="noti-icon-wrap ' + notiBg(n.notifType) + '"><i class="' + notiIcon(n.notifType) + '"></i></div>' +
                '<div class="noti-content"><p class="noti-text">' + escHtml(n.content) + '</p>' +
                '<span class="noti-meta">' + notiTimeAgo(n.createdAt) + '</span></div>' +
                (unread ? '<div class="noti-dot"></div>' : '') + '</div>';
        }).join('');
        listEl.querySelectorAll('.noti-item[data-nid]').forEach(el => {
            el.addEventListener('click', () => {
                const item = notiList.find(n => String(n.notifIdx) === String(el.dataset.nid));
                if (item && item.isRead === 0) {
                    apiPost(BASE + '/admin/util/noti/read', { notifIdx: item.notifIdx })
                        .then(d => { if (d && d.success !== false) { item.isRead = 1; renderNotiModal(); updateNotiBadge(); } });
                }
            });
        });
    }

    function updateNotiBadge() {
        const count = notiList.filter(n => n.isRead === 0).length;
        const badge = document.getElementById('notiCountBadge');
        const ring  = document.getElementById('notiRing');
        const mc    = document.getElementById('notiModalCount');
        if (badge) { badge.textContent = count > 99 ? '99+' : count; badge.style.display = count > 0 ? 'flex' : 'none'; }
        if (ring)  { ring.style.display = count > 0 ? '' : 'none'; }
        if (mc)    { mc.textContent = count > 0 ? count : ''; mc.style.display = count > 0 ? '' : 'none'; }
    }

    function loadNotiList() {
        apiGet(BASE + '/admin/util/noti/list')
            .then(data => {
                notiList = Array.isArray(data) ? data : [];
                renderNotiModal();
                updateNotiBadge();
            }).catch(() => {});
    }

    function injectRealtimeNoti(n) {
        if (!notiList.find(x => x.notifIdx === n.notifIdx)) {
            notiList.unshift(n); renderNotiModal(); updateNotiBadge();
        }
    }

    const notiReadAllBtn = document.getElementById('notiReadAll');
    if (notiReadAllBtn) {
        notiReadAllBtn.addEventListener('click', e => {
            e.stopPropagation();
            apiPost(BASE + '/admin/util/noti/readAll', {})
                .then(() => { notiList.forEach(n => n.isRead = 1); renderNotiModal(); updateNotiBadge(); });
        });
    }

    loadNotiList();
    setInterval(loadNotiList, 60000);


    const setupOverlay     = document.getElementById('setupOverlay');
    const profileOverlay   = document.getElementById('profileOverlay');
    const setupTrigger     = document.getElementById('setupTrigger');
    const myProfileTrigger = document.getElementById('myProfileTrigger');
    const setupClose       = document.getElementById('setupClose');
    const profileFullClose = document.getElementById('profileFullClose');

    if (setupTrigger && setupOverlay) {
        setupTrigger.addEventListener('click', () => { closeAllPopups(); setupOverlay.classList.add('show'); });
    }
    if (myProfileTrigger && profileOverlay) {
        myProfileTrigger.addEventListener('click', () => { closeAllPopups(); profileOverlay.classList.add('show'); });
    }
    if (setupClose)       setupClose.addEventListener('click', () => setupOverlay.classList.remove('show'));
    if (profileFullClose) profileFullClose.addEventListener('click', () => profileOverlay.classList.remove('show'));

    [setupOverlay, profileOverlay].forEach(overlay => {
        if (!overlay) return;
        overlay.addEventListener('click', e => { if (e.target === overlay) overlay.classList.remove('show'); });
    });

    document.querySelectorAll('.fm-nav-item[data-tab]').forEach(btn => {
        btn.addEventListener('click', function() {
            const tab = this.dataset.tab;
            this.closest('.fm-sidebar').querySelectorAll('.fm-nav-item').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            this.closest('.fullscreen-modal').querySelectorAll('.fm-tab').forEach(t => t.classList.remove('active'));
            const target = document.getElementById('tab-' + tab);
            if (target) target.classList.add('active');
        });
    });

    document.querySelectorAll('.fm-nav-item[data-ptab]').forEach(btn => {
        btn.addEventListener('click', function() {
            const tab = this.dataset.ptab;
            this.closest('.fm-sidebar').querySelectorAll('.fm-nav-item').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            this.closest('.fullscreen-modal').querySelectorAll('.fm-tab').forEach(t => t.classList.remove('active'));
            const target = document.getElementById('ptab-' + tab);
            if (target) target.classList.add('active');
        });
    });


    function runClock() {
        const d = new Date();
        const headClock = document.getElementById('systemClock');
        if (headClock) headClock.innerText = d.toLocaleString('ko-KR', { month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit', hour12: false });
        const heroTime = document.getElementById('modalHeroTime');
        if (heroTime) heroTime.innerText = d.toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit', hour12: false });
        const heroDate = document.getElementById('modalHeroDate');
        if (heroDate) heroDate.innerText = d.toLocaleDateString('ko-KR', { month: 'long', day: 'numeric', weekday: 'long' });
    }
    setInterval(runClock, 1000);
    runClock();


    let calYear  = new Date().getFullYear();
    let calMonth = new Date().getMonth();
    const today  = new Date();
    const calMemos       = {};
    let   selectedCalKey = null;

    function calPad(n) { return String(n).padStart(2, '0'); }

    function loadCalMonth() {
        const ym = calYear + '-' + calPad(calMonth + 1);
        apiGet(BASE + '/admin/util/memo/month?yearMonth=' + ym)
            .then(list => {
                Object.keys(calMemos).forEach(k => { if (k.startsWith(ym)) delete calMemos[k]; });
                if (Array.isArray(list)) list.forEach(m => { calMemos[m.memoDate] = m.content; });
                renderCal();
                const badge = document.getElementById('calMemoBadge');
                if (badge) {
                    const cnt = Object.keys(calMemos).filter(k => k.startsWith(ym)).length;
                    badge.textContent = cnt > 0 ? '이번 달 ' + cnt + '개' : '';
                }
            }).catch(() => { renderCal(); });
    }

    function renderCal() {
        const cGrid = document.getElementById('miniCalGrid');
        if (!cGrid) return;
        const monthLabel = document.getElementById('modalMonth');
        if (monthLabel) monthLabel.innerText = new Date(calYear, calMonth).toLocaleString('ko-KR', { year: 'numeric', month: 'long' });
        const tDays      = new Date(calYear, calMonth + 1, 0).getDate();
        const sDay       = new Date(calYear, calMonth, 1).getDay();
        const isCurMonth = calYear === today.getFullYear() && calMonth === today.getMonth();
        let h = '';
        ['일','월','화','수','목','금','토'].forEach(dy => h += '<div class="c-wk">' + dy + '</div>');
        for (let i = 0; i < sDay; i++) h += '<div></div>';
        for (let i = 1; i <= tDays; i++) {
            const key     = calYear + '-' + calPad(calMonth + 1) + '-' + calPad(i);
            const cls     = (isCurMonth && i === today.getDate() ? ' on' : '') +
                            (calMemos[key] ? ' has-memo' : '') +
                            (key === selectedCalKey ? ' selected' : '');
            h += '<div class="c-dt' + cls + '" data-key="' + key + '">' + i + '</div>';
        }
        cGrid.innerHTML = h;
        cGrid.querySelectorAll('.c-dt[data-key]').forEach(cell => {
            cell.addEventListener('click', e => { e.stopPropagation(); selectCalDate(cell.dataset.key); });
        });
    }

    function selectCalDate(key) {
        selectedCalKey = key;
        const panel = document.getElementById('calMemoPanel');
        const label = document.getElementById('calMemoDateLabel');
        const input = document.getElementById('calMemoInput');
        if (!panel || !label || !input) return;
        const p = key.split('-');
        label.textContent = p[0] + '년 ' + p[1] + '월 ' + p[2] + '일';
        input.value = calMemos[key] || '';
        updateCalMemoPreview(key, calMemos[key] || '');
        panel.classList.add('active');
        renderCal();
        setTimeout(() => input.focus(), 60);
    }

    function updateCalMemoPreview(key, val) {
        const preview = document.getElementById('calMemoPreview');
        if (!preview) return;
        if (val) {
            const count = Object.keys(calMemos).length;
            preview.innerHTML =
                '<div style="display:flex;align-items:center;gap:6px;margin-bottom:6px;">' +
                '<i class="ri-checkbox-circle-line" style="color:#7C3AED;font-size:13px;"></i>' +
                '<span style="font-size:11px;font-weight:700;color:#7C3AED;">저장됨</span>' +
                '<span style="font-size:11px;color:#CBD5E1;margin-left:auto;">이번 달 메모 ' + count + '개</span>' +
                '</div>' +
                '<p style="font-size:12px;color:#64748B;line-height:1.6;margin:0;white-space:pre-wrap;word-break:break-word;">' + todoEsc(val) + '</p>';
            preview.style.display = 'block';
        } else {
            preview.style.display = 'none';
        }
    }

    const calPrevBtn  = document.getElementById('calPrev');
    const calNextBtn  = document.getElementById('calNext');
    const calTodayBtn = document.getElementById('calToday');
    if (calPrevBtn)  calPrevBtn.addEventListener('click',  e => { e.stopPropagation(); calMonth--; if (calMonth < 0)  { calMonth = 11; calYear--; } loadCalMonth(); });
    if (calNextBtn)  calNextBtn.addEventListener('click',  e => { e.stopPropagation(); calMonth++; if (calMonth > 11) { calMonth = 0;  calYear++; } loadCalMonth(); });
    if (calTodayBtn) calTodayBtn.addEventListener('click', e => { e.stopPropagation(); calYear = today.getFullYear(); calMonth = today.getMonth(); loadCalMonth(); });

    const calMemoSaveBtn  = document.getElementById('calMemoSave');
    const calMemoClearBtn = document.getElementById('calMemoClear');
    const calMemoInputEl  = document.getElementById('calMemoInput');

    if (calMemoSaveBtn) {
        calMemoSaveBtn.addEventListener('click', e => {
            e.preventDefault();
            e.stopPropagation();
            if (!selectedCalKey) return;
            const val = (calMemoInputEl ? calMemoInputEl.value : '').trim();
            if (val) {
                const isNew = !calMemos[selectedCalKey];
                calMemoSaveBtn.disabled = true;
                calMemoSaveBtn.textContent = '저장 중...';
                apiPost(BASE + '/admin/util/memo/save', { date: selectedCalKey, content: val })
                    .then(d => {
                        calMemoSaveBtn.disabled = false;
                        calMemoSaveBtn.textContent = '저장';
                        if (d && d.success) {
                            calMemos[selectedCalKey] = val;
                            renderCal();
                            updateCalMemoPreview(selectedCalKey, val);
                            loadNotiList();
                            if (typeof showToast === 'function') {
                                showToast(isNew ? '메모가 등록되었습니다.' : '메모가 수정되었습니다.', 'success');
                            }
                        } else {
                            if (typeof showToast === 'function') showToast('저장에 실패했습니다.', 'error');
                        }
                    }).catch(() => {
                        calMemoSaveBtn.disabled = false;
                        calMemoSaveBtn.textContent = '저장';
                        if (typeof showToast === 'function') showToast('저장 중 오류가 발생했습니다.', 'error');
                    });
            } else {
                apiPost(BASE + '/admin/util/memo/delete', { date: selectedCalKey })
                    .then(() => {
                        delete calMemos[selectedCalKey];
                        const panel = document.getElementById('calMemoPanel');
                        if (panel) panel.classList.remove('active');
                        selectedCalKey = null;
                        renderCal();
                        if (typeof showToast === 'function') showToast('메모가 삭제되었습니다.', 'success');
                    }).catch(() => {
                        if (typeof showToast === 'function') showToast('삭제 중 오류가 발생했습니다.', 'error');
                    });
            }
        });
    }

    if (calMemoClearBtn) {
        calMemoClearBtn.addEventListener('click', e => {
            e.preventDefault();
            e.stopPropagation();
            if (calMemoInputEl) calMemoInputEl.value = '';
        });
    }

    if (calMemoInputEl) {
        calMemoInputEl.addEventListener('click', e => e.stopPropagation());
        calMemoInputEl.addEventListener('keydown', e => {
            if (e.key === 'Escape') {
                const panel = document.getElementById('calMemoPanel');
                if (panel) panel.classList.remove('active');
                selectedCalKey = null;
                renderCal();
            }
        });
    }


    function todoEsc(s) { return String(s || '').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }
    let todos = [];

    function loadTodoList() {
        apiGet(BASE + '/admin/util/todo/list')
            .then(data => {
                todos = Array.isArray(data) ? data : [];
                renderTodo();
            }).catch(() => { renderTodo(); });
    }

    function renderTodo() {
        const listEl  = document.getElementById('todoList');
        const countEl = document.getElementById('todoCount');
        if (!listEl) return;
        const remaining = todos.filter(t => t.isDone === 0).length;
        if (countEl) countEl.textContent = remaining + '건';
        if (!todos.length) {
            listEl.innerHTML = '<div style="padding:12px 0;text-align:center;color:#CBD5E1;font-size:12px;font-weight:600;">할 일이 없습니다 ✓</div>';
            return;
        }
        listEl.innerHTML = todos.map(t =>
            '<div class="todo-item' + (t.isDone === 1 ? ' done' : '') + '">' +
            '<div class="todo-check" data-tid="' + t.todoIdx + '"></div>' +
            '<span class="todo-text">' + todoEsc(t.content) + '</span>' +
            '<button type="button" class="todo-del" data-did="' + t.todoIdx + '"><i class="ri-close-line"></i></button></div>'
        ).join('');
        listEl.querySelectorAll('.todo-check[data-tid]').forEach(btn => {
            btn.addEventListener('click', e => {
                e.stopPropagation();
                const t = todos.find(x => String(x.todoIdx) === String(btn.dataset.tid));
                if (!t) return;
                const newDone = t.isDone === 0 ? 1 : 0;
                apiPost(BASE + '/admin/util/todo/toggle', { todoIdx: t.todoIdx, isDone: newDone, content: t.content })
                    .then(d => { if (d && d.success) { t.isDone = newDone; renderTodo(); loadNotiList(); } });
            });
        });
        listEl.querySelectorAll('.todo-del[data-did]').forEach(btn => {
            btn.addEventListener('click', e => {
                e.stopPropagation();
                apiPost(BASE + '/admin/util/todo/delete', { todoIdx: btn.dataset.did })
                    .then(d => { if (d && d.success) { todos = todos.filter(t => String(t.todoIdx) !== String(btn.dataset.did)); renderTodo(); } });
            });
        });
    }

    const todoAddBtnEl = document.getElementById('todoAddBtn');
    const todoInputEl  = document.getElementById('todoInput');

    function addTodo() {
        if (!todoInputEl) return;
        const text = todoInputEl.value.trim();
        if (!text) return;
        todoInputEl.value = '';
        apiPost(BASE + '/admin/util/todo/add', { content: text })
            .then(d => { if (d && d.success) { loadTodoList(); loadNotiList(); } });
    }
    if (todoAddBtnEl) todoAddBtnEl.addEventListener('click', e => { e.stopPropagation(); addTodo(); });
    if (todoInputEl) {
        todoInputEl.addEventListener('keydown', e => { if (e.key === 'Enter') { e.stopPropagation(); addTodo(); } });
        todoInputEl.addEventListener('click', e => e.stopPropagation());
    }

    loadTodoList();
    loadCalMonth();


    if (typeof SockJS !== 'undefined' && typeof Stomp !== 'undefined') {
        try {
            const sock   = new SockJS(BASE + '/ws/chat');
            const stompC = Stomp.over(sock);
            stompC.debug = null;
            stompC.connect({}, () => {
                apiGet(BASE + '/admin/util/noti/list').then(list => {
                    const adminIdx = Array.isArray(list) && list.length > 0 ? list[0].userIdx : null;
                    if (!adminIdx) return;
                    stompC.subscribe('/topic/alarms/' + adminIdx, msg => {
                        try { const n = JSON.parse(msg.body); if (n && n.notifIdx) injectRealtimeNoti(n); }
                        catch(e) {}
                    });
                }).catch(() => {});
            }, () => {});
        } catch(e) {}
    }


    function buildChartGradients(ctx2d) {
        const style = getComputedStyle(document.documentElement);
        const c1  = style.getPropertyValue('--chart-c1').trim()  || '#7C3AED';
        const c2  = style.getPropertyValue('--chart-c2').trim()  || '#EC4899';
        const bg1 = style.getPropertyValue('--chart-bg1').trim() || 'rgba(124,58,237,0.2)';
        const stroke = ctx2d.createLinearGradient(0, 0, 600, 0);
        stroke.addColorStop(0, c1);
        stroke.addColorStop(1, c2);
        const fill = ctx2d.createLinearGradient(0, 0, 0, 400);
        fill.addColorStop(0, bg1);
        fill.addColorStop(1, 'rgba(0,0,0,0)');
        return { stroke, fill, c1 };
    }

    const ctx = document.getElementById('gradientChart');
    if (ctx) {
        const ctx2d = ctx.getContext('2d');
        const g = buildChartGradients(ctx2d);
        window.dashChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['월', '화', '수', '목', '금', '토', '일'],
                datasets: [{
                    label: '매출', data: [32000, 45000, 38000, 52000, 48000, 65000, 58000],
                    borderColor: g.stroke, borderWidth: 4, backgroundColor: g.fill, fill: true,
                    pointBackgroundColor: '#FFFFFF', pointBorderColor: g.c1, pointBorderWidth: 3,
                    pointRadius: 6, pointHoverRadius: 8, tension: 0.5
                }]
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                interaction: { mode: 'index', intersect: false },
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        backgroundColor: '#0F172A', titleColor: '#94A3B8', bodyColor: '#FFFFFF',
                        bodyFont: { weight: '700', size: 14, family: 'Montserrat' },
                        padding: 16, cornerRadius: 12, displayColors: false,
                        callbacks: { label: c => '₩ ' + c.raw.toLocaleString() }
                    }
                },
                scales: {
                    x: { grid: { display: false }, border: { display: false }, ticks: { color: '#94A3B8', font: { family: 'Montserrat', size: 12, weight: '700' } } },
                    y: { grid: { color: '#EAECEF', borderDash: [6, 6], drawBorder: false }, border: { display: false }, ticks: { color: '#94A3B8', font: { family: 'Montserrat', size: 12, weight: '700' }, padding: 16, callback: v => (v / 10000) + 'M' } }
                }
            }
        });
    }

    document.querySelectorAll('.pill-tab').forEach(btn => {
        btn.addEventListener('click', function() {
            this.closest('.pill-tabs').querySelectorAll('.pill-tab').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
        });
    });


    (function() {
        var saved = localStorage.getItem('baton-admin-theme') || 'purple';
        applyTheme(saved);
        var activeCard = document.querySelector('.theme-card[data-theme="' + saved + '"]');
        if (activeCard) {
            document.querySelectorAll('.theme-card').forEach(function(c) { c.classList.remove('active'); });
            activeCard.classList.add('active');
        }
    })();

    document.querySelectorAll('.theme-card[data-theme]').forEach(function(card) {
        card.addEventListener('click', function() {
            document.querySelectorAll('.theme-card').forEach(function(c) { c.classList.remove('active'); });
            card.classList.add('active');
        });
    });

    var THEME_NAMES = {
        purple: '퍼플 (기본)', blue: '오션 블루', emerald: '에메랄드',
        sunset: '선셋', rose: '로즈', slate: '슬레이트'
    };

    var saveThemeBtn = document.getElementById('saveThemeBtn');
    if (saveThemeBtn) {
        saveThemeBtn.addEventListener('click', function() {
            var active = document.querySelector('.theme-card.active');
            if (!active) return;
            var theme = active.dataset.theme;
            var prevTheme = localStorage.getItem('baton-admin-theme') || 'purple';
            applyTheme(theme);
            localStorage.setItem('baton-admin-theme', theme);
            var name = THEME_NAMES[theme] || theme;
            if (typeof showToast === 'function') {
                if (theme === prevTheme) {
                    showToast('이미 적용된 테마입니다.', 'info');
                } else {
                    showToast('테마가 [' + name + ']으로 변경되었습니다.', 'success');
                }
            }
            saveThemeBtn.textContent = '✓ ' + name + ' 적용됨';
            saveThemeBtn.style.opacity = '0.8';
            setTimeout(function() {
                saveThemeBtn.textContent = '변경사항 저장';
                saveThemeBtn.style.opacity = '';
            }, 2000);
        });
    }

    function applyTheme(theme) {
        if (theme === 'purple') {
            document.documentElement.removeAttribute('data-theme');
        } else {
            document.documentElement.setAttribute('data-theme', theme);
        }
        if (window.dashChart) {
            const c = document.getElementById('gradientChart');
            if (c) {
                const g = buildChartGradients(c.getContext('2d'));
                window.dashChart.data.datasets[0].borderColor = g.stroke;
                window.dashChart.data.datasets[0].backgroundColor = g.fill;
                window.dashChart.data.datasets[0].pointBorderColor = g.c1;
                window.dashChart.update();
            }
        }
    }

    function escHtml(s) {
        return String(s || '').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
    }

    function apiGet(url) {
        return fetch(url, { credentials: 'same-origin' })
            .then(r => {
                if (!r.ok) throw new Error('HTTP ' + r.status);
                return r.json();
            });
    }

    function apiPost(url, body) {
        return fetch(url, {
            method: 'POST',
            credentials: 'same-origin',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(body)
        }).then(r => {
            if (!r.ok) throw new Error('HTTP ' + r.status);
            return r.json();
        });
    }
});