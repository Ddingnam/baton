<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>BATON Studio · 전체 회원 목록</title>
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
                    <h1 class="hero-title">Member List</h1>
                    <p class="hero-subtitle">전체 회원 현황을 조회하고 관리합니다.</p>
                </div>
            </div>

            <div class="member-stat-row">
                <div class="member-stat-card" onclick="filterByStatus('')">
                    <div class="msc-icon purple"><i class="ri-group-fill"></i></div>
                    <div class="msc-info">
                        <span class="msc-val">${totalCount}</span>
                        <span class="msc-lbl">전체 회원</span>
                    </div>
                </div>
                <div class="member-stat-card" onclick="filterByStatus(1)">
                    <div class="msc-icon green"><i class="ri-user-smile-fill"></i></div>
                    <div class="msc-info">
                        <span class="msc-val" id="countNormal">-</span>
                        <span class="msc-lbl">정상</span>
                    </div>
                </div>
                <div class="member-stat-card" onclick="filterByStatus(2)">
                    <div class="msc-icon red"><i class="ri-forbid-fill"></i></div>
                    <div class="msc-info">
                        <span class="msc-val" id="countBan">-</span>
                        <span class="msc-lbl">제재</span>
                    </div>
                </div>
                <div class="member-stat-card" onclick="filterByStatus(9)">
                    <div class="msc-icon gray"><i class="ri-user-unfollow-fill"></i></div>
                    <div class="msc-info">
                        <span class="msc-val" id="countOut">-</span>
                        <span class="msc-lbl">탈퇴</span>
                    </div>
                </div>
            </div>

            <div class="member-toolbar block-card">
                <form class="toolbar-form" id="searchForm" method="get" action="${pageContext.request.contextPath}/admin/member/list">
                    <div class="status-tabs">
                        <a href="?schType=${schType}&kwd=${kwd}" class="status-tab ${empty status ? 'active' : ''}">전체</a>
                        <a href="?status=1&schType=${schType}&kwd=${kwd}" class="status-tab ${status == '1' ? 'active' : ''}">
                            <span class="tab-dot green"></span>정상
                        </a>
                        <a href="?status=2&schType=${schType}&kwd=${kwd}" class="status-tab ${status == '2' ? 'active' : ''}">
                            <span class="tab-dot red"></span>제재
                        </a>
                        <a href="?status=9&schType=${schType}&kwd=${kwd}" class="status-tab ${status == '9' ? 'active' : ''}">
                            <span class="tab-dot gray"></span>탈퇴
                        </a>
                    </div>
                    <input type="hidden" name="status" value="${status}">
                    <div class="search-group">
                        <select name="schType" class="fm-input search-select">
                            <option value="all"      ${schType == 'all'      ? 'selected' : ''}>통합검색</option>
                            <option value="userId"   ${schType == 'userId'   ? 'selected' : ''}>아이디</option>
                            <option value="nickname" ${schType == 'nickname' ? 'selected' : ''}>닉네임</option>
                            <option value="email"    ${schType == 'email'    ? 'selected' : ''}>이메일</option>
                        </select>
                        <div class="search-input-wrap">
                            <i class="ri-search-2-line"></i>
                            <input type="text" name="kwd" class="fm-input" value="${kwd}" placeholder="회원 검색...">
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
                                <th>회원</th>
                                <th>아이디</th>
                                <th>이메일</th>
                                <th>권한</th>
                                <th>레벨</th>
                                <th>가입일</th>
                                <th>상태</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty list}">
                                <tr>
                                    <td colspan="8" class="empty-row">
                                        <i class="ri-user-search-line"></i>
                                        <span>검색 결과가 없습니다.</span>
                                    </td>
                                </tr>
                            </c:if>
                            <c:forEach var="m" items="${list}">
                                <tr>
                                    <td>
                                        <div class="member-cell">
                                            <div class="member-avt">${fn:substring(m.nickname, 0, 1)}</div>
                                            <div>
                                                <div class="member-name">${m.nickname}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="font-medium">${m.userId}</td>
                                    <td class="font-medium">${m.email}</td>
                                    <td>
                                        <span class="auth-badge ${m.authority == 'ADMIN' ? 'admin' : 'user'}">
                                            ${m.authority == 'ADMIN' ? '관리자' : '일반'}
                                        </span>
                                    </td>
                                    <td class="font-medium">Lv.${m.userLevel}</td>
                                    <td class="font-medium">${fn:substring(m.createdDate, 0, 10)}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${m.status == 1}"><span class="tag tag-green">정상</span></c:when>
                                            <c:when test="${m.status == 2}"><span class="tag tag-red">제재</span></c:when>
                                            <c:when test="${m.status == 9}"><span class="tag tag-gray">탈퇴</span></c:when>
                                            <c:otherwise><span class="tag tag-gray">-</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <button class="action-btn" onclick="openDetail('${m.userIdx}')" title="상세보기">
										    <i class="ri-eye-line"></i>
										</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <c:if test="${totalPages > 1}">
                    <div class="pagination">
                        <c:if test="${page > 1}">
                            <a href="?page=${page-1}&status=${status}&schType=${schType}&kwd=${kwd}" class="page-btn">
                                <i class="ri-arrow-left-s-line"></i>
                            </a>
                        </c:if>
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <a href="?page=${p}&status=${status}&schType=${schType}&kwd=${kwd}"
                               class="page-btn ${p == page ? 'active' : ''}">${p}</a>
                        </c:forEach>
                        <c:if test="${page < totalPages}">
                            <a href="?page=${page+1}&status=${status}&schType=${schType}&kwd=${kwd}" class="page-btn">
                                <i class="ri-arrow-right-s-line"></i>
                            </a>
                        </c:if>
                    </div>
                </c:if>
            </div>

        </div>
    </main>
</div>

<div class="fullscreen-overlay" id="detailOverlay">
    <div class="member-detail-modal">
        <button class="fm-close" id="detailClose"><i class="ri-close-line"></i></button>

        <div class="detail-left">
            <div class="detail-avt" id="dAvt"></div>
            <div class="detail-name" id="dName"></div>
            <div class="detail-id" id="dId"></div>
            <span class="detail-status-badge" id="dStatusBadge"></span>
            <div class="detail-stats">
                <div class="detail-stat">
                    <span class="stat-val" id="dLevel"></span>
                    <span class="stat-lbl">레벨</span>
                </div>
                
                <div class="detail-stat" style="flex: 1.5;">
                    <span class="stat-lbl">매너온도</span>
                    <span class="stat-val" id="dScoreText" style="margin-top:2px;"></span>
                    <div class="manner-temp-wrap">
                        <div class="manner-bar-bg">
                            <div class="manner-bar-fill" id="dScoreBar"></div>
                        </div>
                    </div>
                </div>

                <div class="detail-stat">
                    <span class="stat-val" id="dPoint"></span>
                    <span class="stat-lbl">포인트</span>
                </div>
            </div>
            <div class="detail-actions">
                <button class="btn-pill btn-danger" id="btnSuspend" style="display:none;">
                    <i class="ri-forbid-line"></i> 제재하기
                </button>
                <button class="btn-pill btn-success" id="btnActivate" style="display:none;">
                    <i class="ri-check-line"></i> 정상화
                </button>
            </div>
        </div>

        <div class="detail-right">
            <div class="detail-tabs">
                <button class="detail-tab-btn active" data-pane="paneInfo">기본 정보</button>
                <button class="detail-tab-btn" data-pane="paneSanction">제재 처리</button>
            </div>

            <div class="detail-pane active" id="paneInfo">
                <h3 class="detail-section-title"><i class="ri-user-3-line"></i> 기본 정보</h3>
                <div class="detail-info-grid">
                    <div class="info-row"><span class="info-lbl">이메일</span><span class="info-val" id="dEmail"></span></div>
                    <div class="info-row"><span class="info-lbl">전화번호</span><span class="info-val" id="dTel"></span></div>
                    <div class="info-row"><span class="info-lbl">생년월일</span><span class="info-val" id="dBirth"></span></div>
                    <div class="info-row"><span class="info-lbl">가입일</span><span class="info-val" id="dCreated"></span></div>
                    <div class="info-row"><span class="info-lbl">최근 로그인</span><span class="info-val" id="dLastLogin"></span></div>
                    <div class="info-row">
                        <span class="info-lbl">권한</span>
                        <span class="info-val">
                            <select class="fm-input" id="dAuthority" style="height:38px;padding:0 12px;font-size:13px;width:130px;">
                                <option value="USER">일반 회원</option>
                                <option value="ADMIN">관리자</option>
                            </select>
                            <button class="btn-pill btn-gradient" style="height:38px;padding:0 16px;font-size:12px;" onclick="saveAuthority()">
                                저장
                            </button>
                        </span>
                    </div>
                </div>
            </div>

            <div class="detail-pane" id="paneSanction">
                <h3 class="detail-section-title"><i class="ri-forbid-line"></i> 제재 처리</h3>
                <div class="sanction-form-box">
                    <div class="fm-section">
                        <div class="fm-field">
                            <label class="fm-label">제재 유형</label>
                            <select class="fm-input" id="sanctionType">
                                <option value="TEMPORARY">기간 정지</option>
                                <option value="PERMANENT">영구 정지</option>
                            </select>
                        </div>
                        <div class="fm-field" id="daysField">
                            <label class="fm-label">정지 기간</label>
                            <select class="fm-input" id="sanctionDays">
                                <option value="3">3일</option>
                                <option value="7">7일</option>
                                <option value="14">14일</option>
                                <option value="30">30일</option>
                            </select>
                        </div>
                        <div class="fm-field">
                            <label class="fm-label">제재 사유</label>
                            <textarea class="fm-input" id="sanctionReason" rows="3" placeholder="제재 사유를 구체적으로 입력하세요"></textarea>
                            <div class="fm-helper error" id="reasonError">
                                <i class="ri-error-warning-line"></i> 제재 사유를 입력해주세요.
                            </div>
                        </div>
                        <div class="sanction-btns">
                            <button class="btn-pill btn-light" onclick="switchPane('paneInfo')">취소</button>
                            <button class="btn-pill" style="background:var(--color-red);color:white;padding:12px 24px;" onclick="submitSanction()">
                                <i class="ri-forbid-line"></i> 제재 적용
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>var CTX = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/dist/js/admin/admin_main.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/admin/member_list.js"></script>
</body>
</html>