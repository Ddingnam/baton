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
					meta: { requiresMember: true },
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
					meta: { requiresMember: true },
					props: true
                },
				{
                    path: 'admin',
                    name: 'crew-admin',
                    component: CrewAdmin,
					meta: { requiresMember: true },
					props: true
                }
            ]
        },
        { 
            path: '/write', 
            component: CrewForm
        }
    ]
});

router.beforeEach(async (to, from, next) => {
    const requiresMember = to.matched.some(record => record.meta.requiresMember);
    const requiresAdmin = to.matched.some(record => record.meta.requiresAdmin);
	
	if (!requiresMember && !requiresAdmin) {
        return next(); 
    }

    if (requiresMember || requiresAdmin) {
        const crewIdx = to.params.crewIdx;
        
        try {
            const response = await fetch(`/api/crew/article/${crewIdx}`);
            if (!response.ok) throw new Error();
            
            const data = await response.json();
            const myStatus = data.myStatus;
			
			const userRole = myStatus?.role; 
            const userStatus = myStatus?.status;

			const isActiveMember = myStatus && userStatus === 'ACTIVE';

            if (requiresAdmin && userRole !== 'LEADER') {
                alert("매니저(방장) 전용 메뉴입니다.");
                return next({ name: 'crew-dashboard', params: { crewIdx } });
            }

            if (requiresMember && !isActiveMember) {
                alert("모임 회원만 이용할 수 있는 메뉴입니다.");
                return next({ name: 'crew-dashboard', params: { crewIdx } });
            }
            
        } catch (error) {
            alert("권한 확인 중 오류가 발생했습니다.");
            return next('/');
        }
    }

    next();
});

const app = Vue.createApp({
    data() {
        return {
            isChatOpen: false,
			myCrewList: []
        }
    },
	watch: {
        isChatOpen(newVal) {
            if (newVal) {
                document.body.classList.add('chat-panel-open');
            } else {
                document.body.classList.remove('chat-panel-open');
            }
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

                if (!response.ok) throw new Error("모임 목록 조회 실패");

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