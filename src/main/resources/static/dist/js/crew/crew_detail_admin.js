const CrewAdmin = {
    template: '#crew-admin-template',
    props: {
        crew: Object,
        crewIdx: Number
    },
    data() {
        return {
            currentTab: 'info',
            editForm: {
				crewName: '',
	            description: '',
	            maxMember: 0,
	            status: 'ACTIVE',
	            joinType: 'F',
	            logoImageFile: null
            },
			previewUrl: null,
            activeMembers: [],
            pendingApps: [],
			historyList: [],
			
			isMemberModalOpen: false,
            isAppModalOpen: false,
            selectedMember: null,
            selectedApp: null
        };
    },
    watch: {
        crew: {
            immediate: true,
            handler(newVal) {
                if (newVal) {
					this.editForm = {
	                    crewName: newVal.name || '',
	                    description: newVal.description || '',
	                    maxMember: newVal.maxMember || 0,
	                    status: newVal.status || 'ACTIVE',
	                    joinType: newVal.joinType || 'F',
	                    logoImageFile: null
	                };
	                this.previewUrl = null;
                }
            }
        }
    },
    mounted() {
        if (this.crewIdx) {
            this.fetchMembers();
            this.fetchApplications();
        }
    },
    methods: {
        switchTab(tabName) {
            this.currentTab = tabName;
            if (tabName === 'members') this.fetchMembers();
            if (tabName === 'apps') this.fetchApplications();
			if (tabName === 'history') this.fetchHistory();
        },

        async closeCrew() {
            if (!confirm("정말 모임을 폐쇄하시겠습니까? 이 작업은 되돌릴 수 없습니다.")) return;
            try {
                const response = await fetch(`/api/crew/manage/${this.crewIdx}/close`, { method: 'POST' });
                if (!response.ok) throw new Error("모임 폐쇄에 실패했습니다.");
                alert("모임이 폐쇄되었습니다. 메인으로 이동합니다.");
                location.href = '/crew/main';
            } catch (error) {
                alert(error.message);
            }
        },

        async fetchMembers() {
            try {
                const response = await fetch(`/api/crew/manage/${this.crewIdx}/members`);
                if (response.ok) {
                    this.activeMembers = await response.json();
                }
            } catch (error) {
                console.error("멤버 목록 조회 실패", error);
            }
        },

        async kickMember(userIdx, nickname) {
            if (!confirm(`${nickname} 님을 정말 모임에서 내보내시겠습니까?`)) return;
            try {
                const response = await fetch(`/api/crew/manage/${this.crewIdx}/members/${userIdx}/kick`, { method: 'POST' });
                if (!response.ok) throw new Error("멤버 강퇴 처리에 실패했습니다.");
                alert("해당 멤버를 내보냈습니다.");
                this.fetchMembers();
            } catch (error) {
                alert(error.message);
            }
        },

        async fetchApplications() {
            try {
                const response = await fetch(`/api/crew/manage/${this.crewIdx}/applications`);
                if (response.ok) {
                    this.pendingApps = await response.json();
                }
            } catch (error) {
                console.error("신청 목록 조회 실패", error);
            }
        },
		
		openMemberModal(member) {
            this.selectedMember = { ...member };
            this.isMemberModalOpen = true;
        },
		
        closeMemberModal() {
            this.isMemberModalOpen = false;
            this.selectedMember = null;
        },
		
        openAppModal(app) {
            this.selectedApp = app;
            this.isAppModalOpen = true;
        },
		
        closeAppModal() {
            this.isAppModalOpen = false;
            this.selectedApp = null;
        },

        async updateMemberRole() {
            if (!confirm(`이 멤버의 권한을 변경하시겠습니까?`)) return;
            try {
                const response = await fetch(`/api/crew/manage/${this.crewIdx}/members/${this.selectedMember.userIdx}/role`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: `role=${this.selectedMember.role}`
                });
                if (!response.ok) throw new Error("권한 변경에 실패했습니다.");
                
                alert("권한이 성공적으로 변경되었습니다.");
                this.closeMemberModal();
                this.fetchMembers();
            } catch (error) {
                alert(error.message);
            }
        },

        async kickMember(userIdx, nickname) {
            if (!confirm(`${nickname} 님을 정말 모임에서 내보내시겠습니까?`)) return;
            try {
                const response = await fetch(`/api/crew/manage/${this.crewIdx}/members/${userIdx}/kick`, { method: 'POST' });
                if (!response.ok) throw new Error("멤버 강퇴 처리에 실패했습니다.");
                alert("해당 멤버를 내보냈습니다.");
                this.closeMemberModal();
                this.fetchMembers();
            } catch (error) {
                alert(error.message);
            }
        },

        async handleApplication(userIdx, action) {
            const actionText = action === 'APPROVE' ? '승인' : '거절';
            if (!confirm(`이 가입 신청을 ${actionText}하시겠습니까?`)) return;
            try {
                const response = await fetch(`/api/crew/manage/${this.crewIdx}/applications/${userIdx}?action=${action}`, { method: 'POST' });
                if (!response.ok) throw new Error(`가입 ${actionText} 처리에 실패했습니다.`);
                alert(`가입이 ${actionText} 되었습니다.`);
                this.closeAppModal();
                this.fetchApplications();
                this.fetchMembers();
            } catch (error) {
                alert(error.message);
            }
        },
		
		handleFileUpload(event) {
	        const file = event.target.files[0];
	        if (file) {
	            this.editForm.logoImageFile = file;
	            this.previewUrl = URL.createObjectURL(file);
	        }
	    },

	    resetProfileImage() {
	        this.editForm.logoImageFile = null;
	        if (this.previewUrl) URL.revokeObjectURL(this.previewUrl);
	        this.previewUrl = null;
	        const fileInput = document.querySelector('.ca-file-input');
	        if (fileInput) fileInput.value = '';
	    },

	    async updateCrewInfo() {
	        try {
	            const formData = new FormData();
	            formData.append('crewName', this.editForm.crewName);
	            formData.append('description', this.editForm.description);
	            formData.append('maxMember', this.editForm.maxMember);
	            formData.append('status', this.editForm.status);
	            formData.append('joinType', this.editForm.joinType);
	            
	            if (this.editForm.logoImageFile) {
	                formData.append('logoImageFile', this.editForm.logoImageFile);
	            }

	            const response = await fetch(`/api/crew/manage/${this.crewIdx}/info`, {
	                method: 'POST',
	                body: formData
	            });

	            if (!response.ok) throw new Error("정보 수정에 실패했습니다.");
	            alert("모임 정보가 성공적으로 변경되었습니다.");
	        } catch (error) {
	            alert(error.message);
	        }
	    },
		
		async fetchHistory() {
	        try {
	            const response = await fetch(`/api/crew/manage/${this.crewIdx}/history`);
	            if (response.ok) {
	                this.historyList = await response.json();
	            }
	        } catch (error) {
	            console.error("이력 로드 실패", error);
	        }
	    },
		
	    formatStatus(status) {
	        const statusMap = {
	            'JOINED': '가입 완료',
	            'APPLIED': '가입 신청',
	            'REJECTED': '가입 거절',
	            'EXITED': '탈퇴 처리',
	            'BANNED': '강제 퇴장',
	            'CLOSED': '모임 폐쇄'
	        };
	        return statusMap[status] || status;
	    }
    }
};