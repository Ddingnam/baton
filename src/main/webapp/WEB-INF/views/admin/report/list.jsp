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
                           class="status-tab ${empty processStatus or processStatus == '0' ? 'active' : ''}">전체</a>
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
                        <select name="domainType" class="fm-input search-select">
                            <option value="">전체 유형</option>
                            <option value="TRADE"            ${param.domainType == 'TRADE'            ? 'selected' : ''}>중고거래</option>
                            <option value="COMMUNITY"       ${param.domainType == 'COMMUNITY'       ? 'selected' : ''}>커뮤니티 게시글</option>
                            <option value="COMMUNITY_REPLY" ${param.domainType == 'COMMUNITY_REPLY' ? 'selected' : ''}>커뮤니티 댓글</option>
                            <option value="ALBA"            ${param.domainType == 'ALBA'            ? 'selected' : ''}>알바구인</option>
                            <option value="CHAT"            ${param.domainType == 'CHAT'            ? 'selected' : ''}>채팅</option>
                            <option value="USER"            ${param.domainType == 'USER'            ? 'selected' : ''}>사용자</option>
                        </select>
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

            <div class="block-card table-block" style="padding:0; border-radius:var(--radius-lg); overflow:hidden;">
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
        <!-- 헤더 -->
        <div class="rpt-modal-header">
            <div class="rpt-modal-header-left">
                <div class="rpt-header-icon">
                    <i class="ri-alarm-warning-fill"></i>
                </div>
                <div>
                    <p class="rpt-header-label">REPORT DETAIL</p>
                    <h3 class="rpt-header-title">신고 상세 내역</h3>
                </div>
            </div>
            <button class="rpt-close-btn" id="detailClose">
                <i class="ri-close-line"></i>
            </button>
        </div>

        <!-- 메타 배지 영역 -->
        <div class="rpt-meta-bar">
            <span class="rpt-meta-item">
                <span class="rpt-meta-label">신고 유형</span>
                <span id="dDomainType"></span>
            </span>
            <span class="rpt-meta-sep"></span>
            <span class="rpt-meta-item">
                <span class="rpt-meta-label">처리 상태</span>
                <span id="dProcessStatus"></span>
            </span>
            <span class="rpt-meta-sep"></span>
            <span class="rpt-meta-item">
                <span class="rpt-meta-label">신고일시</span>
                <span class="rpt-meta-date" id="dReportDate"></span>
            </span>
        </div>

        <!-- 바디 -->
        <div class="rpt-modal-body">
            <!-- 사용자 행 -->
            <div class="rpt-user-row">
                <div class="rpt-user-card">
                    <div class="rpt-user-avatar reporter"><i class="ri-user-line"></i></div>
                    <div>
                        <p class="rpt-user-role">신고자</p>
                        <p class="rpt-user-name" id="dReporter">-</p>
                    </div>
                </div>
                <div class="rpt-arrow"><i class="ri-arrow-right-line"></i></div>
                <div class="rpt-user-card">
                    <div class="rpt-user-avatar reported"><i class="ri-user-forbid-line"></i></div>
                    <div>
                        <p class="rpt-user-role">피신고자</p>
                        <p class="rpt-user-name" id="dReportedUser">-</p>
                    </div>
                </div>
            </div>

            <div class="rpt-section">
                <span class="rpt-section-label"><i class="ri-error-warning-line"></i>신고 사유</span>
                <span class="rpt-section-value" id="dReportType">-</span>
            </div>

            <div class="rpt-section">
                <span class="rpt-section-label"><i class="ri-chat-3-line"></i>신고 내용</span>
                <div class="rpt-content-box" id="dReportContent">내용 없음</div>
            </div>

            <div class="rpt-section">
                <span class="rpt-section-label"><i class="ri-edit-line"></i>관리자 메모</span>
                <textarea class="fm-input" id="dAdminMemo" rows="3" placeholder="처리 메모를 입력하세요"></textarea>
            </div>
        </div>

        <!-- 푸터 -->
        <div class="rpt-modal-footer" id="detailFooter">
            <button class="rpt-btn-cancel" id="detailCancel">
                닫기
            </button>
            <div class="rpt-footer-actions">
                <button class="rpt-btn-reject" id="btnReject" onclick="submitProcess(2)">
                    <i class="ri-close-circle-line"></i> 반려
                </button>
                <button class="rpt-btn-approve" id="btnProcess" onclick="submitProcess(1)">
                    <i class="ri-check-double-line"></i> 처리 완료
                </button>
            </div>
        </div>
    </div>
</div>

<script>var CTX = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/dist/js/admin/admin_main.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/admin/admin_ui.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/admin/report_list.js"></script>
</body>
</html>
