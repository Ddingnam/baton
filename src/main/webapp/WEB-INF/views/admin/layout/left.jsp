<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<aside class="sidebar">
    <div class="brand-area">
        <span class="brand-txt">BATON ADMIN</span>
    </div>

    <nav class="nav-menu">
        <div class="nav-group-tl">Analytics</div>
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin" class="nav-link active">
                <div class="nav-left"><span>대시보드</span></div>
            </a>
        </div>

        <div class="nav-group-tl">Management</div>
        <div class="nav-item has-sub">
            <a href="#" class="nav-link">
                <div class="nav-left"><span>회원 관리</span></div>
                <i class="ri-arrow-down-s-line nav-arrow"></i>
            </a>
            <div class="sub-menu">
                <a href="${pageContext.request.contextPath}/admin/member/list" class="sub-link">전체 회원 목록</a>
                <a href="${pageContext.request.contextPath}/admin/member/sanction" class="sub-link">제재 내역 관리</a>
                <a href="${pageContext.request.contextPath}/admin/member/withdrawal" class="sub-link">탈퇴 요청 처리</a>
            </div>
        </div>

        <div class="nav-item has-sub">
            <a href="#" class="nav-link">
                <div class="nav-left"> <span>거래 및 주문</span></div>
                <i class="ri-arrow-down-s-line nav-arrow"></i>
            </a>
            <div class="sub-menu">
                <a href="${pageContext.request.contextPath}/admin/trade/list" class="sub-link">중고 거래 게시글</a>
                <a href="${pageContext.request.contextPath}/admin/order/list" class="sub-link">결제 내역</a>
            </div>
        </div>

        <div class="nav-group-tl">CS Center</div>
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/cs/notice/list" class="nav-link">
                <div class="nav-left"><span>공지사항</span></div>
            </a>
        </div>
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/cs/inquiry/list" class="nav-link">
                <div class="nav-left"><span>1:1 문의</span></div>
            </a>
        </div>
    </nav>

    <div class="sidebar-footer">
        <div class="user-profile">
            <div class="user-avatar">
                <i class="ri-user-smile-line"></i>
            </div>
            <div class="user-info">
                <span class="user-name">관리자</span> <span class="user-role">Super Admin</span>
            </div>
        </div>
        <div class="user-actions">
            <a href="${pageContext.request.contextPath}/" class="action-btn" title="메인으로">
                <i class="ri-home-4-line"></i>
            </a>
            <a href="#" class="action-btn" title="설정">
                <i class="ri-settings-3-line"></i>
            </a>
            <a href="${pageContext.request.contextPath}/member/logout" class="action-btn logout" title="로그아웃">
                <i class="ri-logout-box-r-line"></i>
            </a>
        </div>
    </div>
</aside>