<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<aside class="agency-sidebar">
    <div class="brand-logo" onclick="location.href='${pageContext.request.contextPath}/admin'" style="cursor:pointer;">
        BATON<span class="dot">.</span>
    </div>

    <nav class="nav-wrapper">
        <div class="nav-category">개요</div>
        <div class="nav-box">
            <a href="${pageContext.request.contextPath}/admin" class="nav-btn" id="nav-dashboard">
                <div class="nav-content">대시보드</div>
            </a>
        </div>

        <div class="nav-category">회원 관리</div>

        <div class="nav-box has-child">
            <a href="#" class="nav-btn">
                <div class="nav-content">회원 관리</div>
                <i class="ri-arrow-down-s-line nav-chev"></i>
            </a>
            <div class="sub-list">
                <a href="${pageContext.request.contextPath}/admin/member/list" class="sub-item">전체 회원 목록</a>
                <a href="${pageContext.request.contextPath}/admin/member/sanction" class="sub-item">제재 내역 관리</a>
                <a href="${pageContext.request.contextPath}/admin/member/withdrawal" class="sub-item">탈퇴 요청 처리</a>
            </div>
        </div>

        <div class="nav-category">콘텐츠 관리</div>

        <div class="nav-box has-child">
            <a href="#" class="nav-btn">
                <div class="nav-content">동네생활 관리</div>
                <i class="ri-arrow-down-s-line nav-chev"></i>
            </a>
            <div class="sub-list">
                <a href="${pageContext.request.contextPath}/admin/trade/list" class="sub-item">중고거래 관리</a>
                <a href="${pageContext.request.contextPath}/admin/community/list" class="sub-item">커뮤니티 관리</a>
                <a href="${pageContext.request.contextPath}/admin/crew/list" class="sub-item">동네모임 관리</a>
                <a href="${pageContext.request.contextPath}/admin/alba/list" class="sub-item">알바구인 관리</a>
            </div>
        </div>

        <div class="nav-category">신고 관리</div>

        <div class="nav-box has-child">
            <a href="#" class="nav-btn">
                <div class="nav-content">신고 처리</div>
                <i class="ri-arrow-down-s-line nav-chev"></i>
            </a>
            <div class="sub-list">
                <a href="${pageContext.request.contextPath}/admin/report/list?domainType=TRADE" class="sub-item">중고거래 신고</a>
                <a href="${pageContext.request.contextPath}/admin/report/list?domainType=COMMUNITY" class="sub-item">커뮤니티 신고</a>
                <a href="${pageContext.request.contextPath}/admin/report/list?domainType=CREW" class="sub-item">동네모임 신고</a>
                <a href="${pageContext.request.contextPath}/admin/report/list?domainType=ALBA" class="sub-item">알바공고 신고</a>
            </div>
        </div>

        <div class="nav-category">결제 · 포인트</div>

        <div class="nav-box has-child">
            <a href="#" class="nav-btn">
                <div class="nav-content">결제 · 포인트</div>
                <i class="ri-arrow-down-s-line nav-chev"></i>
            </a>
            <div class="sub-list">
                <a href="${pageContext.request.contextPath}/admin/payment/list" class="sub-item">포인트 결제 내역</a>
                <a href="${pageContext.request.contextPath}/admin/escrow/list" class="sub-item">에스크로 거래 관리</a>
            </div>
        </div>
    </nav>

    <div class="sidebar-foot">
        <button class="chat-entry-btn" id="studioChatBtn" onclick="location.href='${pageContext.request.contextPath}/admin/chat'">
            <i class="ri-message-3-fill"></i>
            <span>스튜디오 채팅</span>
            <div class="chat-unread-badge">3</div>
        </button>
        <div class="user-badge">
            <div class="avt-circle">AD</div>
            <div class="user-texts">
                <span class="u-name">관리자</span>
                <span class="u-role">최고 관리자</span>
            </div>
            <button class="sidebar-noti-btn" onclick="location.href='${pageContext.request.contextPath}/admin/notifications'" title="알림">
                <i class="ri-notification-3-line"></i>
            </button>
        </div>
    </div>

    <script>
    (function() {
        var path = window.location.pathname;
        var ctx  = '${pageContext.request.contextPath}';
        var adminRoot = ctx + '/admin';

        var matched = false;

        document.querySelectorAll('.sub-list .sub-item').forEach(function(link) {
            var href = link.getAttribute('href');
            if (!href) return;
            var hrefPath  = href.split('?')[0];
            var hrefQuery = href.includes('?') ? href.substring(href.indexOf('?')) : '';
            var fullMatch = (path === hrefPath) && (hrefQuery === '' || window.location.search === hrefQuery);
            var pathMatch = (hrefQuery === '') && path.startsWith(hrefPath + '/');
            if (fullMatch || pathMatch) {
                link.classList.add('active');
                var parentBox = link.closest('.nav-box');
                if (parentBox) parentBox.classList.add('open');
                matched = true;
            }
        });

        document.querySelectorAll('.nav-box:not(.has-child) .nav-btn').forEach(function(btn) {
            var href = btn.getAttribute('href');
            if (!href || href === '#') return;
            var hrefPath = href.split('?')[0];
            if (path === hrefPath) {
                btn.classList.add('active');
                matched = true;
            }
        });

        if (!matched && (path === adminRoot || path === adminRoot + '/')) {
            var dash = document.getElementById('nav-dashboard');
            if (dash) dash.classList.add('active');
        }

        if (path.startsWith(adminRoot + '/chat')) {
            var chatBtn = document.getElementById('studioChatBtn');
            if (chatBtn) chatBtn.classList.add('active');
        }
    })();

        window.CTX          = '${pageContext.request.contextPath}';
        <sec:authorize access="isAuthenticated()">
        window.ADMIN_USER_IDX = '<sec:authentication property="principal.userIdx"/>';
        </sec:authorize>
    </script>
</aside>
