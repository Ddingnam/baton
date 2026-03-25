document.addEventListener("DOMContentLoaded", () => {
    const path = window.location.pathname;

	let domainColor, domainBgColor, pageBg, currentDomain;
	
    if (path.includes('/trade/')) {
        domainColor = '#00B98D';
        domainBgColor = '#E6F8F3';
        pageBg = '#F9FAFB';
        currentDomain = 'trade';
    } else if (path.includes('/crew/')) {
        domainColor = '#F86D7D';
        domainBgColor = '#FFF0F1';
        pageBg = '#FFFBFB';
        currentDomain = 'crew';
    } else if (path.includes('/alba/')) {
        domainColor = '#002C5F';
        domainBgColor = '#F0F4F8';
        pageBg = '#F9FAFB';
        currentDomain = 'alba';
    } else if (path.includes('/community/')) {
        domainColor = '#8A63FF';
        domainBgColor = '#F4F0FF';
        pageBg = '#FBF9FF';
        currentDomain = 'community';
    } else {
		domainColor = '#3182F6';
		domainBgColor = '#E8F3FF';
		pageBg = '#F8FAFF';
		currentDomain = 'home'; 
	}

    if (!path.includes('/mypage')) {
        document.documentElement.style.setProperty('--header-domain-color', domainColor);
        document.documentElement.style.setProperty('--header-domain-bg', domainBgColor);
        document.documentElement.style.setProperty('--page-theme-bg', pageBg);
        document.body.style.backgroundColor = pageBg;
    }

    const mypageLink = document.querySelector('.mypage-link');
    if (mypageLink && currentDomain !== 'home') {
        const baseUrl = mypageLink.getAttribute('href')?.split('?')[0] || '';
        if(baseUrl) {
             mypageLink.setAttribute('href', baseUrl + '?tab=' + currentDomain);
        }
    }

    const navLinks = document.querySelectorAll('.nav-menu .nav-link');
    navLinks.forEach(link => {
        const domain = link.getAttribute('data-domain');
        if (domain === 'home' && (path === '/' || path.endsWith('/index.jsp'))) {
            link.classList.add('active');
        } else if (domain && domain !== 'home' && path.includes('/' + domain + '/')) {
            link.classList.add('active');
        }
    });

    const sideLinks = document.querySelectorAll('.sidebar-menu .side-link');
    document.querySelectorAll('.sidebar-menu li').forEach(li => li.classList.remove('active'));

    let isSideActive = false;
    sideLinks.forEach(link => {
        const domain = link.getAttribute('data-domain');
        if (domain && domain !== 'home' && path.includes('/' + domain + '/')) {
            link.parentElement.classList.add('active');
            isSideActive = true;
        }
    });

    if (!isSideActive && document.querySelector('.sidebar-menu')) {
        const homeLink = document.querySelector('.sidebar-menu .side-link[data-domain="home"]');
        if (homeLink) homeLink.parentElement.classList.add('active');
    }
    
    const profileBtn = document.getElementById('profileDropdownBtn');
    const profileMenu = document.getElementById('profileDropdownMenu');
    const notifBtn = document.getElementById('notifDropdownBtn');
    const notifMenu = document.getElementById('notifDropdownMenu');

    if (profileBtn && profileMenu) {
        profileBtn.addEventListener('click', (e) => {
            e.preventDefault();
            e.stopPropagation();
            profileBtn.classList.toggle('active');
            profileMenu.classList.toggle('show');
            if (notifMenu) notifMenu.style.display = 'none';
        });
    }

    if (notifBtn && notifMenu) {
        notifBtn.addEventListener('click', (e) => {
            e.preventDefault();
            e.stopPropagation();
            notifMenu.style.display = notifMenu.style.display === 'none' || notifMenu.style.display === '' ? 'block' : 'none';
            if (profileBtn) profileBtn.classList.remove('active');
            if (profileMenu) profileMenu.classList.remove('show');
        });
        
        notifMenu.addEventListener('click', (e) => {
            e.stopPropagation();
        });
    }

    document.addEventListener('click', (e) => {
        if (profileBtn && profileMenu && !profileBtn.contains(e.target) && !profileMenu.contains(e.target)) {
            profileBtn.classList.remove('active');
            profileMenu.classList.remove('show');
        }
        if (notifBtn && notifMenu && !notifBtn.contains(e.target) && !notifMenu.contains(e.target)) {
            notifMenu.style.display = 'none';
        }
    });
	
	const displayMsg = window.SERVER_MSG || window.SERVER_MESSAGE;
    if (displayMsg && displayMsg.trim() !== "") {
        showBatonToast(displayMsg);
    }
	
	if (window.IS_FIRST_LOGIN && !window.HAS_MAIN_REGION) {
	    $("#batonAuthLayer").fadeIn(300);
	}

    if (window.LOGGED_IN_USER_ID) {
        checkUnreadAlarms();
        fetchNotifications();
        connectGlobalAlarm();
        window.addEventListener('focus', checkUnreadAlarms);
    }
	
    const adminIcon = document.querySelector('.admin-icon');
    const adminOverlay = document.getElementById('adminTransitionOverlay');

    const ADMIN_THEME_COLORS = {
        purple:  { c1: '#7C3AED', c2: '#EC4899' },
        blue:    { c1: '#1D4ED8', c2: '#06B6D4' },
        emerald: { c1: '#059669', c2: '#3B82F6' },
        sunset:  { c1: '#EA580C', c2: '#EF4444' },
        rose:    { c1: '#BE185D', c2: '#F43F5E' },
        slate:   { c1: '#334155', c2: '#64748B' }
    };

    function applyThemeToOverlay() {
        var newKey = 'baton-admin-theme-' + (window.LOGGED_IN_USER_ID || '');
        var theme  = localStorage.getItem(newKey) || localStorage.getItem('baton-admin-theme') || 'purple';
        var colors = ADMIN_THEME_COLORS[theme] || ADMIN_THEME_COLORS.purple;
        var spinner = adminOverlay ? adminOverlay.querySelector('.admin-loader-spinner') : null;
        var dot     = adminOverlay ? adminOverlay.querySelector('.admin-loader-text .dot') : null;
        if (spinner) {
            spinner.style.background = 'conic-gradient(from 0deg, ' + colors.c1 + ', ' + colors.c2 + ', transparent 60%)';
        }
        if (dot) {
            dot.style.color = colors.c1;
        }
    }

    if (adminIcon && adminOverlay) {
        adminIcon.addEventListener('click', function(e) {
            e.preventDefault();
            const targetUrl = this.getAttribute('href');

            applyThemeToOverlay();
            adminOverlay.style.display = 'flex';
            
            setTimeout(() => {
                adminOverlay.classList.add('show');
            }, 10);
            
            setTimeout(() => {
                window.location.href = targetUrl;
            }, 1200);
        });
    }
	
	const crewBtn = document.getElementById('crew-chat-trigger');

	if (crewBtn) {
	    crewBtn.addEventListener('click', function() {
	        if (typeof window.toggleCrewChat === 'function') {
	            window.toggleCrewChat();
	        }
	    });
	}
});

function showBatonToast(text) {
    const container = document.getElementById('baton-toast-container');
    if (!container) return;

    const toast = document.createElement('div');
    toast.className = 'baton-toast-item';
    toast.innerHTML = `
        <i class="ri-information-line toast-icon"></i>
        <span class="toast-text">${text}</span>
    `;
    
    container.appendChild(toast);

    setTimeout(() => {
        toast.classList.add('hide');
        
        setTimeout(() => {
            if (toast && toast.parentNode) {
                toast.remove();
            }
        }, 700); 
    }, 2000);
}

function closeBatonAuthLayer() {
    $("#batonAuthLayer").fadeOut(200);
}

function fetchNotifications() {
    fetch(window.contextPath + '/api/notification/list')
    .then(res => res.json())
    .then(data => {
        let list = document.getElementById('notifList');
        if(!list) return;
        list.innerHTML = '';
        if(!data || data.length === 0) {
            list.innerHTML = '<div style="padding:40px; text-align:center; color:#999; font-size:14px;"><i class="ri-notification-badge-line" style="font-size:24px; display:block; margin-bottom:10px; color:#ddd;"></i>새로운 알림이 없습니다.</div>';
        } else {
            data.forEach(n => renderSingleNotif(n, false));
        }
    });

    fetch(window.contextPath + '/api/notification/unreadCount')
    .then(res => res.text())
    .then(count => {
        let badge = document.getElementById('notifBadge');
        if(!badge) return;
        if(parseInt(count) > 0) {
            badge.style.display = 'block';
        } else {
            badge.style.display = 'none';
        }
    });
}

function renderSingleNotif(notif, prepend = true) {
    let list = document.getElementById('notifList');
    if(!list) return;
    if(list.querySelector('.ri-notification-badge-line')) list.innerHTML = '';

    let bg = notif.isRead === 0 ? '#F2FAF8' : '#fff';
    let html = '<div id="notif-' + notif.notifIdx + '" style="padding:15px 20px; border-bottom:1px solid #eee; background:' + bg + '; cursor:pointer; transition:0.2s;" onclick="readNotif(' + notif.notifIdx + ', \'' + notif.url + '\')">' +
               '<div style="font-size:12px; color:#00B98D; font-weight:700; margin-bottom:5px;">' + notif.notifType + '</div>' +
               '<div style="font-size:14px; color:#333; margin-bottom:6px; word-break:break-all; line-height:1.4;">' + notif.content + '</div>' +
               '<div style="font-size:11px; color:#999;">' + notif.createdAt + '</div>' +
               '</div>';
    
    if(prepend) {
        list.insertAdjacentHTML('afterbegin', html);
    } else {
        list.insertAdjacentHTML('beforeend', html);
    }
}

function readNotif(notifIdx, url) {
    fetch(window.contextPath + '/api/notification/read', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'notifIdx=' + notifIdx
    }).then(() => {
        if(url && url !== 'null') location.href = window.contextPath + url;
    });
}

function readAllNotifications() {
    fetch(window.contextPath + '/api/notification/readAll', { method: 'POST' })
    .then(() => { fetchNotifications(); });
}

function checkUnreadAlarms() {
    let chatUrl = window.contextPath + '/chat/api/unread?_=' + new Date().getTime();
    let notifUrl = window.contextPath + '/api/notification/unreadCount?_=' + new Date().getTime();

    Promise.all([
        fetch(chatUrl, { cache: 'no-store' }).then(res => res.text()).catch(() => "0"),
        fetch(notifUrl, { cache: 'no-store' }).then(res => res.text()).catch(() => "0")
    ]).then(([chatCount, notifCount]) => {
        if (parseInt(chatCount) > 0 || parseInt(notifCount) > 0) {
            turnOnAlarmDots();
        } else {
            turnOffAlarmDots();
        }
    });
}

function connectGlobalAlarm() {
    let socket = new SockJS(window.contextPath + '/ws/chat');
    let stompClient = Stomp.over(socket);
    stompClient.debug = null; 

    stompClient.connect({}, function (frame) {
		stompClient.subscribe('/topic/alarms/' + window.LOGGED_IN_USER_ID, function (message) {
            try {
                let data = JSON.parse(message.body);

                if(data.notifType) {
                    renderSingleNotif(data, true);
                    turnOnAlarmDots();
                    showBatonToast("🔔 [" + data.notifType + "] " + data.content); 
                    return;
                }
                
                if(data.type === 'CHAT') {
                    turnOnAlarmDots();
                    showBatonToast("💬 " + data.sender + ": " + data.content); 
                    return;
                }
            } catch(e) {}

            if(message.body.includes('read_chat')) {
                checkUnreadAlarms();
            } else if(message.body.includes('room_deleted')) {
                let deletedRoomIdx = message.body.split(':')[1];
                let roomEl = document.getElementById('room-' + deletedRoomIdx);
                if(roomEl) roomEl.remove();
            }
        });
    });
}

function turnOnAlarmDots() {
    let dot1 = document.querySelector('.badge-dot-inline');
    let dot2 = document.querySelector('.notification-dot');
    if(dot1) dot1.style.display = 'inline-block';
    if(dot2) dot2.style.display = 'inline-block';
}

function turnOffAlarmDots() {
    let dot1 = document.querySelector('.badge-dot-inline');
    let dot2 = document.querySelector('.notification-dot');
    if(dot1) dot1.style.display = 'none';
    if(dot2) dot2.style.display = 'none';
}

function switchRegion(regionType) {
    fetch(window.contextPath + '/member/api/switchActiveRegion', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'regionType=' + regionType
    })
    .then(res => res.json())
    .then(data => {
        if (data.state === 'success') {
            location.reload();
        }
    })
    .catch(err => console.error('switchRegion error:', err));
}