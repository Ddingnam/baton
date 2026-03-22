const CrewDetail = {
    template: '#crew-detail-template',
    data() {
        return {
            currentTab: 'dashboard', 
            
            crew: {
                crewIdx: 1,
                name: '주말 아침 한강 러닝',
                description: '주말 아침 상쾌한 공기를 마시며 함께 뛸 크루원을 모집합니다. 초보자 페이스에 맞춰 달리니 걱정 말고 나오세요!',
                tags: ['운동', '러닝', '오운완'],
                regionCode: '1168010100',
                currentMember: 3,
                maxMember: 10,
                logoImage: ''
            },
            
            schedules: [
                { id: 1, day: '23', month: 'MAR', title: '반포대교 달빛 러닝', time: '오후 8:00', location: '잠수교 남단' },
                { id: 2, day: '25', month: 'MAR', title: '여의도 모닝 하프', time: '오전 7:00', location: '여의도 한강공원' }
            ],

            recentPosts: [
                { id: 101, title: '이번 주 토요일 비 온다는데 일정 그대로 가나요?', author: '런린이', time: '2시간 전', likes: 3 },
                { id: 102, title: '가성비 러닝화 추천해 드립니다! (내돈내산)', author: '장비병환자', time: '어제', likes: 12 },
                { id: 103, title: '다들 평일에는 개인 운동 하시나요?', author: '열정맨', time: '2일 전', likes: 7 },
                { id: 104, title: '오늘 한강 노을 미쳤네요 ㅠㅠ (사진)', author: '풍경조아', time: '3일 전', likes: 25 }
            ]
        }
    },
    methods: {
        fetchDashboardData() {
            console.log("대시보드 데이터를 새로 불러옵니다.");
        }
    },
    watch: {
        currentTab(newTab) {
            if(newTab === 'dashboard') {
                this.fetchDashboardData();
            }
        }
    }
};
