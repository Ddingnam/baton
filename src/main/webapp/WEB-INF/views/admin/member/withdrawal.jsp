<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>BATON Studio · 탈퇴 요청 처리</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@500;700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_member.css">
</head>
<body>
<div class="agency-layout">
    <jsp:include page="/WEB-INF/views/admin/layout/left.jsp"/>
    <main class="agency-main">
        <jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>
        <div class="agency-scroll-area">

            <div class="hero-header">
                <div class="hero-titles">
                    <h1 class="hero-title">Withdrawal Requests</h1>
                    <p class="hero-subtitle">총 <strong>${totalCount}</strong>건의 탈퇴 요청이 있습니다.</p>
                </div>
            </div>

            <div class="member-toolbar block-card">
                <form class="toolbar-form" method="get">
                    <div class="status-tabs">
                        <a href="?kwd=${kwd}"                    class="status-tab ${empty wFilter ? 'active' : ''}">전체</a>
                        <a href="?wFilter=PENDING&kwd=${kwd}"    class="status-tab ${wFilter == 'PENDING'  ? 'active' : ''}">
                            <span class="tab-dot blue"></span>대기중
                        </a>
                        <a href="?wFilter=APPROVED&kwd=${kwd}"   class="status-tab ${wFilter == 'APPROVED' ? 'active' : ''}">
                            <span class="tab-dot gray"></span>승인됨
                        </a>
                        <a href="?wFilter=REJECTED&kwd=${kwd}"   class="status-tab ${wFilter == 'REJECTED' ? 'active' : ''}">
                            <span class="tab-dot red"></span>반려됨
                        </a>
                    </div>
                    <div class="search-group">
                        <div class="search-input-wrap">
                            <i class="ri-search-2-line"></i>
                            <input type="text" name="kwd" class="fm-input" value="${kwd}" placeholder="아이디 또는 닉네임 검색">
                        </div>
                        <input type="hidden" name="wFilter" value="${wFilter}">
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
                                <th>이메일</th>
                                <th>가입일</th>
                                <th>요청일</th>
                                <th>탈퇴 사유</th>
                                <th>상태</th>
                                <th>처리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty list}">
                                <tr>
                                    <td colspan="7" class="empty-row">
                                        <i class="ri-user-follow-line"></i>
                                        <span>탈퇴 요청이 없습니다.</span>
                                    </td>
                                </tr>
                            </c:if>
                            <c:forEach var="w" items="${list}">
                                <tr>
                                    <td>
                                        <div class="member-cell">
                                            <div class="member-avt">${fn:substring(w.NICKNAME, 0, 1)}</div>
                                            <div>
                                                <div class="member-name">${w.NICKNAME}</div>
                                                <div class="member-sub">${w.USERID}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="font-medium">${w.EMAIL}</td>
                                    <td class="font-medium">${fn:substring(w.CREATEDDATE, 0, 10)}</td>
                                    <td class="font-medium">${w.REQUESTDATE}</td>
                                    <td>
                                        <span class="reason-cell" title="${w.REASON}">${empty w.REASON ? '-' : w.REASON}</span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${w.WITHDRAWSTATUS == 'PENDING'}">  <span class="tag tag-blue">대기중</span></c:when>
                                            <c:when test="${w.WITHDRAWSTATUS == 'APPROVED'}"> <span class="tag tag-gray">승인됨</span></c:when>
                                            <c:when test="${w.WITHDRAWSTATUS == 'REJECTED'}"> <span class="tag tag-red">반려됨</span></c:when>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:if test="${w.WITHDRAWSTATUS == 'PENDING'}">
                                            <div class="process-btns">
                                                <button class="btn-approve"
                                                        onclick="openApproveModal(${w.WITHDRAWIDX}, ${w.USERIDX}, '${w.NICKNAME}')">
                                                    승인
                                                </button>
                                                <button class="btn-reject"
                                                        onclick="rejectWithdrawal(${w.WITHDRAWIDX}, ${w.USERIDX})">
                                                    반려
                                                </button>
                                            </div>
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
                            <a href="?page=${page-1}&kwd=${kwd}&wFilter=${wFilter}" class="page-btn"><i class="ri-arrow-left-s-line"></i></a>
                        </c:if>
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <a href="?page=${p}&kwd=${kwd}&wFilter=${wFilter}" class="page-btn ${p == page ? 'active' : ''}">${p}</a>
                        </c:forEach>
                        <c:if test="${page < totalPages}">
                            <a href="?page=${page+1}&kwd=${kwd}&wFilter=${wFilter}" class="page-btn"><i class="ri-arrow-right-s-line"></i></a>
                        </c:if>
                    </div>
                </c:if>
            </div>

        </div>
    </main>
</div>

<div class="fullscreen-overlay" id="approveOverlay">
    <div class="mini-modal">
        <div class="mini-modal-head">
            <span class="mini-modal-title" style="color:var(--color-red);">
                <i class="ri-user-unfollow-line" style="margin-right:6px;"></i>탈퇴 승인
            </span>
            <button class="mini-modal-close" id="approveClose"><i class="ri-close-line"></i></button>
        </div>
        <div class="mini-modal-body">
            <div class="member-cell" style="margin-bottom:20px;padding:16px;background:var(--base-bg);border-radius:var(--radius-md);">
                <div class="member-avt" id="approveAvt"></div>
                <div>
                    <div class="member-name" id="approveTargetName"></div>
                    <div class="member-sub">탈퇴 처리 시 계정이 비활성화됩니다.</div>
                </div>
            </div>
            <p style="font-size:13px;color:var(--color-red);font-weight:600;background:#FEE2E2;padding:12px 14px;border-radius:var(--radius-sm);">
                <i class="ri-error-warning-line"></i> 이 작업은 되돌릴 수 없습니다. 신중히 처리해주세요.
            </p>
        </div>
        <div class="mini-modal-foot">
            <button class="btn-pill btn-light" id="approveCancel">취소</button>
            <button class="btn-pill" style="background:var(--color-red);color:white;padding:12px 24px;" id="approveConfirm">탈퇴 승인</button>
        </div>
    </div>
</div>

<script>var CTX = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/dist/js/admin/admin_main.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/admin/member_withdrawal.js"></script>
</body>
</html>
