document.addEventListener("DOMContentLoaded", () => {
    const path = window.location.pathname;
    
    let domainColor = '#3182F6'; 

    if (path.includes('/club/')) {
        domainColor = '#7048E8'; // 동네모임 (퍼플)
    } else if (path.includes('/alba/')) {
        domainColor = '#00B050'; // 알바구인 (그린)
    } else if (path.includes('/community/')) {
        domainColor = '#F86D7D'; // 커뮤니티 (핑크)
    }

    document.documentElement.style.setProperty('--header-domain-color', domainColor);

    const navLinks = document.querySelectorAll('.nav-menu .nav-link');
    navLinks.forEach(link => {
        const domain = link.getAttribute('data-domain');
        if (domain && path.includes('/' + domain + '/')) {
            link.classList.add('active');
        }
    });
});