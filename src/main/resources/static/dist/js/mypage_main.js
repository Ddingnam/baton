document.addEventListener("DOMContentLoaded", () => {
	const root = document.getElementById('mp-theme-root');
	const tabs = document.querySelectorAll('.tab-item');
	const sections = document.querySelectorAll('.mp-section');

	root.style.setProperty('--mp-theme', '#3182F6');
	root.style.setProperty('--mp-theme-bg', '#E8F3FF');

	tabs.forEach(tab => {
		tab.addEventListener('click', () => {
			tabs.forEach(t => t.classList.remove('active'));
			tab.classList.add('active');

			const color = tab.getAttribute('data-color');
			const bg = tab.getAttribute('data-bg');
			root.style.setProperty('--mp-theme', color);
			root.style.setProperty('--mp-theme-bg', bg);

			const targetId = tab.getAttribute('data-target');
			sections.forEach(sec => {
				sec.classList.remove('active');
				if (sec.id === targetId) {
					sec.classList.add('active');
				}
			});
		});
	});
});