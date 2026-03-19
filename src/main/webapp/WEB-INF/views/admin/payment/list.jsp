<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>BATON Studio · 포인트 결제 내역</title>
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
                    <p class="hero-subtitle">포인트 충전 및 결제 내역을 조회하고 관리합니다.</p>
                </div>
            </div>

            <div class="member-toolbar block-card">
                <form class="toolbar-form" id="searchForm" method="get" action="${pageContext.request.contextPath}/admin/payment/list">
                    <div class="status-tabs">
                        <a href="?schType=${schType}&kwd=${kwd}" class="status-tab ${empty status ? 'active' : ''}">전체 내역</a>
                        <a href="?status=PAID&schType=${schType}&kwd=${kwd}" class="status-tab ${status == 'PAID' ? 'active' : ''}">
                            <span class="tab-dot green"></span>결제완료
                        </a>
                        <a href="?status=CANCELLED&schType=${schType}&kwd=${kwd}" class="status-tab ${status == 'CANCELLED' ? 'active' : ''}">
                            <span class="tab-dot red"></span>결제취소
                        </a>
                    </div>
                    <input type="hidden" name="status" value="${status}">

                    <div class="search-group">
                        <input type="hidden" name="schType" id="paymentSchTypeInput" value="${schType}">
                        <div class="adm-dropdown" id="paymentSchType">
                            <button type="button" class="adm-dropdown-btn" onclick="admToggle('paymentSchType')">
                                <span id="paymentSchTypeLabel">통합검색</span>
                                <i class="ri-arrow-down-s-line adm-dropdown-arrow"></i>
                            </button>
                            <div class="adm-dropdown-menu">
                                <div class="adm-dropdown-item ${empty schType || schType == 'all' ? 'active' : ''}" data-value="all" onclick="admSelect(this,'paymentSchType')">통합검색</div>
                                <div class="adm-dropdown-item ${schType == 'userId' ? 'active' : ''}" data-value="userId" onclick="admSelect(this,'paymentSchType')">결제자 아이디</div>
                                <div class="adm-dropdown-item ${schType == 'orderId' ? 'active' : ''}" data-value="orderId" onclick="admSelect(this,'paymentSchType')">주문번호</div>
                            </div>
                        </div>
                        <div class="search-input-wrap">
                            <i class="ri-search-2-line"></i>
                            <input type="text" name="kwd" class="fm-input" value="${kwd}" placeholder="결제 내역 검색...">
                        </div>
                        <button type="submit" class="btn-pill btn-gradient">검색</button>
                    </div>
                </form>
            </div>

            <div class="block-card table-block" style="padding:0; border-radius:var(--radius-lg);">
                <div class="modern-table-wrap">
                    <table class="modern-table">
                        <thead>
                            <tr>
                                <th>주문번호(상점)</th>
                                <th>결제자</th>
                                <th>결제수단</th>
                                <th>충전금액(원)</th>
                                <th>결제일시</th>
                                <th>상태</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty list}">
                                <tr>
                                    <td colspan="7" class="empty-row">
                                        <i class="ri-file-search-line" style="font-size: 2rem; color: var(--color-gray-400); display: block; margin-bottom: 10px;"></i>
                                        <span>조회된 결제 내역이 없습니다.</span>
                                    </td>
                                </tr>
                            </c:if>

                            <c:forEach var="pay" items="${list}">
                                <tr>
                                    <td class="font-medium">${pay.merchantUid}</td>
                                    <td>
                                        <div class="member-cell">
                                            <div class="member-avt">${fn:substring(pay.nickname, 0, 1)}</div>
                                            <div>
                                                <div class="member-name">${pay.nickname}</div>
                                                <div style="font-size:11px; color:#888;">${pay.userId}</div>
                                            </div>
                                        </div>
                                    </td>
                                    
                                    <td class="font-medium" style="text-transform: uppercase;">
                                        ${not empty pay.payMethod ? pay.payMethod : 'CARD'}
                                    </td>
                                    
                                    <td class="font-medium" style="color: var(--color-green);">
                                        +<fmt:formatNumber value="${pay.chargeAmount}" pattern="#,###"/> 원
                                    </td>
                                    
                                    <td class="font-medium">${pay.paidAt}</td>
                                    
                                    <td>
                                        <c:choose>
                                            <c:when test="${pay.payStatus == 'PAID'}">
                                                <span class="tag tag-green">결제완료</span>
                                            </c:when>
                                            <c:when test="${pay.payStatus == 'CANCELLED' or pay.payStatus == 'REFUND'}">
                                                <span class="tag tag-red">취소/환불</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="tag tag-gray">${pay.payStatus}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    
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
    var map = {all:'통합검색', userId:'결제자 아이디', orderId:'주문번호'};
    var inp = document.getElementById('paymentSchTypeInput');
    if (inp && map[inp.value]) document.getElementById('paymentSchTypeLabel').textContent = map[inp.value];
    document.addEventListener('click', function(e) {
        document.querySelectorAll('.adm-dropdown.open').forEach(function(dd) {
            if (!dd.contains(e.target)) dd.classList.remove('open');
        });
    });
});
</script>
</body>
</html>
