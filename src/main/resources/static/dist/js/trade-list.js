/**
 * trade-list.js
 * 순수 Vanilla JS (jQuery 없음)
 * Vue로 전환 시 각 함수를 methods로, 상태값을 data()로 이동하면 됩니다.
 */

/* ── 유틸 ──────────────────────────────────────────── */
function tlGetParams() {
    return new URL(location.href).searchParams;
}

function tlNavigate(params) {
    params.delete('page');
    location.href = '/trade/list?' + params.toString();
}

/* ── 검색 ──────────────────────────────────────────── */
document.getElementById('tlSearchInput').addEventListener('keydown', function (e) {
    if (e.key !== 'Enter') return;
    const p = tlGetParams();
    const kw = this.value.trim();
    if (kw) p.set('keyword', kw);
    else p.delete('keyword');
    tlNavigate(p);
});

/* ── 카테고리 ──────────────────────────────────────── */
function tlSetCategory(idx) {
    const p = tlGetParams();
    if (idx) p.set('categoryIdx', idx);
    else p.delete('categoryIdx');
    tlNavigate(p);
}

/* ── 정렬 ──────────────────────────────────────────── */
function tlChangeSort(val) {
    const p = tlGetParams();
    p.set('sort', val);
    tlNavigate(p);
}

/* ── 가격 + 거래가능 필터 적용 ─────────────────────── */
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

/* ── 필터 전체 초기화 ──────────────────────────────── */
function tlResetFilters() {
    location.href = '/trade/list';
}

/* ── 페이지네이션 ──────────────────────────────────── */
function tlGoPage(page) {
    const p = tlGetParams();
    p.set('page', page);
    location.href = '/trade/list?' + p.toString();
}

/* ── 찜하기 ────────────────────────────────────────── */
function tlToggleWish(e, tradeIdx) {
    e.preventDefault();
    e.stopPropagation();
    fetch('/trade/wish?tradeIdx=' + tradeIdx, { method: 'POST' })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            const btn = e.currentTarget;
            btn.classList.toggle('active', data.wished);
            btn.textContent = data.wished ? '❤️' : '🤍';
        })
        .catch(function () { alert('로그인이 필요합니다.'); });
}

/* ── 모바일 사이드바 토글 ──────────────────────────── */
function tlMobileFilter() {
    ['tlCard1', 'tlCard2', 'tlCard3'].forEach(function (id) {
        document.getElementById(id).classList.toggle('is-open');
    });
}

/* ── 활성 필터 칩 렌더링 ───────────────────────────── */
(function tlRenderChips() {
    const p = tlGetParams();
    const container = document.getElementById('tlActiveFilters');
    if (!container) return;

    const catNames = {
        '1': '📱 전자기기',
        '2': '👗 의류',
        '3': '💄 뷰티',
        '4': '⭐ 스타굿즈',
        '5': '🏠 가구/인테리어',
        '6': '📚 도서',
        '7': '🎮 게임',
        '8': '기타'
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
