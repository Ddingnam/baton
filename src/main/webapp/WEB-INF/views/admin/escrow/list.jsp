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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_report.css">
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
                                        <button class="action-btn" title="상세보기" onclick="openEscrowDetail(${escrow.tradeIdx})"><i class="ri-eye-line"></i></button>
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

<div class="fullscreen-overlay" id="escrowDetailOverlay">
    <div id="escrowModalBox" style="
        background:#fff;border-radius:24px;width:580px;max-width:96vw;
        height:auto;max-height:88vh;display:flex;flex-direction:column;overflow:hidden;
        box-shadow:0 32px 80px rgba(0,0,0,0.26);
        transform:translateY(20px) scale(0.97);opacity:0;
        transition:transform 0.35s cubic-bezier(0.16,1,0.3,1),opacity 0.35s;">

        
        <div style="background:linear-gradient(135deg,#1E1B4B 0%,#312E81 100%);
                    padding:18px 22px;flex-shrink:0;position:relative;overflow:hidden;">
            <div style="position:absolute;top:-25px;right:-25px;width:110px;height:110px;border-radius:50%;background:rgba(255,255,255,0.04);pointer-events:none;"></div>
            <div style="display:flex;align-items:center;justify-content:space-between;position:relative;">
                <div style="display:flex;align-items:center;gap:11px;">
                    <div style="width:36px;height:36px;border-radius:10px;background:rgba(165,180,252,0.15);border:1px solid rgba(165,180,252,0.22);display:flex;align-items:center;justify-content:center;font-size:16px;color:#A5B4FC;flex-shrink:0;">
                        <i class="ri-exchange-2-line"></i>
                    </div>
                    <div>
                        <div style="font-size:9px;font-weight:700;letter-spacing:0.14em;color:rgba(255,255,255,0.3);margin-bottom:3px;">ESCROW DETAIL</div>
                        <div id="escrowModalTitle" style="font-size:14px;font-weight:800;color:#fff;letter-spacing:-0.2px;">에스크로 거래 상세</div>
                    </div>
                </div>
                <button id="escrowDetailClose" style="width:28px;height:28px;border-radius:7px;background:rgba(255,255,255,0.08);border:1px solid rgba(255,255,255,0.1);display:flex;align-items:center;justify-content:center;font-size:15px;color:rgba(255,255,255,0.4);cursor:pointer;transition:all 0.15s;"
                    onmouseover="this.style.background='rgba(239,68,68,0.25)';this.style.color='#FCA5A5';"
                    onmouseout="this.style.background='rgba(255,255,255,0.08)';this.style.color='rgba(255,255,255,0.4)';">
                    <i class="ri-close-line"></i>
                </button>
            </div>
        </div>

        
        <div style="flex:1;overflow-y:auto;padding:0;">
            
            <div style="padding:20px 24px 16px;border-bottom:1px solid #F1F5F9;text-align:center;">
                <div style="font-size:11px;font-weight:700;color:#94A3B8;text-transform:uppercase;letter-spacing:0.08em;margin-bottom:6px;">거래 대금</div>
                <div id="escrowAmount" style="font-size:32px;font-weight:900;color:#7C3AED;letter-spacing:-0.04em;"></div>
                <div id="escrowStatusBadge" style="margin-top:8px;"></div>
            </div>
            
            <div id="escrowParties" style="display:grid;grid-template-columns:1fr 1fr;gap:1px;background:#F1F5F9;border-bottom:1px solid #F1F5F9;"></div>
            
            <div style="padding:12px 24px 20px;">
                <div id="escrowInfoRows" style="display:flex;flex-direction:column;"></div>
            </div>
        </div>

        
        <div style="padding:12px 20px;border-top:1px solid #F1F5F9;display:flex;justify-content:flex-end;background:#FAFAFA;">
            <button id="escrowDetailCancel" style="display:inline-flex;align-items:center;gap:6px;padding:9px 20px;border-radius:10px;border:1.5px solid #E2E8F0;background:#fff;font-size:13px;font-weight:600;color:#64748B;cursor:pointer;font-family:inherit;transition:all 0.15s;"
                onmouseover="this.style.background='#F1F5F9';" onmouseout="this.style.background='#fff';">
                <i class="ri-close-line"></i>닫기
            </button>
        </div>
    </div>
</div>

<script>
(function(){
    var overlay = document.getElementById('escrowDetailOverlay');
    var box     = document.getElementById('escrowModalBox');

    function closeEscrow() {
        box.style.opacity='0'; box.style.transform='translateY(20px) scale(0.97)';
        setTimeout(function(){ overlay.classList.remove('show'); }, 280);
    }
    document.getElementById('escrowDetailClose').addEventListener('click', closeEscrow);
    document.getElementById('escrowDetailCancel').addEventListener('click', closeEscrow);
    overlay.addEventListener('click', function(e){ if(e.target===this) closeEscrow(); });
    document.addEventListener('keydown', function(e){ if(e.key==='Escape' && overlay.classList.contains('show')) closeEscrow(); });

    var STATUS_LABEL = { PAY_COMPLETED:'결제완료', SHIPPING:'배송중', CONFIRMED:'구매확정', CANCELED:'취소/환불', COMPLETED:'완료' };
    var STATUS_COLOR = { PAY_COMPLETED:'#10B981', SHIPPING:'#8B5CF6', CONFIRMED:'#3B82F6', CANCELED:'#EF4444', COMPLETED:'#64748B' };

    function openEscrowDetail(tradeIdx) {
        document.getElementById('escrowModalTitle').textContent = '#TRD-' + tradeIdx;
        document.getElementById('escrowAmount').textContent = '불러오는 중...';
        document.getElementById('escrowStatusBadge').innerHTML = '';
        document.getElementById('escrowParties').innerHTML = '';
        document.getElementById('escrowInfoRows').innerHTML = '<div style="padding:20px 0;text-align:center;color:#94A3B8;font-size:13px;"><i class="ri-loader-4-line" style="animation:cdSpin 1s linear infinite;font-size:18px;display:block;margin-bottom:6px;"></i>불러오는 중...</div>';
        box.style.opacity='0'; box.style.transform='translateY(20px) scale(0.97)';
        overlay.classList.add('show');
        requestAnimationFrame(function(){ box.style.opacity='1'; box.style.transform='translateY(0) scale(1)'; });

        fetch(CTX + '/admin/escrow/detail?tradeIdx=' + tradeIdx)
            .then(function(r){ return r.json(); })
            .then(function(d){
                if (!d.success) { document.getElementById('escrowAmount').textContent='오류'; return; }
                var det = d.detail;

                var amt = det.totalUsedPoint ? Number(det.totalUsedPoint).toLocaleString() + ' P' : '-';
                document.getElementById('escrowAmount').textContent = amt;

                var st = det.tradeStatus || '';
                document.getElementById('escrowStatusBadge').innerHTML =
                    '<span style="display:inline-flex;align-items:center;gap:5px;padding:4px 14px;border-radius:20px;font-size:12px;font-weight:700;background:' +
                    (STATUS_COLOR[st]||'#94A3B8') + '18;color:' + (STATUS_COLOR[st]||'#94A3B8') + ';border:1px solid ' + (STATUS_COLOR[st]||'#94A3B8') + '33;">' +
                    (STATUS_LABEL[st] || st) + '</span>';

                function partyCard(role, roleColor, nick, id) {
                    return '<div style="background:#fff;padding:14px 18px;">' +
                        '<div style="font-size:10px;font-weight:700;color:#94A3B8;text-transform:uppercase;letter-spacing:0.08em;margin-bottom:8px;">' + role + '</div>' +
                        '<div style="display:flex;align-items:center;gap:8px;">' +
                        '<div style="width:30px;height:30px;border-radius:50%;background:' + roleColor + ';color:#fff;display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:800;flex-shrink:0;">' + (nick||'?').charAt(0) + '</div>' +
                        '<div><div style="font-size:13px;font-weight:700;color:#1E293B;">' + (nick||'-') + '</div>' +
                        '<div style="font-size:11px;color:#94A3B8;">' + (id||'-') + '</div></div>' +
                        '</div></div>';
                }
                document.getElementById('escrowParties').innerHTML =
                    partyCard('구매자','#3B82F6', det.buyerNickname, det.buyerId) +
                    partyCard('판매자','#EC4899', det.sellerNickname, det.sellerId);

                function infoSection(title, icon, rows) {
                    var rowsHtml = rows.map(function(r) {
                        var isHighlight = r[2];
                        return '<div style="display:flex;align-items:flex-start;padding:9px 0;border-bottom:1px solid #F8FAFC;">' +
                            '<span style="width:110px;flex-shrink:0;font-size:11px;font-weight:700;color:#94A3B8;padding-top:1px;">' + r[0] + '</span>' +
                            '<span style="flex:1;font-size:13px;font-weight:' + (isHighlight ? '800' : '500') + ';color:' + (isHighlight ? '#7C3AED' : '#334155') + ';word-break:break-all;">' + r[1] + '</span>' +
                            '</div>';
                    }).join('');
                    return '<div style="margin-bottom:14px;">' +
                        '<div style="display:flex;align-items:center;gap:6px;margin-bottom:6px;padding-bottom:6px;border-bottom:2px solid #EDE9FE;">' +
                        '<i class="' + icon + '" style="font-size:13px;color:#7C3AED;"></i>' +
                        '<span style="font-size:10px;font-weight:800;color:#7C3AED;text-transform:uppercase;letter-spacing:0.1em;">' + title + '</span>' +
                        '</div>' + rowsHtml + '</div>';
                }

                var infoHtml = '';

                infoHtml += infoSection('거래 정보', 'ri-exchange-2-line', [
                    ['거래번호',  '#TRD-' + (det.tradeIdx||'-'), false],
                    ['상품번호',  '#' + (det.productIdx||'-'), false],
                    ['상품명',    det.productTitle || '-', false],
                    ['거래일시',  det.tradeDate || '-', false],
                ]);

                infoHtml += infoSection('금액 내역', 'ri-money-cny-circle-line', [
                    ['상품 금액',      det.tradePrice ? Number(det.tradePrice).toLocaleString() + ' P' : '-', false],
                    ['안전결제 수수료', det.safetyFee  ? Number(det.safetyFee).toLocaleString()  + ' P' : '-', false],
                    ['총 사용 포인트', amt, true],
                ]);

                infoHtml += infoSection('배송 정보', 'ri-truck-line', [
                    ['운송장번호',   det.trackingNumber  || '미등록', false],
                    ['배송 시작일',  det.shippingDate    || '-', false],
                    ['수령인',       det.recipientName   || '-', false],
                    ['수령인 연락처',det.recipientPhone  || '-', false],
                    ['배송 주소',    det.shippingAddress || '-', false],
                ]);

                document.getElementById('escrowInfoRows').innerHTML = infoHtml;
            })
            .catch(function(){ document.getElementById('escrowAmount').textContent='오류'; });
    }
    window.openEscrowDetail = openEscrowDetail;
})();
</script>
</body>
</html>
