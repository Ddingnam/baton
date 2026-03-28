<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>BATON Studio · 동네모임 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@500;700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_member.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_ui.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_crew.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_report.css">
</head>
<body>
<div class="agency-layout">
    <jsp:include page="/WEB-INF/views/admin/layout/left.jsp"/>
    <main class="agency-main">
        <jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>
        
        <div class="agency-scroll-area">
            <div class="hero-header">
                <div class="hero-titles">
                    <h1 class="hero-title">Crew Dashboard</h1>
                    <p class="hero-subtitle">총 <strong>${dataCount}</strong>개의 동네모임이 활발히 운영 중입니다.</p>
                </div>
            </div>

            <div class="member-toolbar block-card">
                <form class="toolbar-form" method="get" action="${pageContext.request.contextPath}/admin/crew/list">
                    <div class="status-tabs">
                        <a href="?joinType=all&schType=${schType}&kwd=${kwd}"
                           class="status-tab ${joinType == 'all' || empty joinType ? 'active' : ''}">전체</a>
                        <a href="?joinType=free&schType=${schType}&kwd=${kwd}"
                           class="status-tab ${joinType == 'free' ? 'active' : ''}">자유가입</a>
                        <a href="?joinType=approval&schType=${schType}&kwd=${kwd}"
                           class="status-tab ${joinType == 'approval' ? 'active' : ''}">승인가입</a>
                    </div>
                    <div class="search-group">
                        <input type="hidden" name="schType" id="crewSchTypeInput" value="${schType}">
                        <div class="adm-dropdown" id="crewSchType">
                            <button type="button" class="adm-dropdown-btn" onclick="admToggle('crewSchType')">
                                <span id="crewSchTypeLabel">통합검색</span>
                                <i class="ri-arrow-down-s-line adm-dropdown-arrow"></i>
                            </button>
                            <div class="adm-dropdown-menu">
                                <div class="adm-dropdown-item ${empty schType || schType == 'all' ? 'active' : ''}" data-value="all" onclick="admSelect(this,'crewSchType')">통합검색</div>
                                <div class="adm-dropdown-item ${schType == 'name' ? 'active' : ''}" data-value="name" onclick="admSelect(this,'crewSchType')">모임 이름</div>
                                <div class="adm-dropdown-item ${schType == 'hostNickname' ? 'active' : ''}" data-value="hostNickname" onclick="admSelect(this,'crewSchType')">호스트명</div>
                            </div>
                        </div>
                        <div class="search-input-wrap">
                            <i class="ri-search-2-line"></i>
                            <input type="text" name="kwd" class="fm-input"
                                   value="${kwd}" placeholder="모임 검색...">
                        </div>
                        <input type="hidden" name="joinType" value="${joinType}">
                        <button type="submit" class="btn-pill btn-gradient">검색</button>
                    </div>
                </form>
            </div>

            <div class="crew-grid">
                <c:forEach var="crew" items="${list}">
                    <c:set var="pct" value="${crew.maxMember > 0 ? (crew.currentMember * 100 / crew.maxMember) : 0}"/>
                    
                    <div class="crew-card">
                        <div class="crew-card-cover">
                            <c:if test="${not empty crew.logoImage}">
                                <img src="${pageContext.request.contextPath}/uploads/crew/${crew.logoImage}" alt="cover">
                            </c:if>
                            
                            <c:set var="cName" value="일반" />
                            <c:if test="${not empty crew.categories}">
                                <c:set var="cName" value="${not empty crew.categories[0].name ? crew.categories[0].name : (not empty crew.categories[0].categoryName ? crew.categories[0].categoryName : '일반')}" />
                            </c:if>
                            <span class="crew-badge" style="background: rgba(124,58,237,0.15); color: #6D28D9; border: 1px solid rgba(124,58,237,0.2); backdrop-filter: blur(4px);">${cName}</span>

                            <div class="crew-avatar-wrap">
                                <div class="crew-avatar">
                                    ${fn:substring(crew.name, 0, 1)}
                                </div>
                            </div>
                        </div>

                        <div class="crew-card-body">
                            <div class="crew-title" onclick="openCrewDetail(${crew.crewIdx}, '${fn:escapeXml(crew.name)}')" title="모임 상세 보기">
                                ${crew.name}
                            </div>
                            
                            <div class="crew-host">
                                <i class="ri-user-star-fill"></i>
                                <span>호스트 <strong>${empty crew.hostNickname ? '-' : crew.hostNickname}</strong></span>
                            </div>

                            <div class="crew-meta">
                                <span class="meta-chip"><i class="ri-door-open-line"></i> ${crew.joinType == 'free' ? '자유가입' : '승인가입'}</span>
                                <span class="meta-chip"><i class="ri-eye-line"></i> ${crew.viewCount}</span>
                            </div>

                            <div class="crew-progress">
                                <div class="progress-header">
                                    <span class="progress-label">멤버 모집율</span>
                                    <span class="progress-value">${crew.currentMember} / ${crew.maxMember}명</span>
                                </div>
                                <div class="progress-track">
                                    <div class="progress-fill" style="width: ${pct > 100 ? 100 : pct}%;"></div>
                                </div>
                            </div>
                        </div>

                        <div class="crew-card-footer">
                            <span class="date-text"><i class="ri-calendar-event-line"></i> ${fn:substring(crew.createdDate, 0, 10)} 개설</span>
                            <button type="button" class="btn-admin-action" onclick="openAdminPanel(${crew.crewIdx})">
                                <i class="ri-eye-line" style="font-size: 15px;"></i> 점검
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>
            
            <c:if test="${empty list}">
                <div class="block-card" style="text-align:center;padding:80px 0;color:var(--text-light); border-radius: 24px;">
                    <i class="ri-ghost-line" style="font-size:48px;display:block;margin-bottom:16px; color:#E2E8F0;"></i>
                    등록된 동네모임이 없습니다.
                </div>
            </c:if>

            <c:if test="${total_page > 1}">
                <div class="pagination">
                    <c:if test="${page > 1}">
                        <a href="?page=${page-1}&joinType=${joinType}&schType=${schType}&kwd=${kwd}" class="page-btn"><i class="ri-arrow-left-s-line"></i></a>
                    </c:if>
                    <c:forEach begin="1" end="${total_page}" var="p">
                        <a href="?page=${p}&joinType=${joinType}&schType=${schType}&kwd=${kwd}" class="page-btn ${p == page ? 'active' : ''}">${p}</a>
                    </c:forEach>
                    <c:if test="${page < total_page}">
                        <a href="?page=${page+1}&joinType=${joinType}&schType=${schType}&kwd=${kwd}" class="page-btn"><i class="ri-arrow-right-s-line"></i></a>
                    </c:if>
                </div>
            </c:if>
        </div>
    </main>
</div>

<div class="fullscreen-overlay" id="crewDetailOverlay">
    <div id="cwModalBox" style="background:#fff;border-radius:24px;width:660px;max-width:96vw;height:82vh;max-height:820px;min-height:480px;display:flex;flex-direction:column;overflow:hidden;box-shadow:0 32px 80px rgba(0,0,0,0.26);transform:translateY(20px) scale(0.97);transition:transform 0.35s cubic-bezier(0.16,1,0.3,1),opacity 0.35s;opacity:0;">
        
        <div style="background:linear-gradient(135deg,#1E1B4B 0%,#312E81 100%);padding:20px 24px 18px;flex-shrink:0;position:relative;overflow:hidden;">
            <div style="position:absolute;top:-30px;right:-30px;width:140px;height:140px;border-radius:50%;background:rgba(255,255,255,0.04);pointer-events:none;"></div>
            <div style="display:flex;align-items:flex-start;justify-content:space-between;gap:12px;position:relative;">
                <div style="display:flex;align-items:center;gap:12px;min-width:0;">
                    <div style="width:38px;height:38px;border-radius:12px;background:rgba(165,180,252,0.15);border:1px solid rgba(165,180,252,0.2);display:flex;align-items:center;justify-content:center;font-size:18px;color:#A5B4FC;flex-shrink:0;">
                        <i class="ri-team-line"></i>
                    </div>
                    <div style="min-width:0;">
                        <div style="font-size:9px;font-weight:700;letter-spacing:0.14em;color:rgba(255,255,255,0.3);margin-bottom:4px;">CREW DETAIL</div>
                        <div id="cwTitle" style="font-size:16px;font-weight:800;color:#fff;letter-spacing:-0.3px;line-height:1.3;word-break:break-word;"></div>
                    </div>
                </div>
                <button onclick="closeCrewDetail()" style="width:30px;height:30px;border-radius:8px;flex-shrink:0;background:rgba(255,255,255,0.08);border:1px solid rgba(255,255,255,0.1);display:flex;align-items:center;justify-content:center;font-size:16px;color:rgba(255,255,255,0.4);cursor:pointer;transition:all 0.15s;"><i class="ri-close-line"></i></button>
            </div>
            
            <div style="display:flex;align-items:center;gap:8px;margin-top:14px;flex-wrap:wrap;position:relative;">
                <div id="cwStatusChip"></div>
                <div id="cwJoinTypeChip"></div>
                <div style="margin-left:auto;display:flex;align-items:center;gap:10px;">
                    <span id="cwViewStat" style="display:flex;align-items:center;gap:4px;font-size:12px;color:rgba(255,255,255,0.45);"></span>
                </div>
            </div>
        </div>

        <div style="flex:1;overflow-y:auto;padding:0;" id="cwScrollBody">
            <div style="padding:16px 24px 14px;border-bottom:1px solid #F1F5F9;display:flex;align-items:center;gap:12px;">
                <div id="cwAvatar" style="width:40px;height:40px;border-radius:50%;background:linear-gradient(135deg,#7C3AED,#6D28D9);color:#fff;display:flex;align-items:center;justify-content:center;font-size:16px;font-weight:800;flex-shrink:0;box-shadow:0 4px 12px rgba(124,58,237,0.3);"></div>
                <div>
                    <div id="cwHostName" style="font-size:14px;font-weight:800;color:#1E293B;"></div>
                    <div id="cwHostSub" style="font-size:11px;color:#94A3B8;margin-top:1px;"></div>
                </div>
                <div id="cwMemberProgress" style="margin-left:auto; width:120px; text-align:right;"></div>
            </div>

            <div style="padding:20px 24px;border-bottom:1px solid #F1F5F9;">
                <div style="font-size:11px;font-weight:700;color:#94A3B8;text-transform:uppercase;letter-spacing:0.08em;margin-bottom:10px;display:flex;align-items:center;gap:5px;">
                    <i class="ri-file-text-line"></i>모임 소개 및 규칙
                </div>
                <div id="cwContent" style="font-size:14px;color:#334155;line-height:1.85;word-break:break-word;"></div>
            </div>

            <div style="padding:16px 24px 24px;">
                <div style="font-size:11px;font-weight:700;color:#94A3B8;text-transform:uppercase;letter-spacing:0.08em;margin-bottom:10px;display:flex;align-items:center;gap:5px;">
                    <i class="ri-article-line"></i>최근 활동 게시글
                </div>
                <div id="cwPostsWrap" style="display:flex;flex-direction:column;gap:8px;"></div>
            </div>
        </div>
        
        <div style="padding:12px 20px;border-top:1px solid #F1F5F9;display:flex;justify-content:flex-end;align-items:center;flex-shrink:0;background:#FAFAFA;">
            <button onclick="closeCrewDetail()" class="btn-pill btn-light">닫기</button>
        </div>
    </div>
</div>

<div class="fullscreen-overlay" id="crewAdminOverlay">
    <div class="rpt-modal" style="width:520px;">
        <div class="rpt-modal-header">
            <div class="rpt-header-left">
                <div class="rpt-header-icon"><i class="ri-settings-4-line"></i></div>
                <div>
                    <p class="rpt-header-eyebrow">CREW MANAGEMENT</p>
                    <p class="rpt-header-title" id="caTitle">모임 상태 점검</p>
                </div>
            </div>
            <button class="rpt-close-btn" onclick="closeAdminPanel()"><i class="ri-close-line"></i></button>
        </div>
        
        <div class="rpt-modal-body">
            <div class="rpt-info-list" id="caInfoList">
                <div style="text-align:center;padding:20px 0;"><i class="ri-loader-4-line ri-spin" style="font-size:24px;color:#94A3B8;"></i></div>
            </div>
            
            <div class="rpt-divider"></div>
            
            <div class="rpt-field">
                <p class="rpt-field-label">최근 활동 요약</p>
                <div class="rpt-field-box" id="caActivitySummary">-</div>
            </div>
        </div>
        
        <div class="rpt-modal-footer">
            <button class="rpt-btn-cancel" onclick="closeAdminPanel()">닫기</button>
            <div class="rpt-footer-actions">
                <button class="rpt-btn-reject" id="caDeleteBtn" style="gap: 6px;">
                    <i class="ri-delete-bin-line"></i> 강제 해산 (삭제)
                </button>
            </div>
        </div>
    </div>
</div>

<script>var CTX = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/dist/js/admin/admin_main.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/admin/admin_ui.js"></script>
<script>
function admToggle(id) {
    var dd = document.getElementById(id);
    var isOpen = dd.classList.contains('open');
    document.querySelectorAll('.adm-dropdown.open').forEach(function(d) { d.classList.remove('open'); });
    if (!isOpen) dd.classList.add('open');
}
function admSelect(el, ddId) {
    document.getElementById(ddId + 'Input').value = el.dataset.value;
    document.getElementById(ddId + 'Label').textContent = el.textContent.trim();
    document.querySelectorAll('#' + ddId + ' .adm-dropdown-item').forEach(function(i) { i.classList.remove('active'); });
    el.classList.add('active');
    document.getElementById(ddId).classList.remove('open');
}
document.addEventListener('DOMContentLoaded', function() {
    var map = { all: '통합검색', name: '모임 이름', hostNickname: '호스트명' };
    var inp = document.getElementById('crewSchTypeInput');
    if (inp && map[inp.value]) document.getElementById('crewSchTypeLabel').textContent = map[inp.value];
    document.addEventListener('click', function(e) {
        document.querySelectorAll('.adm-dropdown.open').forEach(function(dd) {
            if (!dd.contains(e.target)) dd.classList.remove('open');
        });
    });
});
</script>
<script>
    var CTX = '${pageContext.request.contextPath}';

    var cdOverlay = document.getElementById('crewDetailOverlay');
    var cdBox = document.getElementById('cwModalBox');

    function openCrewDetail(crewIdx, name) {
        document.getElementById('cwTitle').textContent = name || '불러오는 중...';
        document.getElementById('cwContent').innerHTML = '<div style="text-align:center;padding:20px 0;"><i class="ri-loader-4-line ri-spin" style="font-size:24px;color:#94A3B8;"></i></div>';
        
        cdOverlay.classList.add('show');
        requestAnimationFrame(() => {
            cdBox.style.opacity = '1';
            cdBox.style.transform = 'translateY(0) scale(1)';
        });
        fetch(CTX + '/admin/crew/detail?crewIdx=' + crewIdx)
            .then(r => r.json())
            .then(d => {
                if(!d.success) { document.getElementById('cwContent').textContent = '오류가 발생했습니다.'; return; }
                
                var crew = d.crew || {};
                var posts = d.recentPosts || [];

                document.getElementById('cwStatusChip').innerHTML = `<span style="padding:4px 10px;border-radius:20px;font-size:11px;font-weight:700;background:rgba(16,185,129,0.15);color:#10B981;border:1px solid rgba(16,185,129,0.3);"><i class="ri-checkbox-circle-line" style="margin-right:4px;"></i>활성</span>`;
                document.getElementById('cwJoinTypeChip').innerHTML = `<span style="padding:4px 10px;border-radius:20px;font-size:11px;font-weight:700;background:rgba(139,92,246,0.15);color:#A78BFA;border:1px solid rgba(139,92,246,0.3);"><i class="ri-door-open-line" style="margin-right:4px;"></i>\${crew.joinType === 'free' ? '자유가입' : '승인가입'}</span>`;
                document.getElementById('cwViewStat').innerHTML = `<i class="ri-eye-line"></i> \${crew.viewCount||0}`;

                var nick = crew.hostNickname || '익명';
                document.getElementById('cwAvatar').textContent = nick.charAt(0).toUpperCase();
                document.getElementById('cwHostName').textContent = nick + ' (호스트)';
                document.getElementById('cwHostSub').textContent = '생성일: ' + (crew.createdDate ? crew.createdDate.substring(0,10) : '-');

                var cur = crew.currentMember || 0;
                var max = crew.maxMember || 0;
                var pct = max > 0 ? Math.min(Math.round(cur * 100 / max), 100) : 0;
                document.getElementById('cwMemberProgress').innerHTML = `
                    <div style="font-size:11px;font-weight:700;color:#64748B;margin-bottom:4px;">\${cur} / \${max}명 (\${pct}%)</div>
                    <div style="height:6px;background:#E2E8F0;border-radius:3px;overflow:hidden;">
                        <div style="width:\${pct}%;height:100%;background:var(--color-purple);"></div>
                    </div>`;

                document.getElementById('cwContent').innerHTML = String(crew.description || '<span style="color:#94A3B8;">소개가 없습니다.</span>').replace(/\n/g, '<br>');

                if(posts.length === 0) {
                    document.getElementById('cwPostsWrap').innerHTML = '<div style="background:#F8FAFC;border:1px dashed #E2E8F0;padding:20px;text-align:center;border-radius:12px;color:#94A3B8;font-size:13px;">게시글이 없습니다.</div>';
                } else {
                    document.getElementById('cwPostsWrap').innerHTML = posts.map((p, i) => `
                        <div style="background:#fff;border:1px solid #E2E8F0;padding:12px 16px;border-radius:12px;display:flex;align-items:center;gap:12px;">
                            <div style="width:28px;height:28px;background:#F1F5F9;border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700;color:#64748B;flex-shrink:0;">\${i+1}</div>
                            <div style="flex:1;min-width:0;">
                                <div style="font-size:13px;font-weight:700;color:#1E293B;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">\${p.title}</div>
                                <div style="font-size:11px;color:#94A3B8;margin-top:4px;">\${p.writerNickname} · \${p.createdDate.substring(0,10)}</div>
                            </div>
                        </div>`).join('');
                }
            }).catch(() => { document.getElementById('cwContent').innerHTML = '통신 오류'; });
    }

    function closeCrewDetail() {
        cdBox.style.opacity = '0';
        cdBox.style.transform = 'translateY(20px) scale(0.97)';
        setTimeout(() => cdOverlay.classList.remove('show'), 300);
    }
    cdOverlay.addEventListener('click', e => { if (e.target === cdOverlay) closeCrewDetail(); });

    var caOverlay = document.getElementById('crewAdminOverlay');
    var currentCrewIdx = null;

    function openAdminPanel(crewIdx) {
        currentCrewIdx = crewIdx;
        caOverlay.classList.add('show');
        document.getElementById('caTitle').textContent = '정보 불러오는 중...';

        fetch(CTX + '/admin/crew/inspection?crewIdx=' + crewIdx)
            .then(r => r.json())
            .then(d => {
                if(!d.success) return;
                var crew = d.crew || {};
                
                document.getElementById('caTitle').textContent = crew.name;
                
                var rows = [
                    { label: '모임장', val: crew.hostNickname || '없음' },
                    { label: '가입방식', val: crew.joinType === 'free' ? '자유가입' : '승인가입' },
                    { label: '생성일자', val: crew.createdDate ? crew.createdDate.substring(0,10) : '-' },
                    { label: '멤버/게시글 수', val: `\${crew.currentMember||0}명 / \${d.postCount||0}건` }
                ];
                
                document.getElementById('caInfoList').innerHTML = rows.map((row, i) => `
                    \${i > 0 ? '<div style="height:1px;background:#F1F5F9;"></div>' : ''}
                    <div class="rpt-info-row">
                        <span class="rpt-info-key">\${row.label}</span>
                        <span class="rpt-info-val">\${row.val}</span>
                    </div>`).join('');

                document.getElementById('caActivitySummary').innerHTML = `
                    <div style="background:#F8FAFC;padding:12px 16px;border-radius:8px; display:flex; justify-content:space-between; align-items:center;">
                        <span style="font-size:13px;color:#64748B;font-weight:700;">모임 활동 참여율 지표</span>
                        <span style="font-size:15px;color:var(--color-purple);font-weight:800;">\${d.participationRate||0}%</span>
                    </div>`;
            });
    }

    function closeAdminPanel() { caOverlay.classList.remove('show'); }
    caOverlay.addEventListener('click', e => { if (e.target === caOverlay) closeAdminPanel(); });

    document.getElementById('caDeleteBtn').addEventListener('click', function() {
        if(!currentCrewIdx) return;
        if(confirm('해당 동네모임을 강제 해산(삭제)하시겠습니까? 관련 데이터가 모두 지워집니다.')) {
            fetch(CTX + '/admin/crew/delete', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({ crewIdx: currentCrewIdx })
            }).then(r => r.json()).then(d => {
                if(d.success) {
                    alert('정상적으로 해산되었습니다.');
                    location.reload();
                } else {
                    alert('삭제 실패: ' + d.msg);
                }
            });
        }
    });
</script>
</body>
</html>