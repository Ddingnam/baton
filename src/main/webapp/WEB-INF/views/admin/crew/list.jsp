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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_report.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_crew.css">
</head>
<body>
<div class="agency-layout">
    <jsp:include page="/WEB-INF/views/admin/layout/left.jsp"/>
    <main class="agency-main">
       
        <jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>
        <div class="agency-scroll-area">

            <div class="hero-header">
                <div class="hero-titles">
                    <h1 class="hero-title">Crew</h1>
                    <p class="hero-subtitle">총 <strong>${dataCount}</strong>개의 동네모임이 있습니다.</p>
                </div>
            </div>

            <div class="member-toolbar block-card">
                <form class="toolbar-form" method="get"
                      action="${pageContext.request.contextPath}/admin/crew/list">
                    <div class="status-tabs">
                        <a href="?joinType=all&kwd=${kwd}"
                           class="status-tab ${joinType == 'all' ? 'active' : ''}">전체</a>
                        <a href="?joinType=free&kwd=${kwd}"
                           class="status-tab ${joinType == 'free' ? 'active' : ''}">자유가입</a>
                        <a href="?joinType=approval&kwd=${kwd}"
                           class="status-tab ${joinType == 'approval' ? 'active' : ''}">승인가입</a>
                    </div>
                    <div class="search-group">
                        <div class="search-input-wrap">
                            <i class="ri-search-2-line"></i>
                            <input type="text" name="kwd" class="fm-input"
                                   value="${kwd}" placeholder="모임 이름 검색...">
                        </div>
                        <input type="hidden" name="joinType" value="${joinType}">
                        <button type="submit" class="btn-pill btn-gradient">검색</button>
                    </div>
                </form>
            </div>

            <c:if test="${empty list}">
                <div class="block-card" style="text-align:center;padding:60px 0;color:var(--text-sub);">
                    <i class="ri-team-line" style="font-size:36px;display:block;margin-bottom:10px;"></i>
                    모임이 없습니다.
                </div>
            </c:if>

            <div class="crew-grid">
                <c:forEach var="crew" items="${list}">
                    <c:set var="pct" value="${crew.maxMember > 0 ? (crew.currentMember * 100 / crew.maxMember) : 0}"/>
                    <div class="crew-card">
                        <div class="crew-card-banner">
                            <c:choose>
                                <c:when test="${not empty crew.logoImage}">
                                    <img class="crew-logo" src="${pageContext.request.contextPath}/uploads/crew/${crew.logoImage}" alt="${crew.name}" onerror="this.style.display='none'">
                                </c:when>
                                <c:otherwise>
                                    <div class="crew-logo-placeholder">${fn:substring(crew.name, 0, 1)}</div>
                                </c:otherwise>
                            </c:choose>
                            <c:choose>
                                <c:when test="${crew.status == 'active' || empty crew.status}">
                                    <span class="crew-status-badge active">활성</span>
                                </c:when>
                                <c:when test="${crew.status == 'inactive'}">
                                    <span class="crew-status-badge inactive">비활성</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="crew-status-badge pending">${crew.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="crew-card-body">
                            <div class="crew-name"
                                 onclick="openCrewDetail(${crew.crewIdx}, '${fn:escapeXml(crew.name)}')"
                                 title="${crew.name}">${crew.name}</div>
                                 
                            <div class="crew-host">
                                <i class="ri-user-star-line"></i>
                                <c:choose>
                                    <c:when test="${not empty crew.hostNickname}">${crew.hostNickname}</c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                                &nbsp;·&nbsp;
                                <c:choose>
                                    <c:when test="${crew.joinType == 'free'}">자유가입</c:when>
                                    <c:when test="${crew.joinType == 'approval'}">승인가입</c:when>
                                    <c:otherwise>${crew.joinType}</c:otherwise>
                                </c:choose>
                            </div>
                            
                            <div class="crew-meta-row">
                                <span class="crew-meta-chip">
                                    <i class="ri-eye-line"></i>${crew.viewCount}
                                </span>
                                <c:if test="${not empty crew.categories}">
                                    <c:forEach var="cat" items="${crew.categories}" begin="0" end="0">
                                        <span class="crew-meta-chip">
                                            <i class="ri-price-tag-3-line"></i>${cat.name}
                                        </span>
                                    </c:forEach>
                                </c:if>
                                <c:if test="${not empty crew.createdDate}">
                                    <span class="crew-meta-chip">
                                        <i class="ri-calendar-line"></i>${fn:substring(crew.createdDate, 0, 10)}
                                    </span>
                                </c:if>
                            </div>
                            
                            <div class="crew-progress-wrap">
                                <div class="crew-progress-label">
                                    <span>멤버 현황</span>
                                    <span style="color:var(--color-purple);font-weight:800;">
                                        ${crew.currentMember} / ${crew.maxMember}명
                                    </span>
                                </div>
                                <div class="crew-progress-bar">
                                    <div class="crew-progress-fill" style="width:${pct > 100 ? 100 : pct}%;"></div>
                                </div>
                            </div>
                        </div>

                        <div class="crew-card-actions">
                            <div style="flex:1;"></div> <button type="button" class="action-btn"
                                    onclick="openAdminPanel(${crew.crewIdx})"
                                    title="상세 점검"
                                    style="color:var(--color-primary);">
                                <i class="ri-settings-4-line"></i> 관리
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${total_page > 1}">
                <div class="pagination">
                    <c:if test="${page > 1}">
                        <a href="?page=${page-1}&joinType=${joinType}&kwd=${kwd}" class="page-btn">
                            <i class="ri-arrow-left-s-line"></i>
                        </a>
                    </c:if>
                    <c:forEach begin="1" end="${total_page}" var="p">
                        <a href="?page=${p}&joinType=${joinType}&kwd=${kwd}"
                           class="page-btn ${p == page ? 'active' : ''}">${p}</a>
                    </c:forEach>
                    <c:if test="${page < total_page}">
                        <a href="?page=${page+1}&joinType=${joinType}&kwd=${kwd}" class="page-btn">
                            <i class="ri-arrow-right-s-line"></i>
                        </a>
                    </c:if>
                </div>
            </c:if>

        </div>
    </main>
</div>

<div class="fullscreen-overlay" id="crewDetailOverlay">
    <div id="cwModalBox" style="
        background:#fff;border-radius:24px;width:660px;max-width:96vw;
        height:82vh;max-height:820px;min-height:480px;display:flex;flex-direction:column;overflow:hidden;
        box-shadow:0 32px 80px rgba(0,0,0,0.26);
        transform:translateY(20px) scale(0.97);
        transition:transform 0.35s cubic-bezier(0.16,1,0.3,1),opacity 0.35s;
        opacity:0;">

        <div id="cwHeader" style="
            background:linear-gradient(135deg,#1E1B4B 0%,#312E81 100%);
            padding:20px 24px 18px;flex-shrink:0;position:relative;overflow:hidden;">
            <div style="position:absolute;top:-30px;right:-30px;width:140px;height:140px;border-radius:50%;background:rgba(255,255,255,0.04);pointer-events:none;"></div>
            <div style="position:absolute;bottom:-50px;left:60px;width:200px;height:200px;border-radius:50%;background:rgba(255,255,255,0.03);pointer-events:none;"></div>
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
                <button id="cwClose" style="
                    width:30px;height:30px;border-radius:8px;flex-shrink:0;
                    background:rgba(255,255,255,0.08);border:1px solid rgba(255,255,255,0.1);
                    display:flex;align-items:center;justify-content:center;
                    font-size:16px;color:rgba(255,255,255,0.4);cursor:pointer;
                    transition:all 0.15s;"
                    onmouseover="this.style.background='rgba(239,68,68,0.25)';this.style.color='#FCA5A5';"
                    onmouseout="this.style.background='rgba(255,255,255,0.08)';this.style.color='rgba(255,255,255,0.4)';">
                    <i class="ri-close-line"></i>
                </button>
            </div>
            
            <div style="display:flex;align-items:center;gap:8px;margin-top:14px;flex-wrap:wrap;position:relative;">
                <div id="cwStatusChip"></div>
                <div id="cwJoinTypeChip"></div>
                <div style="margin-left:auto;display:flex;align-items:center;gap:10px;">
                    <span id="cwViewStat" style="display:flex;align-items:center;gap:4px;font-size:12px;color:rgba(255,255,255,0.45);"></span>
                    <span id="cwPostStat" style="display:flex;align-items:center;gap:4px;font-size:12px;color:rgba(255,255,255,0.45);"></span>
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
                    <i class="ri-file-text-line"></i>모임 소개
                </div>
                <div id="cwContent" style="font-size:14px;color:#334155;line-height:1.85;word-break:break-word;"></div>
            </div>

            <div style="padding:16px 24px 24px;">
                <div style="font-size:11px;font-weight:700;color:#94A3B8;text-transform:uppercase;letter-spacing:0.08em;margin-bottom:10px;display:flex;align-items:center;gap:5px;">
                    <i class="ri-article-line"></i>최근 게시글
                </div>
                <div id="cwPostsWrap" style="display:flex;flex-direction:column;gap:8px;"></div>
            </div>
        </div>

        <div style="padding:12px 20px;border-top:1px solid #F1F5F9;display:flex;justify-content:flex-end;align-items:center;flex-shrink:0;background:#FAFAFA;">
            <button id="cwCancel" style="
                display:inline-flex;align-items:center;gap:6px;
                padding:9px 20px;border-radius:10px;
                border:1.5px solid #E2E8F0;background:#fff;
                font-size:13px;font-weight:600;color:#64748B;
                cursor:pointer;font-family:inherit;transition:all 0.15s;"
                onmouseover="this.style.background='#F1F5F9';"
                onmouseout="this.style.background='#fff';">
                <i class="ri-close-line"></i>닫기
            </button>
        </div>
    </div>
</div>

<div class="fullscreen-overlay" id="crewAdminOverlay">
    <div class="rpt-modal" style="width:520px;">
        <div class="rpt-modal-header">
            <div class="rpt-header-left">
                <div class="rpt-header-icon"><i class="ri-settings-4-line"></i></div>
                <div>
                    <p class="rpt-header-eyebrow">CREW INSPECTION</p>
                    <p class="rpt-header-title" id="caTitle">모임 관리 점검</p>
                </div>
            </div>
            <button class="rpt-close-btn" id="caClose"
                onmouseover="this.style.background='rgba(239,68,68,0.22)';this.style.color='#FCA5A5';"
                onmouseout="this.style.background='rgba(255,255,255,0.07)';this.style.color='rgba(255,255,255,0.35)';">
                <i class="ri-close-line"></i>
            </button>
        </div>
        <div class="rpt-modal-body">
            <div class="rpt-info-list" id="caInfoList">
                <div style="padding:20px 0;text-align:center;color:#94A3B8;font-size:13px;">로딩 중...</div>
            </div>
            
            <div class="rpt-divider"></div>
            
            <div class="rpt-field">
                <p class="rpt-field-label">활동 요약 (참여율 등)</p>
                <div class="rpt-field-box" id="caActivitySummary">-</div>
            </div>
        </div>
        <div class="rpt-modal-footer">
            <button class="rpt-btn-cancel" id="caCancel">닫기</button>
            <div class="rpt-footer-actions">
                <button class="rpt-btn-reject" id="caDeleteBtn">
                    <i class="ri-delete-bin-line"></i> 모임 해산(삭제)
                </button>
            </div>
        </div>
    </div>
</div>

<div class="fullscreen-overlay" id="deleteOverlay">
    <div class="mini-modal">
        <div class="mini-modal-head">
            <span class="mini-modal-title"><i class="ri-delete-bin-line"></i>모임 삭제</span>
            <button class="mini-modal-close" id="deleteClose"><i class="ri-close-line"></i></button>
        </div>
        <div class="mini-modal-body">
            <p style="font-size:14px;color:var(--text-sub);margin-bottom:4px;">
                해당 동네모임을 삭제(해산)하시겠습니까? 관련 데이터가 모두 삭제됩니다.
            </p>
            <p style="font-size:14px;color:var(--text-main);font-weight:700;" id="deleteTargetTitle"></p>
        </div>
        <div class="mini-modal-foot">
            <button class="btn-pill btn-light" id="deleteCancel">취소</button>
            <button class="btn-pill" style="background:var(--color-red);color:white;padding:12px 24px;" id="deleteConfirm">
                <i class="ri-delete-bin-line"></i> 삭제
            </button>
        </div>
    </div>
</div>

<script>var CTX = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/dist/js/admin/admin_main.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/admin/admin_ui.js"></script>
<script>
(function() {
    'use strict';
    /* =======================================
       1. 동네모임 상세 모달 (사용자 뷰)
    ======================================= */
    var cdOverlay = document.getElementById('crewDetailOverlay');
    var cdBox = document.getElementById('cwModalBox');
    
    function openCrewDetail(crewIdx, name) {
        document.getElementById('cwTitle').textContent = '불러오는 중...';
        document.getElementById('cwContent').innerHTML = '<div style="text-align:center;padding:20px 0;"><i class="ri-loader-4-line ri-spin" style="font-size:24px;color:#94A3B8;"></i></div>';
        
        cdOverlay.classList.add('show');
        requestAnimationFrame(() => {
            cdBox.style.opacity = '1';
            cdBox.style.transform = 'translateY(0) scale(1)';
        });

        fetch(CTX + '/admin/crew/detail?crewIdx=' + crewIdx)
            .then(r => r.json())
            .then(d => {
                if(!d.success) { document.getElementById('cwTitle').textContent = '오류 발생'; return; }
                renderCrewDetail(d);
            })
            .catch(() => { document.getElementById('cwTitle').textContent = '통신 오류'; });
    }
    window.openCrewDetail = openCrewDetail;

    function renderCrewDetail(d) {
        var crew = d.crew || {};
        var posts = d.recentPosts || [];
        var total = d.postCount || 0;
        
        document.getElementById('cwTitle').textContent = crew.name || '이름 없음';
        
        // Chips
        var statusStr = (crew.status === 'active' || !crew.status) ? '활성' : '비활성';
        var statusColor = (crew.status === 'active' || !crew.status) ? '#10B981' : '#EF4444';
        document.getElementById('cwStatusChip').innerHTML = chip(statusStr, statusColor, 'ri-checkbox-circle-line');
        
        var joinTypeStr = crew.joinType === 'free' ? '자유가입' : crew.joinType === 'approval' ? '승인가입' : crew.joinType;
        document.getElementById('cwJoinTypeChip').innerHTML = chip(joinTypeStr, '#8B5CF6', 'ri-door-open-line');

        // Stats
        document.getElementById('cwViewStat').innerHTML = '<i class="ri-eye-line" style="font-size:13px;"></i><span>' + (crew.viewCount||0) + '</span>';
        document.getElementById('cwPostStat').innerHTML = '<i class="ri-article-line" style="font-size:13px;"></i><span>게시글 ' + total + '건</span>';

        // Host
        var nick = crew.hostNickname || '익명';
        document.getElementById('cwAvatar').textContent = nick.charAt(0).toUpperCase();
        document.getElementById('cwHostName').textContent = nick + ' (호스트)';
        var cDate = crew.createdDate ? crew.createdDate.substring(0,10) : '-';
        document.getElementById('cwHostSub').textContent = '생성일: ' + cDate;

        // Progress
        var cur = crew.currentMember || 0;
        var max = crew.maxMember || 0;
        var pct = max > 0 ? Math.min(Math.round(cur * 100 / max), 100) : 0;
        var pgHtml = `
            <div style="font-size:11px;font-weight:700;color:#64748B;margin-bottom:4px;">\${cur} / \${max}명 (\${pct}%)</div>
            <div style="height:6px;background:#E2E8F0;border-radius:3px;overflow:hidden;">
                <div style="width:\${pct}%;height:100%;background:var(--color-purple);"></div>
            </div>`;
        document.getElementById('cwMemberProgress').innerHTML = pgHtml;

        // Content
        var desc = crew.description || '<span style="color:#94A3B8;font-style:italic;">소개가 없습니다.</span>';
        document.getElementById('cwContent').innerHTML = String(desc).replace(/\n/g, '<br>');

        // Posts
        var postHtml = '';
        if(posts.length === 0) {
            postHtml = '<div style="background:#F8FAFC;border:1px dashed #E2E8F0;padding:20px;text-align:center;border-radius:12px;color:#94A3B8;font-size:13px;">게시글이 없습니다.</div>';
        } else {
            postHtml = posts.map((p, i) => {
                var pDate = p.createdDate ? p.createdDate.substring(0,10) : '-';
                return `<div style="background:#fff;border:1px solid #E2E8F0;padding:12px 16px;border-radius:12px;display:flex;align-items:center;gap:12px;">
                            <div style="width:28px;height:28px;background:#F1F5F9;border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700;color:#64748B;flex-shrink:0;">\${i+1}</div>
                            <div style="flex:1;min-width:0;">
                                <div style="font-size:13px;font-weight:700;color:#1E293B;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">\${esc(p.title)}</div>
                                <div style="font-size:11px;color:#94A3B8;margin-top:4px;">\${esc(p.writerNickname)} · \${pDate}</div>
                            </div>
                            <div style="display:flex;gap:10px;font-size:12px;color:#64748B;flex-shrink:0;">
                                <span><i class="ri-eye-line"></i> \${p.viewCount||0}</span>
                                <span><i class="ri-heart-line"></i> \${p.likeCount||0}</span>
                            </div>
                        </div>`;
            }).join('');
        }
        document.getElementById('cwPostsWrap').innerHTML = postHtml;
    }

    function closeCrewDetail() {
        cdBox.style.opacity = '0';
        cdBox.style.transform = 'translateY(20px) scale(0.97)';
        setTimeout(() => cdOverlay.classList.remove('show'), 300);
    }
    document.getElementById('cwClose').addEventListener('click', closeCrewDetail);
    document.getElementById('cwCancel').addEventListener('click', closeCrewDetail);
    cdOverlay.addEventListener('click', e => { if (e.target === cdOverlay) closeCrewDetail(); });


    /* =======================================
       2. 관리자 점검 모달 (Admin Panel)
    ======================================= */
    var caOverlay = document.getElementById('crewAdminOverlay');
    var currentAdminIdx = null;
    var currentAdminName = '';

    function openAdminPanel(crewIdx) {
        currentAdminIdx = crewIdx;
        currentAdminName = '';
        document.getElementById('caTitle').textContent = '불러오는 중...';
        document.getElementById('caInfoList').innerHTML = '<div style="text-align:center;padding:20px 0;"><i class="ri-loader-4-line ri-spin" style="font-size:24px;color:#94A3B8;"></i></div>';
        document.getElementById('caActivitySummary').innerHTML = '-';

        caOverlay.classList.add('show');

        fetch(CTX + '/admin/crew/inspection?crewIdx=' + crewIdx)
            .then(r => r.json())
            .then(d => {
                if(!d.success) { document.getElementById('caTitle').textContent = '오류 발생'; return; }
                currentAdminName = d.crew ? d.crew.name : '알수없음';
                renderAdminPanel(d);
            })
            .catch(() => { document.getElementById('caTitle').textContent = '통신 오류'; });
    }
    window.openAdminPanel = openAdminPanel;

    function renderAdminPanel(d) {
        var crew = d.crew || {};
        var rate = d.participationRate || 0;

        document.getElementById('caTitle').textContent = crew.name || '이름 없음';

        var rows = [
            { label: '모임장(호스트)', val: crew.hostNickname || '없음' },
            { label: '가입방식', val: crew.joinType === 'free' ? '자유가입' : '승인가입' },
            { label: '생성일자', val: crew.createdDate ? crew.createdDate.substring(0,10) : '-' },
            { label: '상태', val: crew.status || 'active' },
            { label: '멤버 현황', val: `\${crew.currentMember||0} / \${crew.maxMember||0}명` },
            { label: '총 게시글 수', val: `\${d.postCount||0}건` },
            { label: '총 댓글 수', val: `\${d.totalComments||0}개` }
        ];

        document.getElementById('caInfoList').innerHTML = rows.map((row, i) => {
            return (i > 0 ? '<div style="height:1px;background:#F1F5F9;"></div>' : '')
                + `<div class="rpt-info-row">
                    <span class="rpt-info-key">\${row.label}</span>
                    <span class="rpt-info-val">\${esc(String(row.val))}</span>
                   </div>`;
        }).join('');

        var actHtml = `
            <div style="display:flex;flex-direction:column;gap:10px;">
                <div style="display:flex;justify-content:space-between;align-items:center;background:#F8FAFC;padding:12px 16px;border-radius:8px;">
                    <span style="font-size:13px;color:#64748B;font-weight:700;">전체 참여율 (멤버/게시글 대비)</span>
                    <span style="font-size:15px;color:var(--color-purple);font-weight:800;">\${rate}%</span>
                </div>
                <div style="background:#F8FAFC;padding:12px 16px;border-radius:8px;">
                    <div style="font-size:12px;color:#64748B;margin-bottom:4px;font-weight:700;">인기 게시글</div>
                    <div style="font-size:13px;color:#1E293B;font-weight:600;">\${esc(d.hottestTitle || '게시글 없음')}</div>
                    <div style="font-size:11px;color:#94A3B8;margin-top:2px;">조회수 \${d.hottestViews||0}회</div>
                </div>
            </div>
        `;
        document.getElementById('caActivitySummary').innerHTML = actHtml;
    }

    function closeAdminPanel() { caOverlay.classList.remove('show'); }
    document.getElementById('caClose').addEventListener('click', closeAdminPanel);
    document.getElementById('caCancel').addEventListener('click', closeAdminPanel);
    caOverlay.addEventListener('click', e => { if (e.target === caOverlay) closeAdminPanel(); });

    // 삭제 연동
    document.getElementById('caDeleteBtn').addEventListener('click', function() {
        if(!currentAdminIdx) return;
        closeAdminPanel();
        setTimeout(() => { confirmDelete(currentAdminIdx, currentAdminName); }, 300);
    });

    /* =======================================
       3. 삭제 (해산) 모달
    ======================================= */
    var delOverlay = document.getElementById('deleteOverlay');
    var pendingDelIdx = null;

    function confirmDelete(idx, name) {
        pendingDelIdx = idx;
        document.getElementById('deleteTargetTitle').textContent = name;
        delOverlay.classList.add('show');
    }
    function closeDelete() { delOverlay.classList.remove('show'); pendingDelIdx = null; }

    document.getElementById('deleteClose').addEventListener('click', closeDelete);
    document.getElementById('deleteCancel').addEventListener('click', closeDelete);
    
    document.getElementById('deleteConfirm').addEventListener('click', function() {
        if(!pendingDelIdx) return;
        // 실제 삭제 로직 (Community 형태 차용)
        fetch(CTX + '/admin/crew/delete', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({ crewIdx: pendingDelIdx })
        })
        .then(r => r.json())
        .then(d => {
            if(d.success) {
                closeDelete();
                showToast('모임이 정상적으로 삭제되었습니다.', 'success');
                setTimeout(() => location.reload(), 1000);
            } else {
                showToast('삭제 실패: ' + (d.msg || '알 수 없는 오류'), 'error');
            }
        })
        .catch(() => { showToast('요청 처리 중 오류 발생', 'error'); });
    });

    // 헬퍼
    function chip(label, color, icon) {
        return '<span style="display:inline-flex;align-items:center;gap:4px;padding:4px 10px;border-radius:20px;font-size:11px;font-weight:700;background:' + color + '22;color:' + color + ';border:1px solid ' + color + '33;"><i class="' + icon + '" style="font-size:10px;"></i>' + esc(label) + '</span>';
    }
    function esc(s) { return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }
})();
</script>
</body>
</html>