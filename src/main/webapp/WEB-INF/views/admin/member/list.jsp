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
                    <h1 class="hero-title">Member List</h1>
                    <p class="hero-subtitle">전체 회원 현황을 조회하고 관리합니다.</p>
                </div>
            </div>

            <div class="member-stat-row">
                <div class="member-stat-card" onclick="filterByStatus('')">
                    <div class="msc-icon purple"><i class="ri-group-fill"></i></div>
                    <div class="msc-info">
                        <span class="msc-val">${not empty countAll ? countAll : 0}</span>
                        <span class="msc-lbl">전체 회원</span>
                    </div>
                </div>
                <div class="member-stat-card" onclick="filterByStatus(1)" data-count-normal="${countNormal}">
                    <div class="msc-icon green"><i class="ri-user-smile-fill"></i></div>
                    <div class="msc-info">
                        <span class="msc-val" id="countNormal">${not empty countNormal ? countNormal : '-'}</span>
                        <span class="msc-lbl">정상</span>
                    </div>
                </div>
                <div class="member-stat-card" onclick="filterByStatus(2)" data-count-ban="${countBan}">
                    <div class="msc-icon red"><i class="ri-forbid-fill"></i></div>
                    <div class="msc-info">
                        <span class="msc-val" id="countBan">${not empty countBan ? countBan : '-'}</span>
                        <span class="msc-lbl">제재</span>
                    </div>
                </div>
                <div class="member-stat-card" onclick="filterByStatus(9)" data-count-out="${countOut}">
                    <div class="msc-icon gray"><i class="ri-user-unfollow-fill"></i></div>
                    <div class="msc-info">
                        <span class="msc-val" id="countOut">${not empty countOut ? countOut : '-'}</span>
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
                        <input type="hidden" name="schType" id="memberSchTypeInput" value="${schType}">
                        <div class="adm-dropdown" id="memberSchType">
                            <button type="button" class="adm-dropdown-btn" onclick="admToggle('memberSchType')">
                                <span id="memberSchTypeLabel">통합검색</span>
                                <i class="ri-arrow-down-s-line adm-dropdown-arrow"></i>
                            </button>
                            <div class="adm-dropdown-menu">
                                <div class="adm-dropdown-item ${empty schType || schType == 'all' ? 'active' : ''}" data-value="all" onclick="admSelect(this,'memberSchType')">통합검색</div>
                                <div class="adm-dropdown-item ${schType == 'userId' ? 'active' : ''}" data-value="userId" onclick="admSelect(this,'memberSchType')">아이디</div>
                                <div class="adm-dropdown-item ${schType == 'nickname' ? 'active' : ''}" data-value="nickname" onclick="admSelect(this,'memberSchType')">닉네임</div>
                                <div class="adm-dropdown-item ${schType == 'email' ? 'active' : ''}" data-value="email" onclick="admSelect(this,'memberSchType')">이메일</div>
                            </div>
                        </div>
                        <div class="search-input-wrap">
                            <i class="ri-search-2-line"></i>
                            <input type="text" name="kwd" class="fm-input" value="${kwd}" placeholder="회원 검색...">
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
                                <tr data-useridx="${m.userIdx}">
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
                                        <span class="auth-badge ${m.authority == 'ADMIN' ? 'admin' : (m.authority == 'EMP' ? 'emp' : 'user')}">
                                            ${m.authority == 'ADMIN' ? '관리자' : (m.authority == 'EMP' ? '직원' : '일반')}
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
                                        <button type="button" class="action-btn" onclick="openDetail('${m.userIdx}')" title="상세보기">
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
    <div style="
        background:#fff;border-radius:24px;width:720px;max-width:96vw;
        height:82vh;max-height:820px;min-height:520px;
        display:flex;flex-direction:column;overflow:hidden;
        box-shadow:0 32px 80px rgba(0,0,0,0.26);
        transform:translateY(20px) scale(0.97);
        transition:transform 0.35s cubic-bezier(0.16,1,0.3,1),opacity 0.35s;
        opacity:0;" id="memberModalBox">

        
        <div style="background:linear-gradient(135deg,#1E1B4B 0%,#312E81 100%);
                    padding:20px 24px 16px;flex-shrink:0;position:relative;overflow:hidden;">
            <div style="position:absolute;top:-30px;right:-30px;width:130px;height:130px;border-radius:50%;background:rgba(255,255,255,0.04);pointer-events:none;"></div>
            <div style="position:absolute;bottom:-50px;left:50px;width:180px;height:180px;border-radius:50%;background:rgba(255,255,255,0.03);pointer-events:none;"></div>
            <div style="display:flex;align-items:center;justify-content:space-between;position:relative;">
                
                <div style="display:flex;align-items:center;gap:14px;">
                    <div id="dAvt" style="width:48px;height:48px;border-radius:50%;
                        background:var(--grad-primary);color:#fff;
                        display:flex;align-items:center;justify-content:center;
                        font-size:20px;font-weight:800;flex-shrink:0;
                        box-shadow:0 6px 20px rgba(124,58,237,0.4);"></div>
                    <div>
                        <div style="font-size:9px;font-weight:700;letter-spacing:0.14em;color:rgba(255,255,255,0.3);margin-bottom:3px;">MEMBER DETAIL</div>
                        <div id="dName" style="font-size:17px;font-weight:800;color:#fff;letter-spacing:-0.3px;"></div>
                        <div id="dId"   style="font-size:11px;color:rgba(255,255,255,0.4);margin-top:1px;"></div>
                    </div>
                </div>
                
                <button id="detailClose" style="width:30px;height:30px;border-radius:8px;
                    background:rgba(255,255,255,0.08);border:1px solid rgba(255,255,255,0.1);
                    display:flex;align-items:center;justify-content:center;
                    font-size:16px;color:rgba(255,255,255,0.4);cursor:pointer;transition:all 0.15s;"
                    onmouseover="this.style.background='rgba(239,68,68,0.25)';this.style.color='#FCA5A5';"
                    onmouseout="this.style.background='rgba(255,255,255,0.08)';this.style.color='rgba(255,255,255,0.4)';">
                    <i class="ri-close-line"></i>
                </button>
            </div>
            <div style="display:flex;align-items:center;gap:8px;margin-top:12px;flex-wrap:wrap;position:relative;">
                <span id="dStatusBadge" class="detail-status-badge"></span>
                <span style="height:14px;width:1px;background:rgba(255,255,255,0.15);"></span>
                <span style="font-size:11px;color:rgba(255,255,255,0.45);">Lv.<span id="dLevel" style="font-weight:800;color:rgba(255,255,255,0.7);"></span></span>
                <span style="font-size:11px;color:rgba(255,255,255,0.45);">바톤 km <span id="dScoreText" style="font-weight:800;color:rgba(255,255,255,0.7);"></span><span style="font-size:10px;opacity:0.6;">km</span></span>
                <span style="font-size:11px;color:rgba(255,255,255,0.45);">포인트 <span id="dPoint" style="font-weight:800;color:#A5B4FC;"></span></span>
                <div style="margin-left:auto;display:flex;align-items:center;gap:6px;">
                    <span style="font-size:10px;color:rgba(255,255,255,0.3);">달리기</span>
                    <div style="width:80px;height:5px;background:rgba(255,255,255,0.12);border-radius:10px;overflow:hidden;">
                        <div class="manner-bar-fill" id="dScoreBar" style="height:100%;border-radius:10px;"></div>
                    </div>
                </div>
            </div>
        </div>

        
        <div style="flex:1;display:flex;flex-direction:column;overflow:hidden;">
            
            <div style="padding:16px 24px 0;border-bottom:1px solid #F1F5F9;display:flex;gap:4px;flex-shrink:0;">
                <button class="detail-tab-btn active" data-pane="paneInfo"
                    style="padding:8px 18px;border-radius:10px 10px 0 0;font-size:13px;font-weight:700;">기본 정보</button>
                <button class="detail-tab-btn" data-pane="paneSanction"
                    style="padding:8px 18px;border-radius:10px 10px 0 0;font-size:13px;font-weight:700;">제재 처리</button>
                
                <div style="margin-left:auto;display:flex;gap:8px;padding-bottom:4px;">
                    <button type="button" id="btnSuspend" style="display:none;align-items:center;gap:5px;padding:7px 14px;border-radius:10px;background:#EF4444;color:#fff;border:none;font-size:12px;font-weight:700;cursor:pointer;font-family:inherit;transition:all 0.15s;box-shadow:0 3px 10px rgba(239,68,68,0.25);"
                        onmouseover="this.style.opacity='0.85';" onmouseout="this.style.opacity='1';">
                        <i class="ri-forbid-line"></i> 제재하기
                    </button>
                    <button type="button" id="btnActivate" style="display:none;align-items:center;gap:5px;padding:7px 14px;border-radius:10px;background:#10B981;color:#fff;border:none;font-size:12px;font-weight:700;cursor:pointer;font-family:inherit;transition:all 0.15s;box-shadow:0 3px 10px rgba(16,185,129,0.25);"
                        onmouseover="this.style.opacity='0.85';" onmouseout="this.style.opacity='1';">
                        <i class="ri-check-line"></i> 정상화
                    </button>
                </div>
            </div>

            
            <div style="flex:1;overflow-y:auto;padding:24px 28px;">

                <div class="detail-pane active" id="paneInfo">

                    
                    <div style="background:#F8FAFC;border-radius:16px;padding:6px 4px;margin-bottom:16px;">
                        <div style="padding:12px 16px 4px;font-size:10px;font-weight:800;color:#94A3B8;text-transform:uppercase;letter-spacing:0.1em;display:flex;align-items:center;gap:5px;">
                            <i class="ri-user-3-line" style="font-size:12px;color:#7C3AED;"></i>기본 정보
                        </div>
                        <div style="display:grid;grid-template-columns:1fr 1fr;gap:1px;background:#E2E8F0;border-radius:12px;overflow:hidden;margin:8px 4px 4px;">
                            <div style="background:#fff;padding:14px 16px;">
                                <div style="font-size:10px;font-weight:700;color:#94A3B8;margin-bottom:5px;text-transform:uppercase;letter-spacing:0.06em;">이메일</div>
                                <div id="dEmail" style="font-size:13px;font-weight:600;color:#1E293B;word-break:break-all;"></div>
                            </div>
                            <div style="background:#fff;padding:14px 16px;">
                                <div style="font-size:10px;font-weight:700;color:#94A3B8;margin-bottom:5px;text-transform:uppercase;letter-spacing:0.06em;">전화번호</div>
                                <div id="dTel" style="font-size:13px;font-weight:600;color:#1E293B;"></div>
                            </div>
                            <div style="background:#fff;padding:14px 16px;">
                                <div style="font-size:10px;font-weight:700;color:#94A3B8;margin-bottom:5px;text-transform:uppercase;letter-spacing:0.06em;">생년월일</div>
                                <div id="dBirth" style="font-size:13px;font-weight:600;color:#1E293B;"></div>
                            </div>
                            <div style="background:#fff;padding:14px 16px;">
                                <div style="font-size:10px;font-weight:700;color:#94A3B8;margin-bottom:5px;text-transform:uppercase;letter-spacing:0.06em;">가입일</div>
                                <div id="dCreated" style="font-size:13px;font-weight:600;color:#1E293B;"></div>
                            </div>
                        </div>
                    </div>

                    
                    <div style="background:#F8FAFC;border-radius:16px;padding:6px 4px;margin-bottom:16px;">
                        <div style="padding:12px 16px 4px;font-size:10px;font-weight:800;color:#94A3B8;text-transform:uppercase;letter-spacing:0.1em;display:flex;align-items:center;gap:5px;">
                            <i class="ri-time-line" style="font-size:12px;color:#7C3AED;"></i>활동 정보
                        </div>
                        <div style="background:#fff;border-radius:12px;margin:8px 4px 4px;overflow:hidden;">
                            <div style="display:flex;align-items:center;padding:12px 16px;border-bottom:1px solid #F1F5F9;">
                                <span style="width:90px;flex-shrink:0;font-size:11px;font-weight:700;color:#94A3B8;">최근 로그인</span>
                                <span id="dLastLogin" style="font-size:13px;font-weight:600;color:#1E293B;"></span>
                            </div>
                        </div>
                    </div>

                    
                    <div style="background:#F8FAFC;border-radius:16px;padding:6px 4px;">
                        <div style="padding:12px 16px 4px;font-size:10px;font-weight:800;color:#94A3B8;text-transform:uppercase;letter-spacing:0.1em;display:flex;align-items:center;gap:5px;">
                            <i class="ri-shield-star-line" style="font-size:12px;color:#7C3AED;"></i>권한 설정
                        </div>
                        <div style="background:#fff;border-radius:12px;margin:8px 4px 4px;padding:14px 16px;display:flex;align-items:center;gap:10px;">
                            <div class="adm-dropdown" id="dAuthorityDd" style="display:inline-block;flex:1;max-width:180px;">
                                <button type="button" class="adm-dropdown-btn" style="height:40px;width:100%;font-size:13px;" onclick="admToggle('dAuthorityDd')">
                                    <span id="dAuthorityLabel">일반 회원</span>
                                    <i class="ri-arrow-down-s-line adm-dropdown-arrow"></i>
                                </button>
                                <div class="adm-dropdown-menu">
                                    <div class="adm-dropdown-item active" data-value="USER"  onclick="admSelectAuthority(this,'USER','일반 회원')">일반 회원</div>
                                    <div class="adm-dropdown-item"        data-value="EMP"   onclick="admSelectAuthority(this,'EMP','직원')">직원</div>
                                    <div class="adm-dropdown-item"        data-value="ADMIN" onclick="admSelectAuthority(this,'ADMIN','관리자')">관리자</div>
                                </div>
                            </div>
                            <input type="hidden" id="dAuthority" value="USER">
                            <button class="btn-pill btn-gradient" style="height:40px;padding:0 20px;font-size:13px;font-weight:700;" onclick="saveAuthority()">
                                <i class="ri-save-line" style="margin-right:4px;"></i>저장
                            </button>
                        </div>
                    </div>

                </div>

                <div class="detail-pane" id="paneSanction">
                    <div class="sanction-panel">
                        <div class="sanction-panel-header">
                            <div class="sanction-panel-icon"><i class="ri-forbid-2-line"></i></div>
                            <div>
                                <div class="sanction-panel-title">제재 처리</div>
                                <div class="sanction-panel-desc">유형과 기간을 선택하고 사유를 입력하세요.</div>
                            </div>
                        </div>
                        <div class="sanction-panel-body">
                            <div class="sp-field">
                                <label class="sp-label"><i class="ri-shield-cross-line"></i> 제재 유형</label>
                                <div class="adm-dropdown sp-dropdown" id="sanctionTypeDd" style="width:100%;">
                                    <button type="button" class="adm-dropdown-btn sp-dd-btn" onclick="admToggle('sanctionTypeDd')" style="width:100%;">
                                        <span id="sanctionTypeLabel">기간 정지</span>
                                        <i class="ri-arrow-down-s-line adm-dropdown-arrow"></i>
                                    </button>
                                    <div class="adm-dropdown-menu">
                                        <div class="adm-dropdown-item active" data-value="TEMPORARY" onclick="selectSanctionField(this,'sanctionTypeDd','sanctionType','sanctionTypeLabel',handleSanctionTypeChange)"><i class="ri-timer-line" style="margin-right:6px;"></i>기간 정지</div>
                                        <div class="adm-dropdown-item"        data-value="PERMANENT" onclick="selectSanctionField(this,'sanctionTypeDd','sanctionType','sanctionTypeLabel',handleSanctionTypeChange)"><i class="ri-forbid-line" style="margin-right:6px;"></i>영구 정지</div>
                                    </div>
                                </div>
                                <input type="hidden" id="sanctionType" value="TEMPORARY">
                            </div>
                            <div class="sp-field" id="daysField">
                                <label class="sp-label"><i class="ri-calendar-close-line"></i> 정지 기간</label>
                                <div class="adm-dropdown sp-dropdown" id="sanctionDaysDd" style="width:100%;">
                                    <button type="button" class="adm-dropdown-btn sp-dd-btn" onclick="admToggle('sanctionDaysDd')" style="width:100%;">
                                        <span id="sanctionDaysLabel">7일</span>
                                        <i class="ri-arrow-down-s-line adm-dropdown-arrow"></i>
                                    </button>
                                    <div class="adm-dropdown-menu">
                                        <div class="adm-dropdown-item"        data-value="3"  onclick="selectSanctionField(this,'sanctionDaysDd','sanctionDays','sanctionDaysLabel',null)">3일</div>
                                        <div class="adm-dropdown-item active" data-value="7"  onclick="selectSanctionField(this,'sanctionDaysDd','sanctionDays','sanctionDaysLabel',null)">7일</div>
                                        <div class="adm-dropdown-item"        data-value="14" onclick="selectSanctionField(this,'sanctionDaysDd','sanctionDays','sanctionDaysLabel',null)">14일</div>
                                        <div class="adm-dropdown-item"        data-value="30" onclick="selectSanctionField(this,'sanctionDaysDd','sanctionDays','sanctionDaysLabel',null)">30일</div>
                                    </div>
                                </div>
                                <input type="hidden" id="sanctionDays" value="7">
                            </div>
                            <div class="sp-field">
                                <label class="sp-label"><i class="ri-file-text-line"></i> 제재 사유</label>
                                <textarea class="sp-textarea" id="sanctionReason" rows="4" placeholder="제재 사유를 구체적으로 입력하세요"></textarea>
                                <div id="reasonError" style="display:none;align-items:center;gap:6px;margin-top:8px;color:#EF4444;font-size:12px;font-weight:600;"><i class="ri-error-warning-line"></i> 제재 사유를 입력해주세요.</div>
                            </div>
                        </div>
                        <div class="sanction-panel-footer">
                            <button type="button" class="btn-pill btn-light" onclick="closeMemberModal()">
                                <i class="ri-close-line"></i> 취소
                            </button>
                            <button type="button" class="btn-pill btn-gradient" id="btnApplySanction" onclick="submitSanction()">
                                <i class="ri-forbid-line"></i> 제재 적용
                            </button>
                        </div>
                    </div>
                </div>

            </div>
        </div>

    </div>
</div>

div>

<script>var CTX = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/dist/js/admin/admin_main.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/admin/admin_ui.js"></script>
<script>
function _closeAllDd() {
    document.querySelectorAll('.adm-dropdown.open').forEach(function(d) {
        d.classList.remove('open');
        var m = d._portal;
        if (m) {
            d.appendChild(m);
            m.removeAttribute('style');
            d._portal = null;
        }
    });
}

function admToggle(id) {
    var dd = document.getElementById(id);
    if (!dd) return;
    var isOpen = dd.classList.contains('open');
    _closeAllDd();
    if (isOpen) return;

    var btn  = dd.querySelector('.adm-dropdown-btn');
    var menu = dd.querySelector('.adm-dropdown-menu');
    if (!btn || !menu) return;

    dd.classList.add('open');
    dd._portal = menu;
    document.body.appendChild(menu);

    var r    = btn.getBoundingClientRect();
    var mW   = Math.max(r.width, 160);
    var top  = r.bottom + 6;
    var left = r.left;

    if (left + mW > window.innerWidth - 8) left = r.right - mW;
    if (left < 8) left = 8;

    menu.style.cssText = [
        'position:fixed',
        'top:'    + top  + 'px',
        'left:'   + left + 'px',
        'width:'  + mW   + 'px',
        'display:block',
        'z-index:999999',
        'background:#fff',
        'border:1px solid var(--border-color)',
        'border-radius:14px',
        'box-shadow:0 12px 40px rgba(0,0,0,0.14)',
        'padding:6px'
    ].join(';');
}

function admCloseDd(ddId) {
    var dd = document.getElementById(ddId);
    if (!dd) return;
    dd.classList.remove('open');
    var m = dd._portal;
    if (m) {
        dd.appendChild(m);
        m.removeAttribute('style');
        dd._portal = null;
    }
}

function admSelect(el, ddId) {
    document.getElementById(ddId + 'Input').value        = el.dataset.value;
    document.getElementById(ddId + 'Label').textContent  = el.textContent.trim();
    document.querySelectorAll('#' + ddId + ' .adm-dropdown-item').forEach(function(i){ i.classList.remove('active'); });
    el.classList.add('active');
    admCloseDd(ddId);
}

function admSelectAuthority(el, val, label) {
    document.getElementById('dAuthority').value           = val;
    document.getElementById('dAuthorityLabel').textContent = label;
    document.querySelectorAll('#dAuthorityDd .adm-dropdown-item').forEach(function(i){ i.classList.remove('active'); });
    el.classList.add('active');
    admCloseDd('dAuthorityDd');
}

function selectSanctionField(el, ddId, inputId, labelId, cb) {
    document.getElementById(inputId).value       = el.dataset.value;
    document.getElementById(labelId).textContent = el.textContent.trim();
    el.parentNode.querySelectorAll('.adm-dropdown-item').forEach(function(i){ i.classList.remove('active'); });
    el.classList.add('active');
    admCloseDd(ddId);
    if (cb) cb(el.dataset.value);
}

function handleSanctionTypeChange(val) {
    var df = document.getElementById('daysField');
    if (df) val === 'PERMANENT' ? df.classList.add('hidden') : df.classList.remove('hidden');
}

document.addEventListener('DOMContentLoaded', function() {
    var map = { all:'통합검색', userId:'아이디', nickname:'닉네임', email:'이메일' };
    var inp = document.getElementById('memberSchTypeInput');
    if (inp && map[inp.value]) document.getElementById('memberSchTypeLabel').textContent = map[inp.value];

    document.addEventListener('click', function(e) {
        document.querySelectorAll('.adm-dropdown.open').forEach(function(dd) {
            var m      = dd._portal;
            var inBtn  = dd.contains(e.target);
            var inMenu = m && m.contains(e.target);
            if (!inBtn && !inMenu) {
                dd.classList.remove('open');
                if (m) { dd.appendChild(m); m.removeAttribute('style'); dd._portal = null; }
            }
        });
    });
});
</script>
<script src="${pageContext.request.contextPath}/dist/js/admin/member_list.js"></script>
</body>
</html>
