(() => {
    const { createApp, ref, onMounted, watch } = Vue;
    const { createRouter, createWebHashHistory } = VueRouter;

    const categories = ref([]);

    const TradeList = {
        template: '#tpl-trade-list',
        setup() {
            const list = useTradeList({ categories });
            return {
                categories,
                ...list,
                ContextPath: window.ContextPath
            };
        }
    };

    const TradeArticle = {
        template: '#tpl-trade-article',
        setup() {
            const route  = VueRouter.useRoute();
            const router = VueRouter.useRouter();

            const shared = { router };
            const articleComposable = useTradeArticle(shared);

            onMounted(() => {
                articleComposable.loadArticle(route.params.productIdx);

                document.addEventListener('keydown', e => {
                    if (!articleComposable.lightboxOpen.value) return;
                    if (e.key === 'Escape')      articleComposable.lightboxOpen.value = false;
                    if (e.key === 'ArrowLeft')   articleComposable.lightboxPrev();
                    if (e.key === 'ArrowRight')  articleComposable.lightboxNext();
                });
            });

            watch(() => route.params.productIdx, id => {
                if (id) articleComposable.loadArticle(id);
            });

            return {
                ...articleComposable,
                formatTimeAgo: articleComposable.formatTimeAgo,
                ContextPath: window.ContextPath
            };
        }
    };

    const TradeWrite = {
        template: '#tpl-trade-write',
        setup() {
            const route  = VueRouter.useRoute();
            const router = VueRouter.useRouter();

            const viewMode = {
                value: 'WRITE',
                set value(v) { if (v === 'LIST') router.push('/'); }
            };

            const writeComposable = useTradeWrite({ categories, viewMode, router });

            onMounted(() => {
                const productIdx = route.params.productIdx || null;
                writeComposable.initWrite(productIdx);
                document.addEventListener('click', () => { writeComposable.catOpen.value = false; });
            });

            watch(() => route.params.productIdx, id => {
                writeComposable.initWrite(id || null);
            });

            return {
                ...writeComposable,
                categories,
                ContextPath: window.ContextPath
            };
        }
    };

    const router = createRouter({
        history: createWebHashHistory(),
        routes: [
            {
                path: '/',
                component: TradeList
            },
            {
                path: '/article/:productIdx',
                component: TradeArticle
            },
            {
                path: '/write',
                component: TradeWrite
            },
            {
                path: '/write/:productIdx',
                component: TradeWrite
            },
            {
                path: '/:pathMatch(.*)*',
                redirect: '/'
            }
        ],
        scrollBehavior(to, from, savedPosition) {
            if (savedPosition) return savedPosition;
            return { top: 0 };
        }
    });

    router.isReady().then(() => {
        const urlParams = new URLSearchParams(window.location.search);
        const pIdx = urlParams.get('productIdx');
        if (pIdx && router.currentRoute.value.path === '/') {
            router.replace('/article/' + pIdx);
        }
    });

    createApp({}).use(router).mount('#trade-app');

})();
