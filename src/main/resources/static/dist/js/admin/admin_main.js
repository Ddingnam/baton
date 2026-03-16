document.addEventListener("DOMContentLoaded", () => {
    
    const sidebarToggle = document.getElementById('sidebarToggle');
    const mainSidebar = document.querySelector('.agency-sidebar');
    if (sidebarToggle && mainSidebar) {
        sidebarToggle.addEventListener('click', () => {
            mainSidebar.classList.toggle('hidden');
            setTimeout(() => { if (window.dashChart) window.dashChart.resize(); }, 400);
        });
    }

    document.querySelectorAll('.nav-box.has-child > .nav-btn').forEach(header => {
        header.addEventListener('click', function(e) {
            e.preventDefault();
            const parentBox = this.parentElement;
            document.querySelectorAll('.nav-box.has-child').forEach(box => {
                if (box !== parentBox) box.classList.remove('open');
            });
            parentBox.classList.toggle('open');
        });
    });

    const triggerProfile = document.getElementById('profileTrigger');
    const modalProfile = document.getElementById('profileModal');
    const triggerUtility = document.getElementById('systemUtilityTrigger');
    const modalUtility = document.getElementById('systemUtilityModal');
    const triggerNoti = document.getElementById('notiTrigger');
    const modalNoti = document.getElementById('notiModal');

    function closeAllPopups() {
        [modalProfile, modalUtility, modalNoti].forEach(m => m && m.classList.remove('show'));
    }

    if (triggerProfile && modalProfile) {
        triggerProfile.addEventListener('click', e => {
            e.stopPropagation();
            const wasOpen = modalProfile.classList.contains('show');
            closeAllPopups();
            if (!wasOpen) modalProfile.classList.add('show');
        });
    }

    if (triggerUtility && modalUtility) {
        triggerUtility.addEventListener('click', e => {
            e.stopPropagation();
            const wasOpen = modalUtility.classList.contains('show');
            closeAllPopups();
            if (!wasOpen) { modalUtility.classList.add('show'); renderCal(); }
        });
    }

    if (triggerNoti && modalNoti) {
        triggerNoti.addEventListener('click', e => {
            e.stopPropagation();
            const wasOpen = modalNoti.classList.contains('show');
            closeAllPopups();
            if (!wasOpen) modalNoti.classList.add('show');
        });
    }

    document.addEventListener('click', e => {
        const inModal = [modalProfile, modalUtility, modalNoti].some(m => m && m.contains(e.target));
        const inTrigger = [triggerProfile, triggerUtility, triggerNoti].some(t => t && t.contains(e.target));
        if (!inModal && !inTrigger) closeAllPopups();
    });

    const notiReadAll = document.querySelector('.noti-read-all');
    if (notiReadAll) {
        notiReadAll.addEventListener('click', () => {
            document.querySelectorAll('.noti-item.unread').forEach(i => i.classList.remove('unread'));
            document.querySelectorAll('.noti-dot').forEach(d => d.remove());
        });
    }

    const setupOverlay = document.getElementById('setupOverlay');
    const profileOverlay = document.getElementById('profileOverlay');
    const setupTrigger = document.getElementById('setupTrigger');
    const myProfileTrigger = document.getElementById('myProfileTrigger');
    const setupClose = document.getElementById('setupClose');
    const profileFullClose = document.getElementById('profileFullClose');

    if (setupTrigger && setupOverlay) {
        setupTrigger.addEventListener('click', () => {
            closeAllPopups();
            setupOverlay.classList.add('show');
        });
    }
    if (myProfileTrigger && profileOverlay) {
        myProfileTrigger.addEventListener('click', () => {
            closeAllPopups();
            profileOverlay.classList.add('show');
        });
    }
    if (setupClose) setupClose.addEventListener('click', () => setupOverlay.classList.remove('show'));
    if (profileFullClose) profileFullClose.addEventListener('click', () => profileOverlay.classList.remove('show'));

    [setupOverlay, profileOverlay].forEach(overlay => {
        if (!overlay) return;
        overlay.addEventListener('click', e => {
            if (e.target === overlay) overlay.classList.remove('show');
        });
    });

    document.querySelectorAll('.fm-nav-item[data-tab]').forEach(btn => {
        btn.addEventListener('click', function() {
            const tab = this.dataset.tab;
            this.closest('.fm-sidebar').querySelectorAll('.fm-nav-item').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            this.closest('.fullscreen-modal').querySelectorAll('.fm-tab').forEach(t => t.classList.remove('active'));
            const target = document.getElementById('tab-' + tab);
            if (target) target.classList.add('active');
        });
    });

    document.querySelectorAll('.fm-nav-item[data-ptab]').forEach(btn => {
        btn.addEventListener('click', function() {
            const tab = this.dataset.ptab;
            this.closest('.fm-sidebar').querySelectorAll('.fm-nav-item').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            this.closest('.fullscreen-modal').querySelectorAll('.fm-tab').forEach(t => t.classList.remove('active'));
            const target = document.getElementById('ptab-' + tab);
            if (target) target.classList.add('active');
        });
    });

    function runClock() {
        const d = new Date();
        const headClock = document.getElementById('systemClock');
        if (headClock) headClock.innerText = d.toLocaleString('ko-KR', { month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit', hour12: false });
        const cSeoul = document.getElementById('timeSeoul');
        const cNy = document.getElementById('timeNY');
        const cLdn = document.getElementById('timeLDN');
        if (cSeoul) cSeoul.innerText = d.toLocaleTimeString('ko-KR', { timeZone: 'Asia/Seoul', hour: '2-digit', minute: '2-digit', hour12: false });
        if (cNy) cNy.innerText = d.toLocaleTimeString('ko-KR', { timeZone: 'America/New_York', hour: '2-digit', minute: '2-digit', hour12: false });
        if (cLdn) cLdn.innerText = d.toLocaleTimeString('ko-KR', { timeZone: 'Europe/London', hour: '2-digit', minute: '2-digit', hour12: false });
    }
    setInterval(runClock, 1000);
    runClock();

    let calYear = new Date().getFullYear();
    let calMonth = new Date().getMonth();
    const today = new Date();

    function renderCal() {
        const cGrid = document.getElementById('miniCalGrid');
        if (!cGrid) return;
        const monthLabel = document.getElementById('modalMonth');
        if (monthLabel) monthLabel.innerText = new Date(calYear, calMonth).toLocaleString('ko-KR', { year: 'numeric', month: 'long' });
        const tDays = new Date(calYear, calMonth + 1, 0).getDate();
        const sDay = new Date(calYear, calMonth, 1).getDay();
        const isCurrentMonth = calYear === today.getFullYear() && calMonth === today.getMonth();
        let h = '';
        ['일', '월', '화', '수', '목', '금', '토'].forEach(dy => h += `<div class="c-wk">${dy}</div>`);
        for (let i = 0; i < sDay; i++) h += `<div></div>`;
        for (let i = 1; i <= tDays; i++) {
            const isToday = isCurrentMonth && i === today.getDate();
            h += `<div class="c-dt ${isToday ? 'on' : ''}">${i}</div>`;
        }
        cGrid.innerHTML = h;
    }

    const calPrev = document.getElementById('calPrev');
    const calNext = document.getElementById('calNext');
    const calTodayBtn = document.getElementById('calToday');
    if (calPrev) calPrev.addEventListener('click', e => { e.stopPropagation(); calMonth--; if (calMonth < 0) { calMonth = 11; calYear--; } renderCal(); });
    if (calNext) calNext.addEventListener('click', e => { e.stopPropagation(); calMonth++; if (calMonth > 11) { calMonth = 0; calYear++; } renderCal(); });
    if (calTodayBtn) calTodayBtn.addEventListener('click', e => { e.stopPropagation(); calYear = today.getFullYear(); calMonth = today.getMonth(); renderCal(); });

    const ctx = document.getElementById('gradientChart');
    if (ctx) {
        const strokeGrad = ctx.getContext('2d').createLinearGradient(0, 0, 600, 0);
        strokeGrad.addColorStop(0, '#7C3AED');
        strokeGrad.addColorStop(1, '#EC4899');
        const bgGrad = ctx.getContext('2d').createLinearGradient(0, 0, 0, 400);
        bgGrad.addColorStop(0, 'rgba(124, 58, 237, 0.2)');
        bgGrad.addColorStop(1, 'rgba(236, 72, 153, 0)');
        window.dashChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['월', '화', '수', '목', '금', '토', '일'],
                datasets: [{
                    label: '매출',
                    data: [32000, 45000, 38000, 52000, 48000, 65000, 58000],
                    borderColor: strokeGrad,
                    borderWidth: 4,
                    backgroundColor: bgGrad,
                    fill: true,
                    pointBackgroundColor: '#FFFFFF',
                    pointBorderColor: '#7C3AED',
                    pointBorderWidth: 3,
                    pointRadius: 6,
                    pointHoverRadius: 8,
                    tension: 0.5
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                interaction: { mode: 'index', intersect: false },
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        backgroundColor: '#0F172A', titleColor: '#94A3B8', bodyColor: '#FFFFFF',
                        bodyFont: { weight: '700', size: 14, family: 'Montserrat' }, padding: 16, cornerRadius: 12, displayColors: false,
                        callbacks: { label: c => '₩ ' + c.raw.toLocaleString() }
                    }
                },
                scales: {
                    x: { grid: { display: false }, border: { display: false }, ticks: { color: '#94A3B8', font: { family: 'Montserrat', size: 12, weight: '700' } } },
                    y: { grid: { color: '#EAECEF', borderDash: [6, 6], drawBorder: false }, border: { display: false }, ticks: { color: '#94A3B8', font: { family: 'Montserrat', size: 12, weight: '700' }, padding: 16, callback: v => (v / 10000) + 'M' } }
                }
            }
        });
    }

    document.querySelectorAll('.pill-tab').forEach(btn => {
        btn.addEventListener('click', function() {
            this.closest('.pill-tabs').querySelectorAll('.pill-tab').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
        });
    });
});