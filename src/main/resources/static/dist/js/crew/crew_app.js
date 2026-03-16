// 1. 임시 더미 컴포넌트 (나중에 별도 파일로 분리)
const CrewList = { 
    template: `
        <div>
            <h2>모임 탐색</h2>
            <p>이곳에 모임 카드들이 중앙 정렬되어 배치됩니다.</p>
            <div style="height: 1500px; background: repeating-linear-gradient(#eee, #eee 49px, #ccc 50px);">
                (스크롤 테스트용 가짜 데이터)
            </div>
        </div>
    ` 
}; 

const CrewDetail = { template: `<div><h2>모임 상세 내용</h2></div>` };
const CrewChat = { template: `<div style="padding:20px;"><h3>채팅방</h3><p>채팅 내용이 여기에 뜹니다.</p></div>` };

// 2. Vue Router 설정
const router = VueRouter.createRouter({
    history: VueRouter.createWebHashHistory(),
    routes: [
        { path: '/', component: CrewList },
        { path: '/article/:id', component: CrewDetail }
    ]
});

// 3. Vue 앱 초기화
const app = Vue.createApp({
    data() {
        return {
            // 채팅창 기본 상태 (true: 열림, false: 닫힘)
            isChatOpen: false 
        }
    }
});

// 컴포넌트 등록 및 라우터 연결
app.component('crew-chat-component', CrewChat);
app.use(router);
app.mount('#app');