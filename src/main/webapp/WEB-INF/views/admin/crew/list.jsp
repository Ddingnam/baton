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
                    <h1 class="hero-title">Crew Dashboard</h1>
                    <p class="hero-subtitle">총 <strong>${dataCount}</strong>개의 동네모임이 활발히 운영 중입니다.</p>
                </div>
            </div>

            <div class="member-toolbar block-card" style="border-radius: 20px; box-shadow: 0 4px 12px rgba(0,0,0,0.02);">
                <form class="toolbar-form" method="get" action="${pageContext.request.contextPath}/admin/crew/list">
                    <div class="status-tabs">
                        <a href="?joinType=all&kwd=${kwd}" class="status-tab ${joinType == 'all' ? 'active' : ''}">전체</a>
                        <a href="?joinType=free&kwd=${kwd}" class="status-tab ${joinType == 'free' ? 'active' : ''}">자유가입</a>
                        <a href="?joinType=approval&kwd=${kwd}" class="status-tab ${joinType == 'approval' ? 'active' : ''}">승인가입</a>
                    </div>
                    <div class="search-group">
                        <div class="search-input-wrap">
                            <i class="ri-search-2-line"></i>
                            <input type="text" name="kwd" class="fm-input" value="${kwd}" placeholder="모임 이름 검색...">
                        </div>
                        <input type="hidden" name="joinType" value="${joinType}">
                        <button type="submit" class="btn-pill btn-gradient" style="border-radius: 12px;">검색</button>
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
                            
                            <c:choose>
                                <c:when test="${crew.status == 'active' || empty crew.status}">
                                    <span class="crew-badge active">활성</span>
                                </c:when>
                                <c:when test="${crew.status == 'inactive'}">
                                    <span class="crew-badge inactive">비활성(해산)</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="crew-badge approval">${crew.status}</span>
                                </c:otherwise>
                            </c:choose>

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
                            <button type="button" class="btn-admin-action" onclick="openAdminPanel(${crew.crewIdx}, '${fn:escapeXml(crew.name)}')">
                                <i class="ri-settings-4-line"></i> 점검
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
                        <a href="?page=${page-1}&joinType=${joinType}&kwd=${kwd}" class="page-btn"><i class="ri-arrow-left-s-line"></i></a>
                    </c:if>
                    <c:forEach begin="1" end="${total_page}" var="p">
                        <a href="?page=${p}&joinType=${joinType}&kwd=${kwd}" class="page-btn ${p == page ? 'active' : ''}">${p}</a>
                    </c:forEach>
                    <c:if test="${page < total_page}">
                        <a href="?page=${page+1}&joinType=${joinType}&kwd=${kwd}" class="page-btn"><i class="ri-arrow-right-s-line"></i></a>
                    </c:if>
                </div>
            </c:if>
        </div>
    </main>
</div>

<div class="premium-overlay" id="crewDetailModal">
    <div class="premium-modal" style="width: 580px; max-width: 90vw;">
        <div style="padding: 24px 32px; background: #F8FAFC; border-bottom: 1px solid #E2E8F0; display: flex; align-items: center; justify-content: space-between;">
            <div>
                <p style="font-size: 11px; font-weight: 800; color: #7C3AED; letter-spacing: 0.1em; margin-bottom: 4px;">CREW INFO</p>
                <h2 id="cdTitle" style="font-size: 20px; font-weight: 800; color: #0F172A; margin: 0;">모임 상세</h2>
            </div>
            <button onclick="closeModal('crewDetailModal')" style="font-size: 24px; color: #94A3B8; transition: color 0.2s;"><i class="ri-close-line"></i></button>
        </div>
        
        <div style="padding: 32px; flex: 1; overflow-y: auto;">
            <div id="cdContent" style="font-size: 14px; color: #475569; line-height: 1.6; margin-bottom: 24px; background: #F1F5F9; padding: 16px; border-radius: 16px;">
                로딩 중...
            </div>
            <h3 style="font-size: 14px; font-weight: 800; color: #1E293B; margin-bottom: 12px;"><i class="ri-team-line"></i> 현재 참여 멤버</h3>
            <div id="cdMembers" style="display: flex; flex-direction: column; gap: 8px;"></div>
        </div>
        
        <div style="padding: 16px 32px; background: #fff; border-top: 1px solid #E2E8F0; text-align: right;">
            <button class="btn-pill btn-light" onclick="closeModal('crewDetailModal')">닫기</button>
        </div>
    </div>
</div>

<div class="premium-overlay" id="adminPanelModal">
    <div class="premium-modal" style="width: 480px; max-width: 90vw;">
        <div style="padding: 24px 32px; background: #0F172A; color: white; display: flex; align-items: center; justify-content: space-between;">
            <div>
                <p style="font-size: 11px; font-weight: 800; color: #38BDF8; letter-spacing: 0.1em; margin-bottom: 4px;">ADMINISTRATION</p>
                <h2 id="apTitle" style="font-size: 20px; font-weight: 800; margin: 0;">관리자 점검</h2>
            </div>
            <button onclick="closeModal('adminPanelModal')" style="font-size: 24px; color: rgba(255,255,255,0.5); transition: color 0.2s;"><i class="ri-close-line"></i></button>
        </div>
        
        <div style="padding: 32px; background: #fff;">
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 24px;">
                <div style="padding: 16px; border-radius: 16px; border: 1px solid #E2E8F0; text-align: center;">
                    <p style="font-size: 12px; color: #64748B; font-weight: 700; margin-bottom: 4px;">게시글 활동량</p>
                    <p id="apPosts" style="font-size: 24px; font-weight: 900; color: #7C3AED;">-</p>
                </div>
                <div style="padding: 16px; border-radius: 16px; border: 1px solid #E2E8F0; text-align: center;">
                    <p style="font-size: 12px; color: #64748B; font-weight: 700; margin-bottom: 4px;">신고 누적 건수</p>
                    <p id="apReports" style="font-size: 24px; font-weight: 900; color: #EF4444;">-</p>
                </div>
            </div>
            
            <label style="font-size: 12px; font-weight: 800; color: #475569; display: block; margin-bottom: 8px;">관리자 메모 (점검 사항)</label>
            <textarea style="width: 100%; height: 80px; padding: 12px; border: 1px solid #CBD5E1; border-radius: 12px; resize: none; font-family: inherit; font-size: 13px; color: #1E293B;" placeholder="해당 모임에 대한 관리자 메모를 남기세요..."></textarea>
        </div>
        
        <div style="padding: 20px 32px; background: #F8FAFC; border-top: 1px solid #E2E8F0; display: flex; justify-content: space-between;">
            <button class="btn-admin-action" style="background: #FEF2F2; color: #EF4444; border-color: #FCA5A5;" id="btnDeleteCrew">
                <i class="ri-delete-bin-line"></i> 강제 해산
            </button>
            <div style="display: flex; gap: 8px;">
                <button class="btn-pill btn-light" onclick="closeModal('adminPanelModal')">취소</button>
                <button class="btn-pill btn-gradient" style="border-radius: 12px; padding: 0 20px;" onclick="closeModal('adminPanelModal')">메모 저장</button>
            </div>
        </div>
    </div>
</div>

<script>
    var CTX = '${pageContext.request.contextPath}';
    
    function openModal(id) {
        document.getElementById(id).classList.add('show');
    }
    function closeModal(id) {
        document.getElementById(id).classList.remove('show');
    }

    function openCrewDetail(idx, name) {
        document.getElementById('cdTitle').textContent = name;
        document.getElementById('cdContent').innerHTML = '<i class="ri-loader-4-line ri-spin"></i> 데이터를 불러오는 중...';
        document.getElementById('cdMembers').innerHTML = '';
        openModal('crewDetailModal');

        fetch(CTX + '/admin/crew/detail?crewIdx=' + idx)
            .then(r => r.json())
            .then(d => {
                if(d.success) {
                    var desc = d.crew.description ? d.crew.description.replace(/\n/g, '<br>') : '모임 소개가 없습니다.';
                    document.getElementById('cdContent').innerHTML = desc;
                    
                    document.getElementById('cdMembers').innerHTML = `
                        <div style="padding: 12px 16px; background: #fff; border: 1px solid #E2E8F0; border-radius: 12px; display: flex; align-items: center; justify-content: space-between;">
                            <span style="font-size: 13px; font-weight: 700; color: #1E293B;">\${d.crew.hostNickname} (호스트)</span>
                            <span style="font-size: 11px; color: #94A3B8; background: #F1F5F9; padding: 4px 8px; border-radius: 6px;">개설자</span>
                        </div>
                    `;
                }
            }).catch(() => {
                document.getElementById('cdContent').innerHTML = '데이터를 불러오는 데 실패했습니다.';
            });
    }

    var targetCrewIdx = null;
    function openAdminPanel(idx, name) {
        targetCrewIdx = idx;
        document.getElementById('apTitle').textContent = name;
        document.getElementById('apPosts').textContent = '로딩..';
        document.getElementById('apReports').textContent = '로딩..';
        openModal('adminPanelModal');

        fetch(CTX + '/admin/crew/inspection?crewIdx=' + idx)
            .then(r => r.json())
            .then(d => {
                if(d.success) {
                    document.getElementById('apPosts').textContent = (d.postCount || 0) + '건';
                    document.getElementById('apReports').textContent = (d.reportCount || 0) + '건';
                }
            });
    }

    document.getElementById('btnDeleteCrew').addEventListener('click', function() {
        if(!confirm('정말 이 동네모임을 강제 해산(삭제)하시겠습니까?')) return;
        
        fetch(CTX + '/admin/crew/delete', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({ crewIdx: targetCrewIdx })
        }).then(r => r.json()).then(d => {
            if(d.success) {
                alert('해산 처리되었습니다.');
                location.reload();
            } else {
                alert('처리 실패: ' + d.msg);
            }
        });
    });

    document.querySelectorAll('.premium-overlay').forEach(el => {
        el.addEventListener('click', e => {
            if(e.target === el) closeModal(el.id);
        });
    });
</script>
</body>
</html>