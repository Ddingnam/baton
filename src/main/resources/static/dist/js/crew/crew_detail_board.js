const CrewBoard = {
    template: '#crew-board-template',
    props: ['crew'],
    data() {
        return {
            viewMode: 'list',
            currentPost: null,
            newComment: '',
			quill: null,
            writeForm: {
                title: '',
                content: '',
                isNotice: 'N',
                status: 'ACTIVE'
            },
			posts: [], 
            currentPage: 1,
            totalPages: 0,
            totalElements: 0,
			pageSize: 5,
	        blockSize: 5
        }
    },
	computed: {
	    startPage() {
	        return Math.floor((this.currentPage - 1) / this.blockSize) * this.blockSize + 1;
	    },
	    endPage() {
	        let end = this.startPage + this.blockSize - 1;
	        return end > this.totalPages ? this.totalPages : end;
	    },
	    pageNumbers() {
	        const pages = [];
	        for (let i = this.startPage; i <= this.endPage; i++) {
	            pages.push(i);
	        }
	        return pages;
	    }
	},
	mounted() {
        this.fetchPosts(1);
    },
	watch: {
		viewMode(newMode) {
	        if (newMode === 'write') {
	            this.$nextTick(() => {
	                const el = this.$refs.quillEditor;
	                if (!el) {
	                    return;
	                }
	                
	                if (!this.quill) {
	                    this.initQuill();
	                }
	            });
	        } else {
	            this.quill = null;
	        }
	    }
    },
    methods: {
		initQuill() {
            const options = {
                theme: 'snow',
                placeholder: '내용을 입력하세요...',
				modules: {
		            toolbar: [
		                [{ 'header': [1, 2, 3, false] }],
		                [{ 'size': ['small', false, 'large', 'huge'] }],
		                
		                ['bold', 'italic', 'underline', 'strike'],
		                [{ 'color': [] }, { 'background': [] }],
		                
		                [{ 'align': [] }],
		                [{ 'list': 'ordered'}, { 'list': 'bullet' }],
		                
		                ['link', 'image'],
		                ['clean']
		            ]
		        }
            };
            
            this.quill = new Quill(this.$refs.quillEditor, options);

            this.quill.on('text-change', () => {
                this.writeForm.content = this.quill.root.innerHTML;
            });
        },
        goToDetail(post) {
            this.currentPost = post;
            this.viewMode = 'detail';
            window.scrollTo({ top: 0, behavior: 'smooth' });
        },
		async fetchPosts(page = 1) {
            if (!this.crew || !this.crew.crewIdx) return;

            try {
                const response = await fetch(`${contextPath}/api/crew/board/list/${this.crew.crewIdx}?page=${page}`);
                
                if (!response.ok) throw new Error('서버 응답 오류');

                const data = await response.json();

                this.posts = data.posts;
                this.totalPages = data.totalPages;
                this.totalElements = data.totalElements || this.posts.length;
                this.currentPage = data.currentPage;

            } catch (error) {
                console.error('목록 조회 에러:', error);
                alert('게시글 목록을 불러오는 중 오류가 발생했습니다.');
            }
        },

        changePage(page) {
            if (page < 1 || page > this.totalPages || page === this.currentPage) return;
            this.fetchPosts(page);
			window.scrollTo({ top: 0, behavior: 'smooth' });
        },
		async submitPost() {
		    if (this.quill) {
		        this.writeForm.content = this.quill.root.innerHTML;
		    }
		    const pureText = this.quill ? this.quill.getText().trim() : "";
		        
		    if(!this.writeForm.title.trim() || pureText.length === 0) {
		        alert('제목과 내용을 모두 입력해주세요.');
		        return;
		    }

		    const postData = {
		        crewIdx: this.crew.crewIdx,
		        title: this.writeForm.title,
		        content: this.writeForm.content,
		        isNotice: this.writeForm.isNotice,
		        status: this.writeForm.status
		    };

		    try {
		        const response = await fetch(`${contextPath}/api/crew/board/write`, {
		            method: 'POST',
		            headers: {
		                'Content-Type': 'application/json'
		            },
		            body: JSON.stringify(postData)
		        });

		        if (!response.ok) throw new Error('서버 응답 오류');

		        const result = await response.json();

		        if (result.status === 'success') {
		            alert('게시글이 성공적으로 등록되었습니다.');
		            
		            this.writeForm = { title: '', content: '', isNotice: 'N', status: 'ACTIVE' };
		            if (this.quill) this.quill.setContents([]);
		            
		            this.viewMode = 'list';
					this.fetchPosts(1); 
					window.scrollTo(0, 0);
		        } else {
		            alert('등록 실패: ' + result.message);
		        }
		    } catch (error) {
		        console.error('Error:', error);
		        alert('서버와 통신 중 오류가 발생했습니다.');
		    }
		},
        submitComment() {
            if (!this.newComment.trim()) return;
            alert('댓글이 등록되었습니다: ' + this.newComment);
            this.newComment = '';
        },
        onSearch(event) {
            const keyword = event.target.value.trim();
            if(keyword) {
                alert(`'${keyword}' 검색을 실행합니다.`);
            }
        }
    }
};