document.addEventListener('DOMContentLoaded', () => {
    const follower = document.querySelector('.mouse-follower');
    document.addEventListener('mousemove', (e) => {
        if(follower) {
            follower.style.left = e.clientX + 'px';
            follower.style.top = e.clientY + 'px';
        }
    });

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('active');
                
                if(entry.target.classList.contains('sec-review-box')) {
                    const scoreEl = entry.target.querySelector('.score-num');
                    if(scoreEl && scoreEl.innerText === '0.0') {
                        animateScore(scoreEl, 4.9);
                    }
                }

                if(entry.target.classList.contains('sec-data') || entry.target.classList.contains('box-data')) {
                    const numEls = entry.target.querySelectorAll('.num');
                    numEls.forEach(el => {
                        if(el.innerText === '0') {
                            animateCount(el, parseInt(el.dataset.val));
                        }
                    });
                }

                observer.unobserve(entry.target);
            }
        });
    }, { 
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    });

    const targetElements = document.querySelectorAll(
        '.reveal-item, .sec-hero, .sec-philosophy, .sec-showcase, .sec-review-box, .sec-tech, .sec-data, .box-data, .sec-cta'
    );
    targetElements.forEach(el => observer.observe(el));


    const stickySec = document.querySelector('.sec-showcase');
    const txtSteps = document.querySelectorAll('.step-txt');
    const screens = document.querySelectorAll('.screen');
    const deviceFrame = document.querySelector('.device-frame');

    window.addEventListener('scroll', () => {
        if (!stickySec) return;
        
        const rect = stickySec.getBoundingClientRect();
        const totalHeight = stickySec.offsetHeight - window.innerHeight;
        const scrollY = -rect.top;
        
        if (rect.top < window.innerHeight && rect.bottom > 0) {
             deviceFrame.style.transform = `perspective(1000px) rotateY(-10deg) translateY(${scrollY * 0.02}px)`;
        }

        let progress = Math.max(0, Math.min(1, scrollY / totalHeight));

        let index = 0;
        if (progress <= 0.33) index = 0;
        else if (progress < 0.66) index = 1;
        else index = 2;

        txtSteps.forEach((el, i) => {
            if (i === index) el.classList.add('active');
            else el.classList.remove('active');
        });

        screens.forEach((el, i) => {
            if (i === index) el.classList.add('active');
            else el.classList.remove('active');
        });
    });

    function animateScore(el, target) {
        let start = 0;
        const duration = 1500;
        const startTime = performance.now();

        function update(currentTime) {
            const elapsed = currentTime - startTime;
            const progress = Math.min(elapsed / duration, 1);
            const ease = 1 - Math.pow(1 - progress, 3); // Cubic ease out
            
            el.innerText = (start + (target - start) * ease).toFixed(1);

            if (progress < 1) requestAnimationFrame(update);
            else el.innerText = target.toFixed(1); // 확실한 종료값 보장
        }
        requestAnimationFrame(update);
    }

    function animateCount(el, target) {
        let start = 0;
        const duration = 2000;
        const startTime = performance.now();

        function update(currentTime) {
            const elapsed = currentTime - startTime;
            const progress = Math.min(elapsed / duration, 1);
            const ease = 1 - Math.pow(1 - progress, 4); // Quartic ease out
            
            el.innerText = Math.floor(start + (target - start) * ease);

            if (progress < 1) requestAnimationFrame(update);
            else el.innerText = target; // 확실한 종료값 보장
        }
        requestAnimationFrame(update);
    }
});