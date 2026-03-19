const API_BASE_URL = "https://grpc-proxy-server-mkvo6j4wsq-du.a.run.app/v1/regcodes";

const CrewForm = {
    template: '#crew-form-template',
    data() {
        return {
            crewData: {
                name: '',
                description: '',
                categoryIdxs: [], 
                regionCodes: [],
                maxMember: 10,
                joinType: 'F',
                logoImageFile: null
            },
            
            isCategoryModalOpen: false,
            selectedCategories: [],
			tempSelectedCategories: [],
            previewUrl: null,       
            
            isRegionModalOpen: false,
            selectedRegions: [],
            
            sidoList: [],
            sigunguList: [],
            dongList: [],
            
            selectedSido: null,
            selectedSigungu: null,
            
            categories: [
                { idx: 1, name: '스터디', icon: 'ri-book-open-line' },
                { idx: 2, name: '운동', icon: 'ri-run-line' },
                { idx: 3, name: '독서', icon: 'ri-ball-pen-line' },
                { idx: 4, name: '맛집/카페', icon: 'ri-cup-line' }
            ]
        }
    },
    methods: {
        handleFileUpload(event) {
            const file = event.target.files[0];
            if (file) {
                this.crewData.logoImageFile = file;
                this.previewUrl = URL.createObjectURL(file);
            }
        },
        resetProfileImage() {
            this.crewData.logoImageFile = null;
            if (this.previewUrl) URL.revokeObjectURL(this.previewUrl);
            this.previewUrl = null;
            const fileInput = document.querySelector('.cf-file-input');
            if (fileInput) fileInput.value = '';
        },

		openCategoryModal() {
			this.tempSelectedCategories = [...this.selectedCategories];
			this.isCategoryModalOpen = true;
		},

		toggleTempCategory(category) {
			const index = this.tempSelectedCategories.findIndex(item => item.idx === category.idx);

			if (index > -1) {
				this.tempSelectedCategories.splice(index, 1);
			} else {
				if (this.tempSelectedCategories.length >= 3) {
					return alert("최대 3개까지 선택할 수 있습니다.");
				}
				this.tempSelectedCategories.push(category);
			}
		},

		confirmCategorySelection() {
			this.selectedCategories = [...this.tempSelectedCategories];
			this.crewData.categoryIdxs = this.selectedCategories.map(cat => cat.idx);
			this.isCategoryModalOpen = false;
		},

        selectCategory(category) {
            if (this.selectedCategories.some(item => item.idx === category.idx)) return alert("이미 추가된 카테고리입니다.");
            if (this.selectedCategories.length >= 3) return alert("최대 3개까지 선택할 수 있습니다.");
            this.selectedCategories.push(category);
            this.crewData.categoryIdxs.push(category.idx);
        },
		
        removeCategory(index) {
            this.selectedCategories.splice(index, 1);
            this.crewData.categoryIdxs.splice(index, 1);
        },
		
        openRegionModal() {
            if(this.selectedRegions.length >= 3) {
                return alert("지역은 최대 3곳까지만 추가할 수 있습니다.");
            }
            this.isRegionModalOpen = true;
            this.selectedSido = null;
            this.selectedSigungu = null;
            this.fetchSido();
        },
        
        closeRegionModal() {
            this.isRegionModalOpen = false;
        },

        async fetchSido() {
            if(this.sidoList.length > 0) return;
            
            try {
                const response = await fetch(API_BASE_URL + "?regcode_pattern=*00000000");
                const data = await response.json();
                
                const validData = data.regcodes.filter(item => item.name.split(" ").length === 1);
                
                this.sidoList = validData.map(item => ({
                    code: item.code,
                    name: item.name,
                    displayName: item.name.split(" ")[0]
                })).sort((a, b) => a.displayName.localeCompare(b.displayName));
                
            } catch (error) {
                console.error("시/도 로드 실패:", error);
            }
        },

        async fetchSigungu(sido) {
            this.selectedSido = sido;
            this.selectedSigungu = null;
            this.sigunguList = [];
            this.dongList = [];
            
            const pattern = sido.code.substring(0, 2) + "*00000";
            
            try {
                const response = await fetch(API_BASE_URL + "?regcode_pattern=" + pattern + "&is_ignore_zero=true");
                const data = await response.json();
                
                const filteredData = data.regcodes.filter(item => item.code !== sido.code);
                
                this.sigunguList = filteredData.map(item => ({
                    code: item.code,
                    name: item.name,
                    displayName: item.name.split(" ").slice(1).join(" ")
                })).sort((a, b) => a.displayName.localeCompare(b.displayName));
                
            } catch (error) {
                console.error("시/군/구 로드 실패:", error);
            }
        },

        async fetchDong(sgg) {
            this.selectedSigungu = sgg;
            this.dongList = [];
            
            const pattern = sgg.code.substring(0, 4) + "*&is_ignore_zero=true";
            
            try {
                const response = await fetch(API_BASE_URL + "?regcode_pattern=" + pattern);
                const data = await response.json();
                
                const filteredData = data.regcodes.filter(item => item.code !== sgg.code);
                
                this.dongList = filteredData.map(item => {
                    const parts = item.name.split(" ");
                    return {
                        code: item.code,
                        name: item.name,
                        displayName: parts[parts.length - 1]
                    };
                }).sort((a, b) => a.displayName.localeCompare(b.displayName));
                
            } catch (error) {
                console.error("읍/면/동 로드 실패:", error);
            }
        },

        selectDong(dong) {
            if (this.selectedRegions.some(item => item.code === dong.code)) {
                return alert("이미 추가된 지역입니다.");
            }

            const fullName = `${this.selectedSido.displayName} ${this.selectedSigungu.displayName} ${dong.displayName}`;
            
            this.selectedRegions.push({
                code: dong.code,
                fullName: fullName
            });
            this.crewData.regionCodes.push(dong.code);
            
            this.closeRegionModal();
        },

        removeRegion(index) {
            this.selectedRegions.splice(index, 1);
            this.crewData.regionCodes.splice(index, 1);
        },

		async submitForm() {
		    if (!this.crewData.name) return alert("모임 이름을 입력해주세요.");
		    if (this.selectedCategories.length === 0) return alert("카테고리를 선택해주세요.");
		    if (this.selectedRegions.length === 0) return alert("활동 지역을 선택해주세요.");

		    const formData = new FormData();
		    formData.append('name', this.crewData.name);
		    formData.append('description', this.crewData.description);
		    formData.append('maxMember', this.crewData.maxMember);
		    formData.append('joinType', this.crewData.joinType);
		    
			if (this.selectedCategories && this.selectedCategories.length > 0) {
			    this.selectedCategories.forEach(item => {
			        formData.append('categoryIdxs', item.idx);
			    });
			}

			if (this.selectedRegions && this.selectedRegions.length > 0) {
			    this.selectedRegions.forEach(item => {
			        formData.append('regionCodes', item.code);
			    });
			}

		    if (this.crewData.logoImageFile) {
		        formData.append('logoImageFile', this.crewData.logoImageFile);
		    }

		    try {
		        const response = await fetch('/crew/formSubmit', {
		            method: 'POST',
		            body: formData
		        });

		        if (!response.ok) {
		            throw new Error(`서버 에러: ${response.status}`);
		        }

		        const result = await response.json();

		        if (result.state === "success") {
		            alert("모임이 개설되었습니다!");
		            location.href = `/crew/main`; 
		        } else if (result.state === "login_required") {
		            location.href = "/member/login";
		        } else {
		            alert("모임 개설 중 오류가 발생했습니다.");
		        }

		    } catch (error) {
		        console.error("제출 오류:", error);
		        alert("서버와 통신 중 문제가 발생했습니다.");
		    }
		}
    }
};