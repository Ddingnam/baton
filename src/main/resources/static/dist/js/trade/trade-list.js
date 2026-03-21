function tlGetParams() {
    return new URL(location.href).searchParams;
}

function tlGetQueryString(params) {
    params.delete('page');
    return params.toString();
}

function tlNavigate(params) {
    const qs = tlGetQueryString(params);
    history.pushState(null, '', '/trade/list?' + qs);
    tlFetchList(qs);
}

function tlSyncCategoryButtons() {
    const p = tlGetParams();
    const currentCat = p.get('categoryIdx') || '';
    document.querySelectorAll('.tl-filter-list .filter-btn').forEach(function(btn) {
        const onclick = btn.getAttribute('onclick') || '';
        const match = onclick.match(/tlSetCategory\(['"]?(.*?)['"]?\)/);
        const btnCat = match ? match[1] : '';
        btn.classList.toggle('active', btnCat === currentCat);
    });
}

function tlSyncSortDropdown() {
    const p = tlGetParams();
    const currentSort = p.get('sort') || 'newest';

    const sortLabels = {
        'newest': '최신순', 'latest': '최신순',
        'lowPrice': '낮은 가격순', 'highPrice': '높은 가격순', 'hitCount': '인기순'
    };

    const selectedText = document.getElementById('selectedSortText');
    if (selectedText) {
        selectedText.textContent = sortLabels[currentSort] || '최신순';
    }

    document.querySelectorAll('#sortDropdown .dropdown-menu li').forEach(function(li) {
        const val = li.getAttribute('data-value');
        const isActive = val === currentSort || (currentSort === 'newest' && val === 'latest');
        li.classList.toggle('active', isActive);
    });
}

function tlSyncRadiusBtns() {
    const p = tlGetParams();
    const currentKm = p.get('km') || '1';
    document.querySelectorAll('.tl-radius-btn').forEach(function(btn) {
        btn.classList.toggle('active', btn.dataset.km === currentKm);
    });
}

function tlSyncUI() {
    tlSyncCategoryButtons();
    tlSyncSortDropdown();
    tlSyncRadiusBtns();

    const container = document.getElementById('tlActiveFilters');
    if (container) {
        container.innerHTML = '';
        tlRenderChips();
    }
}

function tlFetchList(queryString) {
    const grid = document.querySelector('.tl-product-grid');
    const moreBtnContainer = document.getElementById('more-btn-container');

    if (grid) {
        grid.style.opacity = '0.4';
        grid.style.transition = 'opacity 0.2s';
    }

    fetch('/trade/list?' + queryString + '&isAjax=true&page=1')
        .then(r => { if (!r.ok) throw new Error(); return r.text(); })
        .then(html => {
            if (grid) {
                const cleanHtml = html.replace(/<!--TOTAL_PAGE:\d+-->/g, '').trim();
                if (cleanHtml.length === 0) {
                    grid.innerHTML = `
                        <div class="tl-empty-state">
                            <i class="ri-shopping-basket-line empty-icon"></i>
                            <p>아직 등록된 상품이 없어요</p>
                            <small>첫 번째 판매자가 되어보세요!</small>
                        </div>`;
                } else {
                    grid.innerHTML = cleanHtml;
                    initTimeAgo();
                }
                grid.style.opacity = '1';
            }

            const cp = document.getElementById('currentPage');
            const tp = document.getElementById('totalPage');
            const match = html.match(/<!--TOTAL_PAGE:(\d+)-->/);
            const totalPage = match ? parseInt(match[1]) : 1;
            if (tp) tp.value = totalPage;
            if (cp) cp.value = '1';
            if (moreBtnContainer) {
                moreBtnContainer.style.display = totalPage > 1 ? '' : 'none';
            }

            tlSyncUI();
        })
        .catch(() => {
            if (grid) grid.style.opacity = '1';
        });
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
    document.querySelectorAll('.time-ago').forEach(function(el) {
        const rawDate = el.getAttribute('data-time') || el.innerText;
        if (rawDate && !el.getAttribute('data-formatted')) {
            el.setAttribute('data-time', rawDate);
            el.innerText = formatTimeAgo(rawDate);
            el.setAttribute('data-formatted', 'true');
        }
    });
}

function initSortDropdown() {
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
            tlChangeSort(this.getAttribute('data-value'));
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
        '1': '전자기기', '2': '남성의류', '3': '여성의류', '4': '뷰티',
        '5': '스타굿즈', '6': '가구/인테리어', '7': '도서', '8': '게임',
        '9': '스포츠/레저', '10': '가전제품', '11': '취미/수집',
        '12': '반려동물', '13': '식품', '14': '유아동', '15': '티켓/상품권'
    };
    const sortLabels = {
        'newest': '최신순', 'latest': '최신순',
        'lowPrice': '낮은 가격순', 'highPrice': '높은 가격순', 'hitCount': '인기순'
    };
    const kmLabels = { '1': '내 동네만', '3': '가까운 동네', '5': '먼 동네까지' };

    const chips = [];

    if (p.get('keyword'))
        chips.push({ label: '검색: ' + p.get('keyword'), key: 'keyword' });
    if (p.get('categoryIdx'))
        chips.push({ label: catNames[p.get('categoryIdx')] || '카테고리', key: 'categoryIdx' });
    if (p.get('priceMin') || p.get('priceMax'))
        chips.push({ label: (p.get('priceMin') || '0') + '원 ~ ' + (p.get('priceMax') || '∞') + '원', keys: ['priceMin', 'priceMax'] });
    if (p.get('available') === 'true')
        chips.push({ label: '거래 가능', key: 'available' });

    const currentSort = p.get('sort');
    if (currentSort && currentSort !== 'newest' && currentSort !== 'latest')
        chips.push({ label: '정렬: ' + (sortLabels[currentSort] || currentSort), key: 'sort' });

    const currentKm = p.get('km');
    if (currentKm && currentKm !== '3')
        chips.push({ label: kmLabels[currentKm] || (currentKm + 'km'), key: 'km' });

    chips.forEach(function(chip) {
        const el = document.createElement('span');
        el.className = 'tl-filter-chip';
        el.innerHTML = chip.label
            + ' <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">'
            + '<path d="M18 6 6 18M6 6l12 12"/></svg>';
        el.addEventListener('click', function() {
            const pp = tlGetParams();
            if (chip.keys) chip.keys.forEach(function(k) { pp.delete(k); });
            else pp.delete(chip.key);
            tlNavigate(pp);
        });
        container.appendChild(el);
    });
}

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

function tlApplyFilter() {
    const p = tlGetParams();
    const min = document.getElementById('tlPriceMin').value.trim();
    const max = document.getElementById('tlPriceMax').value.trim();
    const avail = document.getElementById('tlAvailableOnly').checked;
    const kw = document.getElementById('tlSearchInput')?.value.trim();
    if (min) p.set('priceMin', min); else p.delete('priceMin');
    if (max) p.set('priceMax', max); else p.delete('priceMax');
    if (avail) p.set('available', 'true'); else p.delete('available');
    if (kw) p.set('keyword', kw); else p.delete('keyword');
    tlNavigate(p);
}

function tlResetFilters() {
    const priceMin = document.getElementById('tlPriceMin');
    const priceMax = document.getElementById('tlPriceMax');
    const avail = document.getElementById('tlAvailableOnly');
    if (priceMin) priceMin.value = '';
    if (priceMax) priceMax.value = '';
    if (avail) avail.checked = false;
    history.pushState(null, '', '/trade/list?km=3');
    tlFetchList('km=3');
}

let isLoading = false;

function LoadMore() {
    if (isLoading) return;

    const currentPageInput = document.getElementById('currentPage');
    const totalPageEl = document.getElementById('totalPage');
    if (!currentPageInput || !totalPageEl) return;

    let currentPage = parseInt(currentPageInput.value, 10) || 1;
    const totalPage = parseInt(totalPageEl.value, 10) || 1;
    let nextPage = currentPage + 1;
    if (nextPage > totalPage) return;

    isLoading = true;
    const btn = document.getElementById('btn-load-more');
    if (btn) btn.innerHTML = '로딩 중... <i class="ri-loader-4-line"></i>';

    const p = tlGetParams();
    const params = new URLSearchParams({
        page: nextPage,
        isAjax: 'true',
        keyword: document.getElementById('tlSearchInput')?.value || p.get('keyword') || '',
        categoryIdx: p.get('categoryIdx') || '',
        priceMin: document.getElementById('tlPriceMin')?.value || p.get('priceMin') || '',
        priceMax: document.getElementById('tlPriceMax')?.value || p.get('priceMax') || '',
        sort: p.get('sort') || 'newest',
        available: p.get('available') || 'false',
        km: p.get('km') || '3'
    });

    fetch('/trade/list?' + params.toString())
        .then(response => {
            if (!response.ok) throw new Error("HTTP_ERROR");
            return response.text();
        })
        .then(html => {
            const cleanHtml = html.replace(/<!--TOTAL_PAGE:\d+-->/g, '').trim();
            if (cleanHtml.length > 0) {
                const grid = document.querySelector('.tl-product-grid');
                if (grid) {
                    grid.insertAdjacentHTML('beforeend', cleanHtml);
                    initTimeAgo();
                }
                currentPageInput.value = nextPage;
                if (nextPage >= totalPage) {
                    const container = document.getElementById('more-btn-container');
                    if (container) container.style.display = 'none';
                }
            }
            isLoading = false;
            if (btn) btn.innerHTML = '더보기 <i class="ri-arrow-down-s-line"></i>';
        })
        .catch(error => {
            console.error('Error:', error);
            isLoading = false;
            if (btn) btn.innerHTML = '더보기 <i class="ri-arrow-down-s-line"></i>';
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
        showBatonToast('다시 시도하여 주세요.');
    });
}

function tlMobileFilter() {
    ['tlCard1', 'tlCard2', 'tlCard3'].forEach(function(id) {
        document.getElementById(id).classList.toggle('is-open');
    });
}

function initRadiusBtns() {
    document.querySelectorAll('.tl-radius-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            const p = tlGetParams();
            p.set('km', this.dataset.km);
            tlNavigate(p);
        });
    });
}

document.addEventListener('DOMContentLoaded', function() {
    initSortDropdown();
    initRadiusBtns();
    initTimeAgo();
    tlSyncUI();
});
