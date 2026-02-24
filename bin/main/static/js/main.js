document.addEventListener("DOMContentLoaded", () => {
    const intro = document.getElementById('baton-intro');
    
    // 심플한 로딩 후 사라짐
    setTimeout(() => {
        intro.style.opacity = '0';
        setTimeout(() => intro.style.visibility = 'hidden', 800);
    }, 1000);

    // 스크롤 시 부드럽게 떠오르는 효과 (Toss 느낌의 핵심)
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = "1";
                entry.target.style.transform = "translateY(0)";
            }
        });
    }, { 
        threshold: 0.1, // 섹션이 10% 보일 때 애니메이션 시작
        rootMargin: "0px 0px -50px 0px" 
    });

    document.querySelectorAll('.reveal').forEach((el) => {
        el.style.opacity = "0";
        el.style.transform = "translateY(60px)";
        el.style.transition = "all 1s cubic-bezier(0.16, 1, 0.3, 1)"; // 아주 부드러운 감속 곡선
        observer.observe(el);
    });
});