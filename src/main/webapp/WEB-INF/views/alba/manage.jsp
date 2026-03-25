<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ include file="/WEB-INF/views/layout/headerResources.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>지원 내역 관리 | BATON 알바</title>
<link href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/alba/alba-article.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/alba/alba-manage.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<main class="main-layout">

    <!-- 페이지 헤더 -->
    <header class="manage-page-header">
        <button type="button" class="btn-back"
                onclick="location.href='${pageContext.request.contextPath}/alba/article/${posting.postingIdx}'">
            <i class="ri-arrow-left-line"></i>
        </button>
        <div class="manage-page-title-wrap">
            <h1 class="manage-page-title">지원 내역 관리</h1>
            <p class="manage-page-sub">${posting.title}</p>
        </div>
    </header>

    <!-- 통계 카드 -->
    <section class="stat-bar">
        <div class="stat-card" data-filter="all">
            <span class="stat-num" id="cnt-all">${totalCount}</span>
            <span class="stat-label">전체</span>
        </div>
        <div class="stat-card warn" data-filter="열람대기">
            <span class="stat-num" id="cnt-wait">${waitCount}</span>
            <span class="stat-label">열람대기</span>
        </div>
        <div class="stat-card blue" data-filter="검토중">
            <span class="stat-num" id="cnt-review">${reviewCount}</span>
            <span class="stat-label">검토중</span>
        </div>
        <div class="stat-card green" data-filter="합격">
            <span class="stat-num" id="cnt-pass">${passCount}</span>
            <span class="stat-label">합격</span>
        </div>
        <div class="stat-card red" data-filter="불합격">
            <span class="stat-num" id="cnt-fail">${failCount}</span>
            <span class="stat-label">불합격</span>
        </div>
    </section>

    <!-- 필터 탭 -->
    <div class="filter-tab-wrap">
        <button class="filter-tab active" data-filter="all">전체</button>
        <button class="filter-tab" data-filter="열람대기">열람대기</button>
        <button class="filter-tab" data-filter="검토중">검토중</button>
        <button class="filter-tab" data-filter="합격">합격</button>
        <button class="filter-tab" data-filter="불합격">불합격</button>
    </div>

    <!-- 지원자 목록 -->
    <section class="applicant-list-section">

        <c:choose>
            <c:when test="${empty applicants}">
                <div class="empty-state">
                    <i class="ri-inbox-line"></i>
                    <p>아직 지원자가 없습니다.</p>
                    <span>지원자가 생기면 여기에 표시됩니다.</span>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="a" items="${applicants}">
                    <div class="applicant-card" data-status="${a.status}" data-apply-idx="${a.applyIdx}">

                        <!-- 상단: 프로필 + 상태 뱃지 -->
                        <div class="card-top">
                            <div class="applicant-avatar">
                                <c:choose>
                                    <c:when test="${not empty a.photoUrl}">
                                        <img src="${pageContext.request.contextPath}${a.photoUrl}" alt="프로필">
                                    </c:when>
                                    <c:otherwise>
                                        <i class="ri-user-3-line"></i>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="applicant-info">
                                <div class="applicant-name-row">
                                    <strong class="applicant-name">
                                        <c:choose>
                                            <c:when test="${not empty a.applicantName}">${a.applicantName}</c:when>
                                            <c:otherwise>이름 미기재</c:otherwise>
                                        </c:choose>
                                    </strong>
                                    <span class="status-badge status-${a.status}">${a.status}</span>
                                </div>
                                <div class="applicant-meta">
                                    <c:if test="${not empty a.applicantGender}">
                                        <span><i class="ri-user-line"></i>
                                            <c:choose>
                                                <c:when test="${a.applicantGender == 'M'}">남성</c:when>
                                                <c:when test="${a.applicantGender == 'F'}">여성</c:when>
                                                <c:otherwise>${a.applicantGender}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </c:if>
                                    <c:if test="${not empty a.applicantBirth}">
                                        <span><i class="ri-cake-line"></i> ${a.applicantBirth}</span>
                                    </c:if>
                                    <span class="apply-date">
                                        <i class="ri-time-line"></i>
                                        <fmt:formatDate value="${a.applyDate}" pattern="MM.dd HH:mm" type="both"/>
                                    </span>
                                </div>
                                <c:if test="${not empty a.profileTitle}">
                                    <div class="resume-title-tag">
                                        <i class="ri-file-user-line"></i> ${a.profileTitle}
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <!-- 연락처 -->
                        <div class="contact-row">
                            <c:if test="${not empty a.applicantPhone}">
                                <a href="tel:${a.applicantPhone}" class="contact-btn phone">
                                    <i class="ri-phone-line"></i> ${a.applicantPhone}
                                </a>
                            </c:if>
                            <c:if test="${not empty a.applicantEmail}">
                                <a href="mailto:${a.applicantEmail}" class="contact-btn email">
                                    <i class="ri-mail-line"></i> ${a.applicantEmail}
                                </a>
                            </c:if>
                        </div>

                        <!-- 지원 메시지 -->
                        <c:if test="${not empty a.message}">
                            <div class="apply-message-wrap">
                                <i class="ri-chat-quote-line"></i>
                                <p class="apply-message-text">${a.message}</p>
                            </div>
                        </c:if>

                        <!-- 상태 변경 버튼 -->
                        <div class="status-action-row">
                            <span class="status-action-label">상태 변경</span>
                            <div class="status-btn-group">
                                <button type="button"
                                        class="status-btn ${a.status == '열람대기' ? 'active' : ''}"
                                        data-status="열람대기"
                                        onclick="updateStatus(${a.applyIdx}, ${posting.postingIdx}, '열람대기', this)">
                                    열람대기
                                </button>
                                <button type="button"
                                        class="status-btn blue ${a.status == '검토중' ? 'active' : ''}"
                                        data-status="검토중"
                                        onclick="updateStatus(${a.applyIdx}, ${posting.postingIdx}, '검토중', this)">
                                    검토중
                                </button>
                                <button type="button"
                                        class="status-btn green ${a.status == '합격' ? 'active' : ''}"
                                        data-status="합격"
                                        onclick="updateStatus(${a.applyIdx}, ${posting.postingIdx}, '합격', this)">
                                    합격
                                </button>
                                <button type="button"
                                        class="status-btn red ${a.status == '불합격' ? 'active' : ''}"
                                        data-status="불합격"
                                        onclick="updateStatus(${a.applyIdx}, ${posting.postingIdx}, '불합격', this)">
                                    불합격
                                </button>
                            </div>
                        </div>

                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>

    </section>

</main>

<div class="toast" id="toast"></div>

<script>
    const CONTEXT_PATH = "${pageContext.request.contextPath}";

    /* ── 토스트 ── */
    const Toast = (function () {
        let t = null;
        function show(msg) {
            const el = document.getElementById('toast');
            if (!el) return;
            el.textContent = msg;
            el.classList.add('show');
            clearTimeout(t);
            t = setTimeout(() => el.classList.remove('show'), 2500);
        }
        return { show };
    })();

    /* ── 상태 변경 ── */
    function updateStatus(applyIdx, postingIdx, newStatus, btn) {
        const card = btn.closest('.applicant-card');
        const params = new URLSearchParams();
        params.append('applyIdx',   applyIdx);
        params.append('postingIdx', postingIdx);
        params.append('status',     newStatus);

        fetch(CONTEXT_PATH + '/alba/manage/updateStatus', {
            method: 'POST',
            body: params
        })
        .then(res => res.json())
        .then(data => {
            if (data.status === 'success') {
                // 카드 내 뱃지 업데이트
                const badge = card.querySelector('.status-badge');
                if (badge) {
                    badge.className = 'status-badge status-' + newStatus;
                    badge.textContent = newStatus;
                }
                // 버튼 active 상태 업데이트
                card.querySelectorAll('.status-btn').forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                // 카드 data-status 업데이트 (필터링용)
                card.dataset.status = newStatus;
                // 통계 카운트 업데이트
                refreshCounts();
                Toast.show('상태가 [' + newStatus + ']으로 변경되었습니다.');
            } else {
                Toast.show('상태 변경에 실패했습니다.');
            }
        })
        .catch(() => Toast.show('네트워크 오류가 발생했습니다.'));
    }

    /* ── 필터 탭 ── */
    document.querySelectorAll('.filter-tab').forEach(tab => {
        tab.addEventListener('click', function () {
            document.querySelectorAll('.filter-tab').forEach(t => t.classList.remove('active'));
            this.classList.add('active');

            const filter = this.dataset.filter;
            document.querySelectorAll('.applicant-card').forEach(card => {
                if (filter === 'all' || card.dataset.status === filter) {
                    card.style.display = '';
                } else {
                    card.style.display = 'none';
                }
            });
        });
    });

    /* ── 통계 카드도 필터로 동작 ── */
    document.querySelectorAll('.stat-card').forEach(card => {
        card.addEventListener('click', function () {
            const filter = this.dataset.filter;
            document.querySelectorAll('.filter-tab').forEach(tab => {
                tab.classList.toggle('active', tab.dataset.filter === filter);
            });
            document.querySelectorAll('.applicant-card').forEach(c => {
                if (filter === 'all' || c.dataset.status === filter) {
                    c.style.display = '';
                } else {
                    c.style.display = 'none';
                }
            });
        });
    });

    /* ── 카운트 새로고침 ── */
    function refreshCounts() {
        const cards = document.querySelectorAll('.applicant-card');
        let all = 0, wait = 0, review = 0, pass = 0, fail = 0;
        cards.forEach(c => {
            all++;
            const s = c.dataset.status;
            if (s === '열람대기') wait++;
            else if (s === '검토중')  review++;
            else if (s === '합격')    pass++;
            else if (s === '불합격')  fail++;
        });
        document.getElementById('cnt-all').textContent    = all;
        document.getElementById('cnt-wait').textContent   = wait;
        document.getElementById('cnt-review').textContent = review;
        document.getElementById('cnt-pass').textContent   = pass;
        document.getElementById('cnt-fail').textContent   = fail;
    }
</script>

</body>
</html>
