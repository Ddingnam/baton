<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<header class="header">
    <div class="hd-left">
        <button id="sidebarToggle" class="tg-btn"><i class="ri-menu-2-line"></i></button>
        <div style="display:flex; flex-direction:column;">
        </div>
    </div>

    <div class="hd-center utility-trigger" id="systemUtilityTrigger">
        <i class="ri-time-line"></i>
        <span id="systemClock"></span>
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

<div class="system-utility-modal glass-panel" id="systemUtilityModal">
    <div class="utility-grid">
        <div class="widget-box cal-widget">
            <div class="wg-header">
                <span id="modalMonth"></span>
                <i class="ri-calendar-todo-line"></i>
            </div>
            <div class="mini-cal-grid" id="miniCalGrid"></div>
        </div>

        <div class="widget-box status-widget">
            <div class="wg-header">
                <span>Team Status</span>
                <span class="online-count">3 Online</span>
            </div>
            <ul class="team-list">
                <li>
                    <div class="tm-avt bg-blue"><i class="ri-user-smile-fill"></i></div>
                    <div class="tm-info"><span class="tm-name">오다은</span><span class="tm-role">Backend</span></div>
                    <div class="status-dot online"></div>
                </li>
                <li>
                    <div class="tm-avt bg-purple"><i class="ri-user-star-fill"></i></div>
                    <div class="tm-info"><span class="tm-name">이지영</span><span class="tm-role">Frontend</span></div>
                    <div class="status-dot online"></div>
                </li>
                <li>
                    <div class="tm-avt bg-gray"><i class="ri-user-heart-fill"></i></div>
                    <div class="tm-info"><span class="tm-name">최하늘</span><span class="tm-role">CS Manager</span></div>
                    <div class="status-dot offline"></div>
                </li>
            </ul>
        </div>

        <div class="widget-box clock-widget">
            <div class="wg-header"><span>World Clock</span></div>
            <div class="world-clocks">
                <div class="w-clock">
                    <span class="wc-city">Seoul</span>
                    <span class="wc-time" id="timeSeoul"></span>
                </div>
                <div class="w-clock">
                    <span class="wc-city">New York</span>
                    <span class="wc-time" id="timeNY"></span>
                </div>
                <div class="w-clock">
                    <span class="wc-city">London</span>
                    <span class="wc-time" id="timeLDN"></span>
                </div>
            </div>
        </div>

        <div class="widget-box memo-widget">
            <div class="wg-header"><span>Quick Memo</span><i class="ri-edit-line"></i></div>
            <textarea placeholder="자유롭게 메모를 작성하세요..."></textarea>
        </div>
    </div>
</div>