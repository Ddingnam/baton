<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<header class="header">
    <div class="hd-left">
        <button id="sidebarToggle" class="tg-btn"><i class="ri-menu-2-fill"></i></button>
        <div style="display:flex; flex-direction:column;">
            <span class="pg-path">Pages / Dashboard</span>
            <h2 class="pg-current">Overview</h2>
        </div>
    </div>

    <div class="hd-right">
        <div class="noti-wrap">
            <i class="ri-notification-3-line" style="font-size:24px; color:var(--text-secondary);"></i>
            <div class="noti-badge"></div>
        </div>

        <div class="profile-trigger" id="profileTrigger">
            <div class="my-avatar">A</div>
            <div class="my-info">
                <span class="my-nick">관리자님</span>
                <span class="my-role">Super Admin</span>
            </div>
            <i class="ri-arrow-down-s-fill" style="color:var(--text-secondary);"></i>
        </div>

        <div class="profile-modal" id="profileModal">
            <div class="modal-header">Quick Actions</div>
            <div class="modal-item" onclick="window.open('${pageContext.request.contextPath}/')">
                <i class="ri-home-4-line"></i> 메인 홈페이지
            </div>
            <div class="modal-item">
                <i class="ri-settings-3-line"></i> 관리자 설정
            </div>
            <div class="modal-item danger" onclick="location.href='${pageContext.request.contextPath}/member/logout'">
                <i class="ri-logout-box-r-line"></i> 로그아웃
            </div>
        </div>
    </div>
</header>