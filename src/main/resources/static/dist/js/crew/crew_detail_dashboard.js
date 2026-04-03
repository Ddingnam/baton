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
				const [boardResponse, scheduleResponse] = await Promise.all([
		            fetch(`/api/crew/board/list/${idx}?page=1&size=3`),
		            fetch(`/api/crew/schedule/${idx}/upcoming`)
		        ]);
				
				if (boardResponse.ok) {
		            const boardData = await boardResponse.json();
		            if (boardData.status === "success") {
		                this.recentPosts = boardData.posts;
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

            } catch (error) {
                console.error("❌ 대시보드 데이터 로드 실패:", error);
            } finally {
                this.isLoading = false;
            }
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