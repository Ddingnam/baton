<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>BATON Studio · 에스크로 거래 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@500;700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_member.css">
    <style>
        .trade-user-col { display: flex; align-items: center; gap: 8px; }
        .trade-role-badge { font-size: 10px; font-weight: 700; padding: 2px 6px; border-radius: 4px; }
        .role-buyer { background: #e3f2fd; color: #1976d2; }
        .role-seller { background: #fce4ec; color: #c2185b; }
    </style>
</head>
<body>
<div class="agency-layout">
    <jsp:include page="/WEB-INF/views/admin/layout/left.jsp"/>
    <main class="agency-main">
        <jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>
        <div class="agency-scroll-area">

            <div class="hero-header">
                <div class="hero-titles">
                    <h1 class="hero-title">Escrow Management</h1>
                    <p class="hero-subtitle">안전결제(에스크로) 기반의 유저 간 중고거래 내역을 관리합니다.</p>
                </div>
            </div>

            <div class="member-toolbar block-card">
                <form class="toolbar-form" id="searchForm" method="get" action="${pageContext.request.contextPath}/admin/escrow/list">
                    <div class="status-tabs">
                        <a href="?schType=${schType}&kwd=${kwd}" class="status-tab ${empty status ? 'active' : ''}">전체 내역</a>
                        <a href="?status=PAY_COMPLETED&schType=${schType}&kwd=${kwd}" class="status-tab ${status == 'PAY_COMPLETED' ? 'active' : ''}">
                            <span class="tab-dot green"></span>결제완료
                        </a>
                        <a href="?status=SHIPPING&schType=${schType}&kwd=${kwd}" class="status-tab ${status == 'SHIPPING' ? 'active' : ''}">
                            <span class="tab-dot purple"></span>배송중
                        </a>
                        <a href="?status=CANCELED&schType=${schType}&kwd=${kwd}" class="status-tab ${status == 'CANCELED' ? 'active' : ''}">
                            <span class="tab-dot red"></span>취소/환불
                        </a>
                    </div>
                    <input type="hidden" name="status" value="${status}">

                    <div class="search-group">
                        <input type="hidden" name="schType" id="escrowSchTypeInput" value="${schType}">
                        <div class="adm-dropdown" id="escrowSchType">
                            <button type="button" class="adm-dropdown-btn" onclick="admToggle('escrowSchType')">
                                <span id="escrowSchTypeLabel">통합검색</span>
                                <i class="ri-arrow-down-s-line adm-dropdown-arrow"></i>
                            </button>
                            <div class="adm-dropdown-menu">
                                <div class="adm-dropdown-item active" data-value="all" onclick="admSelect(this,'escrowSchType')">통합검색</div>
                                <div class="adm-dropdown-item" data-value="productIdx" onclick="admSelect(this,'escrowSchType')">상품 번호</div>
                                <div class="adm-dropdown-item" data-value="buyerId" onclick="admSelect(this,'escrowSchType')">구매자 ID</div>
                                <div class="adm-dropdown-item" data-value="sellerId" onclick="admSelect(this,'escrowSchType')">판매자 ID</div>
                            </div>
                        </div>
                        <div class="search-input-wrap">
                            <i class="ri-search-2-line"></i>
                            <input type="text" name="kwd" class="fm-input" value="${kwd}" placeholder="거래 내역 검색...">
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
                                <th>거래/상품번호</th>
                                <th>구매자</th>
                                <th>판매자</th>
                                <th>거래대금(포인트)</th>
                                <th>거래일시</th>
                                <th>상태</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty list}">
                                <tr>
                                    <td colspan="7" class="empty-row">
                                        <i class="ri-file-search-line" style="font-size: 2rem; color: var(--color-gray-400); display: block; margin-bottom: 10px;"></i>
                                        <span>조회된 에스크로 거래 내역이 없습니다.</span>
                                    </td>
                                </tr>
                            </c:if>

                            <c:forEach var="escrow" items="${list}">
                                <tr>
                                    <td class="font-medium">
                                        #TRD-${escrow.tradeIdx}<br>
                                        <span style="font-size: 0.8rem; color: #888;">상품: ${escrow.productIdx}</span>
                                    </td>
                                    
                                    <td>
                                        <div class="trade-user-col">
                                            <span class="trade-role-badge role-buyer">구매</span>
                                            <div>
                                                <div class="member-name">${escrow.buyerNickname}</div>
                                                <div style="font-size:11px; color:#888;">${escrow.buyerId}</div>
                                            </div>
                                        </div>
                                    </td>
                                    
                                    <td>
                                        <div class="trade-user-col">
                                            <span class="trade-role-badge role-seller">판매</span>
                                            <div>
                                                <div class="member-name">${escrow.sellerNickname}</div>
                                                <div style="font-size:11px; color:#888;">${escrow.sellerId}</div>
                                            </div>
                                        </div>
                                    </td>

                                    <td class="font-medium" style="color: var(--color-green);">
                                        <fmt:formatNumber value="${escrow.totalUsedPoint}" pattern="#,###"/> P
                                    </td>
                                    <td class="font-medium">${escrow.tradeDate}</td>
                                    
                                    <td>
                                        <c:choose>
                                            <c:when test="${escrow.tradeStatus == 'PAY_COMPLETED'}"><span class="tag tag-green">결제완료</span></c:when>
                                            <c:when test="${escrow.tradeStatus == 'SHIPPING'}"><span class="tag tag-purple">배송중</span></c:when>
                                            <c:when test="${escrow.tradeStatus == 'CONFIRMED'}"><span class="tag tag-blue">구매확정</span></c:when>
                                            <c:when test="${escrow.tradeStatus == 'CANCELED'}"><span class="tag tag-red">취소/환불</span></c:when>
                                            <c:otherwise><span class="tag tag-gray">${escrow.tradeStatus}</span></c:otherwise>
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
    var map = {'all': '통합검색', 'productIdx': '상품 번호', 'buyerId': '구매자 ID', 'sellerId': '판매자 ID'};
    var inp = document.getElementById('escrowSchTypeInput');
    if (inp && map[inp.value]) document.getElementById('escrowSchTypeLabel').textContent = map[inp.value];
    document.addEventListener('click', function(e) {
        document.querySelectorAll('.adm-dropdown.open').forEach(function(dd) {
            if (!dd.contains(e.target)) dd.classList.remove('open');
        });
    });
});
</script>
</body>
</html>
