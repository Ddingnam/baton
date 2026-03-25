const CrewBoard = {
    template: '#crew-board-template',
    props: ['crew'],
    data() {
        return {
            viewMode: 'list',
			isBoardListLoading: false,
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
	        if (newMode === 'write' || newMode === 'edit') {
	            this.$nextTick(() => {
	                const el = this.$refs.quillEditor;
	                if (!el) {
	                    return;
	                }
	                
	                if (!this.quill) {
	                    this.initQuill();
	                }
					
					if (newMode === 'edit') {
	                    this.quill.root.innerHTML = this.writeForm.content;
	                } else if (newMode === 'write') {
	                    this.quill.root.innerHTML = '';
	                    this.writeForm = { title: '', content: '', isNotice: 'N', status: 'ACTIVE' };
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
		async goToDetail(post) {
		    try {
		        const response = await fetch(`${contextPath}/api/crew/board/detail/${post.crewBoardIdx}`);
		        
		        if (!response.ok) throw new Error('상세보기 서버 응답 오류');

		        const updatedPost = await response.json();

		        this.currentPost = updatedPost;

		        const index = this.posts.findIndex(p => p.crewBoardIdx === updatedPost.crewBoardIdx);
		        if (index !== -1) {
		            this.posts.splice(index, 1, updatedPost);
		        }

		        this.viewMode = 'detail';
		        window.scrollTo({ top: 0, behavior: 'smooth' });

		    } catch (error) {
		        console.error('상세 조회 중 에러 발생:', error);
		        alert('게시글 정보를 가져오지 못했습니다.');
		    }
		},
		goToEdit() {
	        this.writeForm = {
	            crewBoardIdx: this.currentPost.crewBoardIdx,
	            title: this.currentPost.title,
	            content: this.currentPost.content,
	            isNotice: this.currentPost.isNotice,
	            status: this.currentPost.status
	        };
	        this.viewMode = 'edit';
	    },
		async deletePost() {
		    if (!confirm('정말로 이 게시글을 삭제하시겠습니까?')) {
		        return;
		    }

		    try {
				const deleteData = {
				    crewBoardIdx: this.currentPost.crewBoardIdx,
				    userIdx: this.currentPost.userIdx
				};

				const response = await fetch(`${contextPath}/api/crew/board/delete`, {
				    method: 'POST',
				    headers: { 'Content-Type': 'application/json' },
				    body: JSON.stringify(deleteData)
				});

		        if (!response.ok) throw new Error('서버 응답 오류');

		        const result = await response.json();

		        if (result.status === 'success') {
		            alert('게시글이 성공적으로 삭제되었습니다.');
		            
		            this.viewMode = 'list';
		            this.currentPost = null;
		            this.fetchPosts(this.currentPage); 
		            window.scrollTo({ top: 0, behavior: 'smooth' });
		        } else {
		            alert('삭제 실패: ' + (result.message || '권한이 없거나 오류가 발생했습니다.'));
		        }

		    } catch (error) {
		        console.error('삭제 중 에러 발생:', error);
		        alert('서버와 통신 중 오류가 발생했습니다.');
		    }
		},
	    cancelWrite() {
	        if (this.viewMode === 'edit') {
	            this.viewMode = 'detail';
	        } else {
	            this.writeForm = { title: '', content: '', isNotice: 'N', status: 'ACTIVE' }; // 폼 초기화
	            this.viewMode = 'list';
	        }
	    },
		async fetchPosts(page = 1) {
            if (!this.crew || !this.crew.crewIdx) return;
			
			const startTime = Date.now();
		    this.isBoardListLoading = true;

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
            } finally {
		        const elapsedTime = Date.now() - startTime;
		        const delay = Math.max(0, 300 - elapsedTime);
		        
		        setTimeout(() => {
		            this.isBoardListLoading = false;
		        }, delay);
		    }
        },
		
		backToList() {
		    this.viewMode = 'list';
		    this.fetchPosts(this.currentPage); 
		    this.currentPost = null;
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
			
			const isEdit = this.viewMode === 'edit';

			const postData = {
		        crewIdx: this.crew.crewIdx,
		        crewBoardIdx: isEdit ? this.writeForm.crewBoardIdx : null,
		        title: this.writeForm.title,
		        content: this.writeForm.content,
		        isNotice: this.writeForm.isNotice,
		        status: this.writeForm.status
		    };
			
			const url = isEdit ? `${contextPath}/api/crew/board/update` : `${contextPath}/api/crew/board/write`;

		    try {
				const response = await fetch(url, {
			        method: 'POST',
			        headers: { 'Content-Type': 'application/json' },
			        body: JSON.stringify(postData)
			    });

		        if (!response.ok) throw new Error('서버 응답 오류');

		        const result = await response.json();

		        if (result.status === 'success') {
		            alert(isEdit ? '게시글이 수정되었습니다.' : '게시글이 등록되었습니다.');
		            
		            this.writeForm = { title: '', content: '', isNotice: 'N', status: 'ACTIVE' };
		            if (this.quill) this.quill.setContents([]);
		            
					if (isEdit) {
		                this.goToDetail(this.currentPost); 
		            } else {
		                this.viewMode = 'list';
		                this.fetchPosts(1); 
		                window.scrollTo(0, 0);
		            }
		        } else {
		            alert((isEdit ? '수정' : '등록') + ' 실패: ' + result.message);
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