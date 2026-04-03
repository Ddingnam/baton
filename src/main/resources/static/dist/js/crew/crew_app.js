const router = VueRouter.createRouter({
    history: VueRouter.createWebHashHistory(),
    routes: [
        { 
            path: '/', 
            components: {
                default: CrewList,
                hero: CrewHero
            }
        },
        { 
            path: '/article/:crewIdx', 
            component: CrewDetail,
            children: [
				{
                    path: '', 
                    redirect: to => `/article/${to.params.crewIdx}/dashboard`
                },
                {
                    path: 'dashboard',
                    name: 'crew-dashboard',
                    component: CrewDashboard,
                    props: true 
                },
                {
                    path: 'board',
                    name: 'crew-board',
                    component: CrewBoard,
					props: true,
					children: [
				        {
				            path: '',
				            name: 'crew-board-list',
				            component: CrewBoard
				        },
				        {
				            path: 'write',
				            name: 'crew-board-write',
				            component: CrewBoard
				        },
						{
					        path: 'edit/:boardIdx',
					        name: 'crew-board-edit',
					        component: CrewBoard,
					        props: true
					    },
				        {
				            path: ':boardIdx',
				            name: 'crew-board-detail',
				            component: CrewBoard,
				            props: true
				        }
				    ]
                },
                {
                    path: 'schedule',
                    name: 'crew-schedule',
                    component: CrewSchedule,
					props: true
                },
                {
                    path: 'chat',
                    name: 'crew-chat-tab',
                    component: { template: '<div class="cd-glass-card" style="padding:20px;">채팅 준비 중입니다.</div>' }
                }
            ]
        },
        { 
            path: '/write', 
            component: CrewForm
        }
    ]
});

const app = Vue.createApp({
    data() {
        return {
            isChatOpen: false,
			myCrewList: []
        }
    },
    async mounted() {
        window.toggleCrewChat = () => {
            this.isChatOpen = !this.isChatOpen;
        };
        window.closeCrewChat = () => {
            this.isChatOpen = false;
        };
		
		await this.fetchMyCrews();
    },
	methods: {
        async fetchMyCrews() {
            try {
                const response = await fetch('/api/crew/myCrew');
                
                if (response.status === 401) {
                    this.myCrewList = [];
                    return;
                }

                if (!response.ok) throw new Error("크루 목록 조회 실패");

                const data = await response.json();
                this.myCrewList = data.myCrewListJoined;

            } catch (error) {
                console.error("❌ fetchMyCrews Error:", error);
            }
        }
    }
});

app.component('crew-chat-component', CrewChatComponent);
app.use(router);
app.mount('#app');