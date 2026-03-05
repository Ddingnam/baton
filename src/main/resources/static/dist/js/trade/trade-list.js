function tlGetParams() {
    return new URL(location.href).searchParams;
}

function tlNavigate(params) {
    params.delete('page');
    location.href = '/trade/list?' + params.toString();
}

document.getElementById('tlSearchInput').addEventListener('keydown', function (e) {
    if (e.key !== 'Enter') return;
    const p = tlGetParams();
    const kw = this.value.trim();
    if (kw) p.set('keyword', kw);
    else p.delete('keyword');
    tlNavigate(p);
});

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

document.addEventListener('DOMContentLoaded', function() {
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
});

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

function tlGoPage(page) {
    const p = tlGetParams();
    p.set('page', page);
    location.href = '/trade/list?' + p.toString();
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
                    wishIcon.parentElement.innerHTML = '<i class="ri-heart-3-fill wish-icon"></i> ' + data.likeCount;
                }
            }
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

(function tlRenderChips() {
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
})();
