<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<aside class="admin-sidebar">
    <div class="sidebar-logo">
        <a href="${pageContext.request.contextPath}/admin" class="logo-link" onclick="location.reload(); return false;">
            <div class="logo-point"></div>
            <span>BATON ADMIN</span>
        </a>
    </div>

    <nav class="nav-wrap">
        <div class="nav-category">Main</div>
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin" class="nav-link">
                <div class="nav-left"><i class="ri-dashboard-3-fill nav-icon"></i> <span class="nav-text">대시보드</span></div>
            </a>
        </div>

        <div class="nav-category">Service</div>
        
        <div class="nav-item has-sub">
            <a href="#" class="nav-link">
                <div class="nav-left"><i class="ri-user-smile-fill nav-icon"></i> <span class="nav-text">회원 관리</span></div>
                <i class="ri-arrow-down-s-line nav-arrow"></i>
            </a>
            <ul class="sub-nav">
                <li><a href="${pageContext.request.contextPath}/admin/member/list" class="sub-link">전체 회원</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/member/dormant" class="sub-link">휴면/탈퇴</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/member/sanction" class="sub-link">제재 내역</a></li>
            </ul>
        </div>

        <div class="nav-item has-sub">
            <a href="#" class="nav-link">
                <div class="nav-left"><i class="ri-shopping-bag-3-fill nav-icon"></i> <span class="nav-text">중고거래</span></div>
                <i class="ri-arrow-down-s-line nav-arrow"></i>
            </a>
            <ul class="sub-nav">
                <li><a href="${pageContext.request.contextPath}/admin/trade/list" class="sub-link">매물 목록</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/trade/report" class="sub-link">신고 접수</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/trade/category" class="sub-link">카테고리</a></li>
            </ul>
        </div>

        <div class="nav-item has-sub">
            <a href="#" class="nav-link">
                <div class="nav-left"><i class="ri-briefcase-4-fill nav-icon"></i> <span class="nav-text">알바천국</span></div>
                <i class="ri-arrow-down-s-line nav-arrow"></i>
            </a>
            <ul class="sub-nav">
                <li><a href="${pageContext.request.contextPath}/admin/alba/list" class="sub-link">공고 목록</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/alba/report" class="sub-link">신고 내역</a></li>
            </ul>
        </div>

        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/crew/list" class="nav-link">
                <div class="nav-left"><i class="ri-group-2-fill nav-icon"></i> <span class="nav-text">동네모임</span></div>
            </a>
        </div>

        <div class="nav-category">Support</div>
        <div class="nav-item has-sub">
            <a href="#" class="nav-link">
                <div class="nav-left"><i class="ri-customer-service-2-fill nav-icon"></i> <span class="nav-text">고객센터</span></div>
                <i class="ri-arrow-down-s-line nav-arrow"></i>
            </a>
            <ul class="sub-nav">
                <li><a href="${pageContext.request.contextPath}/admin/cs/notice/list" class="sub-link">공지사항</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/cs/inquiry/list" class="sub-link">1:1 문의</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/cs/faq/list" class="sub-link">FAQ</a></li>
            </ul>
        </div>
        
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/stats/sales" class="nav-link">
                <div class="nav-left"><i class="ri-pie-chart-2-fill nav-icon"></i> <span class="nav-text">통계</span></div>
            </a>
        </div>
    </nav>

    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/member/logout" class="btn-logout">
            <i class="ri-logout-box-r-line"></i> <span class="nav-text">로그아웃</span>
        </a>
    </div>
</aside>