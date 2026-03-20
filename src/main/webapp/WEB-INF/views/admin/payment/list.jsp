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
                                        <button class="action-btn" title="상세보기" onclick="openPayDetail(${pay.paymentIdx})"><i class="ri-eye-line"></i></button>
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

<div class="fullscreen-overlay" id="payDetailOverlay">
    <div id="payModalBox" style="
        background:#fff;border-radius:24px;width:500px;max-width:96vw;
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
                        <i class="ri-coin-line"></i>
                    </div>
                    <div>
                        <div style="font-size:9px;font-weight:700;letter-spacing:0.14em;color:rgba(255,255,255,0.3);margin-bottom:3px;">PAYMENT DETAIL</div>
                        <div style="font-size:14px;font-weight:800;color:#fff;letter-spacing:-0.2px;" id="payModalTitle">포인트 결제 상세</div>
                    </div>
                </div>
                <button id="payDetailClose" style="width:28px;height:28px;border-radius:7px;background:rgba(255,255,255,0.08);border:1px solid rgba(255,255,255,0.1);display:flex;align-items:center;justify-content:center;font-size:15px;color:rgba(255,255,255,0.4);cursor:pointer;transition:all 0.15s;"
                    onmouseover="this.style.background='rgba(239,68,68,0.25)';this.style.color='#FCA5A5';"
                    onmouseout="this.style.background='rgba(255,255,255,0.08)';this.style.color='rgba(255,255,255,0.4)';">
                    <i class="ri-close-line"></i>
                </button>
            </div>
        </div>

        
        <div style="flex:1;overflow-y:auto;padding:0;">
            
            <div style="padding:20px 24px 16px;border-bottom:1px solid #F1F5F9;text-align:center;">
                <div style="font-size:11px;font-weight:700;color:#94A3B8;text-transform:uppercase;letter-spacing:0.08em;margin-bottom:6px;">충전 금액</div>
                <div id="payAmount" style="font-size:32px;font-weight:900;color:#7C3AED;letter-spacing:-0.04em;"></div>
                <div id="payStatusBadge" style="margin-top:8px;"></div>
            </div>
            
            <div style="padding:12px 24px 20px;">
                <div id="payInfoRows" style="display:flex;flex-direction:column;"></div>
            </div>
        </div>

        
        <div style="padding:12px 20px;border-top:1px solid #F1F5F9;display:flex;justify-content:flex-end;background:#FAFAFA;">
            <button id="payDetailCancel" style="display:inline-flex;align-items:center;gap:6px;padding:9px 20px;border-radius:10px;border:1.5px solid #E2E8F0;background:#fff;font-size:13px;font-weight:600;color:#64748B;cursor:pointer;font-family:inherit;transition:all 0.15s;"
                onmouseover="this.style.background='#F1F5F9';" onmouseout="this.style.background='#fff';">
                <i class="ri-close-line"></i>닫기
            </button>
        </div>
    </div>
</div>

<script>
(function(){
    var overlay = document.getElementById('payDetailOverlay');
    var box     = document.getElementById('payModalBox');

    function closePayDetail() {
        box.style.opacity='0'; box.style.transform='translateY(20px) scale(0.97)';
        setTimeout(function(){ overlay.classList.remove('show'); }, 280);
    }
    document.getElementById('payDetailClose').addEventListener('click', closePayDetail);
    document.getElementById('payDetailCancel').addEventListener('click', closePayDetail);
    overlay.addEventListener('click', function(e){ if(e.target===this) closePayDetail(); });
    document.addEventListener('keydown', function(e){ if(e.key==='Escape' && overlay.classList.contains('show')) closePayDetail(); });

    function openPayDetail(paymentIdx) {
        document.getElementById('payModalTitle').textContent = '포인트 결제 상세';
        document.getElementById('payAmount').textContent = '불러오는 중...';
        document.getElementById('payStatusBadge').innerHTML = '';
        document.getElementById('payInfoRows').innerHTML = '<div style="padding:20px 0;text-align:center;color:#94A3B8;font-size:13px;"><i class="ri-loader-4-line" style="animation:cdSpin 1s linear infinite;font-size:18px;display:block;margin-bottom:6px;"></i>불러오는 중...</div>';
        box.style.opacity='0'; box.style.transform='translateY(20px) scale(0.97)';
        overlay.classList.add('show');
        requestAnimationFrame(function(){ box.style.opacity='1'; box.style.transform='translateY(0) scale(1)'; });

        fetch(CTX + '/admin/payment/detail?paymentIdx=' + paymentIdx)
            .then(function(r){ return r.json(); })
            .then(function(d){
                if (!d.success) { document.getElementById('payAmount').textContent='오류'; return; }
                var det = d.detail;
                var amt = det.chargeAmount ? Number(det.chargeAmount).toLocaleString() + ' 원' : '-';
                document.getElementById('payAmount').textContent = amt;

                var statusMap = { PAID:'결제완료', CANCELLED:'취소', REFUND:'환불' };
                var statusColor = { PAID:'#10B981', CANCELLED:'#EF4444', REFUND:'#F59E0B' };
                var st = det.payStatus || '';
                document.getElementById('payStatusBadge').innerHTML =
                    '<span style="display:inline-flex;align-items:center;gap:5px;padding:4px 14px;border-radius:20px;font-size:12px;font-weight:700;background:' +
                    (statusColor[st]||'#94A3B8') + '18;color:' + (statusColor[st]||'#94A3B8') + ';border:1px solid ' + (statusColor[st]||'#94A3B8') + '33;">' +
                    (statusMap[st] || st) + '</span>';

                document.getElementById('payModalTitle').textContent = det.merchantUid || '포인트 결제 상세';

                var rows = [
                    ['주문번호',   det.merchantUid || '-'],
                    ['결제자',     (det.nickname||'-') + ' (' + (det.userId||'-') + ')'],
                    ['이메일',     det.email || '-'],
                    ['결제수단',   (det.payMethod||'CARD').toUpperCase()],
                    ['잔여 포인트', det.batonpoint != null ? Number(det.batonpoint).toLocaleString() + ' P' : '-'],
                    ['결제일시',   det.paidAt || '-'],
                    ['PG 거래번호', det.impUid || '-'],
                ];
                document.getElementById('payInfoRows').innerHTML = rows.map(function(r){
                    return '<div style="display:flex;align-items:center;padding:12px 0;border-bottom:1px solid #F8FAFC;">' +
                        '<span style="width:110px;flex-shrink:0;font-size:12px;font-weight:600;color:#94A3B8;">' + r[0] + '</span>' +
                        '<span style="flex:1;font-size:13px;font-weight:500;color:#334155;">' + r[1] + '</span>' +
                        '</div>';
                }).join('');
            })
            .catch(function(){ document.getElementById('payAmount').textContent='오류'; });
    }
    window.openPayDetail = openPayDetail;
})();
</script>
</body>
</html>
