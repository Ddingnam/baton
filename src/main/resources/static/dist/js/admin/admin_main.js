document.addEventListener("DOMContentLoaded", () => {
    
    const toggleBtn = document.getElementById('sidebarToggle');
    const sidebar = document.querySelector('.sidebar');
    
    if(toggleBtn && sidebar) {
        toggleBtn.addEventListener('click', () => {
            sidebar.classList.toggle('hidden');
            setTimeout(() => {
                if(window.mainChart) window.mainChart.resize();
            }, 400);
        });
    }

    const navHeaders = document.querySelectorAll('.nav-item.has-sub > .nav-link');

    navHeaders.forEach(header => {
        header.addEventListener('click', function(e) {
            e.preventDefault(); 
            const parentItem = this.parentElement;
            
            document.querySelectorAll('.nav-item.has-sub').forEach(item => {
                if (item !== parentItem) {
                    item.classList.remove('open');
                }
            });

            parentItem.classList.toggle('open');
        });
    });

    const profileTrigger = document.getElementById('profileTrigger');
    const profileModal = document.getElementById('profileModal');
    
    if(profileTrigger && profileModal) {
        profileTrigger.addEventListener('click', (e) => {
            e.stopPropagation();
            profileModal.classList.toggle('active');
            if(document.getElementById('systemUtilityModal')) {
                document.getElementById('systemUtilityModal').classList.remove('active');
            }
        });
    }

    const utilTrigger = document.getElementById('systemUtilityTrigger');
    const utilModal = document.getElementById('systemUtilityModal');
    
    if(utilTrigger && utilModal) {
        utilTrigger.addEventListener('click', (e) => {
            e.stopPropagation();
            utilModal.classList.toggle('active');
            if(profileModal) profileModal.classList.remove('active');
            renderCalendar();
        });
    }

    document.addEventListener('click', (e) => {
        if (profileTrigger && profileModal && !profileTrigger.contains(e.target) && !profileModal.contains(e.target)) {
            profileModal.classList.remove('active');
        }
        if (utilTrigger && utilModal && !utilTrigger.contains(e.target) && !utilModal.contains(e.target)) {
            utilModal.classList.remove('active');
        }
    });

    function updateClocks() {
        const now = new Date();
        const mainClock = document.getElementById('systemClock');
        if(mainClock) {
            const options = { month: 'long', day: 'numeric', weekday: 'short', hour: '2-digit', minute: '2-digit' };
            mainClock.innerText = now.toLocaleString('ko-KR', options);
        }

        const timeSeoul = document.getElementById('timeSeoul');
        const timeNY = document.getElementById('timeNY');
        const timeLDN = document.getElementById('timeLDN');

        if(timeSeoul) timeSeoul.innerText = now.toLocaleTimeString('en-US', { timeZone: 'Asia/Seoul', hour: '2-digit', minute: '2-digit', hour12: false });
        if(timeNY) timeNY.innerText = now.toLocaleTimeString('en-US', { timeZone: 'America/New_York', hour: '2-digit', minute: '2-digit', hour12: false });
        if(timeLDN) timeLDN.innerText = now.toLocaleTimeString('en-US', { timeZone: 'Europe/London', hour: '2-digit', minute: '2-digit', hour12: false });
    }
    
    setInterval(updateClocks, 1000);
    updateClocks();

    function renderCalendar() {
        const grid = document.getElementById('miniCalGrid');
        if(!grid) return;
        
        const now = new Date();
        const monthEl = document.getElementById('modalMonth');
        if(monthEl) monthEl.innerText = now.toLocaleString('en-US', { month: 'long', year: 'numeric' }).toUpperCase();
        
        const daysInMonth = new Date(now.getFullYear(), now.getMonth()+1, 0).getDate();
        const startDay = new Date(now.getFullYear(), now.getMonth(), 1).getDay();
        const today = now.getDate();
        
        let html = '';
        ['S','M','T','W','T','F','S'].forEach(d => html += `<div class="cd-h">${d}</div>`);
        for(let i=0; i<startDay; i++) html += `<div></div>`;
        for(let i=1; i<=daysInMonth; i++) {
            const cls = i === today ? 'today' : '';
            html += `<div class="cd-d ${cls}">${i}</div>`;
        }
        grid.innerHTML = html;
    }
    
    if(document.getElementById('miniCalGrid')) {
        renderCalendar();
    }
});