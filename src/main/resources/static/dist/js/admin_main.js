document.addEventListener("DOMContentLoaded", () => {
    
    const toggleBtn = document.getElementById('sidebarToggle');
    const sidebar = document.querySelector('.sidebar');
    
    if(toggleBtn && sidebar) {
        toggleBtn.addEventListener('click', () => {
            sidebar.classList.toggle('hidden');
            
            setTimeout(() => {
                if(window.mainChart) window.mainChart.resize();
            }, 450);
        });
    }

    const navHeaders = document.querySelectorAll('.nav-item.has-sub > .nav-link');

    navHeaders.forEach(header => {
        header.addEventListener('click', function(e) {
            e.preventDefault(); 
            
            const parentItem = this.parentElement;
            const isOpen = parentItem.classList.contains('open');

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
        });

        document.addEventListener('click', (e) => {
            if (!profileTrigger.contains(e.target) && !profileModal.contains(e.target)) {
                profileModal.classList.remove('active');
            }
        });
    }

    renderCalendar();
    if(document.getElementById('bigChart')) {
        initChart();
    }
});

function renderCalendar() {
    const grid = document.getElementById('calGrid');
    if(!grid) return;
    const now = new Date();
    const monthEl = document.getElementById('calMonth');
    if(monthEl) monthEl.innerText = now.toLocaleString('en-US', { month: 'long', year: 'numeric' });
    const daysInMonth = new Date(now.getFullYear(), now.getMonth()+1, 0).getDate();
    const startDay = new Date(now.getFullYear(), now.getMonth(), 1).getDay();
    const today = now.getDate();
    let html = '';
    ['S','M','T','W','T','F','S'].forEach(d => html += `<div class="cd-h" style="text-align:center; font-weight:700; color:#A3AED0; font-size:12px;">${d}</div>`);
    for(let i=0; i<startDay; i++) html += `<div></div>`;
    for(let i=1; i<=daysInMonth; i++) {
        const cls = i === today ? 'today' : '';
        html += `<div class="cd-d ${cls}">${i}</div>`;
    }
    grid.innerHTML = html;
}

function initChart() {
    const ctx = document.getElementById('bigChart').getContext('2d');
    const gradient = ctx.createLinearGradient(0, 0, 0, 500);
    gradient.addColorStop(0, 'rgba(67, 24, 255, 0.4)');
    gradient.addColorStop(1, 'rgba(67, 24, 255, 0)');

    window.mainChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            datasets: [{
                label: 'Revenue',
                data: [2100, 3200, 2800, 4500, 3900, 5800, 6500],
                borderColor: '#4318FF',
                borderWidth: 4,
                backgroundColor: gradient,
                fill: true,
                pointBackgroundColor: '#fff',
                pointBorderColor: '#4318FF',
                pointRadius: 6,
                pointHoverRadius: 10,
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                x: { grid: { display: false }, ticks: { font: { family: 'Pretendard' } } },
                y: { grid: { color: '#E0E5F2', borderDash: [5, 5] }, border: { display: false } }
            }
        }
    });
}