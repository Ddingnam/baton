const CrewHero = { 
    template: '#crew-hero-template',
    data() {
        return {
            searchKeyword: ''
        }
    },
    methods: {
        dispatchSearch() {
            const keyword = this.searchKeyword.trim();
            const searchEvent = new CustomEvent('crew-search', { 
                detail: { keyword: keyword } 
            });
            window.dispatchEvent(searchEvent);
        }
    }
};