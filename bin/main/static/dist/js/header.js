document.addEventListener("DOMContentLoaded", () => {
    const path = window.location.pathname;

    let domainColor = '#3182F6';
    let domainBgColor = '#E8F3FF';
    let pageBg = '#F8FAFF';
    let currentDomain = 'home'; 
	
    if (path.includes('/trade/')) {
        domainColor = '#00B98D';
        domainBgColor = '#E6F8F3';
        pageBg = '#F7FCFA';
        currentDomain = 'trade';
    } else if (path.includes('/club/')) {
        domainColor = '#F86D7D';
        domainBgColor = '#FFF0F1';
        pageBg = '#FFFBFB';
        currentDomain = 'club';
    } else if (path.includes('/alba/')) {
        domainColor = '#002C5F';
        domainBgColor = '#F0F4F8';
        pageBg = '#F9FAFB';
        currentDomain = 'alba';
    } else if (path.includes('/community/')) {
        domainColor = '#8A63FF';
        domainBgColor = '#F4F0FF';
        pageBg = '#FBF9FF';
        currentDomain = 'community';
    }

    if (!path.includes('/mypage')) {
        document.documentElement.style.setProperty('--header-domain-color', domainColor);
        document.documentElement.style.setProperty('--header-domain-bg', domainBgColor);
        document.documentElement.style.setProperty('--page-theme-bg', pageBg);
        document.body.style.backgroundColor = pageBg;
    }

    const mypageLink = document.querySelector('.action-profile');
    if (mypageLink && currentDomain !== 'home') {
        const baseUrl = mypageLink.getAttribute('href').split('?')[0];
        mypageLink.setAttribute('href', baseUrl + '?tab=' + currentDomain);
    }

    const navLinks = document.querySelectorAll('.nav-menu .nav-link');
    navLinks.forEach(link => {
        const domain = link.getAttribute('data-domain');
        if (domain === 'home' && (path === '/' || path.endsWith('/main') || path.endsWith('/index.jsp'))) {
            link.classList.add('active');
        } else if (domain && domain !== 'home' && path.includes('/' + domain + '/')) {
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

    if (!isSideActive && document.querySelector('.sidebar-menu')) {
        const homeLink = document.querySelector('.sidebar-menu .side-link[data-domain="home"]');
        if (homeLink) homeLink.parentElement.classList.add('active');
    }
});