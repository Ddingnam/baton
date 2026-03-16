<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>BATON Studio · 결제/포인트 관리</title>
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
                    <h1 class="hero-title">Payment History</h1>
                    <p class="hero-subtitle">포인트 충전, 환불 및 에스크로 결제 내역을 관리합니다.</p>
                </div>
            </div>

            <div class="member-stat-row">
                <div class="member-stat-card">
                    <div class="msc-icon purple"><i class="ri-money-dollar-circle-fill"></i></div>
                    <div class="msc-info">
                        <span class="msc-val">12,050,000</span>
                        <span class="msc-lbl">누적 결제액(원)</span>
                    </div>
                </div>
                <div class="member-stat-card">
                    <div class="msc-icon green"><i class="ri-secure-payment-fill"></i></div>
                    <div class="msc-info">
                        <span class="msc-val">4,200,000</span>
                        <span class="msc-lbl">에스크로 보관금(원)</span>
                    </div>
                </div>
            </div>

            <div class="member-toolbar block-card">
                <form class="toolbar-form" id="searchForm" method="get" action="${pageContext.request.contextPath}/admin/payment/list">
                    <div class="status-tabs">
                        <a href="?schType=${schType}&kwd=${kwd}" class="status-tab ${empty status ? 'active' : ''}">전체 내역</a>
                        <a href="?status=charge&schType=${schType}&kwd=${kwd}" class="status-tab ${status == 'charge' ? 'active' : ''}">
                            <span class="tab-dot green"></span>충전
                        </a>
                        <a href="?status=refund&schType=${schType}&kwd=${kwd}" class="status-tab ${status == 'refund' ? 'active' : ''}">
                            <span class="tab-dot red"></span>환불
                        </a>
                    </div>
                    <input type="hidden" name="status" value="${status}">

                    <div class="search-group">
                        <select name="schType" class="fm-input search-select">
                            <option value="all" ${schType == 'all' ? 'selected' : ''}>통합검색</option>
                            <option value="userId" ${schType == 'userId' ? 'selected' : ''}>결제자 아이디</option>
                            <option value="orderId" ${schType == 'orderId' ? 'selected' : ''}>주문번호</option>
                        </select>
                        <div class="search-input-wrap">
                            <i class="ri-search-2-line"></i>
                            <input type="text" name="kwd" class="fm-input" value="${kwd}" placeholder="결제 내역 검색...">
                        </div>
                        <button type="submit" class="btn-pill btn-gradient">검색</button>
                    </div>
                </form>
            </div>

            <div class="block-card table-block" style="padding:0; border-radius:var(--radius-lg); overflow:hidden;">
                <div class="modern-table-wrap">
                    <table class="modern-table">
                        <thead>
                            <tr>
                                <th>주문번호</th>
                                <th>결제자(ID)</th>
                                <th>결제유형</th>
                                <th>금액</th>
                                <th>결제/승인일</th>
                                <th>상태</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty list}">
                                <tr>
                                    <td colspan="7" class="empty-row">
                                        <i class="ri-file-search-line" style="font-size: 2rem; color: var(--color-gray-400); display: block; margin-bottom: 10px;"></i>
                                        <span>결제 내역이 없습니다.</span>
                                    </td>
                                </tr>
                            </c:if>
                            
                            <c:forEach var="pay" items="${list}">
                                <tr>
                                    <td class="font-medium">#ORD-20260317-001</td>
                                    <td>
                                        <div class="member-cell">
                                            <div class="member-avt">어</div>
                                            <div>
                                                <div class="member-name">어진 (eojin)</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="font-medium">포인트 충전</td>
                                    <td class="font-medium" style="color: var(--color-green);">+50,000 원</td>
                                    <td class="font-medium">2026-03-17 14:30</td>
                                    <td><span class="tag tag-green">결제완료</span></td>
                                    <td>
                                        <button class="action-btn" title="상세보기"><i class="ri-eye-line"></i></button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <c:if test="${totalPages > 1}">
                    <div class="pagination">
                        <c:if test="${page > 1}">
                            <a href="?page=${page-1}&status=${status}&schType=${schType}&kwd=${kwd}" class="page-btn"><i class="ri-arrow-left-s-line"></i></a>
                        </c:if>
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <a href="?page=${p}&status=${status}&schType=${schType}&kwd=${kwd}" class="page-btn ${p == page ? 'active' : ''}">${p}</a>
                        </c:forEach>
                        <c:if test="${page < totalPages}">
                            <a href="?page=${page+1}&status=${status}&schType=${schType}&kwd=${kwd}" class="page-btn"><i class="ri-arrow-right-s-line"></i></a>
                        </c:if>
                    </div>
                </c:if>
            </div>

        </div>
    </main>
</div>

<script>var CTX = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/dist/js/admin/admin_main.js"></script>
</body>
</html>