const CrewList = { 
    template: '#crew-list-template',
    data() {
        return {
            crews: [],
            totalCount: 0,
            isLoading: false
        }
    },
    mounted() {
        this.fetchCrews();
    },
    methods: {
        async fetchCrews() {
            this.isLoading = true;
            try {
                const response = await fetch('/api/crew/list');
                
                if (!response.ok) {
                    throw new Error('서버 응답 에러: ' + response.status);
                }

                const data = await response.json();

                if (data.state === 'success') {
                    this.crews = data.crewList;
                    this.totalCount = data.count;
                } else {
                    console.error("데이터 로드 실패:", data.state);
                }
            } catch (error) {
                console.error("fetch 에러 발생:", error);
            } finally {
                this.isLoading = false;
            }
        },

        toggleWish(id) {
            console.log(id + "번 게시글 찜하기!");
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