document.addEventListener("DOMContentLoaded", () => {
	const path = window.location.pathname;

	let domainColor = '#3182F6';
	let domainBgColor = '#E8F3FF';

	if (path.includes('/trade/')) {
		domainColor = '#00B98D';
		domainBgColor = '#E6F8F3';
	} else if (path.includes('/club/')) {
		domainColor = '#F86D7D';
		domainBgColor = '#FFF0F1';
	} else if (path.includes('/alba/')) {
		domainColor = '#002C5F';
		domainBgColor = '#F0F4F8';
	} else if (path.includes('/community/')) {
		domainColor = '#8A63FF';
		domainBgColor = '#F4F0FF';
	}

	document.documentElement.style.setProperty('--header-domain-color', domainColor);
	document.documentElement.style.setProperty('--header-domain-bg', domainBgColor);

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

	if (!isSideActive) {
		const homeLink = document.querySelector('.sidebar-menu .side-link[data-domain="home"]');
		if (homeLink) homeLink.parentElement.classList.add('active');
	}
});