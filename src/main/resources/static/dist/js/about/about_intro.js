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
                    if(scoreEl && !scoreEl.dataset.animated) {
                        scoreEl.dataset.animated = 'true';
                        animateScore(scoreEl, 4.9);
                    }
                }

                if(entry.target.classList.contains('sec-data') || entry.target.classList.contains('box-data')) {
                    const numEls = entry.target.querySelectorAll('.num');
                    numEls.forEach(el => {
                        if(!el.dataset.animated) {
                            el.dataset.animated = 'true';
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
        '.reveal-item, .sec-hero, .sec-philosophy, .sec-review-box, .sec-tech, .sec-data, .box-data, .sec-cta'
    );
    targetElements.forEach(el => observer.observe(el));


    const phSection  = document.querySelector('.sec-philosophy');
    const phWords    = document.querySelectorAll('.ph-word');
    const phDesc     = document.querySelector('.ph-desc-reveal');
    const totalWords = phWords.length;

    const stickySec = document.querySelector('.sec-showcase');
    const txtSteps = document.querySelectorAll('.step-txt');
    const screens = document.querySelectorAll('.screen');
    const deviceFrame = document.querySelector('.device-frame');

    if (txtSteps[0]) txtSteps[0].classList.add('active');
    if (screens[0]) screens[0].classList.add('active');

    window.addEventListener('scroll', () => {

        if (phSection && totalWords > 0) {
            const phRect     = phSection.getBoundingClientRect();
            const phTotalH   = phSection.offsetHeight - window.innerHeight;
            const phScrollY  = -phRect.top;
            const phProgress = Math.max(0, Math.min(1, phScrollY / phTotalH));

            phWords.forEach((word, i) => {
                word.classList.toggle('lit', phProgress >= i / totalWords);
            });
            if (phDesc) phDesc.classList.toggle('visible', phProgress > 0.75);
        }

        if (!stickySec) return;
        
        const rect = stickySec.getBoundingClientRect();
        const totalHeight = stickySec.offsetHeight - window.innerHeight;
        const scrollY = -rect.top;

        if (scrollY < 0 || rect.bottom < 0) return;
        
        if (deviceFrame && rect.top < window.innerHeight && rect.bottom > 0) {
             deviceFrame.style.transform = `perspective(1000px) rotateY(-10deg) translateY(${scrollY * 0.02}px)`;
        }

        let progress = Math.max(0, Math.min(1, scrollY / totalHeight));

        let index = 0;
        if (progress < 0.25) index = 0;
        else if (progress < 0.50) index = 1;
        else if (progress < 0.75) index = 2;
        else index = 3;

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
            const ease = 1 - Math.pow(1 - progress, 3);
            
            el.innerText = (start + (target - start) * ease).toFixed(1);

            if (progress < 1) requestAnimationFrame(update);
            else el.innerText = target.toFixed(1);
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
            const ease = 1 - Math.pow(1 - progress, 4);
            
            el.innerText = Math.floor(start + (target - start) * ease);

            if (progress < 1) requestAnimationFrame(update);
            else el.innerText = target;
        }
        requestAnimationFrame(update);
    }
});