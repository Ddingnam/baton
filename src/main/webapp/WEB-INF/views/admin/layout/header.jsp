<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<header class="admin-header">
    <div class="header-left">
        <button id="toggleSidebar" class="header-btn" title="메뉴 토글">
            <i class="ri-menu-2-fill"></i>
        </button>
        <span style="font-size:18px; font-weight:700; margin-left:12px; color:#191F28;">관리자 센터</span>
    </div>

    <div class="header-right">
        <button class="header-btn">
            <i class="ri-notification-3-line"></i>
        </button>
        
        <a href="${pageContext.request.contextPath}/" target="_blank" class="header-btn" title="사이트 이동">
            <i class="ri-home-4-line"></i>
        </a>

        <div class="profile-chip" id="btnProfile">
            <div class="u-avatar">A</div>
            <span class="u-name">${sessionScope.member.userName != null ? sessionScope.member.userName : '관리자'}</span>
            <i class="ri-arrow-down-s-fill" style="color:#B0B8C1;"></i>
        </div>

        <div class="user-modal" id="modalProfile">
            <div class="um-header">
                <strong>${sessionScope.member.userName}</strong>
                <span style="display:block; font-size:12px; color:#8B95A1; margin-top:4px;">최고 관리자</span>
            </div>
            <div class="um-body">
                <a href="${pageContext.request.contextPath}/admin/member/profile" class="um-item">
                    <i class="ri-user-settings-line"></i> 정보 수정
                </a>
                <a href="${pageContext.request.contextPath}/member/logout" class="um-item red">
                    <i class="ri-logout-box-r-line"></i> 로그아웃
                </a>
            </div>
        </div>
    </div>
</header>