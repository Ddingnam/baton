<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>BATON Studio · 제재 내역 관리</title>
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
                    <h1 class="hero-title">Sanction History</h1>
                    <p class="hero-subtitle">총 <strong>${totalCount}</strong>건의 제재 내역이 있습니다.</p>
                </div>
            </div>

            <div class="member-toolbar block-card">
                <form class="toolbar-form" method="get"
                      action="${pageContext.request.contextPath}/admin/member/sanction">
                    <div class="status-tabs">
                        <a href="?kwd=${kwd}"
                           class="status-tab ${empty sanctionFilter ? 'active' : ''}">전체</a>
                        <a href="?sanctionFilter=ACTIVE&kwd=${kwd}"
                           class="status-tab ${sanctionFilter == 'ACTIVE' ? 'active' : ''}">
                            <span class="tab-dot red"></span>제재중
                        </a>
                        <a href="?sanctionFilter=LIFTED&kwd=${kwd}"
                           class="status-tab ${sanctionFilter == 'LIFTED' ? 'active' : ''}">
                            <span class="tab-dot green"></span>해제됨
                        </a>
                        <a href="?sanctionFilter=PERMANENT&kwd=${kwd}"
                           class="status-tab ${sanctionFilter == 'PERMANENT' ? 'active' : ''}">
                            <span class="tab-dot gray"></span>영구정지
                        </a>
                    </div>
                    <div class="search-group">
                        <div class="search-input-wrap">
                            <i class="ri-search-2-line"></i>
                            <input type="text" name="kwd" class="fm-input"
                                   value="${kwd}" placeholder="아이디 또는 닉네임 검색">
                        </div>
                        <input type="hidden" name="sanctionFilter" value="${sanctionFilter}">
                        <button type="submit" class="btn-pill btn-gradient">검색</button>
                    </div>
                </form>
            </div>

            <div class="block-card table-block" style="padding:0; border-radius:var(--radius-lg); overflow:hidden;">
                <div class="modern-table-wrap">
                    <table class="modern-table">
                        <thead>
                            <tr>
                                <th>회원</th>
                                <th>제재 유형</th>
                                <th>사유</th>
                                <th>시작일</th>
                                <th>종료일</th>
                                <th>상태</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty list}">
                                <tr>
                                    <td colspan="7" class="empty-row">
                                        <i class="ri-shield-check-line"></i>
                                        <span>제재 내역이 없습니다.</span>
                                    </td>
                                </tr>
                            </c:if>
                            <c:forEach var="s" items="${list}">
                                <tr>
                                    <td>
                                        <div class="member-cell">
                                            <div class="member-avt">${fn:substring(s.NICKNAME, 0, 1)}</div>
                                            <div>
                                                <div class="member-name">${s.NICKNAME}</div>
                                                <div class="member-sub">${s.USERID}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="tag ${s.SANCTIONTYPE == 'PERMANENT' ? 'tag-red' : 'tag-blue'}">
                                            ${s.SANCTIONTYPE == 'PERMANENT' ? '영구정지' : '기간정지'}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="reason-cell" title="${s.REASON}">${s.REASON}</span>
                                    </td>
                                    <td class="font-medium">${s.STARTDATE}</td>
                                    <td class="font-medium">${empty s.ENDDATE ? '영구' : s.ENDDATE}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${s.ISLIFTED == 1}">
                                                <span class="tag tag-green">해제됨</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="tag tag-red">제재중</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:if test="${s.ISLIFTED == 0}">
                                            <button class="action-btn"
                                                    onclick="openLiftModal(${s.SANCTIONIDX}, ${s.USERIDX}, '${s.NICKNAME}')"
                                                    title="제재 해제">
                                                <i class="ri-lock-unlock-line"></i>
                                            </button>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <c:if test="${totalPages > 1}">
                    <div class="pagination">
                        <c:if test="${page > 1}">
                            <a href="?page=${page-1}&kwd=${kwd}&sanctionFilter=${sanctionFilter}" class="page-btn">
                                <i class="ri-arrow-left-s-line"></i>
                            </a>
                        </c:if>
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <a href="?page=${p}&kwd=${kwd}&sanctionFilter=${sanctionFilter}"
                               class="page-btn ${p == page ? 'active' : ''}">${p}</a>
                        </c:forEach>
                        <c:if test="${page < totalPages}">
                            <a href="?page=${page+1}&kwd=${kwd}&sanctionFilter=${sanctionFilter}" class="page-btn">
                                <i class="ri-arrow-right-s-line"></i>
                            </a>
                        </c:if>
                    </div>
                </c:if>
            </div>

        </div>
    </main>
</div>

<div class="fullscreen-overlay" id="liftOverlay">
    <div class="mini-modal">
        <div class="mini-modal-head">
            <span class="mini-modal-title"><i class="ri-lock-unlock-line"></i>제재 해제</span>
            <button class="mini-modal-close" id="liftClose"><i class="ri-close-line"></i></button>
        </div>
        <div class="mini-modal-body">
            <p style="font-size:14px;color:var(--text-sub);margin-bottom:16px;">
                <strong id="liftTargetName" style="color:var(--text-main);"></strong> 님의 제재를 해제합니다.
            </p>
            <div class="fm-field">
                <label class="fm-label">해제 사유</label>
                <textarea class="fm-input" id="liftReason" rows="3" placeholder="해제 사유를 입력하세요"></textarea>
                <div class="fm-helper error" id="liftReasonError" style="display:none;">
                    <i class="ri-error-warning-line"></i> 해제 사유를 입력해주세요.
                </div>
            </div>
        </div>
        <div class="mini-modal-foot">
            <button class="btn-pill btn-light"     id="liftCancel">취소</button>
            <button class="btn-pill btn-gradient"  id="liftConfirm">해제 확정</button>
        </div>
    </div>
</div>

<script>var CTX = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/dist/js/admin/admin_main.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/admin/admin_ui.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/admin/member_sanction.js"></script>
</body>
</html>
