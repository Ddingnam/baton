const CrewDashboard = {
    template: '#crew-dashboard-template',
    props: ['crewIdx', 'crew'],
    data() {
        return {
            schedules: [],
            recentPosts: [],
            isLoading: false
        };
    },
    async mounted() {
        if (this.crewIdx) {
            await this.fetchDashboardData(this.crewIdx);
        }
    },
    methods: {
		async fetchDashboardData(idx) {
            this.isLoading = true;
            try {
                const response = await fetch(`/api/crew/board/list/${idx}?page=1&size=3`);
                
                if (!response.ok) throw new Error("게시글 로드 실패");
                
                const data = await response.json();
                
                if (data.status === "success") {
                    this.recentPosts = data.posts;
                }

                this.schedules = [
                    { id: 1, day: '23', month: 'MAR', title: '반포대교 달빛 러닝', time: '오후 8:00', location: '잠수교 남단' },
                    { id: 2, day: '25', month: 'MAR', title: '여의도 모닝 하프', time: '오전 7:00', location: '여의도 한강공원' }
                ];

            } catch (error) {
                console.error("❌ 대시보드 데이터 로드 실패:", error);
            } finally {
                this.isLoading = false;
            }
        },
		goToBoardDetail(postIdx) {
			window.scrollTo({ top: 0, behavior: 'smooth' });
	        this.$router.push({
	            path: `/article/${this.crewIdx}/board`, 
	            query: { 
	                ...this.$route.query,
	                targetBoardIdx: postIdx
	            }
	        });
	    }
    },
    watch: {
        crewIdx(newIdx) {
            if (newIdx) {
                this.fetchDashboardData(Number(newIdx));
            }
        }
    }
};