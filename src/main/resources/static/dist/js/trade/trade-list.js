function tlGetParams() {
    return new URL(location.href).searchParams;
}

function tlNavigate(params) {
    params.delete('page');
    location.href = '/trade/list?' + params.toString();
}

function formatTimeAgo(dateString) {
    if (!dateString) return "";
    
    let cleanDate = dateString.trim().split('.')[0].replace(/-/g, '/');
    const date = new Date(cleanDate);
    const now = new Date();
    const diff = Math.floor((now - date) / 1000);

    if (isNaN(date.getTime())) return dateString;
    
    if (diff < 60) return "방금 전";
    if (diff < 3600) return Math.floor(diff / 60) + "분 전";
    if (diff < 86400) return Math.floor(diff / 3600) + "시간 전";
    if (diff < 2592000) return Math.floor(diff / 86400) + "일 전";
    
    return dateString.split(' ')[0];
}

function initTimeAgo() {
    const elements = document.querySelectorAll('.time-ago');
    elements.forEach(function(el) {
        const rawDate = el.getAttribute('data-time') || el.innerText;
        
		if (rawDate && !el.getAttribute('data-formatted')) {
            el.setAttribute('data-time', rawDate); 
            el.innerText = formatTimeAgo(rawDate);
            el.setAttribute('data-formatted', 'true');
        }
    });
}

function initSortDropdown(){
    const sortDropdown = document.getElementById('sortDropdown');
    if (!sortDropdown) return;

    const selected = sortDropdown.querySelector('.dropdown-selected');
    const menuItems = sortDropdown.querySelectorAll('.dropdown-menu li');

    selected.addEventListener('click', function(e) {
        e.stopPropagation();
        sortDropdown.classList.toggle('active');
    });

    menuItems.forEach(item => {
        item.addEventListener('click', function() {
            const sortVal = this.getAttribute('data-value');

            tlChangeSort(sortVal);
        });
    });

    document.addEventListener('click', function() {
        sortDropdown.classList.remove('active');
    });
}

function tlRenderChips() {
    const p = tlGetParams();
    const container = document.getElementById('tlActiveFilters');
    if (!container) return;

    const catNames = {
        '1': '전자기기',
        '2': '남성의류',
        '3': '여성의류',
        '4': '뷰티',
        '5': '스타굿즈',
        '6': '가구/인테리어',
        '7': '도서',
        '8': '게임',
		'9': '스포츠/레저',
		'10': '가전제품',
		'11': '취미/수집',
		'12': '반려동물',
		'13': '식품',
		'14': '유아동',
		'15': '티켓/상품권'
    };

    const chips = [];
    if (p.get('keyword'))
        chips.push({ label: '검색: ' + p.get('keyword'), key: 'keyword' });
    if (p.get('categoryIdx'))
        chips.push({ label: catNames[p.get('categoryIdx')] || '카테고리', key: 'categoryIdx' });
    if (p.get('priceMin') || p.get('priceMax'))
        chips.push({ label: (p.get('priceMin') || '0') + '원 ~ ' + (p.get('priceMax') || '∞') + '원', keys: ['priceMin', 'priceMax'] });
    if (p.get('available') === 'true')
        chips.push({ label: '거래 가능', key: 'available' });

    chips.forEach(function (chip) {
        const el = document.createElement('span');
        el.className = 'tl-filter-chip';
        el.innerHTML = chip.label
            + ' <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">'
            + '<path d="M18 6 6 18M6 6l12 12"/></svg>';
        el.addEventListener('click', function () {
            const pp = tlGetParams();
            if (chip.keys) chip.keys.forEach(function (k) { pp.delete(k); });
            else pp.delete(chip.key);
            tlNavigate(pp);
        });
        container.appendChild(el);
    });
};

function tlSetCategory(idx) {
    const p = tlGetParams();
    if (idx) p.set('categoryIdx', idx);
    else p.delete('categoryIdx');
    tlNavigate(p);
}

function tlChangeSort(val) {
    const p = tlGetParams();
    p.set('sort', val);
    tlNavigate(p);
}

function initRadiusSlider() {
    const slider = document.getElementById('tlRadiusSlider');
    if (!slider) return;

    const badge    = document.getElementById('tlRadiusBadgeText');
    const steps    = document.querySelectorAll('.tl-radius-step');

    const KM_MAP   = { 1: '1', 2: '3', 3: '5' };
    const LABEL_MAP = { 1: '1km 이내', 2: '3km 이내', 3: '5km 이내' };

    function updateFill(val) {
        const pct = ((val - 1) / 2) * 100;
        slider.style.setProperty('--tl-fill', pct + '%');
    }

    function updateUI(val) {
        const v = parseInt(val, 10);
        updateFill(v);
        if (badge) badge.textContent = LABEL_MAP[v];
        steps.forEach(s => {
            s.classList.toggle('active', parseInt(s.dataset.step, 10) === v);
        });
    }

    slider.addEventListener('input', function () {
        updateUI(this.value);
    });

    slider.addEventListener('change', function () {
        tlChangeRadius(KM_MAP[this.value]);
    });

    steps.forEach(function (step) {
        step.addEventListener('click', function () {
            const s = this.dataset.step;
            slider.value = s;
            updateUI(s);
            tlChangeRadius(this.dataset.km);
        });
    });

    updateFill(slider.value);
}

function tlChangeRadius(km) {
    const p = tlGetParams();
    p.set('km', km);
    tlNavigate(p);
}

function tlApplyFilter() {
    const p = tlGetParams();
    const min = document.getElementById('tlPriceMin').value.trim();
    const max = document.getElementById('tlPriceMax').value.trim();
    const avail = document.getElementById('tlAvailableOnly').checked;
    if (min) p.set('priceMin', min); else p.delete('priceMin');
    if (max) p.set('priceMax', max); else p.delete('priceMax');
    if (avail) p.set('available', 'true'); else p.delete('available');
    tlNavigate(p);
}

function tlResetFilters() {
    location.href = '/trade/list';
}

let isLoading = false;

function LoadMore() {
    if(isLoading) return;
    
	const currentPageInput = document.getElementById('currentPage');
	const totalPageEl = document.getElementById('totalPage');
	    
	if (!currentPageInput || !totalPageEl) return;

	let currentPage = parseInt(currentPageInput.value, 10) || 1;
	const totalPage = parseInt(totalPageEl.value, 10) || 1;
	let nextPage = currentPage + 1;

    if (nextPage > totalPage) return;

    isLoading = true;
    const btn = document.getElementById('btn-load-more');
    if(btn) btn.innerHTML = '로딩 중... <i class="ri-loader-4-line"></i>';
	
	const p = tlGetParams();
	const categoryIdx = p.get('categoryIdx') || '';
	const keyword = document.getElementById('tlSearchInput')?.value || p.get('keyword') || '';
	const priceMin = document.getElementById('tlPriceMin')?.value || p.get('priceMin') || '';
	const priceMax = document.getElementById('tlPriceMax')?.value || p.get('priceMax') || '';
	const sort = p.get('sort') || 'newest';
	const available = p.get('available') || 'false';
	
	const params = new URLSearchParams({
		page: nextPage,
		isAjax: 'true',
		keyword: keyword,
		categoryIdx: categoryIdx,
		priceMin: priceMin,
		priceMax: priceMax,
		sort: sort,
		available: available,
		km: p.get('km') || '1'
	});

	const url = `/trade/list?${params.toString()}`;
	
	fetch(url)
		.then(response => {
			if (!response.ok) throw new Error("HTTP_ERROR");
			return response.text();
		})
		.then(html => {
			if (html.trim().length > 0) {
				const grid = document.querySelector('.tl-product-grid');
				if(grid) {
	                    grid.insertAdjacentHTML('beforeend', html);
	                    initTimeAgo();
	                }
	                
	                currentPageInput.value = nextPage;
	                
	                if (nextPage >= totalPage) {
	                    const container = document.getElementById('more-btn-container');
	                    if(container) container.style.display = 'none';
	                }
	            }
	            isLoading = false;
	            if(btn) btn.innerHTML = '더보기 <i class="ri-arrow-down-s-line"></i>';
	        })
	        .catch(error => {
	            console.error('Error:', error);
	            isLoading = false;
	            if(btn) btn.innerHTML = '더보기 <i class="ri-arrow-down-s-line"></i>';
	        });
}

function tlToggleWish(e, productIdx) {
    e.preventDefault();
    e.stopPropagation();

    const btn = e.currentTarget; 
    
    const csrfToken = document.querySelector('meta[name="_csrf"]')?.content;
    const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.content;
    const headers = { 'Content-Type': 'application/x-www-form-urlencoded' };
    if (csrfHeader && csrfToken) headers[csrfHeader] = csrfToken;

    fetch('/trade/toggleLike', {
        method: 'POST',
        headers: headers,
        body: new URLSearchParams({ productIdx: productIdx })
    })
    .then(response => {
        if (!response.ok) throw new Error("HTTP_ERROR");
        return response.json();
    })
    .then(data => {
        if (data.status === 'loginRequired') {
            alert('로그인이 필요한 서비스입니다.');
            return;
        }

        if (data.status === 'success') {
            const icon = btn.querySelector('i');

            btn.classList.toggle('active', data.isLiked);
            if (data.isLiked) {
                icon.classList.replace('ri-heart-3-line', 'ri-heart-3-fill');
            } else {
                icon.classList.replace('ri-heart-3-fill', 'ri-heart-3-line');
            }
            
            const card = btn.closest('.trade-card');
            if (card) {
                const wishIcon = card.querySelector('.wish-icon');
                if (wishIcon) {
                    wishIcon.parentElement.innerHTML = '<i class="ri-heart-3-line wish-icon"></i> ' + data.likeCount;
                }
            }
			
			showBatonToast(data.isLiked ? "관심 목록에 추가되었습니다." : "관심 목록에서 제거되었습니다.");
        }
    })
    .catch(err => {
        console.error("찜하기 상세 에러:", err);
        alert('처리 중 오류가 발생했습니다.');
    });
}

function tlMobileFilter() {
    ['tlCard1', 'tlCard2', 'tlCard3'].forEach(function (id) {
        document.getElementById(id).classList.toggle('is-open');
    });
}

document.addEventListener('DOMContentLoaded', function() {
	initSortDropdown();
	initRadiusSlider();
	initTimeAgo();
	tlRenderChips();
	
	const searchInput = document.getElementById('tlSearchInput');
	if (searchInput) {
		searchInput.addEventListener('keydown', function (e) {
			if (e.key !== 'Enter') return;
			const p = tlGetParams();
			const kw = this.value.trim();
			if (kw) p.set('keyword', kw); else p.delete('keyword');
				tlNavigate(p);
		});
	}
});
