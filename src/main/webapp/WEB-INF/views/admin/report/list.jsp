<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>BATON Studio · 신고 관리</title>
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
                    <h1 class="hero-title">Report List</h1>
                    <p class="hero-subtitle">총 <strong>${dataCount}</strong>건의 신고가 접수되어 있습니다.</p>
                </div>
            </div>

            <div class="member-toolbar block-card">
                <form class="toolbar-form" method="get"
                      action="${pageContext.request.contextPath}/admin/report/list">
                    <div class="status-tabs">
                        <a href="?processStatus=&domainType=${domainType}"
                           class="status-tab ${empty processStatus ? 'active' : ''}">전체</a>
                        <a href="?processStatus=0&domainType=${domainType}"
                           class="status-tab ${processStatus == '0' ? 'active' : ''}">
                            <span class="tab-dot red"></span>미처리
                        </a>
                        <a href="?processStatus=1&domainType=${domainType}"
                           class="status-tab ${processStatus == '1' ? 'active' : ''}">
                            <span class="tab-dot green"></span>처리완료
                        </a>
                        <a href="?processStatus=2&domainType=${domainType}"
                           class="status-tab ${processStatus == '2' ? 'active' : ''}">
                            <span class="tab-dot gray"></span>반려
                        </a>
                    </div>
                    <div class="search-group">
                        <input type="hidden" name="domainType" id="domainTypeInput" value="${param.domainType}">
                        <div class="rpt-dropdown" id="domainDropdown">
                            <button type="button" class="rpt-dropdown-btn" onclick="toggleDropdown()">
                                <span id="domainLabel">전체 유형</span>
                                <i class="ri-arrow-down-s-line rpt-dropdown-arrow"></i>
                            </button>
                            <div class="rpt-dropdown-menu" id="domainMenu">
                                <div class="rpt-dropdown-item ${empty param.domainType ? 'active' : ''}" data-value="" onclick="selectDomain(this, '전체 유형')">전체 유형</div>
                                <div class="rpt-dropdown-item ${param.domainType == 'TRADE' ? 'active' : ''}" data-value="TRADE" onclick="selectDomain(this, '중고거래')">중고거래</div>
                                <div class="rpt-dropdown-item ${param.domainType == 'COMMUNITY' ? 'active' : ''}" data-value="COMMUNITY" onclick="selectDomain(this, '커뮤니티 (게시글+댓글)')">커뮤니티 (게시글+댓글)</div>
                                <div class="rpt-dropdown-item ${param.domainType == 'COMMUNITY_REPLY' ? 'active' : ''}" data-value="COMMUNITY_REPLY" onclick="selectDomain(this, '커뮤니티 댓글만')">커뮤니티 댓글만</div>
                                <div class="rpt-dropdown-item ${param.domainType == 'CREW' ? 'active' : ''}" data-value="CREW" onclick="selectDomain(this, '동네모임')">동네모임</div>
                                <div class="rpt-dropdown-item ${param.domainType == 'ALBA' ? 'active' : ''}" data-value="ALBA" onclick="selectDomain(this, '알바구인')">알바구인</div>
                                <div class="rpt-dropdown-item ${param.domainType == 'CHAT' ? 'active' : ''}" data-value="CHAT" onclick="selectDomain(this, '채팅')">채팅</div>
                                <div class="rpt-dropdown-item ${param.domainType == 'USER' ? 'active' : ''}" data-value="USER" onclick="selectDomain(this, '사용자')">사용자</div>
                            </div>
                        </div>
                        <div class="search-input-wrap">
                            <i class="ri-search-2-line"></i>
                            <input type="text" name="kwd" class="fm-input"
                                   value="${param.kwd}" placeholder="신고자 또는 피신고자 검색...">
                        </div>
                        <input type="hidden" name="processStatus" value="${processStatus}">
                        <button type="submit" class="btn-pill btn-gradient">검색</button>
                    </div>
                </form>
            </div>

            <div class="block-card table-block" style="padding:0; border-radius:var(--radius-lg);">
                <div class="modern-table-wrap">
                    <table class="modern-table">
                        <thead>
                            <tr>
                                <th>신고 유형</th>
                                <th>신고 사유</th>
                                <th>신고자</th>
                                <th>피신고자</th>
                                <th>신고일시</th>
                                <th>처리상태</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty list}">
                                <tr>
                                    <td colspan="7" class="empty-row">
                                        <i class="ri-shield-check-line"></i>
                                        <span>신고 내역이 없습니다.</span>
                                    </td>
                                </tr>
                            </c:if>
                            <c:forEach var="r" items="${list}">
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${r.domainType == 'TRADE'}">
                                                <span class="tag tag-blue">중고거래</span>
                                            </c:when>
                                            <c:when test="${r.domainType == 'COMMUNITY'}">
                                                <span class="tag tag-purple">커뮤니티</span>
                                            </c:when>
                                            <c:when test="${r.domainType == 'COMMUNITY_REPLY'}">
                                                <span class="tag tag-purple">커뮤니티 댓글</span>
                                            </c:when>
                                            <c:when test="${r.domainType == 'CREW'}">
                                                <span class="tag tag-orange">동네모임</span>
                                            </c:when>
                                            <c:when test="${r.domainType == 'ALBA'}">
                                                <span class="tag tag-green">알바구인</span>
                                            </c:when>
                                            <c:when test="${r.domainType == 'CHAT'}">
                                                <span class="tag tag-blue">채팅</span>
                                            </c:when>
                                            <c:when test="${r.domainType == 'USER'}">
                                                <span class="tag tag-gray">사용자</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="tag tag-gray">${r.domainType}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="reason-cell" title="${r.reportContent}">${r.reportType}</span>
                                    </td>
                                    <td>
                                        <div class="member-cell">
                                            <div class="member-avt">${fn:substring(r.reporterName, 0, 1)}</div>
                                            <div>
                                                <div class="member-name">${r.reporterName}</div>
                                                <div class="member-sub">${r.reporterId}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="member-cell">
                                            <div class="member-avt">${fn:substring(r.reportedUserName, 0, 1)}</div>
                                            <div>
                                                <div class="member-name">${r.reportedUserName}</div>
                                                <div class="member-sub">${r.reportedUserId}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="font-medium">${fn:substring(r.reportDate, 0, 16)}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${r.processStatus == 0}">
                                                <span class="tag tag-red">미처리</span>
                                            </c:when>
                                            <c:when test="${r.processStatus == 1}">
                                                <span class="tag tag-green">처리완료</span>
                                            </c:when>
                                            <c:when test="${r.processStatus == 2}">
                                                <span class="tag tag-gray">반려</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <button type="button" class="action-btn"
                                                onclick="openDetail(${r.reportIdx})"
                                                title="상세보기">
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
                            <a href="?page=${page-1}&processStatus=${processStatus}&domainType=${domainType}" class="page-btn">
                                <i class="ri-arrow-left-s-line"></i>
                            </a>
                        </c:if>
                        <c:forEach begin="1" end="${total_page}" var="p">
                            <a href="?page=${p}&processStatus=${processStatus}&domainType=${domainType}"
                               class="page-btn ${p == page ? 'active' : ''}">${p}</a>
                        </c:forEach>
                        <c:if test="${page < total_page}">
                            <a href="?page=${page+1}&processStatus=${processStatus}&domainType=${domainType}" class="page-btn">
                                <i class="ri-arrow-right-s-line"></i>
                            </a>
                        </c:if>
                    </div>
                </c:if>
            </div>

        </div>
    </main>
</div>

<div class="fullscreen-overlay" id="detailOverlay">
    <div class="rpt-modal">
        
        <div class="rpt-modal-header">
            <div class="rpt-header-left">
                <div class="rpt-header-icon"><i class="ri-alarm-warning-fill"></i></div>
                <div>
                    <p class="rpt-header-eyebrow">REPORT DETAIL</p>
                    <p class="rpt-header-title" id="dModalTitle">신고 상세</p>
                </div>
            </div>
            <button class="rpt-close-btn" id="detailClose"
                onmouseover="this.style.background='rgba(239,68,68,0.22)';this.style.color='#FCA5A5';"
                onmouseout="this.style.background='rgba(255,255,255,0.07)';this.style.color='rgba(255,255,255,0.35)';">
                <i class="ri-close-line"></i>
            </button>
        </div>

        
        <div class="rpt-modal-body">
            <div class="rpt-info-list">
                <div class="rpt-info-row">
                    <span class="rpt-info-key">신고 유형</span>
                    <span class="rpt-info-val" id="dDomainType"></span>
                </div>
                <div class="rpt-info-row">
                    <span class="rpt-info-key">처리 상태</span>
                    <span class="rpt-info-val" id="dProcessStatus"></span>
                </div>
                <div class="rpt-info-row">
                    <span class="rpt-info-key">신고 사유</span>
                    <span class="rpt-info-val bold" id="dReportType"></span>
                </div>
                <div class="rpt-info-row">
                    <span class="rpt-info-key">신고일시</span>
                    <span class="rpt-info-val" id="dReportDate"></span>
                </div>
                <div class="rpt-info-row">
                    <span class="rpt-info-key">신고자</span>
                    <span class="rpt-info-val" id="dReporter"></span>
                </div>
                <div class="rpt-info-row">
                    <span class="rpt-info-key">피신고자</span>
                    <span class="rpt-info-val" id="dReportedUser"></span>
                </div>
            </div>

            <div class="rpt-divider"></div>

            <div class="rpt-field">
                <p class="rpt-field-label">신고 내용</p>
                <div class="rpt-field-box" id="dReportContent">내용 없음</div>
            </div>

            <div class="rpt-field">
                <p class="rpt-field-label">관리자 메모</p>
                <textarea class="rpt-textarea" id="dAdminMemo" rows="3" placeholder="처리 메모를 입력하세요"></textarea>
            </div>

            <!-- ── 제재 옵션 (처리 완료 시에만 사용) ── -->
            <div class="rpt-field rpt-sanction-toggle-row" id="sanctionToggleRow">
                <label class="rpt-sanction-chk-label">
                    <span class="rpt-sanction-chk-text">
                        <i class="ri-shield-cross-line"></i> 처리 완료 시 제재 추가
                    </span>
                    <input type="checkbox" id="chkSanction" class="rpt-sanction-chk">
                    <span class="rpt-toggle-track" id="sanctionToggleTrack"></span>
                </label>
            </div>

            <div class="rpt-sanction-section" id="sanctionSection" style="display:none;">
                <div class="rpt-sanction-inner">
                    <p class="rpt-sanction-title"><i class="ri-alert-fill"></i> 제재 설정</p>
                    <div class="rpt-sanction-fields">
                        <div class="rpt-sanction-field">
                            <label class="rpt-field-label">제재 유형</label>
                            <select id="sanctionTypeSelect" class="rpt-sanction-select">
                                <option value="TEMPORARY">기간 정지</option>
                                <option value="PERMANENT">영구 정지</option>
                            </select>
                        </div>
                        <div class="rpt-sanction-field" id="daysField">
                            <label class="rpt-field-label">정지 기간</label>
                            <div class="rpt-days-wrap">
                                <input type="number" id="sanctionDays" class="rpt-days-input"
                                       value="7" min="1" max="365">
                                <span class="rpt-days-unit">일</span>
                            </div>
                        </div>
                    </div>
                    <p class="rpt-sanction-warn">
                        <i class="ri-information-line"></i>
                        처리 완료 버튼을 눌러야 제재가 적용됩니다. 반려 시에는 무시됩니다.
                    </p>
                </div>
            </div>

            <!-- 콘텐츠 숨기기 옵션 (처리 완료 시에만 사용) -->
            <div class="rpt-field rpt-sanction-toggle-row" id="hideContentToggleRow">
                <label class="rpt-sanction-chk-label">
                    <span class="rpt-sanction-chk-text">
                        <i class="ri-eye-off-line"></i> 처리 완료 시 게시글/댓글 숨기기
                    </span>
                    <input type="checkbox" id="chkHideContent" class="rpt-sanction-chk">
                    <span class="rpt-toggle-track" id="hideContentToggleTrack"></span>
                </label>
            </div>
            <div class="rpt-hide-warn" id="hideContentWarn" style="display:none;">
                <i class="ri-information-line"></i>
                신고된 게시글 또는 댓글이 다른 사용자에게 보이지 않게 숨깜 처리됩니다.
            </div>
        </div>

        
        <div class="rpt-modal-footer" id="detailFooter">
            <button class="rpt-btn-cancel" id="detailCancel">닫기</button>
            <div class="rpt-footer-actions">
                <button class="rpt-btn-reject" id="btnReject" onclick="submitProcess(2)">
                    <i class="ri-close-line"></i> 반려
                </button>
                <button class="rpt-btn-approve" id="btnProcess" onclick="submitProcess(1)">
                    <i class="ri-check-line"></i> 처리 완료
                </button>
            </div>
        </div>
    </div>
</div>

<script>var CTX = '${pageContext.request.contextPath}';</script>
<script>

(function() {

    var labelMap = {
        '': '전체 유형',
        'TRADE': '중고거래',
        'COMMUNITY': '커뮤니티 (게시글+댓글)',
        'COMMUNITY_REPLY': '커뮤니티 댓글만',
        'CREW': '동네모임',
        'ALBA': '알바구인',
        'CHAT': '채팅',
        'USER': '사용자'
    };
    var current = document.getElementById('domainTypeInput').value;
    if (labelMap[current]) {
        document.getElementById('domainLabel').textContent = labelMap[current];
    }

    document.addEventListener('click', function(e) {
        var dd = document.getElementById('domainDropdown');
        if (dd && !dd.contains(e.target)) {
            dd.classList.remove('open');
        }
    });
})();

function toggleDropdown() {
    document.getElementById('domainDropdown').classList.toggle('open');
}

function selectDomain(el, label) {
    var val = el.dataset.value;
    document.getElementById('domainTypeInput').value = val;
    document.getElementById('domainLabel').textContent = label;
    document.querySelectorAll('.rpt-dropdown-item').forEach(function(i) { i.classList.remove('active'); });
    el.classList.add('active');
    document.getElementById('domainDropdown').classList.remove('open');
}
</script>
<script src="${pageContext.request.contextPath}/dist/js/admin/admin_main.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/admin/admin_ui.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/admin/report_list.js"></script>
</body>
</html>
