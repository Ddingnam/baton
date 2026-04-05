const CrewDetail = {
    template: '#crew-detail-template',
    components: {
        'crew-dashboard': CrewDashboard 
    },
	data() {
        return {
            isLoading: false,
            crew: null,
            myStatus: null,
			
			isJoinModalOpen: false,
            joinReason: ''
        }
    },
    
    async mounted() {
        window.scrollTo(0, 0);
        const crewIdx = this.$route.params.crewIdx;
        if (crewIdx) {
            await this.loadAllData(crewIdx);
        }
    },
	computed: {
		joinButtonText() {
	        if (!this.myStatus) {
	            if (this.crew && this.crew.currentMember >= this.crew.maxMember) {
	                return '모집 정원 초과';
	            }
	            return this.crew?.joinType === 'A' ? '가입 신청하기' : '모임 가입하기';
	        }

	        const status = this.myStatus.status;
	        
	        if (status === 'ACTIVE') return '모임 탈퇴하기';
	        if (status === 'WAIT') return '가입 승인 대기 중';
	        if (status === 'BANNED') return '가입이 제한된 모임';

	        if (this.crew && this.crew.currentMember >= this.crew.maxMember) {
	            return '모집 정원 초과';
	        }
	        return this.crew?.joinType === 'A' ? '가입 신청하기' : '모임 가입하기';
	    },

        isJoinDisabled() {
			if (!this.myStatus) {
	            return this.crew ? this.crew.currentMember >= this.crew.maxMember : false;
	        }
	        
	        return ['WAIT', 'BANNED'].includes(this.myStatus.status) || 
	               (this.crew && this.crew.currentMember >= this.crew.maxMember);
        },
		
		buttonClass() {
			if (!this.myStatus) return 'primary';
	        if (this.myStatus.status === 'ACTIVE') return 'btn-danger';
	        if (this.isJoinDisabled) return 'btn-disabled';
	        return 'primary';
	    }
    },
	
	watch: {
        '$route.params.crewIdx': function(newIdx) {
            if (newIdx) this.loadAllData(newIdx);
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
			if (response.status === 401) {
                const errorData = await response.json();
                if (errorData.state === 'login_required') {
                    alert("로그인이 필요한 메뉴입니다. 로그인 페이지로 이동합니다.");
					throw new Error("login_required");
                }
            }

            if (!response.ok) throw new Error("상세 정보 호출 실패");

            const responseData = await response.json();
            this.crew = responseData.crew;
            this.myStatus = responseData.myStatus;
        },
		
		async handleButtonClick() {
	        if (this.myStatus && this.myStatus.status === 'ACTIVE') {
	            await this.handleExitCrew();
	            return;
	        }

	        if (this.crew.joinType === 'F') {
                await this.handleJoinCrew("자유 가입");
			} else {
                this.joinReason = '';
                this.isJoinModalOpen = true;
            }
	    },
		
		closeJoinModal() {
            this.isJoinModalOpen = false;
            this.joinReason = '';
        },

        async submitJoinApplication() {
            if (!this.joinReason.trim()) {
                alert("가입 사유를 입력해주세요.");
                return;
            }
            await this.handleJoinCrew(this.joinReason);
            this.closeJoinModal();
        },
		
		async handleJoinCrew(reasonText) {
			if (!confirm("이 모임에 바로 참여하시겠습니까?")) return;
            try {
                this.isLoading = true;
                
                const response = await fetch('/api/crew/join', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        crewIdx: this.crew.crewIdx,
                        reason: reasonText
                    })
                });

                if (response.status === 401) {
                    alert("로그인이 필요한 서비스입니다.");
                    return;
                }

                if (!response.ok) {
                    const errorMsg = await response.text();
                    throw new Error(errorMsg || "가입 처리 중 오류가 발생했습니다.");
                }

				if (this.crew.joinType === 'F') {
                    alert("🎉 모임 가입이 완료되었습니다!");
                } else {
                    alert("✅ 가입 신청이 완료되었습니다. 방장의 승인을 기다려주세요.");
                }
                
                await this.fetchCrewDetail(this.crew.crewIdx);
            } catch (error) {
                console.error("❌ 가입 신청 실패:", error);
                alert(error.message);
            } finally {
                this.isLoading = false;
            }
        },
		
		async handleExitCrew() {
	        if (!confirm("정말로 이 모임을 탈퇴하시겠습니까?\n탈퇴 후 재가입은 모임 설정에 따라 제한될 수 있습니다.")) return;

	        try {
	            this.isLoading = true;
	            const response = await fetch('/api/crew/exit', {
	                method: 'POST',
	                headers: { 'Content-Type': 'application/json' },
	                body: JSON.stringify({ 
	                    crewIdx: this.crew.crewIdx,
	                    reason: "사용자 자진 탈퇴" 
	                })
	            });

	            if (!response.ok) throw new Error("탈퇴 처리 중 오류가 발생했습니다.");

	            alert("정상적으로 탈퇴 처리되었습니다.");
	            await this.fetchCrewDetail(this.crew.crewIdx);

	        } catch (error) {
	            alert(error.message);
	        } finally {
	            this.isLoading = false;
	        }
	    }
    }
};