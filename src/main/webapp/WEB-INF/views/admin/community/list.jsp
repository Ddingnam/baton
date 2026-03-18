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
                        <select name="schType" class="fm-input search-select">
                            <option value="all"     ${schType == 'all'     ? 'selected' : ''}>통합검색</option>
                            <option value="subject" ${schType == 'subject' ? 'selected' : ''}>제목</option>
                            <option value="content" ${schType == 'content' ? 'selected' : ''}>내용</option>
                        </select>
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
                                        <span class="reason-cell" title="${item.subject}">${item.subject}</span>
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

<div class="fullscreen-overlay" id="deleteOverlay">
    <div class="mini-modal">
        <div class="mini-modal-head">
            <span class="mini-modal-title">
                <i class="ri-delete-bin-line" style="color:var(--color-red);margin-right:6px;"></i>게시글 삭제
            </span>
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
<script src="${pageContext.request.contextPath}/dist/js/admin/community_list.js"></script>
</body>
</html>
