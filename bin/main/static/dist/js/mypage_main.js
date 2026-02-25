document.addEventListener("DOMContentLoaded", () => {
	
	const summaryCards = document.querySelectorAll('.summary-card');
	
	summaryCards.forEach(card => {
		card.addEventListener('mouseenter', () => {
			card.style.transform = 'translateY(-4px)';
		});
		card.addEventListener('mouseleave', () => {
			card.style.transform = 'translateY(0)';
		});
	});

	const tradeItems = document.querySelectorAll('.trade-item');
	
	tradeItems.forEach(item => {
		item.addEventListener('click', () => {
			window.location.href = '/mypage/trade/buy';
		});
	});
	
});