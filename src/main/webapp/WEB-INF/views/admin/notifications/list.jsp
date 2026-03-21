<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>BATON Studio · 알림 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@500;700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_member.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_ui.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_report.css">
    <style>
        @keyframes spin { to { transform: rotate(360deg); } }
        @keyframes fadeSlideIn {
            from { opacity: 0; transform: translateY(8px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .noti-summary-bar {
            display: flex; align-items: center; gap: 24px;
            padding: 0 0 4px;
        }
        .noti-summary-item { display: flex; align-items: baseline; gap: 6px; }
        .noti-summary-num {
            font-family: 'Montserrat', sans-serif;
            font-size: 22px; font-weight: 900; color: var(--text-main);
        }
        .noti-summary-num.red { color: #EF4444; }
        .noti-summary-label { font-size: 13px; font-weight: 600; color: var(--text-light); }
        .noti-summary-divider { width: 1px; height: 24px; background: var(--border-color); }

        .noti-filter-bar {
            display: flex; align-items: center; gap: 8px;
            flex-wrap: wrap; padding: 16px 0 4px;
        }
        .nfi-chip {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 8px 16px; border-radius: var(--radius-pill);
            font-size: 12px; font-weight: 700; cursor: pointer;
            border: 1.5px solid var(--border-color);
            color: var(--text-sub); background: var(--card-bg);
            transition: all 0.2s; white-space: nowrap;
        }
        .nfi-chip:hover { border-color: var(--color-purple); color: var(--color-purple); transform: translateY(-1px); }
        .nfi-chip.active {
            background: var(--color-purple); color: #fff;
            border-color: var(--color-purple);
            box-shadow: 0 4px 12px rgba(124,58,237,0.28);
        }
        .nfi-chip .chip-dot { width: 6px; height: 6px; border-radius: 50%; background: currentColor; }
        .chip-count {
            padding: 1px 7px; border-radius: 20px; font-size: 10px;
            background: var(--base-bg); color: var(--text-light);
        }
        .nfi-chip.active .chip-count { background: rgba(255,255,255,0.25); color: #fff; }

        .noti-list-wrap {
            display: flex; flex-direction: column; gap: 8px; padding-top: 8px;
        }

        .noti-card {
            display: flex; align-items: flex-start; gap: 16px;
            background: var(--card-bg);
            border: 1.5px solid var(--border-color);
            border-radius: 16px; padding: 18px 20px 16px;
            transition: all 0.2s; cursor: pointer;
            animation: fadeSlideIn 0.22s ease both;
            position: relative; overflow: hidden;
        }
        .noti-card::before {
            content: ''; position: absolute; left: 0; top: 0; bottom: 0;
            width: 3px; background: transparent; border-radius: 16px 0 0 16px;
        }
        .noti-card.unread {
            background: rgba(124,58,237,0.025);
            border-color: rgba(124,58,237,0.16);
        }
        .noti-card.unread::before { background: var(--color-purple); }
        .noti-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.07);
            border-color: rgba(124,58,237,0.3);
        }

        .noti-card-icon {
            width: 44px; height: 44px; border-radius: 14px; flex-shrink: 0;
            display: flex; align-items: center; justify-content: center;
            font-size: 18px; color: white; margin-top: 1px;
        }
        .noti-card-body { flex: 1; min-width: 0; }

        .noti-card-tags {
            display: flex; align-items: center; gap: 6px; margin-bottom: 8px;
        }
        .noti-tag {
            display: inline-flex; align-items: center;
            padding: 3px 10px; border-radius: 20px;
            font-size: 10px; font-weight: 800; letter-spacing: 0.02em;
        }
        .noti-tag-new {
            background: var(--color-purple-light); color: var(--color-purple);
        }

        .noti-card-text {
            font-size: 14px; font-weight: 600; color: var(--text-main);
            line-height: 1.6; margin-bottom: 10px; word-break: break-word;
        }
        .noti-card-meta {
            display: flex; align-items: center; gap: 12px;
            font-size: 12px; color: var(--text-light); font-weight: 500;
        }
        .noti-card-meta-time { display: flex; align-items: center; gap: 4px; }
        .noti-goto-link {
            display: inline-flex; align-items: center; gap: 4px;
            color: var(--color-purple); font-size: 12px; font-weight: 700;
            padding: 4px 12px; border-radius: 20px;
            background: var(--color-purple-light);
            transition: all 0.15s; text-decoration: none;
        }
        .noti-goto-link:hover { background: var(--color-purple); color: #fff; }

        .noti-card-right {
            display: flex; flex-direction: column;
            align-items: flex-end; justify-content: space-between;
            gap: 12px; flex-shrink: 0; align-self: stretch;
        }
        .noti-unread-dot {
            width: 9px; height: 9px; border-radius: 50%;
            background: var(--color-purple);
            box-shadow: 0 0 0 3px rgba(124,58,237,0.15);
            margin-top: 2px;
        }
        .noti-del-btn {
            width: 30px; height: 30px; border-radius: 9px; border: none;
            background: none; color: var(--text-light); cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            font-size: 14px; transition: all 0.15s; opacity: 0;
        }
        .noti-card:hover .noti-del-btn { opacity: 1; }
        .noti-del-btn:hover { background: #FEF2F2; color: #EF4444; }

        .noti-empty {
            padding: 80px 20px; text-align: center;
            color: var(--text-light);
        }
        .noti-empty-icon {
            font-size: 44px; display: block; margin-bottom: 14px; opacity: 0.3;
        }
        .noti-empty-title { font-size: 15px; font-weight: 700; color: var(--text-sub); margin-bottom: 6px; }
        .noti-empty-sub { font-size: 13px; }

        .noti-loading { padding: 80px 20px; text-align: center; color: var(--text-light); }
        .noti-loading i { font-size: 28px; display: block; margin-bottom: 10px; animation: spin 1s linear infinite; }
    </style>
</head>
<body>
<div class="agency-layout">
    <jsp:include page="/WEB-INF/views/admin/layout/left.jsp"/>
    <main class="agency-main">
        <jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>
        <div class="agency-scroll-area">

            <div class="hero-header">
                <div class="hero-titles">
                    <div style="display:flex;align-items:center;gap:12px;margin-bottom:6px;">
                        <h1 class="hero-title" style="margin-bottom:0;">Notifications</h1>
                        <div class="noti-summary-bar">
                            <div class="noti-summary-item">
                                <span class="noti-summary-num" id="summaryTotal">—</span>
                                <span class="noti-summary-label">전체</span>
                            </div>
                            <div class="noti-summary-divider"></div>
                            <div class="noti-summary-item">
                                <span class="noti-summary-num red" id="summaryUnread">—</span>
                                <span class="noti-summary-label">미읽음</span>
                            </div>
                        </div>
                    </div>
                    <p class="hero-subtitle">관리자 알림 내역을 확인하고 관리합니다.</p>
                </div>
                <div class="hero-actions">
                    <button class="btn-pill btn-light" id="readAllBtn">
                        <i class="ri-check-double-line"></i> 모두 읽음
                    </button>
                    <button class="btn-pill" style="background:#FEF2F2;color:#EF4444;border:1.5px solid #FEE2E2;" id="deleteAllBtn">
                        <i class="ri-delete-bin-line"></i> 전체 삭제
                    </button>
                </div>
            </div>

            <div style="padding: 0 0 0 0;">
                <div class="block-card" style="padding: 16px 24px 20px;">
                    <div class="noti-filter-bar" id="filterBar">
                        <button class="nfi-chip active" data-type="">
                            <i class="ri-list-check-2"></i> 전체
                            <span class="chip-count" id="cnt-all">0</span>
                        </button>
                        <button class="nfi-chip" data-type="REPORT">
                            <i class="ri-error-warning-line"></i> 신고
                            <span class="chip-count" id="cnt-REPORT">0</span>
                        </button>
                        <button class="nfi-chip" data-type="PAYMENT">
                            <i class="ri-coin-line"></i> 결제/충전
                            <span class="chip-count" id="cnt-PAYMENT">0</span>
                        </button>
                        <button class="nfi-chip" data-type="REFUND">
                            <i class="ri-refund-2-line"></i> 환불
                            <span class="chip-count" id="cnt-REFUND">0</span>
                        </button>
                        <button class="nfi-chip" data-type="CALENDAR">
                            <i class="ri-calendar-check-line"></i> 캘린더
                            <span class="chip-count" id="cnt-CALENDAR">0</span>
                        </button>
                        <button class="nfi-chip" data-type="TODO">
                            <i class="ri-task-line"></i> 할 일
                            <span class="chip-count" id="cnt-TODO">0</span>
                        </button>
                        <button class="nfi-chip" data-type="unread">
                            <span class="chip-dot"></span> 미읽음만
                            <span class="chip-count" id="cnt-unread">0</span>
                        </button>
                    </div>
                </div>
            </div>

            <div class="noti-list-wrap" id="notiFullList">
                <div class="noti-loading">
                    <i class="ri-loader-4-line"></i>
                    <span style="font-size:13px;font-weight:600;">불러오는 중...</span>
                </div>
            </div>

        </div>
    </main>
</div>

<script>var CTX = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/dist/js/admin/admin_main.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/admin/admin_ui.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
<script>
(function() {
    var BASE = CTX || '';
    var currentType = '';
    var allNotis = [];

    var TYPE_MAP = {
        'REPORT':    { icon: 'ri-error-warning-fill',   bg: 'bg-orange', label: '신고',    lb: '#FFF7ED', lc: '#F97316' },
        'PAYMENT':   { icon: 'ri-coin-fill',            bg: 'bg-blue',   label: '결제',    lb: '#EFF6FF', lc: '#3B82F6' },
        'REFUND':    { icon: 'ri-refund-2-fill',        bg: 'bg-purple', label: '환불',    lb: '#F5F3FF', lc: '#7C3AED' },
        'CALENDAR':  { icon: 'ri-calendar-check-line',  bg: 'bg-purple', label: '캘린더',  lb: '#F5F3FF', lc: '#7C3AED' },
        'TODO':      { icon: 'ri-task-line',            bg: 'bg-purple', label: '할 일',   lb: '#F5F3FF', lc: '#7C3AED' },
        'TODO_DONE': { icon: 'ri-checkbox-circle-line', bg: 'bg-green',  label: '완료',    lb: '#F0FDF4', lc: '#10B981' },
        'default':   { icon: 'ri-notification-3-fill',  bg: 'bg-blue',   label: '알림',    lb: '#EFF6FF', lc: '#3B82F6' }
    };

    function getInfo(t) { return TYPE_MAP[t] || TYPE_MAP['default']; }

    function timeAgo(s) {
        if (!s) return '';
        try {
            var d = new Date(s.replace(' ', 'T'));
            var diff = Math.floor((Date.now() - d.getTime()) / 1000);
            if (diff < 60)    return '방금 전';
            if (diff < 3600)  return Math.floor(diff / 60) + '분 전';
            if (diff < 86400) return Math.floor(diff / 3600) + '시간 전';
            return Math.floor(diff / 86400) + '일 전';
        } catch(e) { return s; }
    }

    function esc(s) {
        return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
    }

    function updateCounts() {
        var total  = allNotis.length;
        var unread = allNotis.filter(function(n) { return n.isRead === 0; }).length;
        document.getElementById('summaryTotal').textContent  = total;
        document.getElementById('summaryUnread').textContent = unread;
        var cntAll = document.getElementById('cnt-all');
        if (cntAll) cntAll.textContent = total;
        var cntUr = document.getElementById('cnt-unread');
        if (cntUr) cntUr.textContent = unread;
        ['REPORT','PAYMENT','REFUND','CALENDAR','TODO'].forEach(function(t) {
            var el = document.getElementById('cnt-' + t);
            if (el) el.textContent = allNotis.filter(function(n) { return n.notifType === t; }).length;
        });
    }

    function renderList() {
        var list = allNotis.filter(function(n) {
            if (currentType === 'unread') return n.isRead === 0;
            if (currentType) return n.notifType === currentType;
            return true;
        });
        var container = document.getElementById('notiFullList');
        if (!container) return;
        updateCounts();

        if (!list.length) {
            container.innerHTML =
                '<div class="noti-empty">' +
                '<i class="ri-notification-off-line noti-empty-icon"></i>' +
                '<p class="noti-empty-title">알림이 없습니다</p>' +
                '<span class="noti-empty-sub">' + (currentType ? '해당 유형의 알림이 없어요' : '새로운 알림이 없어요') + '</span>' +
                '</div>';
            return;
        }

        container.innerHTML = list.map(function(n, idx) {
            var info = getInfo(n.notifType);
            var ur   = n.isRead === 0;
            return '<div class="noti-card' + (ur ? ' unread' : '') + '" data-nid="' + n.notifIdx + '" style="animation-delay:' + (idx * 0.03) + 's">' +
                '<div class="noti-card-icon ' + info.bg + '"><i class="' + info.icon + '"></i></div>' +
                '<div class="noti-card-body">' +
                '<div class="noti-card-tags">' +
                '<span class="noti-tag" style="background:' + info.lb + ';color:' + info.lc + ';">' + info.label + '</span>' +
                (ur ? '<span class="noti-tag noti-tag-new">NEW</span>' : '') +
                '</div>' +
                '<p class="noti-card-text">' + esc(n.content) + '</p>' +
                '<div class="noti-card-meta">' +
                '<span class="noti-card-meta-time"><i class="ri-time-line"></i> ' + timeAgo(n.createdAt) + '</span>' +
                (n.url ? '<a href="' + esc(n.url) + '" class="noti-goto-link" onclick="event.stopPropagation()"><i class="ri-arrow-right-up-line"></i>바로가기</a>' : '') +
                '</div></div>' +
                '<div class="noti-card-right">' +
                (ur ? '<div class="noti-unread-dot"></div>' : '<div></div>') +
                '<button type="button" class="noti-del-btn" data-did="' + n.notifIdx + '"><i class="ri-delete-bin-line"></i></button>' +
                '</div></div>';
        }).join('');

        container.querySelectorAll('.noti-card[data-nid]').forEach(function(el) {
            el.addEventListener('click', function(e) {
                if (e.target.closest('.noti-del-btn') || e.target.closest('.noti-goto-link')) return;
                var n = allNotis.find(function(x) { return String(x.notifIdx) === String(el.dataset.nid); });
                if (n && n.isRead === 0) {
                    fetch(BASE + '/admin/util/noti/read', {
                        method: 'POST', credentials: 'same-origin',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ notifIdx: n.notifIdx })
                    }).then(function() {
                        n.isRead = 1;
                        el.classList.remove('unread');
                        var dot = el.querySelector('.noti-unread-dot');
                        if (dot) dot.remove();
                        var newTag = el.querySelector('.noti-tag-new');
                        if (newTag) newTag.remove();
                        updateCounts();
                    });
                }
            });
        });

        container.querySelectorAll('.noti-del-btn[data-did]').forEach(function(btn) {
            btn.addEventListener('click', function(e) {
                e.stopPropagation();
                var id = btn.dataset.did;
                var card = btn.closest('.noti-card');
                if (card) { card.style.opacity = '0.4'; card.style.pointerEvents = 'none'; }
                fetch(BASE + '/admin/notifications/delete', {
                    method: 'POST', credentials: 'same-origin',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ notifIdx: id })
                }).then(function(r) { return r.json(); }).then(function(d) {
                    if (d && d.success) {
                        allNotis = allNotis.filter(function(n) { return String(n.notifIdx) !== String(id); });
                        renderList();
                        if (typeof showToast === 'function') showToast('알림이 삭제되었습니다.', 'success');
                    } else {
                        if (card) { card.style.opacity = ''; card.style.pointerEvents = ''; }
                    }
                });
            });
        });
    }

    function loadNotis() {
        fetch(BASE + '/admin/util/noti/list', { credentials: 'same-origin' })
            .then(function(r) { return r.json(); })
            .then(function(data) { allNotis = Array.isArray(data) ? data : []; renderList(); })
            .catch(function() {
                document.getElementById('notiFullList').innerHTML =
                    '<div class="noti-empty"><i class="ri-error-warning-line noti-empty-icon" style="color:#EF4444;opacity:1;"></i>' +
                    '<p class="noti-empty-title" style="color:#EF4444;">불러오기에 실패했습니다</p>' +
                    '<span class="noti-empty-sub">잠시 후 다시 시도해주세요</span></div>';
            });
    }

    document.querySelectorAll('.nfi-chip[data-type]').forEach(function(chip) {
        chip.addEventListener('click', function() {
            document.querySelectorAll('.nfi-chip').forEach(function(c) { c.classList.remove('active'); });
            chip.classList.add('active');
            currentType = chip.dataset.type;
            renderList();
        });
    });

    var readAllBtn = document.getElementById('readAllBtn');
    if (readAllBtn) {
        readAllBtn.addEventListener('click', function() {
            fetch(BASE + '/admin/util/noti/readAll', { method: 'POST', credentials: 'same-origin' })
                .then(function() {
                    allNotis.forEach(function(n) { n.isRead = 1; });
                    renderList();
                    if (typeof showToast === 'function') showToast('모든 알림을 읽음 처리했습니다.', 'success');
                });
        });
    }

    var deleteAllBtn = document.getElementById('deleteAllBtn');
    if (deleteAllBtn) {
        deleteAllBtn.addEventListener('click', function() {
            if (!confirm('전체 알림을 삭제하시겠습니까?')) return;
            fetch(BASE + '/admin/notifications/deleteAll', { method: 'POST', credentials: 'same-origin' })
                .then(function(r) { return r.json(); }).then(function(d) {
                    if (d && d.success) {
                        allNotis = [];
                        renderList();
                        if (typeof showToast === 'function') showToast('전체 알림이 삭제되었습니다.', 'success');
                    }
                });
        });
    }

    loadNotis();
})();
</script>
</body>
</html>
