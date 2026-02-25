document.addEventListener("DOMContentLoaded", () => {
    const intro = document.getElementById('baton-intro');
    const nodes = document.querySelectorAll('.node');
    
    if (intro) {
        let nodeIdx = 0;
        const nodeInterval = setInterval(() => {
            nodes.forEach(n => n.classList.remove('active'));
            if(nodes[nodeIdx]) nodes[nodeIdx].classList.add('active');
            nodeIdx = (nodeIdx + 1) % nodes.length;
        }, 550);

        setTimeout(() => {
            clearInterval(nodeInterval);
            intro.style.opacity = '0';
            setTimeout(() => intro.style.visibility = 'hidden', 800);
        }, 3000); 
    }

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = "1";
                entry.target.style.transform = "translateY(0)";
                if (entry.target.id === 'stats-section' && !entry.target.dataset.counted) {
                    startCounterAnimation();
                    entry.target.dataset.counted = "true";
                }
            }
        });
    }, { threshold: 0.1 });

    document.querySelectorAll('.reveal').forEach((el) => {
        el.style.opacity = "0";
        el.style.transform = "translateY(80px)";
        el.style.transition = "all 1.2s cubic-bezier(0.16, 1, 0.3, 1)";
        observer.observe(el);
    });
});

function startCounterAnimation() {
    const el = document.getElementById('counter');
    const target = 1584200;
    let curr = 0;
    const duration = 2000;
    const frameTime = 16;
    const totalFrames = duration / frameTime;
    const step = target / totalFrames;

    const count = setInterval(() => {
        curr += step;
        if (curr >= target) {
            el.innerText = target.toLocaleString();
            clearInterval(count);
        } else {
            el.innerText = Math.floor(curr).toLocaleString();
        }
    }, frameTime);
}

function toggleWish(el, e) {
            e.stopPropagation();
            el.classList.toggle('active');
            const icon = el.querySelector('i');
            if (el.classList.contains('active')) {
                icon.className = 'ri-heart-fill';
            } else {
                icon.className = 'ri-heart-line';
            }
        }