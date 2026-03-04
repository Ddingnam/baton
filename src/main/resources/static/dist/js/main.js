function closeIntroNow() {
    const intro = document.getElementById('baton-intro');
    if (intro) {
        intro.style.opacity = '0';
        setTimeout(() => {
            intro.style.display = 'none';
        }, 800);
    }
}

document.addEventListener("DOMContentLoaded", () => {
    const intro = document.getElementById('baton-intro');
    const introToggle = document.getElementById('intro-toggle');
    
    const introSetting = localStorage.getItem('introSetting') || 'on';

    if (introToggle) {
        introToggle.checked = (introSetting === 'on');
        introToggle.addEventListener('change', (e) => {
            const status = e.target.checked ? 'on' : 'off';
            localStorage.setItem('introSetting', status);
            // alert('인트로 설정이 ' + (e.target.checked ? '켜졌습니다.' : '꺼졌습니다.'));
        });
    }

    if (introSetting === 'on' && intro) {
        intro.style.display = 'flex';
        intro.style.opacity = '1';
        window.addEventListener('load', () => {
            setTimeout(closeIntroNow, 2000);
        });
    } else if (intro) {
        intro.style.display = 'none';
    }
	const counters = document.querySelectorAll('.counter-number');
	counters.forEach(c => {
	    c.dataset.count = c.innerText.replace(/,/g, '');
	    c.innerText = '0';
	});
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = "1";
                entry.target.style.transform = "translateY(0)";
                
                const nums = entry.target.querySelectorAll('.counter-number, #counter');
                nums.forEach(num => {
                    if (!num.classList.contains('done')) {
                        num.classList.add('done');
                        
                        const targetStr = num.innerText.replace(/,/g, '');
                        const target = parseInt(targetStr) || 1584200;

                        let currentFrame = 0;
                        const duration = 2000;
                        const frameRate = 1000 / 60;
                        const totalFrames = Math.round(duration / frameRate);
                        
                        const easeOutQuart = t => 1 - (--t) * t * t * t;

                        const timer = setInterval(() => {
                            currentFrame++;
                            const progress = easeOutQuart(currentFrame / totalFrames);
                            const currentCount = Math.round(target * progress);
                            
                            num.innerText = currentCount.toLocaleString();

                            if (currentFrame === totalFrames) {
                                num.innerText = target.toLocaleString();
                                clearInterval(timer);
                            }
                        }, frameRate);
                    }
                });
            }
        });
    }, { threshold: 0.1 });

    document.querySelectorAll('.reveal').forEach(el => {
        el.style.opacity = "0";
        el.style.transform = "translateY(40px)";
        el.style.transition = "all 1.2s cubic-bezier(0.16, 1, 0.3, 1)";
        observer.observe(el);
    });
});

function toggleWish(el, e) {
    if (!el || !e) return;
    e.stopPropagation();
    el.classList.toggle('active');
    const icon = el.querySelector('i');
    if (icon) {
        icon.className = el.classList.contains('active') ? 'ri-heart-fill' : 'ri-heart-line';
    }
}


function handleSidebar() {
    const container = document.getElementById('baton-layout-container');
    const openBtn = document.getElementById('baton-sidebar-open');
    if (!container) return;
    container.classList.toggle('sidebar-hidden');
    if (openBtn) {
        openBtn.style.display = container.classList.contains('sidebar-hidden') ? 'flex' : 'none';
    }
}