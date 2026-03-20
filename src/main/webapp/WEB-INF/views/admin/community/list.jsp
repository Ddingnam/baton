<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>BATON Studio · 커뮤니티 관리</title>
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
                    <h1 class="hero-title">Community</h1>
                    <p class="hero-subtitle">총 <strong>${dataCount}</strong>건의 커뮤니티 게시글이 있습니다.</p>
                </div>
            </div>

            <div class="member-toolbar block-card">
                <form class="toolbar-form" method="get"
                      action="${pageContext.request.contextPath}/admin/community/list">
                    <div class="status-tabs">
                        <a href="?schType=${schType}&kwd=${kwd}"
                           class="status-tab ${empty category ? 'active' : ''}">전체</a>
                        <a href="?category=일상&schType=${schType}&kwd=${kwd}"
                           class="status-tab ${category == '일상' ? 'active' : ''}">일상</a>
                        <a href="?category=동네질문&schType=${schType}&kwd=${kwd}"
                           class="status-tab ${category == '동네질문' ? 'active' : ''}">동네질문</a>
                        <a href="?category=동네맛집&schType=${schType}&kwd=${kwd}"
                           class="status-tab ${category == '동네맛집' ? 'active' : ''}">동네맛집</a>
                        <a href="?category=같이해요&schType=${schType}&kwd=${kwd}"
                           class="status-tab ${category == '같이해요' ? 'active' : ''}">같이해요</a>
                        <a href="?category=분실/실종&schType=${schType}&kwd=${kwd}"
                           class="status-tab ${category == '분실/실종' ? 'active' : ''}">분실/실종</a>
                        <a href="?category=동네사건사고&schType=${schType}&kwd=${kwd}"
                           class="status-tab ${category == '동네사건사고' ? 'active' : ''}">동네사건사고</a>
                        <a href="?category=생활정보&schType=${schType}&kwd=${kwd}"
                           class="status-tab ${category == '생활정보' ? 'active' : ''}">생활정보</a>
                        <a href="?category=취미생활&schType=${schType}&kwd=${kwd}"
                           class="status-tab ${category == '취미생활' ? 'active' : ''}">취미생활</a>
                    </div>
                    <div class="search-group">
                        <input type="hidden" name="schType" id="communitySchTypeInput" value="${schType}">
                        <div class="adm-dropdown" id="communitySchType">
                            <button type="button" class="adm-dropdown-btn" onclick="admToggle('communitySchType')">
                                <span id="communitySchTypeLabel">통합검색</span>
                                <i class="ri-arrow-down-s-line adm-dropdown-arrow"></i>
                            </button>
                            <div class="adm-dropdown-menu">
                                <div class="adm-dropdown-item ${empty schType || schType == 'all' ? 'active' : ''}" data-value="all" onclick="admSelect(this,'communitySchType')">통합검색</div>
                                <div class="adm-dropdown-item ${schType == 'subject' ? 'active' : ''}" data-value="subject" onclick="admSelect(this,'communitySchType')">제목</div>
                                <div class="adm-dropdown-item ${schType == 'content' ? 'active' : ''}" data-value="content" onclick="admSelect(this,'communitySchType')">내용</div>
                            </div>
                        </div>
                        <div class="search-input-wrap">
                            <i class="ri-search-2-line"></i>
                            <input type="text" name="kwd" class="fm-input"
                                   value="${kwd}" placeholder="게시글 검색...">
                        </div>
                        <input type="hidden" name="category" value="${category}">
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
                                <th>카테고리</th>
                                <th>제목</th>
                                <th>작성자</th>
                                <th>동네(장소)</th>
                                <th>조회</th>
                                <th>좋아요</th>
                                <th>작성일</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty list}">
                                <tr>
                                    <td colspan="9" class="empty-row">
                                        <i class="ri-article-line"></i>
                                        <span>게시글이 없습니다.</span>
                                    </td>
                                </tr>
                            </c:if>
                            <c:forEach var="item" items="${list}">
                                <tr>
                                    <td class="font-medium">${item.id}</td>
                                    <td>
                                        <span class="tag tag-blue">
                                            <c:choose>
                                                <c:when test="${item.category == '1' || item.category == '일상'}">일상</c:when>
                                                <c:when test="${item.category == '2' || item.category == '동네질문'}">동네질문</c:when>
                                                <c:when test="${item.category == '3' || item.category == '동네맛집'}">동네맛집</c:when>
                                                <c:when test="${item.category == '4' || item.category == '같이해요'}">같이해요</c:when>
                                                <c:when test="${item.category == '5' || item.category == '분실/실종'}">분실/실종</c:when>
                                                <c:when test="${item.category == '6' || item.category == '동네사건사고'}">동네사건사고</c:when>
                                                <c:when test="${item.category == '7' || item.category == '생활정보'}">생활정보</c:when>
                                                <c:when test="${item.category == '8' || item.category == '취미생활'}">취미생활</c:when>
                                                <c:otherwise>${not empty item.category ? item.category : '기타'}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="reason-cell community-title-link" title="${item.subject}" onclick="openDetail(${item.id})" style="cursor:pointer;color:var(--color-primary);font-weight:600;">${item.subject}</span>
                                    </td>
                                    <td>
                                        <div class="member-cell">
                                            <div class="member-avt">${fn:substring(item.writerNickname, 0, 1)}</div>
                                            <div class="member-name">${item.writerNickname}</div>
                                        </div>
                                    </td>
                                    <td class="font-medium">
                                        <c:choose>
                                            <c:when test="${not empty item.dong}">
                                                <span>${item.dong}</span>
                                            </c:when>
                                            <c:when test="${not empty item.placeName}">
                                                <span title="${item.address}">${item.placeName}</span>
                                            </c:when>
                                            <c:otherwise><span class="tag tag-gray">미설정</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="font-medium">${item.hitCount}</td>
                                    <td class="font-medium">${item.likeCount}</td>
                                    <td class="font-medium">
                                        <c:if test="${not empty item.regDate}">
                                            ${fn:substring(item.regDate.toString(), 0, 10)}
                                        </c:if>
                                    </td>
                                    <td>
                                        <button type="button" class="action-btn"
                                                onclick="confirmDelete(${item.id}, '${fn:escapeXml(item.subject)}')"
                                                title="삭제">
                                            <i class="ri-delete-bin-line"></i>
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
                            <a href="?page=${page-1}&category=${category}&schType=${schType}&kwd=${kwd}" class="page-btn">
                                <i class="ri-arrow-left-s-line"></i>
                            </a>
                        </c:if>
                        <c:forEach begin="1" end="${total_page}" var="p">
                            <a href="?page=${p}&category=${category}&schType=${schType}&kwd=${kwd}"
                               class="page-btn ${p == page ? 'active' : ''}">${p}</a>
                        </c:forEach>
                        <c:if test="${page < total_page}">
                            <a href="?page=${page+1}&category=${category}&schType=${schType}&kwd=${kwd}" class="page-btn">
                                <i class="ri-arrow-right-s-line"></i>
                            </a>
                        </c:if>
                    </div>
                </c:if>
            </div>

        </div>
    </main>
</div>

<div class="fullscreen-overlay" id="communityDetailOverlay">
    <div id="cdModalBox" style="
        background:#fff;border-radius:24px;width:660px;max-width:96vw;
        height:82vh;max-height:820px;min-height:480px;display:flex;flex-direction:column;overflow:hidden;
        box-shadow:0 32px 80px rgba(0,0,0,0.26);
        transform:translateY(20px) scale(0.97);
        transition:transform 0.35s cubic-bezier(0.16,1,0.3,1),opacity 0.35s;
        opacity:0;">

        
        <div id="cdHeader" style="
            background:linear-gradient(135deg,#1E1B4B 0%,#312E81 100%);
            padding:20px 24px 18px;flex-shrink:0;position:relative;overflow:hidden;">
            <div style="position:absolute;top:-30px;right:-30px;width:140px;height:140px;border-radius:50%;background:rgba(255,255,255,0.04);pointer-events:none;"></div>
            <div style="position:absolute;bottom:-50px;left:60px;width:200px;height:200px;border-radius:50%;background:rgba(255,255,255,0.03);pointer-events:none;"></div>
            <div style="display:flex;align-items:flex-start;justify-content:space-between;gap:12px;position:relative;">
                <div style="display:flex;align-items:center;gap:12px;min-width:0;">
                    <div style="width:38px;height:38px;border-radius:12px;background:rgba(165,180,252,0.15);border:1px solid rgba(165,180,252,0.2);display:flex;align-items:center;justify-content:center;font-size:18px;color:#A5B4FC;flex-shrink:0;">
                        <i class="ri-article-line"></i>
                    </div>
                    <div style="min-width:0;">
                        <div style="font-size:9px;font-weight:700;letter-spacing:0.14em;color:rgba(255,255,255,0.3);margin-bottom:4px;">COMMUNITY ARTICLE</div>
                        <div id="cdTitle" style="font-size:16px;font-weight:800;color:#fff;letter-spacing:-0.3px;line-height:1.3;word-break:break-word;"></div>
                    </div>
                </div>
                <button id="cdClose" style="
                    width:30px;height:30px;border-radius:8px;flex-shrink:0;
                    background:rgba(255,255,255,0.08);border:1px solid rgba(255,255,255,0.1);
                    display:flex;align-items:center;justify-content:center;
                    font-size:16px;color:rgba(255,255,255,0.4);cursor:pointer;
                    transition:all 0.15s;"
                    onmouseover="this.style.background='rgba(239,68,68,0.25)';this.style.color='#FCA5A5';"
                    onmouseout="this.style.background='rgba(255,255,255,0.08)';this.style.color='rgba(255,255,255,0.4)';">
                    <i class="ri-close-line"></i>
                </button>
            </div>
            
            <div style="display:flex;align-items:center;gap:8px;margin-top:14px;flex-wrap:wrap;position:relative;">
                <div id="cdCategoryChip"></div>
                <div id="cdDongChip"></div>
                <div id="cdDateChip"></div>
                <div style="margin-left:auto;display:flex;align-items:center;gap:10px;">
                    <span id="cdViewStat" style="display:flex;align-items:center;gap:4px;font-size:12px;color:rgba(255,255,255,0.45);"></span>
                    <span id="cdLikeStat" style="display:flex;align-items:center;gap:4px;font-size:12px;color:rgba(255,255,255,0.45);"></span>
                </div>
            </div>
        </div>

        
        <div style="flex:1;overflow-y:auto;padding:0;" id="cdScrollBody">

            
            <div style="padding:16px 24px 14px;border-bottom:1px solid #F1F5F9;display:flex;align-items:center;gap:12px;">
                <div id="cdAvatar" style="width:40px;height:40px;border-radius:50%;background:linear-gradient(135deg,#7C3AED,#6D28D9);color:#fff;display:flex;align-items:center;justify-content:center;font-size:16px;font-weight:800;flex-shrink:0;box-shadow:0 4px 12px rgba(124,58,237,0.3);"></div>
                <div>
                    <div id="cdWriter" style="font-size:14px;font-weight:800;color:#1E293B;"></div>
                    <div id="cdWriterSub" style="font-size:11px;color:#94A3B8;margin-top:1px;"></div>
                </div>
            </div>

            
            <div style="padding:20px 24px;border-bottom:1px solid #F1F5F9;">
                <div id="cdContent" style="font-size:14px;color:#334155;line-height:1.85;word-break:break-word;"></div>
            </div>

            
            <div id="cdPollWrap" style="display:none;padding:16px 24px;border-bottom:1px solid #F1F5F9;">
                <div style="background:linear-gradient(135deg,#F5F3FF,#EDE9FE);border:1px solid #DDD6FE;border-radius:16px;padding:18px 20px;">
                    <div style="display:flex;align-items:center;gap:8px;margin-bottom:14px;">
                        <div style="width:28px;height:28px;border-radius:8px;background:#7C3AED;color:#fff;display:flex;align-items:center;justify-content:center;font-size:13px;"><i class="ri-bar-chart-box-line"></i></div>
                        <span id="cdPollTitle" style="font-size:14px;font-weight:800;color:#4C1D95;"></span>
                        <span id="cdPollMeta" style="font-size:11px;color:#7C3AED;margin-left:auto;background:rgba(124,58,237,0.1);padding:3px 10px;border-radius:20px;font-weight:700;"></span>
                    </div>
                    <div id="cdPollOptions" style="display:flex;flex-direction:column;gap:8px;"></div>
                    <div id="cdPollFooter" style="margin-top:12px;font-size:11px;color:#7C3AED;display:flex;align-items:center;gap:12px;"></div>
                </div>
            </div>

            
            <div id="cdImageWrap" style="display:none;padding:16px 24px;border-bottom:1px solid #F1F5F9;">
                <div style="font-size:11px;font-weight:700;color:#94A3B8;text-transform:uppercase;letter-spacing:0.08em;margin-bottom:10px;display:flex;align-items:center;gap:5px;">
                    <i class="ri-image-line"></i>이미지
                </div>
                <div id="cdImages" style="display:flex;flex-wrap:wrap;gap:8px;"></div>
            </div>

            
            <div id="cdAttachWrap" style="display:none;padding:14px 24px;border-bottom:1px solid #F1F5F9;">
                <div style="font-size:11px;font-weight:700;color:#94A3B8;text-transform:uppercase;letter-spacing:0.08em;margin-bottom:10px;display:flex;align-items:center;gap:5px;">
                    <i class="ri-attachment-line"></i>첨부파일
                </div>
                <div id="cdAttaches" style="display:flex;flex-direction:column;gap:6px;"></div>
            </div>

            
            <div id="cdTagWrap" style="display:none;padding:14px 24px;border-bottom:1px solid #F1F5F9;">
                <div id="cdTags" style="display:flex;flex-wrap:wrap;gap:6px;"></div>
            </div>

            
            <div id="cdPlaceWrap" style="display:none;padding:14px 24px;border-bottom:1px solid #F1F5F9;">
                <div style="display:flex;align-items:center;gap:10px;background:#F8FAFC;border:1px solid #E2E8F0;border-radius:12px;padding:12px 14px;cursor:pointer;"
                     id="cdPlaceBox">
                    <div style="width:32px;height:32px;border-radius:10px;background:#DBEAFE;color:#3B82F6;display:flex;align-items:center;justify-content:center;font-size:15px;flex-shrink:0;"><i class="ri-map-pin-2-fill"></i></div>
                    <div>
                        <div id="cdPlaceName" style="font-size:13px;font-weight:700;color:#1E293B;"></div>
                        <div id="cdPlaceAddr" style="font-size:11px;color:#94A3B8;margin-top:2px;"></div>
                    </div>
                    <i class="ri-external-link-line" style="margin-left:auto;color:#CBD5E1;font-size:14px;"></i>
                </div>
            </div>

            
            <div style="padding:16px 24px 24px;">
                <div style="display:flex;align-items:center;gap:8px;margin-bottom:14px;">
                    <i class="ri-chat-3-line" style="font-size:15px;color:#94A3B8;"></i>
                    <span style="font-size:12px;font-weight:700;color:#64748B;text-transform:uppercase;letter-spacing:0.06em;">댓글</span>
                    <span id="cdReplyCount" style="font-size:12px;font-weight:800;color:#7C3AED;background:#EDE9FE;padding:2px 9px;border-radius:20px;"></span>
                </div>
                <div id="cdReplies" style="display:flex;flex-direction:column;gap:6px;"></div>
            </div>
        </div>

        
        <div style="padding:12px 20px;border-top:1px solid #F1F5F9;display:flex;justify-content:flex-end;flex-shrink:0;background:#FAFAFA;">
            <button id="cdCancel" style="
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

<div class="fullscreen-overlay" id="deleteOverlay">
    <div class="mini-modal">
        <div class="mini-modal-head">
            <span class="mini-modal-title"><i class="ri-delete-bin-line"></i>게시글 삭제</span>
            <button class="mini-modal-close" id="deleteClose"><i class="ri-close-line"></i></button>
        </div>
        <div class="mini-modal-body">
            <p style="font-size:14px;color:var(--text-sub);margin-bottom:4px;">
                아래 게시글을 삭제합니다. 이 작업은 되돌릴 수 없습니다.
            </p>
            <p style="font-size:14px;color:var(--text-main);font-weight:700;" id="deleteTargetTitle"></p>
        </div>
        <div class="mini-modal-foot">
            <button class="btn-pill btn-light" id="deleteCancel">취소</button>
            <button class="btn-pill" style="background:var(--color-red);color:white;padding:12px 24px;" id="deleteConfirm">
                <i class="ri-delete-bin-line"></i> 삭제
            </button>
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
    var map = { all: '통합검색', subject: '제목', content: '내용' };
    var inp = document.getElementById('communitySchTypeInput');
    if (inp && map[inp.value]) document.getElementById('communitySchTypeLabel').textContent = map[inp.value];
    document.addEventListener('click', function(e) {
        document.querySelectorAll('.adm-dropdown.open').forEach(function(dd) {
            if (!dd.contains(e.target)) dd.classList.remove('open');
        });
    });
});
</script>
<script src="${pageContext.request.contextPath}/dist/js/admin/community_list.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/admin/community_detail.js"></script>
</body>
</html>
