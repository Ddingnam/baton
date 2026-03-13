document.addEventListener("DOMContentLoaded", () => {
    
    const sidebarToggle = document.getElementById('sidebarToggle');
    const mainSidebar = document.querySelector('.agency-sidebar');
    
    if (sidebarToggle && mainSidebar) {
        sidebarToggle.addEventListener('click', () => {
            mainSidebar.classList.toggle('hidden');
            setTimeout(() => { if (window.dashChart) window.dashChart.resize(); }, 400);
        });
    }

    const accHeaders = document.querySelectorAll('.nav-box.has-child > .nav-btn');
    accHeaders.forEach(header => {
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

    if(triggerProfile && modalProfile) {
        triggerProfile.addEventListener('click', (e) => {
            e.stopPropagation();
            modalProfile.classList.toggle('show');
            if(modalUtility) modalUtility.classList.remove('show');
        });
    }

    if(triggerUtility && modalUtility) {
        triggerUtility.addEventListener('click', (e) => {
            e.stopPropagation();
            modalUtility.classList.toggle('show');
            if(modalProfile) modalProfile.classList.remove('show');
            renderCal(); 
        });
    }

    document.addEventListener('click', (e) => {
        if (modalProfile && !modalProfile.contains(e.target) && !triggerProfile.contains(e.target)) {
            modalProfile.classList.remove('show');
        }
        if (modalUtility && !modalUtility.contains(e.target) && !triggerUtility.contains(e.target)) {
            modalUtility.classList.remove('show');
        }
    });

    function runClock() {
        const d = new Date();
        const headClock = document.getElementById('systemClock');
        if(headClock) headClock.innerText = d.toLocaleString('en-US', { month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit', hour12: true });
        
        const cSeoul = document.getElementById('timeSeoul');
        const cNy = document.getElementById('timeNY');
        const cLdn = document.getElementById('timeLDN');
        
        if(cSeoul) cSeoul.innerText = d.toLocaleTimeString('en-US', { timeZone: 'Asia/Seoul', hour: '2-digit', minute: '2-digit', hour12: false });
        if(cNy) cNy.innerText = d.toLocaleTimeString('en-US', { timeZone: 'America/New_York', hour: '2-digit', minute: '2-digit', hour12: false });
        if(cLdn) cLdn.innerText = d.toLocaleTimeString('en-US', { timeZone: 'Europe/London', hour: '2-digit', minute: '2-digit', hour12: false });
    }
    setInterval(runClock, 1000); runClock();

    function renderCal() {
        const cGrid = document.getElementById('miniCalGrid');
        if(!cGrid) return;
        const d = new Date();
        document.getElementById('modalMonth').innerText = d.toLocaleString('en-US', { month: 'long', year: 'numeric' });
        const tDays = new Date(d.getFullYear(), d.getMonth()+1, 0).getDate();
        const sDay = new Date(d.getFullYear(), d.getMonth(), 1).getDay();
        const tdy = d.getDate();
        let h = '';
        ['S','M','T','W','T','F','S'].forEach(dy => h += `<div class="c-wk">${dy}</div>`);
        for(let i=0; i<sDay; i++) h += `<div></div>`;
        for(let i=1; i<=tDays; i++) {
            const act = i === tdy ? 'on' : '';
            h += `<div class="c-dt ${act}">${i}</div>`;
        }
        cGrid.innerHTML = h;
    }

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
                labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                datasets: [{
                    label: 'Revenue', 
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
                        callbacks: { label: c => '₩ ' + (c.raw).toLocaleString() }
                    }
                },
                scales: {
                    x: { grid: { display: false }, border: { display: false }, ticks: { color: '#94A3B8', font: { family: 'Montserrat', size: 12, weight: '700' } } },
                    y: { grid: { color: '#EAECEF', borderDash: [6, 6], drawBorder: false }, border: { display: false }, ticks: { color: '#94A3B8', font: { family: 'Montserrat', size: 12, weight: '700' }, padding: 16, callback: v => (v / 10000) + 'M' } }
                }
            }
        });
    }

    const pillTabs = document.querySelectorAll('.pill-tab');
    pillTabs.forEach(btn => {
        btn.addEventListener('click', function() {
            this.closest('.pill-tabs').querySelectorAll('.pill-tab').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
        });
    });
});