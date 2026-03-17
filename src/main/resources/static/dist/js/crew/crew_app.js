const CrewList = { 
    template: '#crew-list-template',
    data() {
        return {
        }
    },
    methods: {
        toggleWish(id) {
            console.log(id + "번 게시글 찜하기!");
        }
    }
};

const CrewHero = { template: '#crew-hero-template' };

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
            path: '/article/:id', 
            components: {
                default: CrewDetail 
            }
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