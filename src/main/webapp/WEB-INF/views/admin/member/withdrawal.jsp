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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_ui.css">
    <style>
        :root { --color-red-light: #FEE2E2; }

        .wd-review-modal {
            width: 680px;
            max-width: 96vw;
            max-height: 88vh;
            background: white;
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 40px 80px rgba(0,0,0,0.25);
            transform: translateY(24px) scale(0.97);
            transition: all 0.4s var(--spring);
            display: flex;
            flex-direction: column;
        }
        .fullscreen-overlay.show .wd-review-modal {
            transform: translateY(0) scale(1);
        }
        .wd-modal-head {
            padding: 18px 24px 16px;
            background: linear-gradient(135deg, #1E1B4B 0%, #312E81 100%);
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-shrink: 0;
            position: relative;
            overflow: hidden;
        }
        .wd-modal-head::before {
            content: ''; position: absolute;
            top: -25px; right: -25px;
            width: 110px; height: 110px; border-radius: 50%;
            background: rgba(255,255,255,0.04); pointer-events: none;
        }
        .wd-modal-head-left { display: flex; align-items: center; gap: 12px; position: relative; }
        .wd-modal-avt {
            width: 40px; height: 40px; border-radius: 50%;
            background: rgba(165,180,252,0.18);
            border: 1px solid rgba(165,180,252,0.25);
            color: #A5B4FC;
            display: flex; align-items: center; justify-content: center;
            font-size: 17px; font-weight: 800; flex-shrink: 0;
        }
        .wd-modal-name { font-size: 15px; font-weight: 800; color: #fff; }
        .wd-modal-id   { font-size: 11px; color: rgba(255,255,255,0.4); margin-top: 2px; }

        .wd-modal-body {
            padding: 22px 28px;
            overflow-y: auto;
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 22px;
        }
        .wd-modal-body::-webkit-scrollbar { width: 4px; }
        .wd-modal-body::-webkit-scrollbar-thumb { background: var(--border-color); border-radius: 4px; }

        .wd-sec-title {
            font-size: 12px; font-weight: 800;
            color: var(--text-light);
            text-transform: uppercase;
            letter-spacing: 0.06em;
            margin-bottom: 10px;
            display: flex; align-items: center; gap: 6px;
        }
        .wd-sec-title i { font-size: 14px; color: var(--color-purple); }
        .wd-cnt {
            margin-left: auto;
            font-size: 11px; font-weight: 700;
            padding: 2px 8px; border-radius: var(--radius-pill);
        }
        .wd-cnt.has  { background: var(--color-red-light); color: var(--color-red); }
        .wd-cnt.none { background: var(--base-bg); color: var(--text-light); }

        .wd-empty {
            text-align: center; padding: 18px;
            color: var(--text-light); font-size: 13px; font-weight: 600;
            background: var(--base-bg); border-radius: var(--radius-sm);
        }

        .wd-reason-box {
            background: var(--base-bg); border-radius: var(--radius-sm);
            padding: 14px 16px; font-size: 13px; color: var(--text-sub); line-height: 1.6;
        }

        .wd-trade-item {
            background: var(--base-bg); border-radius: var(--radius-sm);
            padding: 13px 16px; display: flex; align-items: center; gap: 12px;
            margin-bottom: 8px;
        }
        .wd-trade-item:last-child { margin-bottom: 0; }
        .wd-trade-icon {
            width: 34px; height: 34px; border-radius: 8px;
            background: #FEF3C7; color: #F59E0B;
            display: flex; align-items: center; justify-content: center; font-size: 15px; flex-shrink: 0;
        }
        .wd-trade-title { font-size: 13px; font-weight: 700; color: var(--text-main); }
        .wd-trade-sub   { font-size: 12px; color: var(--text-light); margin-top: 2px; }
        .wd-trade-badge {
            font-size: 11px; font-weight: 700; padding: 3px 9px;
            border-radius: var(--radius-pill); background: #FEF3C7; color: #B45309; flex-shrink: 0;
        }

        .wd-report-item {
            background: var(--color-red-light); border-radius: var(--radius-sm);
            padding: 13px 16px; display: flex; align-items: flex-start; gap: 12px;
            margin-bottom: 8px;
        }
        .wd-report-item:last-child { margin-bottom: 0; }
        .wd-report-icon {
            width: 34px; height: 34px; border-radius: 8px;
            background: rgba(239,68,68,0.15); color: var(--color-red);
            display: flex; align-items: center; justify-content: center; font-size: 15px; flex-shrink: 0;
        }
        .wd-report-type    { font-size: 13px; font-weight: 700; color: #991B1B; }
        .wd-report-content { font-size: 12px; color: #7F1D1D; margin-top: 3px; line-height: 1.5; }
        .wd-report-meta    { font-size: 11px; color: var(--color-red); margin-top: 4px; opacity: 0.7; }

        .wd-modal-foot {
            padding: 14px 28px 20px;
            border-top: 1px solid var(--border-color);
            display: flex; justify-content: flex-end; gap: 10px; flex-shrink: 0;
        }
        .wd-loading {
            text-align: center; padding: 40px;
            color: var(--text-light); font-size: 13px;
        }
        .wd-loading i { font-size: 28px; display: block; margin-bottom: 10px; opacity: 0.4; }
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
                    <h1 class="hero-title">Withdrawal Requests</h1>
                    <p class="hero-subtitle">총 <strong>${totalCount}</strong>건의 탈퇴 요청이 있습니다.</p>
                </div>
            </div>

            <div class="member-toolbar block-card">
                <form class="toolbar-form" method="get"
                      action="${pageContext.request.contextPath}/admin/member/withdrawal">
                    <div class="status-tabs">
                        <a href="?kwd=${kwd}" class="status-tab ${empty wFilter ? 'active' : ''}">전체</a>
                        <a href="?wFilter=PENDING&kwd=${kwd}"
                           class="status-tab ${wFilter == 'PENDING' ? 'active' : ''}">
                            <span class="tab-dot blue"></span>대기중
                        </a>
                        <a href="?wFilter=APPROVED&kwd=${kwd}"
                           class="status-tab ${wFilter == 'APPROVED' ? 'active' : ''}">
                            <span class="tab-dot gray"></span>승인됨
                        </a>
                        <a href="?wFilter=REJECTED&kwd=${kwd}"
                           class="status-tab ${wFilter == 'REJECTED' ? 'active' : ''}">
                            <span class="tab-dot red"></span>반려됨
                        </a>
                    </div>
                    <div class="search-group">
                        <div class="search-input-wrap">
                            <i class="ri-search-2-line"></i>
                            <input type="text" name="kwd" class="fm-input"
                                   value="${kwd}" placeholder="아이디 또는 닉네임 검색">
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
                                <th>관리</th>
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
                                            <c:when test="${w.WITHDRAWSTATUS == 'PENDING'}">
                                                <span class="tag tag-blue">대기중</span>
                                            </c:when>
                                            <c:when test="${w.WITHDRAWSTATUS == 'APPROVED'}">
                                                <span class="tag tag-gray">승인됨</span>
                                            </c:when>
                                            <c:when test="${w.WITHDRAWSTATUS == 'REJECTED'}">
                                                <span class="tag tag-red">반려됨</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <button type="button" class="action-btn"
                                                onclick="openReviewModal(${w.WITHDRAWIDX}, ${w.USERIDX}, '${w.NICKNAME}', '${w.USERID}', '${w.REASON}', '${w.WITHDRAWSTATUS}')"
                                                title="상세 검토">
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
                            <a href="?page=${page-1}&kwd=${kwd}&wFilter=${wFilter}" class="page-btn">
                                <i class="ri-arrow-left-s-line"></i>
                            </a>
                        </c:if>
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <a href="?page=${p}&kwd=${kwd}&wFilter=${wFilter}"
                               class="page-btn ${p == page ? 'active' : ''}">${p}</a>
                        </c:forEach>
                        <c:if test="${page < totalPages}">
                            <a href="?page=${page+1}&kwd=${kwd}&wFilter=${wFilter}" class="page-btn">
                                <i class="ri-arrow-right-s-line"></i>
                            </a>
                        </c:if>
                    </div>
                </c:if>
            </div>

        </div>
    </main>
</div>

<div class="fullscreen-overlay" id="reviewOverlay">
    <div class="wd-review-modal">
        <div class="wd-modal-head">
            <div class="wd-modal-head-left">
                <div class="wd-modal-avt" id="rvAvt"></div>
                <div>
                    <div class="wd-modal-name" id="rvName"></div>
                    <div class="wd-modal-id"   id="rvId"></div>
                </div>
            </div>
            <button id="reviewClose" style="width:28px;height:28px;border-radius:7px;background:rgba(255,255,255,0.08);border:1px solid rgba(255,255,255,0.1);display:flex;align-items:center;justify-content:center;font-size:15px;color:rgba(255,255,255,0.4);cursor:pointer;transition:all 0.15s;flex-shrink:0;" onmouseover="this.style.background='rgba(239,68,68,0.25)';this.style.color='#FCA5A5';" onmouseout="this.style.background='rgba(255,255,255,0.08)';this.style.color='rgba(255,255,255,0.4)';"><i class="ri-close-line"></i></button>
        </div>

        <div class="wd-modal-body" id="rvBody">
            <div class="wd-loading">
                <i class="ri-loader-4-line"></i>정보를 불러오는 중...
            </div>
        </div>

        <div class="wd-modal-foot" id="rvFoot">
            <button class="btn-pill btn-light" id="reviewCancel">닫기</button>
        </div>
    </div>
</div>

<script>var CTX = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/dist/js/admin/admin_main.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/admin/admin_ui.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/admin/member_withdrawal.js"></script>
</body>
</html>
