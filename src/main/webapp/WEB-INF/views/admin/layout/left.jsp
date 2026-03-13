<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<aside class="agency-sidebar">
    <div class="brand-logo">
        BATON<span class="dot">.</span>
    </div>

    <nav class="nav-wrapper">
        <div class="nav-category">Overview</div>
        <div class="nav-box">
            <a href="${pageContext.request.contextPath}/admin" class="nav-btn active">
                <div class="nav-content">Dashboard</div>
            </a>
        </div>

        <div class="nav-category">Services</div>
        
        <div class="nav-box has-child">
            <a href="#" class="nav-btn">
                <div class="nav-content">중고거래 관리</div>
                <i class="ri-arrow-down-s-line nav-chev"></i>
            </a>
            <div class="sub-list">
                <a href="${pageContext.request.contextPath}/admin/trade/list" class="sub-item">거래 게시글 관리</a>
                <a href="${pageContext.request.contextPath}/admin/trade/report" class="sub-item">신고 게시글 처리</a>
            </div>
        </div>

        <div class="nav-box has-child">
            <a href="#" class="nav-btn">
                <div class="nav-content">동네생활 관리</div>
                <i class="ri-arrow-down-s-line nav-chev"></i>
            </a>
            <div class="sub-list">
                <a href="${pageContext.request.contextPath}/admin/community/list" class="sub-item">커뮤니티 관리</a>
                <a href="${pageContext.request.contextPath}/admin/alba/list" class="sub-item">동네알바 관리</a>
                <a href="${pageContext.request.contextPath}/admin/crew/list" class="sub-item">동네모임 관리</a>
            </div>
        </div>

        <div class="nav-box has-child">
            <a href="#" class="nav-btn">
                <div class="nav-content">결제 및 안심거래</div>
                <i class="ri-arrow-down-s-line nav-chev"></i>
            </a>
            <div class="sub-list">
                <a href="${pageContext.request.contextPath}/admin/payment/list" class="sub-item">결제/충전 내역</a>
                <a href="${pageContext.request.contextPath}/admin/escrow/list" class="sub-item">안심결제(에스크로)</a>
            </div>
        </div>

        <div class="nav-category">System</div>
        
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

        <div class="nav-box has-child">
            <a href="#" class="nav-btn">
                <div class="nav-content">고객센터</div>
                <i class="ri-arrow-down-s-line nav-chev"></i>
            </a>
            <div class="sub-list">
                <a href="${pageContext.request.contextPath}/admin/cs/notice/list" class="sub-item">공지사항 관리</a>
                <a href="${pageContext.request.contextPath}/admin/cs/inquiry/list" class="sub-item">1:1 문의 답변</a>
            </div>
        </div>
    </nav>

    <div class="sidebar-foot">
        <div class="user-badge">
            <div class="avt-circle">AD</div>
            <div class="user-texts">
                <span class="u-name">Administrator</span>
                <span class="u-role">Super Admin</span>
            </div>
        </div>
    </div>
</aside>