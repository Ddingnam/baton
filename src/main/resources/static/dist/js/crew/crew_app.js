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
                    component: { template: '<div class="cd-glass-card" style="padding:20px;">게시판 준비 중입니다.</div>' }
                },
                {
                    path: 'schedule',
                    name: 'crew-schedule',
                    component: { template: '<div class="cd-glass-card" style="padding:20px;">일정 준비 중입니다.</div>' }
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
            isChatOpen: false
        }
    },
    mounted() {
        window.toggleCrewChat = () => {
            this.isChatOpen = !this.isChatOpen;
        };
        window.closeCrewChat = () => {
            this.isChatOpen = false;
        };
    }
});

app.component('crew-chat-component', CrewChatComponent);
app.use(router);
app.mount('#app');