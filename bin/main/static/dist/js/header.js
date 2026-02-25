document.addEventListener("DOMContentLoaded", () => {
    const path = window.location.pathname;
    
    let domainColor = '#3182F6'; 
    let domainBgColor = '#E8F3FF';

    if (path.includes('/club/')) {
        domainColor = '#7048E8'; // 동네모임 (보라)
        domainBgColor = '#F3EFFF'; 
    } else if (path.includes('/alba/')) {
        domainColor = '#00B050'; // 알바구인 (초록)
        domainBgColor = '#E6F7ED'; 
    } else if (path.includes('/community/')) {
        domainColor = '#F86D7D'; // 커뮤니티 (핑크)
        domainBgColor = '#FEECEE'; 
    }

    document.documentElement.style.setProperty('--header-domain-color', domainColor);
    document.documentElement.style.setProperty('--header-domain-bg', domainBgColor);

    const navLinks = document.querySelectorAll('.nav-menu .nav-link');
    navLinks.forEach(link => {
        const domain = link.getAttribute('data-domain');
        if (domain && path.includes('/' + domain + '/')) {
            link.classList.add('active');
        }
    });

    const sideLinks = document.querySelectorAll('.sidebar-menu .side-link');
    
    document.querySelectorAll('.sidebar-menu li').forEach(li => li.classList.remove('active'));
    
    let isSideActive = false;
    sideLinks.forEach(link => {
        const domain = link.getAttribute('data-domain');
        if (domain && domain !== 'home' && path.includes('/' + domain + '/')) {
            link.parentElement.classList.add('active');
            isSideActive = true;
        }
    });
    
    if (!isSideActive) {
        const homeLink = document.querySelector('.sidebar-menu .side-link[data-domain="home"]');
        if (homeLink) homeLink.parentElement.classList.add('active');
    }
});