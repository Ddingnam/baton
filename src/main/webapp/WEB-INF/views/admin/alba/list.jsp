<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn"   uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>BATON Studio · 알바구인 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@500;700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_member.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_ui.css">
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
                    <h1 class="hero-title">Alba</h1>
                    <p class="hero-subtitle">총 <strong>${dataCount}</strong>건의 알바구인 공고가 있습니다.</p>
                </div>
            </div>

            <div class="member-toolbar block-card">
                <form class="toolbar-form" method="get"
                      action="${pageContext.request.contextPath}/admin/alba/list">
                    <div class="status-tabs">
                        <a href="?schType=${schType}&kwd=${kwd}"
                           class="status-tab ${empty category ? 'active' : ''}">전체</a>
                        <a href="?category=카페/음식점&schType=${schType}&kwd=${kwd}"
                           class="status-tab ${category == '카페/음식점' ? 'active' : ''}">카페/음식점</a>
                        <a href="?category=편의점&schType=${schType}&kwd=${kwd}"
                           class="status-tab ${category == '편의점' ? 'active' : ''}">편의점</a>
                        <a href="?category=마트/물류&schType=${schType}&kwd=${kwd}"
                           class="status-tab ${category == '마트/물류' ? 'active' : ''}">마트/물류</a>
                        <a href="?category=사무직&schType=${schType}&kwd=${kwd}"
                           class="status-tab ${category == '사무직' ? 'active' : ''}">사무직</a>
                        <a href="?category=서비스&schType=${schType}&kwd=${kwd}"
                           class="status-tab ${category == '서비스' ? 'active' : ''}">서비스</a>
                        <a href="?category=기타&schType=${schType}&kwd=${kwd}"
                           class="status-tab ${category == '기타' ? 'active' : ''}">기타</a>
                    </div>
                    <div class="search-group">
                        <input type="hidden" name="schType" id="albaSchTypeInput" value="${schType}">
                        <div class="adm-dropdown" id="albaSchType">
                            <button type="button" class="adm-dropdown-btn" onclick="admToggle('albaSchType')">
                                <span id="albaSchTypeLabel">통합검색</span>
                                <i class="ri-arrow-down-s-line adm-dropdown-arrow"></i>
                            </button>
                            <div class="adm-dropdown-menu">
                                <div class="adm-dropdown-item ${empty schType || schType == 'all' ? 'active' : ''}" data-value="all"      onclick="admSelect(this,'albaSchType')">통합검색</div>
                                <div class="adm-dropdown-item ${schType == 'title'    ? 'active' : ''}" data-value="title"    onclick="admSelect(this,'albaSchType')">공고 제목</div>
                                <div class="adm-dropdown-item ${schType == 'employer' ? 'active' : ''}" data-value="employer" onclick="admSelect(this,'albaSchType')">업체명</div>
                                <div class="adm-dropdown-item ${schType == 'location' ? 'active' : ''}" data-value="location" onclick="admSelect(this,'albaSchType')">근무지</div>
                            </div>
                        </div>
                        <div class="search-input-wrap">
                            <i class="ri-search-2-line"></i>
                            <input type="text" name="kwd" class="fm-input"
                                   value="${kwd}" placeholder="공고 검색...">
                        </div>
                        <input type="hidden" name="category" value="${category}">
                        <button type="submit" class="btn-pill btn-gradient">검색</button>
                    </div>
                </form>
            </div>

            <div class="block-card table-block" style="padding:0; border-radius:var(--radius-lg); overflow:hidden;">
                <div class="modern-table-wrap">
                    <table class="modern-table">
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>공고 제목</th>
                                <th>업체명</th>
                                <th>카테고리</th>
                                <th>급여</th>
                                <th>마감일</th>
                                <th>근무지</th>
                                <th>등록일</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty list}">
                                <tr>
                                    <td colspan="9" class="empty-row">
                                        <i class="ri-briefcase-line"></i>
                                        <span>공고가 없습니다.</span>
                                    </td>
                                </tr>
                            </c:if>
                            <c:forEach var="item" items="${list}">
                                <tr>
                                    <td class="font-medium">${item.postingIdx}</td>
                                    <td>
                                        <span class="reason-cell" title="${item.title}"
                                              onclick="openDetail(${item.postingIdx})"
                                              style="cursor:pointer;color:var(--color-primary);font-weight:600;">${item.title}</span>
                                    </td>
                                    <td>
                                        <div class="member-cell">
                                            <div class="member-avt" style="background:linear-gradient(135deg,#F59E0B,#D97706);">
                                                ${fn:substring(item.employer, 0, 1)}
                                            </div>
                                            <div class="member-name">${item.employer}</div>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="tag tag-blue">${not empty item.category ? item.category : '기타'}</span>
                                    </td>
                                    <td class="font-medium">
                                        <c:choose>
                                            <c:when test="${not empty item.payType}">
                                                <span style="font-size:11px;color:#94A3B8;">${item.payType}</span>
                                                <strong><fmt:formatNumber value="${item.pay}" pattern="#,###"/></strong>원
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="font-medium">
                                        <c:choose>
                                            <c:when test="${not empty item.deadline}">${fn:substring(item.deadline, 0, 10)}</c:when>
                                            <c:otherwise><span class="tag tag-green">상시채용</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="font-medium">
                                        <c:choose>
                                            <c:when test="${not empty item.location}">
                                                <span title="${item.location}">${item.location}</span>
                                            </c:when>
                                            <c:otherwise><span class="tag tag-gray">미설정</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="font-medium">
                                        <c:if test="${not empty item.createdDate}">${fn:substring(item.createdDate.toString(), 0, 10)}</c:if>
                                    </td>
                                    <td>
                                        <button type="button" class="action-btn"
                                                onclick="openDetail(${item.postingIdx})"
                                                title="상세보기"
                                                style="color:var(--color-primary);">
                                            <i class="ri-eye-line"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <c:if test="${total_page > 1}">
                    <div class="pagination">
                        <c:if test="${page > 1}">
                            <a href="?page=${page-1}&category=${category}&schType=${schType}&kwd=${kwd}" class="page-btn">
                                <i class="ri-arrow-left-s-line"></i>
                            </a>
                        </c:if>
                        <c:forEach begin="1" end="${total_page}" var="p">
                            <a href="?page=${p}&category=${category}&schType=${schType}&kwd=${kwd}"
                               class="page-btn ${p == page ? 'active' : ''}">${p}</a>
                        </c:forEach>
                        <c:if test="${page < total_page}">
                            <a href="?page=${page+1}&category=${category}&schType=${schType}&kwd=${kwd}" class="page-btn">
                                <i class="ri-arrow-right-s-line"></i>
                            </a>
                        </c:if>
                    </div>
                </c:if>
            </div>

        </div>
    </main>
</div>

<!-- ====== 상세보기 모달 ====== -->
<div class="fullscreen-overlay" id="albaDetailOverlay">
    <div id="adModalBox" style="
        background:#fff;border-radius:24px;width:680px;max-width:96vw;
        height:84vh;max-height:880px;min-height:480px;display:flex;flex-direction:column;overflow:hidden;
        box-shadow:0 32px 80px rgba(0,0,0,0.26);
        transform:translateY(20px) scale(0.97);
        transition:transform 0.35s cubic-bezier(0.16,1,0.3,1),opacity 0.35s;
        opacity:0;">

        <!-- 헤더 -->
        <div id="adHeader" style="
            background:linear-gradient(135deg,#1E1B4B 0%,#312E81 100%);
            padding:20px 24px 18px;flex-shrink:0;position:relative;overflow:hidden;">
            <div style="position:absolute;top:-30px;right:-30px;width:140px;height:140px;border-radius:50%;background:rgba(255,255,255,0.04);pointer-events:none;"></div>
            <div style="display:flex;align-items:flex-start;justify-content:space-between;gap:12px;position:relative;">
                <div style="display:flex;align-items:center;gap:12px;min-width:0;">
                    <div style="width:38px;height:38px;border-radius:12px;background:rgba(165,180,252,0.15);border:1px solid rgba(165,180,252,0.2);display:flex;align-items:center;justify-content:center;font-size:18px;color:#A5B4FC;flex-shrink:0;">
                        <i class="ri-briefcase-4-line"></i>
                    </div>
                    <div style="min-width:0;">
                        <div id="adEmployer" style="font-size:9px;font-weight:700;letter-spacing:0.14em;color:rgba(255,255,255,0.5);margin-bottom:4px;text-transform:uppercase;"></div>
                        <div id="adTitle" style="font-size:16px;font-weight:800;color:#fff;letter-spacing:-0.3px;line-height:1.3;word-break:break-word;"></div>
                    </div>
                </div>
                <button id="adClose" style="
                    width:30px;height:30px;border-radius:8px;flex-shrink:0;
                    background:rgba(255,255,255,0.08);border:1px solid rgba(255,255,255,0.1);
                    display:flex;align-items:center;justify-content:center;
                    font-size:16px;color:rgba(255,255,255,0.4);cursor:pointer;transition:all 0.15s;"
                    onmouseover="this.style.background='rgba(239,68,68,0.25)';this.style.color='#FCA5A5';"
                    onmouseout="this.style.background='rgba(255,255,255,0.08)';this.style.color='rgba(255,255,255,0.4)';">
                    <i class="ri-close-line"></i>
                </button>
            </div>
            <div style="display:flex;align-items:center;gap:8px;margin-top:14px;flex-wrap:wrap;position:relative;">
                <div id="adCategoryChip"></div>
                <div id="adPayChip"></div>
                <div id="adDeadlineChip"></div>
                <div style="margin-left:auto;display:flex;align-items:center;gap:10px;">
                    <span id="adViewStat" style="display:flex;align-items:center;gap:4px;font-size:12px;color:rgba(255,255,255,0.45);"></span>
                </div>
            </div>
        </div>

        <!-- 바디 -->
        <div style="flex:1;overflow-y:auto;padding:0;" id="adScrollBody">

            <!-- 근무조건 그리드 -->
            <div style="padding:18px 24px;border-bottom:1px solid #F1F5F9;">
                <div style="font-size:11px;font-weight:700;color:#94A3B8;text-transform:uppercase;letter-spacing:0.08em;margin-bottom:12px;display:flex;align-items:center;gap:5px;">
                    <i class="ri-list-check-2"></i>근무 조건
                </div>
                <div id="adCondGrid" style="display:grid;grid-template-columns:1fr 1fr;gap:10px;"></div>
            </div>

            <!-- 공고 내용 -->
            <div style="padding:18px 24px;border-bottom:1px solid #F1F5F9;">
                <div style="font-size:11px;font-weight:700;color:#94A3B8;text-transform:uppercase;letter-spacing:0.08em;margin-bottom:12px;display:flex;align-items:center;gap:5px;">
                    <i class="ri-file-text-line"></i>공고 내용
                </div>
                <div id="adDescription" style="font-size:14px;color:#334155;line-height:1.85;word-break:break-word;white-space:pre-wrap;"></div>
            </div>

            <!-- 이미지 -->
            <div id="adImageWrap" style="display:none;padding:16px 24px;border-bottom:1px solid #F1F5F9;">
                <div style="font-size:11px;font-weight:700;color:#94A3B8;text-transform:uppercase;letter-spacing:0.08em;margin-bottom:10px;display:flex;align-items:center;gap:5px;">
                    <i class="ri-image-line"></i>첨부 이미지
                </div>
                <div id="adImages" style="display:flex;flex-wrap:wrap;gap:8px;"></div>
            </div>

            <!-- 근무지 -->
            <div id="adLocationWrap" style="display:none;padding:14px 24px 22px;">
                <div style="font-size:11px;font-weight:700;color:#94A3B8;text-transform:uppercase;letter-spacing:0.08em;margin-bottom:10px;display:flex;align-items:center;gap:5px;">
                    <i class="ri-map-pin-line"></i>근무 위치
                </div>
                <div style="background:#F8FAFC;border:1px solid #E2E8F0;border-radius:12px;padding:14px 16px;display:flex;align-items:center;gap:12px;">
                    <div style="width:32px;height:32px;border-radius:10px;background:#FEF3C7;color:#D97706;display:flex;align-items:center;justify-content:center;font-size:15px;flex-shrink:0;"><i class="ri-map-pin-2-fill"></i></div>
                    <div>
                        <div id="adLocation" style="font-size:13px;font-weight:700;color:#1E293B;"></div>
                        <div id="adLocationDetail" style="font-size:11px;color:#94A3B8;margin-top:2px;"></div>
                        <div id="adSubway" style="font-size:11px;color:#6366F1;margin-top:2px;"></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 푸터 -->
        <div style="padding:12px 20px;border-top:1px solid #F1F5F9;display:flex;justify-content:space-between;align-items:center;flex-shrink:0;background:#FAFAFA;">
            <button id="adDeleteBtn" style="
                display:inline-flex;align-items:center;gap:6px;
                padding:9px 18px;border-radius:10px;
                border:1.5px solid #FEE2E2;background:#FFF5F5;
                font-size:13px;font-weight:600;color:#EF4444;
                cursor:pointer;font-family:inherit;transition:all 0.15s;"
                onmouseover="this.style.background='#FEE2E2';"
                onmouseout="this.style.background='#FFF5F5';">
                <i class="ri-delete-bin-line"></i>삭제
            </button>
            <button id="adCancel" style="
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

<!-- ====== 삭제 확인 모달 ====== -->
<div class="fullscreen-overlay" id="albaDeleteOverlay">
    <div class="mini-modal">
        <div class="mini-modal-head">
            <span class="mini-modal-title"><i class="ri-delete-bin-line"></i>공고 삭제</span>
            <button class="mini-modal-close" id="albaDeleteClose"><i class="ri-close-line"></i></button>
        </div>
        <div class="mini-modal-body">
            <p style="font-size:14px;color:var(--text-sub);margin-bottom:4px;">
                아래 공고를 삭제합니다. 이 작업은 되돌릴 수 없습니다.
            </p>
            <p style="font-size:14px;color:var(--text-main);font-weight:700;" id="albaDeleteTargetTitle"></p>
        </div>
        <div class="mini-modal-foot">
            <button class="btn-pill btn-light" id="albaDeleteCancel">취소</button>
            <button class="btn-pill" style="background:var(--color-red);color:white;padding:12px 24px;" id="albaDeleteConfirm">
                <i class="ri-delete-bin-line"></i> 삭제
            </button>
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
    var map = { all: '통합검색', title: '공고 제목', employer: '업체명', location: '근무지' };
    var inp = document.getElementById('albaSchTypeInput');
    if (inp && map[inp.value]) document.getElementById('albaSchTypeLabel').textContent = map[inp.value];
    document.addEventListener('click', function(e) {
        document.querySelectorAll('.adm-dropdown.open').forEach(function(dd) {
            if (!dd.contains(e.target)) dd.classList.remove('open');
        });
    });
});
</script>
<script src="${pageContext.request.contextPath}/dist/js/admin/alba_list.js"></script>
</body>
</html>
