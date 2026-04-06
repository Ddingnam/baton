const CrewList = { 
    template: '#crew-list-template',
    data() {
        return {
            crews: [],
            totalCount: 0,
            isLoading: false,
            isLastPage: false,
            observer: null,
            
            categories: [
                { idx: 1, name: '스터디' },
                { idx: 2, name: '운동' },
                { idx: 3, name: '독서' },
                { idx: 4, name: '맛집/카페' },
                { idx: 5, name: '산책/반려동물' },
                { idx: 6, name: '공예/만들기' },
                { idx: 7, name: '음악/악기' },
                { idx: 8, name: '게임/오락' },
                { idx: 9, name: '자유 주제' }
            ],

            params: {
                categoryIdx: 0,
                distance: 'local',
                joinType: 'all',
                isRecruiting: true,
                sortType: 'latest', 
                keyword: '',       
                page: 1,    
                size: 9
            }
        }
    },
    computed: {
        activeFilters() {
            const filters = [];

            if (this.params.categoryIdx !== 0) {
                const cat = this.categories.find(c => c.idx === this.params.categoryIdx);
                if (cat) filters.push({ id: 'category', text: cat.name });
            }
            if (this.params.distance !== '') {
                const distMap = { local: '내 동네', near: '가까운 동네', far: '먼 동네' };
                filters.push({ id: 'distance', text: distMap[this.params.distance] });
            }
            if (this.params.joinType !== 'all') {
                const joinMap = { F: '자유가입', A: '승인제' };
                filters.push({ id: 'joinType', text: joinMap[this.params.joinType] });
            }
            if (this.params.keyword.trim() !== '') {
                filters.push({ id: 'keyword', text: `검색어: ${this.params.keyword}` });
            }

            return filters;
        }
    },
    mounted() {
        this.fetchCrews();
        this.$nextTick(() => {
            this.initObserver();
        });
		
		this.searchListener = (event) => {
            if (this.handleSearch) {
                this.handleSearch(event);
            }
        };
        
        window.addEventListener('crew-search', this.searchListener);
    },
    beforeUnmount() {
        if (this.observer) this.observer.disconnect();
		window.removeEventListener('crew-search', this.searchListener);
    },
    methods: {
        async fetchCrews(isAppend = false) {
            if (this.isLoading || (this.isLastPage && isAppend)) return;
            
            this.isLoading = true;
            try {
                const queryParams = new URLSearchParams(this.params).toString();
                const response = await fetch(`/api/crew/list?${queryParams}`);
                
                if (!response.ok) throw new Error('서버 응답 에러');

                const data = await response.json();

                if (data.state === 'success') {
                    if (isAppend) {
                        this.crews.push(...data.crewList);
                    } else {
                        this.crews = data.crewList;
                        window.scrollTo({ top: 0, behavior: 'smooth' });
                    }
                    this.totalCount = data.count;
                    this.isLastPage = data.crewList.length < this.params.size;
                }
            } catch (error) {
                console.error("fetch 에러 발생:", error);
            } finally {
                this.isLoading = false;
            }
        },

        initObserver() {
            this.observer = new IntersectionObserver((entries) => {
                if (entries[0].isIntersecting && !this.isLoading && !this.isLastPage) {
                    this.params.page++;
                    this.fetchCrews(true);
                }
            }, { rootMargin: '0px 0px 200px 0px', threshold: 0 });

            const trigger = this.$refs.loadTrigger;
            if (trigger) this.observer.observe(trigger);
        },
        
        resetAndFetch() {
            this.params.page = 1;
            this.isLastPage = false;
            this.fetchCrews(false);
        },
		
		handleSearch(event) {
	        const keyword = event.detail.keyword;
	        this.params.keyword = keyword;
	        this.resetAndFetch();
	    },

        changeCategory(idx) {
            this.params.categoryIdx = idx;
            this.resetAndFetch();
        },
        
        changeDistance(val) {
            this.params.distance = this.params.distance === val ? '' : val;
            this.resetAndFetch();
        },
        
        changeJoinType(val) {
            this.params.joinType = val;
            this.resetAndFetch();
        },
        
        searchKeyword(keyword) {
            this.params.keyword = keyword;
            this.resetAndFetch();
        },

        removeFilter(filterId) {
            if (filterId === 'category') this.params.categoryIdx = 0;
            if (filterId === 'distance') this.params.distance = 'local';
            if (filterId === 'joinType') this.params.joinType = 'all';
            if (filterId === 'keyword') this.params.keyword = '';
            
            this.resetAndFetch();
        },
		
		resetFilters() {
	        this.params = {
	            categoryIdx: 0,
	            distance: 'local',
	            joinType: 'all',
	            isRecruiting: true,
	            keyword: '',
	            sortType: 'latest',
	            page: 1,
	            size: 9
	        };
			/*
	        if (this.activeFilters) {
	            this.activeFilters = [];
	        }
			*/
	        this.resetAndFetch();
	    },

        toggleWish(id) {
            console.log(id + "번 모임 찜하기!");
        },
        
        scrollTags(direction) {
            const container = this.$refs.tagCarousel;
            if (!container) return;
            const scrollAmount = 400; 
            if (direction === 'left') {
                container.scrollBy({ left: -scrollAmount, behavior: 'smooth' });
            } else {
                container.scrollBy({ left: scrollAmount, behavior: 'smooth' });
            }
        },
        
        openGuide() {
            console.log("이용 가이드 팝업 오픈!");
        }
    }
};