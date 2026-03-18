(function () {
	'use strict';

	function initMypage() {
		var root = document.getElementById('mp-theme-root');
		var tabs = document.querySelectorAll('.tab-item');
		var sections = document.querySelectorAll('.mp-section');

		if (!root || tabs.length === 0 || sections.length === 0) return;

		var urlParams = new URLSearchParams(window.location.search);
		var activeTabParam = urlParams.get('tab');
		var activeInnerParam = urlParams.get('inner');

		var targetTab = document.querySelector('.tab-item[data-target="sec-overview"]');

		if (activeTabParam) {
			var foundTab = document.querySelector('.tab-item[data-target="sec-' + activeTabParam + '"]');
			if (foundTab) {
				targetTab = foundTab;
			}
		}

		function applyTheme(tab) {
			tabs.forEach(function (t) { t.classList.remove('active'); });
			tab.classList.add('active');

			var color = tab.getAttribute('data-color');
			var bg    = tab.getAttribute('data-bg');

			root.style.setProperty('--mp-theme', color);
			root.style.setProperty('--mp-theme-bg', bg);

			document.documentElement.style.setProperty('--header-domain-color', color);
			document.documentElement.style.setProperty('--header-domain-bg', bg);

			var targetId = tab.getAttribute('data-target');
			sections.forEach(function (sec) {
				sec.classList.remove('active');
				if (sec.id === targetId) {
					sec.classList.add('active');
				}
			});
		}

		tabs.forEach(function (tab) {
			tab.addEventListener('click', function () {
				applyTheme(tab);

				var newParam = tab.getAttribute('data-target').replace('sec-', '');
				var newUrl   = window.location.pathname + '?tab=' + newParam;
				window.history.replaceState({}, '', newUrl);
			});
		});

		if (targetTab) {
			applyTheme(targetTab);
			
			if (activeInnerParam) {
				var prefix = activeTabParam === 'community' ? 'comm' : activeTabParam;
				var selector = '.inner-tab[data-inner="' + prefix + '-' + activeInnerParam + '"]';
				var targetInnerBtn = document.querySelector(selector);
							
				if (targetInnerBtn) {
					targetInnerBtn.click();
				}
			}
		}
	}

	if (document.readyState === 'loading') {
		document.addEventListener('DOMContentLoaded', initMypage);
	} else {
		initMypage();
	}

})();