<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<header class="agency-header">
    <div class="head-left">
        <button id="sidebarToggle" class="toggle-icon"><i class="ri-menu-4-fill"></i></button>
    </div>

    <div class="head-center" id="systemUtilityTrigger">
        <span id="systemClock"></span>
    </div>

    <div class="head-right">
        <div class="noti-btn">
            <i class="ri-notification-3-fill"></i>
            <div class="noti-ring"></div>
        </div>

        <div class="user-avt-btn" id="profileTrigger">
            A
        </div>

        <div class="pop-modal" id="profileModal">
            <div class="sq-user">
                <div class="sq-avt">AD</div>
                <div class="sq-info">
                    <span class="sq-name">Admin User</span>
                    <span class="sq-role">Super Admin</span>
                </div>
            </div>
            
            <div class="sq-grid">
                <div class="sq-box" onclick="window.open('${pageContext.request.contextPath}/')">
                    <i class="ri-window-fill"></i>
                    Site
                </div>
                <div class="sq-box">
                    <i class="ri-equalizer-fill"></i>
                    Setup
                </div>
                <div class="sq-box">
                    <i class="ri-user-settings-fill"></i>
                    Profile
                </div>
                <div class="sq-box red" onclick="location.href='${pageContext.request.contextPath}/member/logout'">
                    <i class="ri-shut-down-line"></i>
                    Logout
                </div>
            </div>
        </div>
    </div>
</header>

<div class="huge-modal" id="systemUtilityModal">
    <div class="wg-box">
        <div class="wg-tl">
            <span id="modalMonth"></span>
            <i class="ri-calendar-event-fill" style="color:var(--color-purple);"></i>
        </div>
        <div class="cal-wrap" id="miniCalGrid"></div>
    </div>

    <div class="wg-box">
        <div class="wg-tl">Team Status</div>
        <div class="team-rows">
            <div class="t-row">
                <div class="t-avt">OD</div>
                <div class="t-info">오다은</div>
                <div class="t-dot active"></div>
            </div>
            <div class="t-row">
                <div class="t-avt">JY</div>
                <div class="t-info">이지영</div>
                <div class="t-dot active"></div>
            </div>
            <div class="t-row">
                <div class="t-avt">HN</div>
                <div class="t-info">최하늘</div>
                <div class="t-dot active"></div>
            </div>
            <div class="t-row">
                <div class="t-avt">MN</div>
                <div class="t-info" style="color:var(--text-light);">정명남</div>
                <div class="t-dot away"></div>
            </div>
            <div class="t-row">
                <div class="t-avt">HS</div>
                <div class="t-info" style="color:var(--text-light);">함형서</div>
                <div class="t-dot away"></div>
            </div>
        </div>
    </div>

    <div class="wg-box">
        <div class="wg-tl">World Clocks</div>
        <div class="wt-row"><span class="wt-lbl">Seoul</span><span class="wt-val" id="timeSeoul"></span></div>
        <div class="wt-row"><span class="wt-lbl">New York</span><span class="wt-val" id="timeNY"></span></div>
        <div class="wt-row"><span class="wt-lbl">London</span><span class="wt-val" id="timeLDN"></span></div>
    </div>

    <div class="wg-box">
        <div class="wg-tl">Scratchpad</div>
        <textarea class="memo-pad" placeholder="Jot something down..."></textarea>
    </div>
</div>