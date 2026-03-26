function useTradeList(shared) {
    const { Vue } = window;
    const { ref, computed, watch, onMounted } = Vue;

    const { categories } = shared;

    function formatTimeAgo(dateString) {
        if (!dateString) return '';
        const clean = dateString.trim().split('.')[0].replace(/-/g, '/');
        const date  = new Date(clean);
        const diff  = Math.floor((Date.now() - date) / 1000);
        if (isNaN(date.getTime())) return dateString;
        if (diff < 60) return '방금 전';
        if (diff < 3600) return Math.floor(diff / 60) + '분 전';
        if (diff < 86400) return Math.floor(diff / 3600) + '시간 전';
        if (diff < 2592000) return Math.floor(diff / 86400) + '일 전';
        return dateString.split(' ')[0];
    }

    function formatPrice(price) {
        if (price === 0) return '나눔';
        return Number(price).toLocaleString('ko-KR') + '원';
    }

    function csrfHeaders() {
        const token  = document.querySelector('meta[name="_csrf"]')?.content;
        const header = document.querySelector('meta[name="_csrf_header"]')?.content;
        const h = { 'Content-Type': 'application/x-www-form-urlencoded' };
        if (token && header) h[header] = token;
        return h;
    }

    const products = ref([]);
    const isLoading = ref(false);
    const isLoadingMore = ref(false);
    const keyword = ref('');
    const priceMin = ref('');
    const priceMax = ref('');
    const availableOnly = ref(false);
    const categoryIdx = ref('');
    const sort = ref('newest');
    const km = ref('1');
    const sortDropdownOpen = ref(false);
    const currentPage = ref(1);
    const totalPage = ref(1);

    const SORT_LABELS = {
        newest: '최신순', latest: '최신순',
        lowPrice: '낮은 가격순', highPrice: '높은 가격순', hitCount: '인기순'
    };
    const KM_LABELS = { '1': '내 동네만', '3': '가까운 동네', '5': '먼 동네까지' };

    const sortLabel = computed(() => SORT_LABELS[sort.value] || '최신순');
    const hasMore = computed(() => currentPage.value < totalPage.value);

    const activeChips = computed(() => {
        const chips = [];
        if (keyword.value) chips.push({ label: '검색: ' + keyword.value, key: 'keyword' });
        if (categoryIdx.value) chips.push({
            label: categories.value.find(c => String(c.CATEGORYIDX) === categoryIdx.value)?.CATEGORYNAME || '카테고리',
            key: 'categoryIdx'
        });
        if (priceMin.value || priceMax.value) chips.push({
            label: (priceMin.value||'0') + '원 ~ ' + (priceMax.value||'∞') + '원',
            keys: ['priceMin', 'priceMax']
        });
        if (availableOnly.value) chips.push({ label: '거래 가능', key: 'available' });
        if (sort.value && sort.value !== 'newest') chips.push({ label: '정렬: ' + (SORT_LABELS[sort.value]||sort.value), key: 'sort' });
        if (km.value && km.value !== '1') chips.push({ label: KM_LABELS[km.value]||km.value+'km', key: 'km' });
        return chips;
    });

    function buildQs(page) {
        const p = new URLSearchParams();
        if (keyword.value) p.set('keyword', keyword.value);
        if (priceMin.value) p.set('priceMin', priceMin.value);
        if (priceMax.value) p.set('priceMax', priceMax.value);
        if (availableOnly.value) p.set('available', 'true');
        if (categoryIdx.value) p.set('categoryIdx', categoryIdx.value);
        if (sort.value) p.set('sort', sort.value);
        if (km.value) p.set('km', km.value);
        if (page) p.set('page', page);
        return p.toString();
    }

    async function fetchList(page = 1, append = false) {
        page === 1 ? (isLoading.value = true) : (isLoadingMore.value = true);
        try {
            const res = await fetch('/api/trade/list?' + buildQs(page));
            const data = await res.json();
            append ? products.value.push(...(data.tradeList||[]))
                   : (products.value = data.tradeList||[]);
            totalPage.value = data.totalPage || 1;
            currentPage.value = data.currentPage || page;
            if (data.categoryList) categories.value = data.categoryList;
        } catch (e) {
            console.error(e);
        } finally {
            isLoading.value = false;
            isLoadingMore.value = false;
        }
    }

    function navigate() { fetchList(1); }
    function setCategory(idx) { categoryIdx.value = idx; navigate(); }
    function setSort(val) { sort.value = val; sortDropdownOpen.value = false; navigate(); }
    function setKm(val) { km.value = val; navigate(); }
    function applyFilter() { navigate(); }

    function removeChip(chip) {
        if (chip.keys) { priceMin.value = ''; priceMax.value = ''; }
        else {
            if (chip.key === 'keyword') keyword.value = '';
            if (chip.key === 'categoryIdx') categoryIdx.value = '';
            if (chip.key === 'available') availableOnly.value = false;
            if (chip.key === 'sort') sort.value = 'newest';
            if (chip.key === 'km') km.value = '1';
        }
        navigate();
    }

    function resetFilters() {
        keyword.value = ''; priceMin.value = ''; priceMax.value = '';
        availableOnly.value = false; categoryIdx.value = '';
        sort.value = 'newest'; km.value = '1';
        navigate();
    }

    async function loadMore() {
        if (isLoadingMore.value || !hasMore.value) return;
        await fetchList(currentPage.value + 1, true);
    }

    async function toggleWish(e, product) {
        e.preventDefault(); e.stopPropagation();
        const res = await fetch('/api/trade/toggleLike', {
            method: 'POST', headers: csrfHeaders(),
            body: new URLSearchParams({ productIdx: product.productIdx })
        });
        const data = await res.json();
        if (data.status === 'loginRequired') {
            if (typeof showBatonToast === 'function') showBatonToast('로그인이 필요한 서비스입니다.');
            return;
        }
        if (data.isLiked !== undefined) {
            product.isLiked = data.isLiked;
            product.likeCount = data.likeCount;
            if (typeof showBatonToast === 'function') {
                showBatonToast(data.isLiked ? '관심 목록에 추가되었습니다.' : '관심 목록에서 제거되었습니다.');
            }
        }
    }

    function getTradePlace(item) {
        if (item.tradeType === '둘다가능') return (item.tradePlace||'택배 거래만 가능') + ' · 택배 거래';
        return item.tradePlace || '택배 거래만 가능';
    }

    let debounceTimer = null;
    let isComposing = false;

    function debounce() {
        if (isComposing) return;
        clearTimeout(debounceTimer);
        debounceTimer = setTimeout(navigate, 400);
    }

    watch(keyword, () => debounce());
    watch(priceMin, () => debounce());
    watch(priceMax, () => debounce());
    watch(availableOnly, () => navigate());

    onMounted(() => {
        fetchList(1);
        document.addEventListener('compositionstart', () => { isComposing = true; });
        document.addEventListener('compositionend', () => { isComposing = false; debounce(); });
        document.addEventListener('click', () => { sortDropdownOpen.value = false; });
    });

    return {
        products, isLoading, isLoadingMore,
        keyword, priceMin, priceMax, availableOnly, categoryIdx, sort, km,
        sortDropdownOpen, activeChips, sortLabel, hasMore,
        fetchList, navigate,
        setCategory, setSort, setKm, applyFilter, removeChip, resetFilters,
        loadMore, toggleWish, getTradePlace,
        formatTimeAgo, formatPrice, debounce
    };
}
