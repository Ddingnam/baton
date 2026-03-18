// crewList.js
const CrewList = { 
    template: '#crew-list-template',
    data() {
        return {
            // 필터링이나 데이터 로딩 상태 등을 여기서 관리하게 됩니다.
        }
    },
    methods: {
        // 찜하기 기능
        toggleWish(id) {
            console.log(id + "번 게시글 찜하기!");
        },
        
        // ⭐ 캐러셀 스크롤 로직 (추가됨)
        scrollTags(direction) {
            // JSP에 설정한 ref="tagCarousel"을 통해 DOM에 접근
            const container = this.$refs.tagCarousel;
            if (!container) return;

            // 한 번 클릭 시 이동할 거리 (버튼 3~4개 정도 분량)
            const scrollAmount = 400; 

            if (direction === 'left') {
                container.scrollBy({ left: -scrollAmount, behavior: 'smooth' });
            } else {
                container.scrollBy({ left: scrollAmount, behavior: 'smooth' });
            }
        },

        // 가이드 열기 기능 (JSP에 @click="openGuide"가 있다면 추가)
        openGuide() {
            console.log("이용 가이드 팝업 오픈!");
            // 팝업 레이어 로직 작성
        }
    }
};