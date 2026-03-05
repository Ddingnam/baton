document.addEventListener("DOMContentLoaded", () => {
	const root = document.getElementById('mp-theme-root');
	const tabs = document.querySelectorAll('.tab-item');
	const sections = document.querySelectorAll('.mp-section');


	const urlParams = new URLSearchParams(window.location.search);
	const activeTabParam = urlParams.get('tab');


	let targetTab = document.querySelector('.tab-item[data-target="sec-overview"]');


	if (activeTabParam) {
		const foundTab = document.querySelector('.tab-item[data-target="sec-' + activeTabParam + '"]');
		if (foundTab) {
			targetTab = foundTab;
		}
	}


	const applyTheme = (tab) => {

		tabs.forEach(t => t.classList.remove('active'));
		tab.classList.add('active');


		const color = tab.getAttribute('data-color');
		const bg = tab.getAttribute('data-bg');


		root.style.setProperty('--mp-theme', color);
		root.style.setProperty('--mp-theme-bg', bg);


		document.documentElement.style.setProperty('--header-domain-color', color);
		document.documentElement.style.setProperty('--header-domain-bg', bg);


		const targetId = tab.getAttribute('data-target');
		sections.forEach(sec => {
			sec.classList.remove('active');
			if (sec.id === targetId) {
				sec.classList.add('active');
			}
		});
	};

	tabs.forEach(tab => {
		tab.addEventListener('click', () => {
			applyTheme(tab);


			const newParam = tab.getAttribute('data-target').replace('sec-', '');
			const newUrl = window.location.pathname + '?tab=' + newParam;
			window.history.replaceState({}, '', newUrl);
		});
	});

	if (targetTab) {
		applyTheme(targetTab);
	}
});
