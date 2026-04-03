const CrewSchedule = {
    template: '#crew-schedule-template',
    props: {
        crew: Object,
        myStatus: String,
		currentUserIdx: Number
    },
    data() {
        return {
            currentDate: new Date(),
            selectedDate: new Date(),
            weekdays: ['일', '월', '화', '수', '목', '금', '토'],
            allSchedules: [],
            dailySchedules: [],
			
            isModalOpen: false,
            searchKeyword: '',
            scheduleForm: {
                title: '',
                content: '',
                startDate: '',
                endDate: '',
                locationName: '',
                lat: null,
                lng: null,
                maxPeople: 0
            },
            
            kMap: null,
            kMarker: null,
            kGeocoder: null,
            kPlaces: null,
			
			isDetailModalOpen: false,
            selectedSchedule: {},
			mdMap: null,
            mdMarker: null
        };
    },
    computed: {
        currentYear() { return this.currentDate.getFullYear(); },
        currentMonth() { return this.currentDate.getMonth() + 1; },
        
        formattedSelectedDate() {
            const month = this.selectedDate.getMonth() + 1;
            const date = this.selectedDate.getDate();
            const day = this.weekdays[this.selectedDate.getDay()];
            return `${month}월 ${date}일 (${day})`;
        },

		calendarDays() {
		    const year = this.currentDate.getFullYear();
		    const month = this.currentDate.getMonth();
		    const firstDay = new Date(year, month, 1);
		    const lastDay = new Date(year, month + 1, 0);
		    
		    const days = [];
		    
		    for (let i = 0; i < firstDay.getDay(); i++) {
		        const prevDate = new Date(year, month, -firstDay.getDay() + i + 1);
		        days.push(this.createDayObject(prevDate, false));
		    }
		    
		    for (let i = 1; i <= lastDay.getDate(); i++) {
		        const currDate = new Date(year, month, i);
		        days.push(this.createDayObject(currDate, true));
		    }
		    
		    const currentCount = days.length;
		    const remainingDays = currentCount % 7 === 0 ? 0 : 7 - (currentCount % 7);
		    
		    for (let i = 1; i <= remainingDays; i++) {
		        const nextDate = new Date(year, month + 1, i);
		        days.push(this.createDayObject(nextDate, false));
		    }
		    
		    return days;
		}
    },
    mounted() {
        this.fetchMonthlySchedules();
    },
    methods: {
        createDayObject(dateObj, isCurrentMonth) {
            const yyyy = dateObj.getFullYear();
            const mm = String(dateObj.getMonth() + 1).padStart(2, '0');
            const dd = String(dateObj.getDate()).padStart(2, '0');
            const fullDate = `${yyyy}-${mm}-${dd}`;
            
            const today = new Date();
            const isToday = (dateObj.getDate() === today.getDate() && 
                             dateObj.getMonth() === today.getMonth() && 
                             dateObj.getFullYear() === today.getFullYear());

            const hasSchedule = this.allSchedules.some(sch => sch.startDate.startsWith(fullDate));

            return {
                day: dateObj.getDate(),
                fullDate: fullDate,
                dateObj: dateObj,
                isCurrentMonth: isCurrentMonth,
                isToday: isToday,
                hasSchedule: hasSchedule
            };
        },
        
        prevMonth() {
            this.currentDate = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth() - 1, 1);
            this.fetchMonthlySchedules();
        },
        
        nextMonth() {
            this.currentDate = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth() + 1, 1);
            this.fetchMonthlySchedules();
        },
        
		selectDate(fullDateStr) {
            this.selectedDate = new Date(fullDateStr);
            this.fetchDailySchedules(fullDateStr); 
        },
        
        isSelectedDate(fullDateStr) {
            const selY = this.selectedDate.getFullYear();
            const selM = String(this.selectedDate.getMonth() + 1).padStart(2, '0');
            const selD = String(this.selectedDate.getDate()).padStart(2, '0');
            return fullDateStr === `${selY}-${selM}-${selD}`;
        },

		async fetchMonthlySchedules() {
            const year = this.currentDate.getFullYear();
            const month = this.currentDate.getMonth() + 1;

            try {
                const response = await fetch(`/api/crew/schedule/${this.crew.crewIdx}/monthly?year=${year}&month=${month}`);
                if (!response.ok) throw new Error("월별 일정을 불러오는데 실패했습니다.");
                
                this.allSchedules = await response.json();
                
                const selY = this.selectedDate.getFullYear();
                const selM = String(this.selectedDate.getMonth() + 1).padStart(2, '0');
                const selD = String(this.selectedDate.getDate()).padStart(2, '0');
                
                this.fetchDailySchedules(`${selY}-${selM}-${selD}`);
            } catch (error) {
                console.error(error);
            }
        },
		
		async fetchDailySchedules(dateStr) {
            try {
                const response = await fetch(`/api/crew/schedule/${this.crew.crewIdx}/daily?date=${dateStr}`);
                if (!response.ok) throw new Error("일간 일정을 불러오는데 실패했습니다.");
                
                this.dailySchedules = await response.json();
            } catch (error) {
                console.error(error);
            }
        },

        filterDailySchedules(dateStr) {
            this.dailySchedules = this.allSchedules.filter(sch => sch.startDate.startsWith(dateStr));
            this.dailySchedules.sort((a, b) => new Date(a.startDate) - new Date(b.startDate));
        },

        formatTime(dateTimeStr) {
            if(!dateTimeStr) return "";
            const dateObj = new Date(dateTimeStr);
            const hours = String(dateObj.getHours()).padStart(2, '0');
            const mins = String(dateObj.getMinutes()).padStart(2, '0');
            return `${hours}:${mins}`;
        },

        openAddModal() {
            alert("일정 추가 모달을 띄웁니다!");
        },

        goToDetail(scheduleIdx) {
            alert(`${scheduleIdx}번 일정 상세 페이지로 이동합니다.`);
        },
		
		openAddModal() {
            this.isModalOpen = true;
            this.scheduleForm = { title: '', content: '', startDate: '', endDate: '', locationName: '', lat: null, lng: null, maxPeople: 0 };
            
            if (this.selectedDate) {
                const selY = this.selectedDate.getFullYear();
                const selM = String(this.selectedDate.getMonth() + 1).padStart(2, '0');
                const selD = String(this.selectedDate.getDate()).padStart(2, '0');
                this.scheduleForm.startDate = `${selY}-${selM}-${selD}T19:00`;
            }

            this.$nextTick(() => {
                this.initKakaoMap();
            });
        },

        closeModal() {
            this.isModalOpen = false;
        },

        initKakaoMap() {
            if (!window.kakao || !window.kakao.maps) {
                console.error("카카오맵 API가 로드되지 않았습니다.");
                return;
            }

            const mapContainer = document.getElementById('cs-kakao-map');
            const defaultLoc = new kakao.maps.LatLng(37.566826, 126.978656);

            const mapOption = { center: defaultLoc, level: 3 };
            this.kMap = new kakao.maps.Map(mapContainer, mapOption);
            
            this.kMarker = new kakao.maps.Marker({ position: defaultLoc, map: this.kMap });
            this.kGeocoder = new kakao.maps.services.Geocoder();
            this.kPlaces = new kakao.maps.services.Places();

            kakao.maps.event.addListener(this.kMap, 'click', (mouseEvent) => {
                const latlng = mouseEvent.latLng;
                this.updateLocation(latlng.getLat(), latlng.getLng());
                
                this.kGeocoder.coord2Address(latlng.getLng(), latlng.getLat(), (result, status) => {
                    if (status === kakao.maps.services.Status.OK) {
                        const addr = result[0].road_address ? result[0].road_address.address_name : result[0].address.address_name;
                        this.scheduleForm.locationName = addr;
                    }
                });
            });
        },

        searchLocation() {
            if (!this.searchKeyword.replace(/^\s+|\s+$/g, '')) {
                alert('검색어를 입력해주세요!');
                return;
            }
			
            this.kPlaces.keywordSearch(this.searchKeyword, (data, status) => {
                if (status === kakao.maps.services.Status.OK) {
                    const firstPlace = data[0];
                    const lat = firstPlace.y;
                    const lng = firstPlace.x;
                    
                    this.updateLocation(lat, lng);
                    
                    const moveLatLon = new kakao.maps.LatLng(lat, lng);
                    this.kMap.setCenter(moveLatLon);
                    
                    this.scheduleForm.locationName = firstPlace.place_name; 
                } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
                    alert('검색 결과가 존재하지 않습니다.');
                }
            });
        },

        updateLocation(lat, lng) {
            const locPosition = new kakao.maps.LatLng(lat, lng);
            this.kMarker.setPosition(locPosition);
            this.scheduleForm.lat = lat;
            this.scheduleForm.lng = lng;
        },

		submitSchedule() {
		    if (!this.scheduleForm.title) return alert("일정 제목을 입력해주세요.");
		    if (!this.scheduleForm.startDate) return alert("시작 일시를 입력해주세요.");
		    if (!this.scheduleForm.endDate) return alert("종료 일시를 입력해주세요.");
			
			const isEditMode = !!this.scheduleForm.scheduleIdx; 
		    const apiUrl = isEditMode 
		        ? `/api/crew/schedule/${this.scheduleForm.scheduleIdx}/update`
		        : `/api/crew/schedule/${this.crew.crewIdx}`;
		    
			fetch(apiUrl, {
			        method: 'POST',
			        headers: { 'Content-Type': 'application/json' },
			        body: JSON.stringify(this.scheduleForm)
			    })
		    .then(response => {
		        if (!response.ok) {
		            throw new Error(`일정 처리에 실패했습니다.`);
		        }
		        return response.text(); 
		    })
		    .then(data => {
		        alert(isEditMode ? "일정이 성공적으로 수정되었습니다!" : "일정이 성공적으로 등록되었습니다!");
		        this.closeModal();
		        this.fetchMonthlySchedules();
		    })
		    .catch(error => {
		        console.error("일정 등록 오류:", error);
		        alert(error.message || "일정 등록 중 네트워크 오류가 발생했습니다.");
		    });
		},
		
		async openDetailModal(scheduleIdx) {
            try {
                const response = await fetch(`/api/crew/schedule/detail/${scheduleIdx}`);
                if (!response.ok) throw new Error("일정 상세 정보를 불러오지 못했습니다.");
				
				const data = await response.json();
                
				if (!data.attendees) {
		            data.attendees = [];
		        }
		        
		        this.selectedSchedule = data;
		        this.isDetailModalOpen = true;
				
                if (this.selectedSchedule.lat && this.selectedSchedule.lng) {
                    this.$nextTick(() => {
                        this.initDetailMap();
                    });
                }
            } catch (error) {
                console.error(error);
                alert(error.message);
            }
        },

        closeDetailModal() {
            this.isDetailModalOpen = false;
            this.selectedSchedule = {};
        },

        initDetailMap() {
            const mapContainer = document.getElementById('cs-md-map');
            if (!mapContainer || !window.kakao) return;

            const locPosition = new kakao.maps.LatLng(this.selectedSchedule.lat, this.selectedSchedule.lng);
            
            const mapOption = { 
                center: locPosition, 
                level: 3,
                draggable: false,
                scrollwheel: false
            };
            
            this.mdMap = new kakao.maps.Map(mapContainer, mapOption);
            this.mdMarker = new kakao.maps.Marker({ position: locPosition });
            this.mdMarker.setMap(this.mdMap);

            setTimeout(() => {
                this.mdMap.relayout();
                this.mdMap.setCenter(locPosition);
            }, 100); 
        },

        formatDateTime(dateStr) {
            if (!dateStr) return '';
            const d = new Date(dateStr);
            const month = d.getMonth() + 1;
            const date = d.getDate();
            const hours = String(d.getHours()).padStart(2, '0');
            const mins = String(d.getMinutes()).padStart(2, '0');
            return `${month}월 ${date}일 ${hours}:${mins}`;
        },
		
		async deleteSchedule(scheduleIdx) {
		    if (!confirm("정말로 이 일정을 삭제하시겠습니까?")) return;

		    try {
		        const response = await fetch(`/api/crew/schedule/${scheduleIdx}/delete`, {
		            method: 'POST'
		        });

		        if (!response.ok) throw new Error("일정 삭제에 실패했습니다.");

		        alert("일정이 삭제되었습니다.");
		        this.closeDetailModal();
		        this.fetchMonthlySchedules();
		    } catch (error) {
		        console.error(error);
		        alert(error.message);
		    }
		},
		
		editSchedule(scheduleIdx) {
		    this.isDetailModalOpen = false;
		    
		    const formatForInput = (dateStr) => {
		        if (!dateStr) return '';
		        return dateStr.length >= 16 ? dateStr.substring(0, 16) : dateStr;
		    };

		    this.scheduleForm = { 
		        scheduleIdx: this.selectedSchedule.scheduleIdx, 
		        title: this.selectedSchedule.title || '',
		        content: this.selectedSchedule.content || '',
		        startDate: formatForInput(this.selectedSchedule.startDate),
		        endDate: formatForInput(this.selectedSchedule.endDate),
		        locationName: this.selectedSchedule.locationName || '',
		        lat: this.selectedSchedule.lat || null,
		        lng: this.selectedSchedule.lng || null,
		        maxPeople: this.selectedSchedule.maxPeople || 0
		    }; 
		    
		    this.isModalOpen = true; 
		    
		    this.$nextTick(() => {
		        this.initKakaoMap();
		        
		        if (this.scheduleForm.lat && this.scheduleForm.lng) {
		            const moveLatLon = new kakao.maps.LatLng(this.scheduleForm.lat, this.scheduleForm.lng);
		            this.kMap.setCenter(moveLatLon);
		            this.kMarker.setPosition(moveLatLon);
		        }
		    });
		},
		
		async toggleVote(scheduleIdx) {
		    try {
				const response = await fetch(`/api/crew/schedule/${scheduleIdx}/vote?status=ATTEND`, {
		            method: 'POST',
		            headers: {
		                'Content-Type': 'application/x-www-form-urlencoded' 
		            }
		        });

		        if (!response.ok) {
		            const errorMessage = await response.text();
		            throw new Error(errorMessage || "참석 처리에 실패했습니다.");
		        }

		        await this.openDetailModal(scheduleIdx); 
		        
		        this.fetchMonthlySchedules(); 

		    } catch (error) {
		        console.error("투표 처리 오류:", error);
		        alert(error.message);
		    }
		}
    }
};