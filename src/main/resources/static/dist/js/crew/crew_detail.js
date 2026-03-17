const CrewDetail = { 
    template: '#crew-detail-template',
    data() {
        return {
            articleId: null
        }
    },
    mounted() {
        this.articleId = this.$route.params.id;
        console.log("선택된 게시글 번호:", this.articleId);
    }
};