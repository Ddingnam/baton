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
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(10px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .noti-summary-bar { display:flex; align-items:center; gap:10px; }
        .noti-sum-pill {
            display:inline-flex; align-items:center; gap:5px;
            padding:4px 12px; border-radius:20px;
            font-size:12px; font-weight:700;
            border:1.5px solid var(--border-color);
            background:var(--card-bg); color:var(--text-sub);
        }
        .noti-sum-pill .sum-num {
            font-family:'Montserrat',sans-serif;
            font-size:13px; font-weight:900;
        }
        .noti-sum-pill.red { border-color:#FECACA; background:#FFF5F5; color:#DC2626; }
        .noti-sum-pill.red .sum-num { color:#DC2626; }

        .noti-filter-bar {
            display:flex; align-items:center; gap:6px;
            flex-wrap:wrap; padding:14px 0 2px;
        }
        .nfi-chip {
            display:inline-flex; align-items:center; gap:5px;
            padding:6px 13px; border-radius:20px;
            font-size:11px; font-weight:700; cursor:pointer;
            border:1.5px solid var(--border-color);
            color:var(--text-sub); background:var(--card-bg);
            transition:all 0.18s; white-space:nowrap;
        }
        .nfi-chip i { font-size:12px; }
        .nfi-chip:hover { border-color:var(--color-purple); color:var(--color-purple); transform:translateY(-1px); }
        .nfi-chip.active {
            background:var(--color-purple); color:#fff;
            border-color:var(--color-purple);
            box-shadow:0 4px 12px rgba(124,58,237,0.3);
        }
        .nfi-chip .chip-dot { width:5px; height:5px; border-radius:50%; background:currentColor; }
        .chip-count {
            padding:1px 6px; border-radius:10px; font-size:10px;
            background:var(--base-bg); color:var(--text-light);
            font-family:'Montserrat',sans-serif; font-weight:700;
        }
        .nfi-chip.active .chip-count { background:rgba(255,255,255,0.22); color:#fff; }

        .noti-list-wrap { display:flex; flex-direction:column; gap:6px; padding-top:8px; }

        /* ── CARD ── */
        .noti-card {
            display:flex; align-items:center; gap:14px;
            background:var(--card-bg);
            border:1.5px solid var(--border-color);
            border-radius:16px; padding:13px 16px;
            transition:all 0.2s; cursor:pointer;
            animation:fadeUp 0.22s ease both;
            position:relative; overflow:hidden;
        }
        .noti-card::before {
            content:''; position:absolute; left:0; top:0; bottom:0;
            width:3px; border-radius:16px 0 0 16px;
            background:transparent; transition:background 0.2s;
        }
        .noti-card.unread { background:rgba(124,58,237,0.03); border-color:rgba(124,58,237,0.2); }
        .noti-card.unread::before { background:var(--color-purple); }
        .noti-card:hover {
            transform:translateY(-2px);
            box-shadow:0 6px 20px rgba(0,0,0,0.07);
            border-color:rgba(124,58,237,0.3);
        }

        /* 그라디언트 아이콘 - CSS 변수로 테마 자동 연동 */
        .nc-icon {
            width:44px; height:44px; border-radius:13px;
            display:flex; align-items:center; justify-content:center;
            font-size:19px; color:#fff; flex-shrink:0;
        }
        .nc-icon.grad-1 { background:var(--grad-icon-1); box-shadow:0 4px 14px var(--shadow-icon); }
        .nc-icon.grad-2 { background:var(--grad-icon-2); box-shadow:0 4px 14px var(--shadow-icon); }
        .nc-icon.grad-3 { background:var(--grad-icon-3); box-shadow:0 4px 14px var(--shadow-icon); }
        .nc-icon.grad-4 { background:var(--grad-icon-4); box-shadow:0 4px 14px var(--shadow-icon); }

        .nc-body { flex:1; min-width:0; }
        .nc-top  { display:flex; align-items:center; gap:6px; margin-bottom:5px; }

        /* 뱃지: 테마 색상 통일 */
        .nc-badge {
            font-size:10px; font-weight:800; letter-spacing:0.04em;
            padding:2px 9px; border-radius:20px;
            background:var(--color-purple-light); color:var(--color-purple);
        }

        /* NEW 뱃지 */
        .nc-new {
            font-size:9px; font-weight:900; letter-spacing:0.06em;
            padding:2px 7px; border-radius:20px;
            background:var(--color-purple); color:#fff;
        }

        .nc-text {
            font-size:13px; font-weight:600; color:var(--text-main);
            line-height:1.5; margin-bottom:6px;
            white-space:nowrap; overflow:hidden; text-overflow:ellipsis;
        }
        .nc-meta {
            display:flex; align-items:center; gap:10px;
            font-size:11px; color:var(--text-light); font-weight:500;
        }
        .nc-meta i { font-size:11px; }

        .nc-link {
            display:inline-flex; align-items:center; gap:3px;
            font-size:11px; font-weight:700; color:var(--color-purple);
            padding:3px 10px; border-radius:20px;
            background:rgba(124,58,237,0.08);
            text-decoration:none; transition:all 0.15s;
        }
        .nc-link:hover { background:var(--color-purple); color:#fff; }
        .nc-link i { font-size:11px; }

        .nc-right {
            display:flex; flex-direction:column;
            align-items:center; justify-content:center;
            gap:8px; flex-shrink:0;
        }
        .nc-unread-dot {
            width:8px; height:8px; border-radius:50%;
            background:var(--color-purple);
            box-shadow:0 0 0 3px rgba(124,58,237,0.18);
        }
        .nc-del {
            width:28px; height:28px; border-radius:8px; border:none;
            background:none; color:var(--text-light); cursor:pointer;
            display:flex; align-items:center; justify-content:center;
            font-size:13px; transition:all 0.15s; opacity:0;
        }
        .noti-card:hover .nc-del { opacity:1; }
        .nc-del:hover { background:#FEF2F2; color:#EF4444; }

        .noti-empty { padding:80px 20px; text-align:center; color:var(--text-light); }
        .noti-empty-icon { font-size:42px; display:block; margin-bottom:14px; opacity:0.25; }
        .noti-empty-title { font-size:15px; font-weight:700; color:var(--text-sub); margin-bottom:6px; }
        .noti-empty-sub { font-size:13px; }
        .noti-loading { padding:80px 20px; text-align:center; color:var(--text-light); }
        .noti-loading i { font-size:28px; display:block; margin-bottom:10px; animation:spin 1s linear infinite; }
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
                            <div class="noti-sum-pill">
                                <span class="sum-num" id="summaryTotal">—</span>
                                <span>전체</span>
                            </div>
                            <div class="noti-sum-pill red">
                                <span class="sum-num" id="summaryUnread">—</span>
                                <span>미읽음</span>
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

            <div>
                <div class="block-card" style="padding:12px 24px 18px;">
                    <div class="noti-filter-bar" id="filterBar">
                        <button class="nfi-chip active" data-type=""><i class="ri-list-check-2"></i> 전체 <span class="chip-count" id="cnt-all">0</span></button>
                        <button class="nfi-chip" data-type="REPORT"><i class="ri-error-warning-line"></i> 신고 <span class="chip-count" id="cnt-REPORT">0</span></button>
                        <button class="nfi-chip" data-type="INQUIRY"><i class="ri-question-answer-line"></i> 문의 <span class="chip-count" id="cnt-INQUIRY">0</span></button>
                        <button class="nfi-chip" data-type="PAYMENT"><i class="ri-coin-line"></i> 결제 <span class="chip-count" id="cnt-PAYMENT">0</span></button>
                        <button class="nfi-chip" data-type="REFUND"><i class="ri-refund-2-line"></i> 환불 <span class="chip-count" id="cnt-REFUND">0</span></button>
                        <button class="nfi-chip" data-type="CHAT"><i class="ri-chat-3-line"></i> 채팅 <span class="chip-count" id="cnt-CHAT">0</span></button>
                        <button class="nfi-chip" data-type="MEMBER"><i class="ri-user-add-line"></i> 회원 <span class="chip-count" id="cnt-MEMBER">0</span></button>
                        <button class="nfi-chip" data-type="CALENDAR"><i class="ri-calendar-check-line"></i> 캘린더 <span class="chip-count" id="cnt-CALENDAR">0</span></button>
                        <button class="nfi-chip" data-type="TODO"><i class="ri-task-line"></i> 할 일 <span class="chip-count" id="cnt-TODO">0</span></button>
                        <button class="nfi-chip" data-type="SYSTEM"><i class="ri-shield-flash-line"></i> 시스템 <span class="chip-count" id="cnt-SYSTEM">0</span></button>
                        <button class="nfi-chip" data-type="unread"><span class="chip-dot"></span> 미읽음만 <span class="chip-count" id="cnt-unread">0</span></button>
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
        'REPORT':    { grad:'grad-2', icon:'ri-error-warning-fill',   label:'신고',   badgeCls:'' },
        'PAYMENT':   { grad:'grad-3', icon:'ri-coin-fill',            label:'결제',   badgeCls:'' },
        'REFUND':    { grad:'grad-1', icon:'ri-refund-2-fill',        label:'환불',   badgeCls:'' },
        'INQUIRY':   { grad:'grad-4', icon:'ri-question-answer-fill', label:'문의',   badgeCls:'' },
        'MEMBER':    { grad:'grad-4', icon:'ri-user-add-fill',        label:'회원',   badgeCls:'' },
        'CHAT':      { grad:'grad-3', icon:'ri-chat-3-fill',          label:'채팅',   badgeCls:'' },
        'CALENDAR':  { grad:'grad-1', icon:'ri-calendar-check-fill',  label:'캘린더', badgeCls:'' },
        'TODO':      { grad:'grad-2', icon:'ri-task-fill',            label:'할 일',  badgeCls:'' },
        'TODO_DONE': { grad:'grad-4', icon:'ri-checkbox-circle-fill', label:'완료',   badgeCls:'' },
        'SYSTEM':    { grad:'grad-3', icon:'ri-shield-flash-fill',    label:'시스템', badgeCls:'' },
        'default':   { grad:'grad-1', icon:'ri-notification-3-fill',  label:'알림',   badgeCls:'' }
    };

    function getInfo(t) { return TYPE_MAP[t] || TYPE_MAP['default']; }

    function timeAgo(s) {
        if (!s) return '';
        try {
            var d = new Date(s.replace(' ', 'T'));
            var diff = Math.floor((Date.now() - d.getTime()) / 1000);
            if (diff < 60)     return '방금 전';
            if (diff < 3600)   return Math.floor(diff / 60) + '분 전';
            if (diff < 86400)  return Math.floor(diff / 3600) + '시간 전';
            if (diff < 604800) return Math.floor(diff / 86400) + '일 전';
            return Math.floor(diff / 604800) + '주 전';
        } catch(e) { return s; }
    }

    function esc(s) {
        return String(s || '').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
    }

    function updateCounts() {
        var total  = allNotis.length;
        var unread = allNotis.filter(function(n) { return n.isRead === 0; }).length;
        document.getElementById('summaryTotal').textContent  = total;
        document.getElementById('summaryUnread').textContent = unread;
        var el;
        el = document.getElementById('cnt-all');    if (el) el.textContent = total;
        el = document.getElementById('cnt-unread'); if (el) el.textContent = unread;
        ['REPORT','INQUIRY','PAYMENT','REFUND','CHAT','MEMBER','CALENDAR','TODO','SYSTEM'].forEach(function(t) {
            el = document.getElementById('cnt-' + t);
            if (el) el.textContent = allNotis.filter(function(n) { return n.notifType === t; }).length;
        });
    }

    function cardHTML(n, idx) {
        var info = getInfo(n.notifType);
        var ur   = n.isRead === 0;
        var bc   = 'nc-badge' + (info.badgeCls ? ' ' + info.badgeCls : '');
        var link = n.url
            ? '<a href="' + esc(n.url) + '" class="nc-link" onclick="event.stopPropagation()">'
              + '<i class="ri-arrow-right-up-line"></i>바로가기</a>'
            : '';
        return '<div class="noti-card' + (ur ? ' unread' : '') + '" data-nid="' + n.notifIdx
            + '" style="animation-delay:' + (idx * 0.025) + 's">'
            + '<div class="nc-icon ' + info.grad + '"><i class="' + info.icon + '"></i></div>'
            + '<div class="nc-body">'
            +   '<div class="nc-top"><span class="' + bc + '">' + info.label + '</span>'
            +   (ur ? '<span class="nc-new">NEW</span>' : '') + '</div>'
            +   '<p class="nc-text">' + esc(n.content) + '</p>'
            +   '<div class="nc-meta"><span><i class="ri-time-line"></i> ' + timeAgo(n.createdAt) + '</span>' + link + '</div>'
            + '</div>'
            + '<div class="nc-right">'
            +   (ur ? '<div class="nc-unread-dot"></div>' : '<div style="width:8px;"></div>')
            +   '<button type="button" class="nc-del" data-did="' + n.notifIdx + '" title="삭제"><i class="ri-delete-bin-line"></i></button>'
            + '</div></div>';
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
            container.innerHTML = '<div class="noti-empty">'
                + '<i class="ri-notification-off-line noti-empty-icon"></i>'
                + '<p class="noti-empty-title">알림이 없습니다</p>'
                + '<span class="noti-empty-sub">' + (currentType ? '해당 유형의 알림이 없어요' : '새로운 알림이 없어요') + '</span></div>';
            return;
        }

        container.innerHTML = list.map(cardHTML).join('');

        container.querySelectorAll('.noti-card[data-nid]').forEach(function(el) {
            el.addEventListener('click', function(e) {
                if (e.target.closest('.nc-del') || e.target.closest('.nc-link')) return;
                var n = allNotis.find(function(x) { return String(x.notifIdx) === String(el.dataset.nid); });
                var doNav = function() { if (n && n.url) window.location.href = n.url; };
                if (n && n.isRead === 0) {
                    fetch(BASE + '/admin/util/noti/read', {
                        method:'POST', credentials:'same-origin',
                        headers:{'Content-Type':'application/json'},
                        body: JSON.stringify({ notifIdx: n.notifIdx })
                    }).then(function() {
                        n.isRead = 1;
                        el.classList.remove('unread');
                        var dot = el.querySelector('.nc-unread-dot'); if (dot) dot.remove();
                        var badge = el.querySelector('.nc-new');      if (badge) badge.remove();
                        updateCounts();
                        doNav();
                    }).catch(doNav);
                } else { doNav(); }
            });
        });

        container.querySelectorAll('.nc-del[data-did]').forEach(function(btn) {
            btn.addEventListener('click', function(e) {
                e.stopPropagation();
                var id = btn.dataset.did;
                var card = btn.closest('.noti-card');
                if (card) { card.style.opacity = '0.35'; card.style.pointerEvents = 'none'; }
                fetch(BASE + '/admin/notifications/delete', {
                    method:'POST', credentials:'same-origin',
                    headers:{'Content-Type':'application/json'},
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
        fetch(BASE + '/admin/util/noti/list', { credentials:'same-origin' })
            .then(function(r) { return r.json(); })
            .then(function(data) { allNotis = Array.isArray(data) ? data : []; renderList(); })
            .catch(function() {
                document.getElementById('notiFullList').innerHTML =
                    '<div class="noti-empty"><i class="ri-error-warning-line noti-empty-icon" style="color:#EF4444;opacity:1;"></i>'
                    + '<p class="noti-empty-title" style="color:#EF4444;">불러오기에 실패했습니다</p>'
                    + '<span class="noti-empty-sub">잠시 후 다시 시도해주세요</span></div>';
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
            fetch(BASE + '/admin/util/noti/readAll', { method:'POST', credentials:'same-origin' })
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
            fetch(BASE + '/admin/notifications/deleteAll', { method:'POST', credentials:'same-origin' })
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
