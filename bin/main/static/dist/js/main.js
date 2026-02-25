document.addEventListener("DOMContentLoaded", () => {
    
    const intro = document.getElementById('baton-intro');
    if (intro) {
        window.addEventListener('load', () => {
            setTimeout(() => {
                intro.style.opacity = '0';
                setTimeout(() => intro.style.visibility = 'hidden', 800);
            }, 1500); 
        });
    }

    const observerOptions = { threshold: 0.1 };
    const revealObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = "1";
                entry.target.style.transform = "translateY(0)";
                
                if (entry.target.id === 'stats-section') {
                    startCounterAnimation();
                }
                
                revealObserver.unobserve(entry.target);
            }
        });
    }, observerOptions);

    document.querySelectorAll('.reveal').forEach(el => {
        el.style.opacity = "0";
        el.style.transform = "translateY(40px)";
        el.style.transition = "all 0.8s cubic-bezier(0.22, 1, 0.36, 1)";
        revealObserver.observe(el);
    });
});

// ==========================================
// 3. 통계 카운터 애니메이션 함수
// ==========================================
function startCounterAnimation() {
    const counterEl = document.getElementById('counter');
    if (!counterEl) return;
    
    let start = 0;
    const end = 1584200;
    const duration = 2000;
    
    const timer = setInterval(() => {
        start += Math.floor(end / 40);
        if (start >= end) {
            counterEl.innerText = end.toLocaleString();
            clearInterval(timer);
        } else {
            counterEl.innerText = start.toLocaleString();
        }
    }, 50);
}

// ==========================================
// 4. 찜하기(하트) 토글 기능
// ==========================================
function toggleWish(el, e) {
    if (!el || !e) return;
    e.stopPropagation();
    
    el.classList.toggle('active');
    const icon = el.querySelector('i');
    
    if (el.classList.contains('active')) {
        icon.className = 'ri-heart-fill';
    } else {
        icon.className = 'ri-heart-line';
    }
}

// ==========================================
// 5. 사이드바 숨김/보임 토글 기능
// ==========================================
function handleSidebar() {
    const container = document.getElementById('baton-layout-container');
    const openBtn = document.getElementById('baton-sidebar-open');
    
    if (!container) return;

    container.classList.toggle('sidebar-hidden');
    
    if (openBtn) {
        if (container.classList.contains('sidebar-hidden')) {
            openBtn.style.display = 'flex';
        } else {
            openBtn.style.display = 'none';
        }
    }
}