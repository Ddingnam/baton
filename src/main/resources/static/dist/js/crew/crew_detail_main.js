const CrewDetail = {
    template: '#crew-detail-template',
    components: {
        'crew-dashboard': CrewDashboard 
    },
    data() {
        return {
            isLoading: false,
            crew: null
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
                    this.fetchCrewDetail(crewIdx)
                ]);
            } catch (error) {
                console.error("❌ 데이터 로드 실패:", error);
                alert("데이터를 불러오는 중 오류가 발생했습니다.");
            } finally {
                this.isLoading = false;
            }
        },

        async fetchCrewDetail(idx) {
            const response = await fetch(`/api/crew/article/${idx}`);
            if (!response.ok) throw new Error("상세 정보 호출 실패");
            this.crew = await response.json();
        }
    },

    watch: {
        '$route.params.crewIdx': function(newIdx) {
            if (newIdx) this.loadAllData(newIdx);
        }
    }
};