<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn"   uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>BATON Studio · 중고거래 관리</title>
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
                    <h1 class="hero-title">Trade</h1>
                    <p class="hero-subtitle">총 <strong>${dataCount}</strong>건의 중고거래 게시글이 있습니다.</p>
                </div>
            </div>

            <div class="member-toolbar block-card">
                <form class="toolbar-form" method="get"
                      action="${pageContext.request.contextPath}/admin/trade/list">
                    <div class="status-tabs">
                        <a href="?schType=${schType}&kwd=${kwd}"
                           class="status-tab ${empty tradeStatus ? 'active' : ''}">전체</a>
                        <a href="?tradeStatus=판매중&schType=${schType}&kwd=${kwd}"
                           class="status-tab ${tradeStatus == '판매중' ? 'active' : ''}">판매중</a>
                        <a href="?tradeStatus=예약중&schType=${schType}&kwd=${kwd}"
                           class="status-tab ${tradeStatus == '예약중' ? 'active' : ''}">예약중</a>
                        <a href="?tradeStatus=판매완료&schType=${schType}&kwd=${kwd}"
                           class="status-tab ${tradeStatus == '판매완료' ? 'active' : ''}">판매완료</a>
                        <a href="?tradeStatus=숨기기&schType=${schType}&kwd=${kwd}"
                           class="status-tab ${tradeStatus == '숨기기' ? 'active' : ''}">숨김</a>
                    </div>
                    <div class="search-group">
                        <input type="hidden" name="schType" id="tradeSchTypeInput" value="${schType}">
                        <div class="adm-dropdown" id="tradeSchType">
                            <button type="button" class="adm-dropdown-btn" onclick="admToggle('tradeSchType')">
                                <span id="tradeSchTypeLabel">통합검색</span>
                                <i class="ri-arrow-down-s-line adm-dropdown-arrow"></i>
                            </button>
                            <div class="adm-dropdown-menu">
                                <div class="adm-dropdown-item ${empty schType || schType == 'all' ? 'active' : ''}" data-value="all"      onclick="admSelect(this,'tradeSchType')">통합검색</div>
                                <div class="adm-dropdown-item ${schType == 'title'    ? 'active' : ''}" data-value="title"    onclick="admSelect(this,'tradeSchType')">제목</div>
                                <div class="adm-dropdown-item ${schType == 'content'  ? 'active' : ''}" data-value="content"  onclick="admSelect(this,'tradeSchType')">내용</div>
                                <div class="adm-dropdown-item ${schType == 'nickname' ? 'active' : ''}" data-value="nickname" onclick="admSelect(this,'tradeSchType')">닉네임</div>
                            </div>
                        </div>
                        <div class="search-input-wrap">
                            <i class="ri-search-2-line"></i>
                            <input type="text" name="kwd" class="fm-input"
                                   value="${kwd}" placeholder="게시글 검색...">
                        </div>
                        <input type="hidden" name="tradeStatus" value="${tradeStatus}">
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
                                <th>제목</th>
                                <th>판매자</th>
                                <th>가격</th>
                                <th>상태</th>
                                <th>등록일</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty list}">
                                <tr>
                                    <td colspan="7" class="empty-row">
                                        <i class="ri-shopping-bag-line"></i>
                                        <span>게시글이 없습니다.</span>
                                    </td>
                                </tr>
                            </c:if>
                            <c:forEach var="item" items="${list}">
                                <tr>
                                    <td class="font-medium">${item.productIdx}</td>
                                    <td>
                                        <span class="reason-cell" title="${item.title}"
                                              onclick="openDetail(${item.productIdx})"
                                              style="cursor:pointer;color:var(--color-primary);font-weight:600;">${item.title}</span>
                                    </td>
                                    <td>
                                        <div class="member-cell">
                                            <div class="member-avt">${fn:substring(item.nickName, 0, 1)}</div>
                                            <div class="member-name">${item.nickName}</div>
                                        </div>
                                    </td>
                                    <td class="font-medium">
                                        <c:choose>
                                            <c:when test="${item.price == 0}">무료나눔</c:when>
                                            <c:otherwise><fmt:formatNumber value="${item.price}" pattern="#,###"/>원</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.tradeStatus == '판매중'}"><span class="tag tag-green">판매중</span></c:when>
                                            <c:when test="${item.tradeStatus == '예약중'}"><span class="tag tag-blue">예약중</span></c:when>
                                            <c:when test="${item.tradeStatus == '판매완료'}"><span class="tag tag-gray">판매완료</span></c:when>
                                            <c:when test="${item.tradeStatus == '숨기기'}"><span class="tag" style="background:#FEF2F2;color:#EF4444;">숨김</span></c:when>
                                            <c:otherwise><span class="tag tag-gray">${item.tradeStatus}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="font-medium">
                                        <c:if test="${not empty item.createdDate}">${fn:substring(item.createdDate.toString(), 0, 10)}</c:if>
                                    </td>
                                    <td>
                                        <button type="button" class="action-btn"
                                                onclick="openAdminPanel(${item.productIdx})"
                                                title="관리"
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
                            <a href="?page=${page-1}&tradeStatus=${tradeStatus}&schType=${schType}&kwd=${kwd}" class="page-btn">
                                <i class="ri-arrow-left-s-line"></i>
                            </a>
                        </c:if>
                        <c:forEach begin="1" end="${total_page}" var="p">
                            <a href="?page=${p}&tradeStatus=${tradeStatus}&schType=${schType}&kwd=${kwd}"
                               class="page-btn ${p == page ? 'active' : ''}">${p}</a>
                        </c:forEach>
                        <c:if test="${page < total_page}">
                            <a href="?page=${page+1}&tradeStatus=${tradeStatus}&schType=${schType}&kwd=${kwd}" class="page-btn">
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
<div class="fullscreen-overlay" id="tradeDetailOverlay">
    <div id="tdModalBox" style="
        background:#fff;border-radius:24px;width:680px;max-width:96vw;
        height:84vh;max-height:860px;min-height:480px;display:flex;flex-direction:column;overflow:hidden;
        box-shadow:0 32px 80px rgba(0,0,0,0.26);
        transform:translateY(20px) scale(0.97);
        transition:transform 0.35s cubic-bezier(0.16,1,0.3,1),opacity 0.35s;
        opacity:0;">

        <!-- 헤더 -->
        <div id="tdHeader" style="
            background:linear-gradient(135deg,#1E1B4B 0%,#312E81 100%);
            padding:20px 24px 18px;flex-shrink:0;position:relative;overflow:hidden;">
            <div style="position:absolute;top:-30px;right:-30px;width:140px;height:140px;border-radius:50%;background:rgba(255,255,255,0.04);pointer-events:none;"></div>
            <div style="display:flex;align-items:flex-start;justify-content:space-between;gap:12px;position:relative;">
                <div style="display:flex;align-items:center;gap:12px;min-width:0;">
                    <div style="width:38px;height:38px;border-radius:12px;background:rgba(165,180,252,0.15);border:1px solid rgba(165,180,252,0.2);display:flex;align-items:center;justify-content:center;font-size:18px;color:#A5B4FC;flex-shrink:0;">
                        <i class="ri-shopping-bag-3-line"></i>
                    </div>
                    <div style="min-width:0;">
                        <div style="font-size:9px;font-weight:700;letter-spacing:0.14em;color:rgba(255,255,255,0.3);margin-bottom:4px;">TRADE ARTICLE</div>
                        <div id="tdTitle" style="font-size:16px;font-weight:800;color:#fff;letter-spacing:-0.3px;line-height:1.3;word-break:break-word;"></div>
                    </div>
                </div>
                <button id="tdClose" style="
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
                <div id="tdStatusChip"></div>
                <div id="tdTypeChip"></div>
                <div id="tdDongChip"></div>
                <div style="margin-left:auto;display:flex;align-items:center;gap:10px;">
                    <span id="tdViewStat" style="display:flex;align-items:center;gap:4px;font-size:12px;color:rgba(255,255,255,0.45);"></span>
                    <span id="tdLikeStat" style="display:flex;align-items:center;gap:4px;font-size:12px;color:rgba(255,255,255,0.45);"></span>
                    <span id="tdChatStat" style="display:flex;align-items:center;gap:4px;font-size:12px;color:rgba(255,255,255,0.45);"></span>
                </div>
            </div>
        </div>

        <!-- 바디 -->
        <div style="flex:1;overflow-y:auto;padding:0;" id="tdScrollBody">

            <!-- 작성자 -->
            <div style="padding:16px 24px 14px;border-bottom:1px solid #F1F5F9;display:flex;align-items:center;gap:12px;">
                <div id="tdAvatar" style="width:40px;height:40px;border-radius:50%;background:linear-gradient(135deg,#7C3AED,#6D28D9);color:#fff;display:flex;align-items:center;justify-content:center;font-size:16px;font-weight:800;flex-shrink:0;box-shadow:0 4px 12px rgba(124,58,237,0.3);"></div>
                <div>
                    <div id="tdWriter" style="font-size:14px;font-weight:800;color:#1E293B;"></div>
                    <div id="tdWriterSub" style="font-size:11px;color:#94A3B8;margin-top:1px;"></div>
                </div>
                <div id="tdPriceBox" style="margin-left:auto;"></div>
            </div>

            <!-- 본문 -->
            <div style="padding:20px 24px;border-bottom:1px solid #F1F5F9;">
                <div id="tdContent" style="font-size:14px;color:#334155;line-height:1.85;word-break:break-word;"></div>
            </div>

            <!-- 이미지 -->
            <div id="tdImageWrap" style="display:none;padding:16px 24px;border-bottom:1px solid #F1F5F9;">
                <div style="font-size:11px;font-weight:700;color:#94A3B8;text-transform:uppercase;letter-spacing:0.08em;margin-bottom:10px;display:flex;align-items:center;gap:5px;">
                    <i class="ri-image-line"></i>상품 이미지
                </div>
                <div id="tdImages" style="display:flex;flex-wrap:wrap;gap:8px;"></div>
            </div>

            <!-- 태그 -->
            <div id="tdTagWrap" style="display:none;padding:14px 24px;border-bottom:1px solid #F1F5F9;">
                <div id="tdTags" style="display:flex;flex-wrap:wrap;gap:6px;"></div>
            </div>

            <!-- 거래정보 -->
            <div id="tdInfoWrap" style="padding:16px 24px 24px;">
                <div style="font-size:11px;font-weight:700;color:#94A3B8;text-transform:uppercase;letter-spacing:0.08em;margin-bottom:12px;display:flex;align-items:center;gap:5px;">
                    <i class="ri-information-line"></i>거래 정보
                </div>
                <div id="tdInfoGrid" style="display:grid;grid-template-columns:1fr 1fr;gap:10px;"></div>
            </div>
        </div>

        <!-- 푸터 -->
        <div style="padding:12px 20px;border-top:1px solid #F1F5F9;display:flex;justify-content:space-between;align-items:center;flex-shrink:0;background:#FAFAFA;">
            <button id="tdDeleteBtn" style="
                display:inline-flex;align-items:center;gap:6px;
                padding:9px 18px;border-radius:10px;
                border:1.5px solid #FEE2E2;background:#FFF5F5;
                font-size:13px;font-weight:600;color:#EF4444;
                cursor:pointer;font-family:inherit;transition:all 0.15s;"
                onmouseover="this.style.background='#FEE2E2';"
                onmouseout="this.style.background='#FFF5F5';">
                <i class="ri-delete-bin-line"></i>삭제
            </button>
            <button id="tdCancel" style="
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
<div class="fullscreen-overlay" id="tradeDeleteOverlay">
    <div class="mini-modal">
        <div class="mini-modal-head">
            <span class="mini-modal-title"><i class="ri-delete-bin-line"></i>게시글 삭제</span>
            <button class="mini-modal-close" id="tradeDeleteClose"><i class="ri-close-line"></i></button>
        </div>
        <div class="mini-modal-body">
            <p style="font-size:14px;color:var(--text-sub);margin-bottom:4px;">
                아래 게시글을 삭제합니다. 이 작업은 되돌릴 수 없습니다.
            </p>
            <p style="font-size:14px;color:var(--text-main);font-weight:700;" id="tradeDeleteTargetTitle"></p>
        </div>
        <div class="mini-modal-foot">
            <button class="btn-pill btn-light" id="tradeDeleteCancel">취소</button>
            <button class="btn-pill" style="background:var(--color-red);color:white;padding:12px 24px;" id="tradeDeleteConfirm">
                <i class="ri-delete-bin-line"></i> 삭제
            </button>
        </div>
    </div>
</div>

<div class="fullscreen-overlay" id="tradeAdminOverlay">
    <div class="rpt-modal" style="width:480px;">
        <div class="rpt-modal-header">
            <div class="rpt-header-left">
                <div class="rpt-header-icon"><i class="ri-shopping-bag-3-line"></i></div>
                <div>
                    <p class="rpt-header-eyebrow">TRADE DETAIL</p>
                    <p class="rpt-header-title" id="taTitle">중고거래 관리</p>
                </div>
            </div>
            <button class="rpt-close-btn" id="taClose"
                onmouseover="this.style.background='rgba(239,68,68,0.22)';this.style.color='#FCA5A5';"
                onmouseout="this.style.background='rgba(255,255,255,0.07)';this.style.color='rgba(255,255,255,0.35)';">
                <i class="ri-close-line"></i>
            </button>
        </div>
        <div class="rpt-modal-body">
            <div class="rpt-info-list" id="taInfoList">
                <div style="padding:20px 0;text-align:center;color:#94A3B8;font-size:13px;">로딩 중...</div>
            </div>
            <div class="rpt-divider"></div>
            <div class="rpt-field" id="taImageWrap" style="display:none;">
                <p class="rpt-field-label"><i class="ri-image-line" style="margin-right:4px;"></i>상품 이미지</p>
                <div id="taImages" style="display:flex;flex-wrap:wrap;gap:8px;margin-top:6px;"></div>
            </div>
            <div class="rpt-divider" id="taImageDivider" style="display:none;"></div>
            <div class="rpt-field">
                <p class="rpt-field-label">본문 내용</p>
                <div class="rpt-field-box" id="taContent">-</div>
            </div>
        </div>
        <div class="rpt-modal-footer">
            <button class="rpt-btn-cancel" id="taCancel">닫기</button>
            <div class="rpt-footer-actions">
                <button class="rpt-btn-reject" id="taDeleteBtn">
                    <i class="ri-delete-bin-line"></i> 삭제
                </button>
            </div>
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
    var map = { all: '통합검색', title: '제목', content: '내용', nickname: '닉네임' };
    var inp = document.getElementById('tradeSchTypeInput');
    if (inp && map[inp.value]) document.getElementById('tradeSchTypeLabel').textContent = map[inp.value];
    document.addEventListener('click', function(e) {
        document.querySelectorAll('.adm-dropdown.open').forEach(function(dd) {
            if (!dd.contains(e.target)) dd.classList.remove('open');
        });
    });
});
</script>
<script src="${pageContext.request.contextPath}/dist/js/admin/trade_list.js"></script>
</body>
</html>
