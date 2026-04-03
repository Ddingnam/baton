const CrewDashboard = {
    template: '#crew-dashboard-template',
    props: ['crewIdx', 'crew'],
    data() {
        return {
            schedules: [],
			recentPosts: [],
            noticePosts: [],
			vitalityScore: 0,
            topRankers: [],
            isLoading: false
        };
    },
	computed: {
        vitalityStatus() {
            if (this.vitalityScore >= 80) return '열정 폭발 ☀️';
            if (this.vitalityScore >= 50) return '매우 활발 🔥';
            if (this.vitalityScore >= 25) return '적당함 😊';
            return '시작 단계 🌱';
        }
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
				const [boardResponse, scheduleResponse, statsResponse] = await Promise.all([
                    fetch(`/api/crew/board/dashboard/${idx}`),
                    fetch(`/api/crew/schedule/${idx}/upcoming`),
                    fetch(`/api/crew/dashboard/${idx}/stats`)
                ]);
				
				if (boardResponse.ok) {
		            const boardData = await boardResponse.json();
					if (boardData.status === "success") {
                        this.noticePosts = boardData.data.notices || [];
                        this.recentPosts = boardData.data.posts || [];
                    }
		        } else {
					throw new Error("게시글 로드 실패");
				}

				if (scheduleResponse.ok) {
		            const scheduleData = await scheduleResponse.json();
		            
		            this.schedules = scheduleData.map(sch => {
		                const dateObj = new Date(sch.startDate);
		                const monthNames = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
		                
		                let hours = dateObj.getHours();
		                const minutes = String(dateObj.getMinutes()).padStart(2, '0');
		                const ampm = hours >= 12 ? '오후' : '오전';
		                hours = hours % 12 || 12;

		                return {
		                    id: sch.scheduleIdx,
		                    day: String(dateObj.getDate()).padStart(2, '0'),
		                    month: monthNames[dateObj.getMonth()],
		                    title: sch.title,
		                    time: `${ampm} ${hours}:${minutes}`,
		                    location: sch.locationName || '장소 미정'
		                };
		            }).slice(0, 2);
		        }
				
				if (statsResponse.ok) {
                    const statsData = await statsResponse.json();
                    if (statsData.state === "success" && statsData.data) {
                        this.vitalityScore = statsData.data.vitality || 0;
                        this.topRankers = statsData.data.topRankers || [];
                    }
                }

            } catch (error) {
                console.error("❌ 대시보드 데이터 로드 실패:", error);
            } finally {
                this.isLoading = false;
            }
        },
		
		getMedal(index) {
            const medals = ['🥇', '🥈', '🥉'];
            return medals[index] || '🏅';
        },
		
		goToBoardDetail(boardIdx) {
			window.scrollTo({ top: 0, behavior: 'smooth' });
	        this.$router.push({ 
	            name: 'crew-board-detail', 
	            params: { 
	                crewIdx: this.crew.crewIdx, 
	                boardIdx: boardIdx 
	            } 
	        }).catch(() => {});
	    },
		goToSchedule() {
	        window.scrollTo({ top: 0, behavior: 'smooth' });
	        
	        this.$router.push({ 
	            name: 'crew-schedule', 
	            params: { 
	                crewIdx: this.crew.crewIdx 
	            } 
	        }).catch(() => {});
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