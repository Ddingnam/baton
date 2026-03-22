const CrewDetail = {
    template: '#crew-detail-template',
    data() {
        return {
            isLoading: false,
            crew: null, 
            schedules: [],
            recentPosts: []
        }
    },
    
    async mounted() {
		window.scrollTo(0, 0);
        const crewIdx = this.$route.params.crewIdx;
        if (crewIdx) {
            await this.loadAllData(crewIdx);
        }
    },

    methods: {
        async loadAllData(crewIdx) {
            this.isLoading = true;
            try {
                await Promise.all([
                    this.fetchCrewDetail(crewIdx),
                    this.fetchDashboardData(crewIdx)
                ]);
            } catch (error) {
                console.error("❌ 데이터 로드 실패:", error);
            } finally {
                this.isLoading = false;
            }
        },

        async fetchCrewDetail(idx) {
            const response = await fetch(`/api/crew/article/${idx}`);
            if (!response.ok) throw new Error("상세 정보 호출 실패");
            this.crew = await response.json();
        },

        async fetchDashboardData(idx) {
            this.schedules = [
                { id: 1, day: '23', month: 'MAR', title: '반포대교 달빛 러닝', time: '오후 8:00', location: '잠수교 남단' },
                { id: 2, day: '25', month: 'MAR', title: '여의도 모닝 하프', time: '오전 7:00', location: '여의도 한강공원' }
            ];
            this.recentPosts = [
                { id: 101, title: '이번 주 토요일 일정 그대로 가나요?', author: '런린이', time: '2시간 전', likes: 3 },
                { id: 102, title: '가성비 러닝화 추천!', author: '장비병', time: '어제', likes: 12 }
            ];
        }
    },

    watch: {
        '$route.params.crewIdx': function(newIdx) {
            if (newIdx) this.loadAllData(newIdx);
        }
    }
};