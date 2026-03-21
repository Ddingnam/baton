const { createApp, ref, computed, onMounted, watch } = Vue;

createApp({
    setup() {
        const products = ref([]);
        const categories = ref([]);
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

        const CAT_NAMES = {
            '1': '전자기기', '2': '남성의류', '3': '여성의류', '4': '뷰티',
            '5': '스타굿즈', '6': '가구/인테리어', '7': '도서', '8': '게임',
            '9': '스포츠/레저', '10': '가전제품', '11': '취미/수집',
            '12': '반려동물', '13': '식품', '14': '유아동', '15': '티켓/상품권'
        };
        const SORT_LABELS = {
            'newest': '최신순', 'latest': '최신순',
            'lowPrice': '낮은 가격순', 'highPrice': '높은 가격순', 'hitCount': '인기순'
        };
        const KM_LABELS = {
            '1': '내 동네만', '3': '가까운 동네', '5': '먼 동네까지'
        };

        const activeChips = computed(() => {
            const chips = [];
            if (keyword.value)
                chips.push({ label: '검색: ' + keyword.value, key: 'keyword' });
            if (categoryIdx.value)
                chips.push({ label: CAT_NAMES[categoryIdx.value] || '카테고리', key: 'categoryIdx' });
            if (priceMin.value || priceMax.value)
                chips.push({ label: (priceMin.value || '0') + '원 ~ ' + (priceMax.value || '∞') + '원', keys: ['priceMin', 'priceMax'] });
            if (availableOnly.value)
                chips.push({ label: '거래 가능', key: 'available' });
            if (sort.value && sort.value !== 'newest' && sort.value !== 'latest')
                chips.push({ label: '정렬: ' + (SORT_LABELS[sort.value] || sort.value), key: 'sort' });
            if (km.value && km.value !== '1')
                chips.push({ label: KM_LABELS[km.value] || km.value + 'km', key: 'km' });
            return chips;
        });

        const sortLabel = computed(() => SORT_LABELS[sort.value] || '최신순');
        const hasMore = computed(() => currentPage.value < totalPage.value);

        function readFromUrl() {
            const p = new URL(location.href).searchParams;
            keyword.value = p.get('keyword') || '';
            priceMin.value = p.get('priceMin') || '';
            priceMax.value = p.get('priceMax') || '';
            availableOnly.value = p.get('available') === 'true';
            categoryIdx.value = p.get('categoryIdx') || '';
            sort.value = p.get('sort') || 'newest';
            km.value = p.get('km') || '1';
        }

        function buildQueryString() {
            const p = new URLSearchParams();
            if (keyword.value) p.set('keyword', keyword.value);
            if (priceMin.value) p.set('priceMin', priceMin.value);
            if (priceMax.value) p.set('priceMax', priceMax.value);
            if (availableOnly.value) p.set('available', 'true');
            if (categoryIdx.value) p.set('categoryIdx', categoryIdx.value);
            if (sort.value) p.set('sort', sort.value);
            if (km.value) p.set('km', km.value);
            return p.toString();
        }

        function pushUrl() {
            const qs = buildQueryString();
            history.pushState(null, '', '/trade/list' + (qs ? '?' + qs : ''));
        }

        async function fetchList(page = 1, append = false) {
            if (page === 1) isLoading.value = true;
            else isLoadingMore.value = true;

            try {
                const p = new URLSearchParams();
                if (keyword.value) p.set('keyword', keyword.value);
                if (priceMin.value) p.set('priceMin', priceMin.value);
                if (priceMax.value) p.set('priceMax', priceMax.value);
                if (availableOnly.value) p.set('available', 'true');
                if (categoryIdx.value) p.set('categoryIdx', categoryIdx.value);
                if (sort.value) p.set('sort', sort.value);
                if (km.value) p.set('km', km.value);
                p.set('page', page);

                const res = await fetch('/trade/listJson?' + p.toString());
                if (!res.ok) throw new Error('HTTP_ERROR');
                const data = await res.json();

                if (append) {
                    products.value = [...products.value, ...data.tradeList];
                } else {
                    products.value = data.tradeList || [];
                    currentPage.value = 1;
                }

                totalPage.value = data.totalPage || 1;
                currentPage.value = data.currentPage || page;

                if (data.categoryList) {
                    categories.value = data.categoryList;
                }
            } catch (e) {
                console.error('fetchList 오류:', e);
            } finally {
                isLoading.value = false;
                isLoadingMore.value = false;
            }
        }

        function goTo(path) {
            location.href = (typeof CTX !== 'undefined' ? CTX : '') + path;
        }

        function navigate() {
            pushUrl();
            fetchList(1);
        }

        function setCategory(idx) {
            categoryIdx.value = idx;
            navigate();
        }

        function setSort(val) {
            sort.value = val;
            sortDropdownOpen.value = false;
            navigate();
        }

        function setKm(val) {
            km.value = val;
            navigate();
        }

        function applyFilter() {
            navigate();
        }

        function removeChip(chip) {
            if (chip.keys) {
                chip.keys.forEach(k => {
                    if (k === 'priceMin') priceMin.value = '';
                    if (k === 'priceMax') priceMax.value = '';
                });
            } else {
                if (chip.key === 'keyword') keyword.value = '';
                if (chip.key === 'categoryIdx') categoryIdx.value = '';
                if (chip.key === 'available') availableOnly.value = false;
                if (chip.key === 'sort') sort.value = 'newest';
                if (chip.key === 'km') km.value = '1';
            }
            navigate();
        }

        function resetFilters() {
            keyword.value = '';
            priceMin.value = '';
            priceMax.value = '';
            availableOnly.value = false;
            categoryIdx.value = '';
            sort.value = 'newest';
            km.value = '1';
            navigate();
        }

        async function loadMore() {
            if (isLoadingMore.value || !hasMore.value) return;
            await fetchList(currentPage.value + 1, true);
        }

        async function toggleWish(e, product) {
            e.preventDefault();
            e.stopPropagation();

            const csrfToken = document.querySelector('meta[name="_csrf"]')?.content;
            const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.content;
            const headers = { 'Content-Type': 'application/x-www-form-urlencoded' };
            if (csrfHeader && csrfToken) headers[csrfHeader] = csrfToken;

            try {
                const res = await fetch('/trade/toggleLike', {
                    method: 'POST',
                    headers,
                    body: new URLSearchParams({ productIdx: product.productIdx })
                });
                const data = await res.json();

                if (data.status === 'loginRequired') {
                    alert('로그인이 필요한 서비스입니다.');
                    return;
                }
                if (data.status === 'success') {
                    product.isLiked = data.isLiked;
                    product.likeCount = data.likeCount;
                    showBatonToast(data.isLiked ? '관심 목록에 추가되었습니다.' : '관심 목록에서 제거되었습니다.');
                }
            } catch (e) {
                showBatonToast('다시 시도하여 주세요.');
            }
        }

        function formatTimeAgo(dateString) {
            if (!dateString) return '';
            const cleanDate = dateString.trim().split('.')[0].replace(/-/g, '/');
            const date = new Date(cleanDate);
            const diff = Math.floor((Date.now() - date) / 1000);
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

        function getTradePlace(item) {
            if (item.tradeType === '둘다가능') {
                return (item.tradePlace || '택배 거래만 가능') + ' · 택배 거래';
            }
            return item.tradePlace || '택배 거래만 가능';
        }

        window.addEventListener('popstate', () => {
            readFromUrl();
            fetchList(1);
        });

        let debounceTimer = null;
        function debounceNavigate() {
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(() => navigate(), 0);
        }

        watch(keyword, () => debounceNavigate());
        watch(priceMin, () => debounceNavigate());
        watch(priceMax, () => debounceNavigate());
        watch(availableOnly, () => navigate());

        onMounted(() => {
            readFromUrl();
            fetchList(1);
            document.addEventListener('click', () => { sortDropdownOpen.value = false; });
        });

        return {
            products, categories, isLoading, isLoadingMore,
            keyword, priceMin, priceMax, availableOnly,
            categoryIdx, sort, km,
            currentPage, totalPage,
            activeChips, sortLabel, hasMore,
            CAT_NAMES, SORT_LABELS, KM_LABELS,
            sortDropdownOpen,
            setCategory, setSort, setKm,
            applyFilter, removeChip, resetFilters, loadMore, toggleWish, goTo,
            formatTimeAgo, formatPrice, getTradePlace
        };
    }
}).mount('#trade-list-app');