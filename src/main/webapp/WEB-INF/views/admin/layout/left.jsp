<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<aside class="sidebar">
    <div class="brand-area">
        <span class="brand-txt">BATON <span>ADMIN</span></span>
    </div>

    <nav class="nav-menu">
        <div class="nav-group-tl">Overview</div>
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin" class="nav-link active">
                <div class="nav-left">
                    <span>대시보드</span>
                </div>
            </a>
        </div>

        <div class="nav-group-tl">Service Management</div>
        <div class="nav-item has-sub">
            <a href="#" class="nav-link">
                <div class="nav-left">
                    <span>중고거래</span>
                </div>
                <i class="ri-arrow-down-s-line nav-arrow"></i>
            </a>
            <div class="sub-menu">
                <a href="${pageContext.request.contextPath}/admin/trade/list" class="sub-link">거래 게시글 관리</a>
                <a href="${pageContext.request.contextPath}/admin/trade/report" class="sub-link">신고 게시글 처리</a>
            </div>
        </div>

        <div class="nav-item has-sub">
            <a href="#" class="nav-link">
                <div class="nav-left">
                    <span>동네생활</span>
                </div>
                <i class="ri-arrow-down-s-line nav-arrow"></i>
            </a>
            <div class="sub-menu">
                <a href="${pageContext.request.contextPath}/admin/community/list" class="sub-link">커뮤니티 관리</a>
                <a href="${pageContext.request.contextPath}/admin/alba/list" class="sub-link">동네알바 관리</a>
                <a href="${pageContext.request.contextPath}/admin/crew/list" class="sub-link">동네모임 관리</a>
            </div>
        </div>

        <div class="nav-item has-sub">
            <a href="#" class="nav-link">
                <div class="nav-left">
                    <span>결제 및 안심거래</span>
                </div>
                <i class="ri-arrow-down-s-line nav-arrow"></i>
            </a>
            <div class="sub-menu">
                <a href="${pageContext.request.contextPath}/admin/payment/list" class="sub-link">결제/충전 내역</a>
                <a href="${pageContext.request.contextPath}/admin/escrow/list" class="sub-link">안심결제(에스크로)</a>
            </div>
        </div>

        <div class="nav-group-tl">User & CS</div>
        <div class="nav-item has-sub">
            <a href="#" class="nav-link">
                <div class="nav-left">
                    <span>회원 관리</span>
                </div>
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
                <div class="nav-left">
                    <span>고객센터</span>
                </div>
                <i class="ri-arrow-down-s-line nav-arrow"></i>
            </a>
            <div class="sub-menu">
                <a href="${pageContext.request.contextPath}/admin/cs/notice/list" class="sub-link">공지사항</a>
                <a href="${pageContext.request.contextPath}/admin/cs/inquiry/list" class="sub-link">1:1 문의</a>
            </div>
        </div>
    </nav>

    <div class="sidebar-footer">
        <div class="user-profile">
            <div class="user-avatar">
                <i class="ri-shield-user-fill"></i>
            </div>
            <div class="user-info">
                <span class="user-name">관리자</span>
                <span class="user-role">Super Admin</span>
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