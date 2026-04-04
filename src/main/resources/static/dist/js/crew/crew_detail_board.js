const CrewBoard = {
    template: '#crew-board-template',
    props: ['crew', 'myStatus'],
    data() {
		const targetIdx = this.$route.query.targetBoardIdx;
		
        return {
            viewMode: targetIdx ? 'detail' : 'list',
			isBoardListLoading: false,
            currentPost: null,
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
	        blockSize: 5,
			
			comments: [],
            commentTotalCount: 0,
            newComment: '',
            activeReplyId: null,
            replyContent: '',
            editingCommentId: null,
            editCommentContent: ''
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
	watch: {
		viewMode(newMode) {
	        if (newMode === 'write' || newMode === 'edit') {
				setTimeout(() => {
		            this.$nextTick(() => {
		                const el = this.$refs.quillEditor;
		                if (!el) return;
		                
		                if (!this.quill) this.initQuill();
						
						if (newMode === 'edit') {
		                    this.quill.root.innerHTML = this.writeForm.content;
		                } else if (newMode === 'write') {
		                    this.quill.root.innerHTML = '';
		                }
		            });
				}, 150);
	        } else {
	            this.quill = null;
	        }
	    },
		
		'$route': {
	        immediate: true,
	        handler(to) {
	            const boardIdx = to.params.boardIdx;
	            const path = to.path;
				
				const isRestrictedAction = path.includes('/edit/') || path.endsWith('/write') || boardIdx;

                if (isRestrictedAction) {
                    if (!this.myStatus || this.myStatus.status !== 'ACTIVE') {
                        alert('모임의 정식 멤버만 이용할 수 있는 기능입니다.');
                        this.$router.push(`/article/${this.crew.crewIdx}`);
                    }
                }

	            if (path.includes('/edit/')) {
	                this.viewMode = 'edit';
	                if (!this.currentPost || this.currentPost.crewBoardIdx != boardIdx) {
	                    this.fetchDetail(boardIdx).then(() => this.prepareEditForm());
	                } else {
	                    this.prepareEditForm();
	                }
	            } else if (boardIdx) {
	                this.viewMode = 'detail';
	                this.fetchDetail(boardIdx);
	            } else if (path.endsWith('/write')) {
	                this.viewMode = 'write';
	                this.writeForm = { title: '', content: '', isNotice: 'N', status: 'ACTIVE' };
	                if (this.quill) this.quill.setContents([]);
	            } else {
	                this.viewMode = 'list';
	                this.fetchPosts(this.currentPage);
	            }
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
		prepareEditForm() {
	        if (!this.currentPost) return;
	        this.writeForm = {
	            crewBoardIdx: this.currentPost.crewBoardIdx,
	            title: this.currentPost.title,
	            content: this.currentPost.content,
	            isNotice: this.currentPost.isNotice,
	            status: this.currentPost.status
	        };
	    },
		async goToDetail(post) {
			this.$router.push({ 
		        name: 'crew-board-detail', 
		        params: { 
		            crewIdx: this.crew.crewIdx, 
		            boardIdx: post.crewBoardIdx 
		        } 
		    }).catch(() => {});
		},
		async fetchDetail(boardIdx) {
		    this.isBoardListLoading = true;
		    try {
		        const response = await fetch(`${contextPath}/api/crew/board/detail/${boardIdx}`);
		        if (!response.ok) throw new Error('상세보기 서버 응답 오류');
		        
		        const updatedPost = await response.json();

		        this.currentPost = updatedPost;

		        await this.fetchComments(boardIdx);

		        const index = this.posts.findIndex(p => p.crewBoardIdx === updatedPost.crewBoardIdx);
		        if (index !== -1) this.posts.splice(index, 1, updatedPost);

		        window.scrollTo({ top: 0, behavior: 'smooth' });

		    } catch (error) {
		        console.error('fetchDetail 에러:', error);
		        alert('게시글 정보를 가져오지 못했습니다.');
		        this.backToList(); 
		    } finally {
		        this.isBoardListLoading = false;
		    }
		},
		goToWrite() {
		    this.currentPost = null; 
		    this.$router.push({ 
		        name: 'crew-board-write', 
		        params: { crewIdx: this.crew.crewIdx } 
		    }).catch(() => {});
		},
		goToEdit() {
			this.$router.push({ 
		        name: 'crew-board-edit', 
		        params: { 
		            crewIdx: this.crew.crewIdx, 
		            boardIdx: this.currentPost.crewBoardIdx 
		        } 
		    }).catch(() => {});
	    },
		async deletePost() {
		    if (!confirm('정말로 이 게시글을 삭제하시겠습니까?'))  return;

		    try {
				const deleteData = { crewBoardIdx: this.currentPost.crewBoardIdx };

				const response = await fetch(`${contextPath}/api/crew/board/delete`, {
				    method: 'POST',
				    headers: { 'Content-Type': 'application/json' },
				    body: JSON.stringify(deleteData)
				});

		        if (!response.ok) throw new Error('서버 응답 오류');
		        const result = await response.json();

		        if (result.status === 'success') {
		            alert('게시글이 성공적으로 삭제되었습니다.');
		            this.backToList();
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
		        this.goToDetail(this.currentPost);
		    } else {
		        this.backToList();
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
		    this.currentPost = null;
		    this.$router.push({ name: 'crew-board-list', params: { crewIdx: this.crew.crewIdx } }).catch(() => {});
		},

        changePage(page) {
            if (page < 1 || page > this.totalPages || page === this.currentPage) return;
            this.fetchPosts(page);
			window.scrollTo({ top: 0, behavior: 'smooth' });
        },
		
		async submitPost() {
		    if (this.quill) this.writeForm.content = this.quill.root.innerHTML;
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
					    this.backToList();
					}
		        } else {
		            alert((isEdit ? '수정' : '등록') + ' 실패: ' + result.message);
		        }
		    } catch (error) {
		        console.error('Error:', error);
		        alert('서버와 통신 중 오류가 발생했습니다.');
		    }
		},
		
        onSearch(event) {
            const keyword = event.target.value.trim();
            if(keyword) {
                alert(`'${keyword}' 검색을 실행합니다.`);
            }
        },
		
		async fetchComments(boardIdx, page = 1) {
            try {
                const response = await fetch(`${contextPath}/api/crew/comment/list/${boardIdx}?page=${page}&size=50`);
                if (!response.ok) throw new Error('댓글을 불러오지 못했습니다.');
                
                const data = await response.json();
                if (data.status === 'success') {
                    this.comments = data.comments;
                    this.commentTotalCount = data.totalCount;
                }
            } catch (error) {
                console.error('fetchComments Error:', error);
            }
        },
		
		async submitComment() {
            if (!this.newComment.trim()) return;
            try {
                const response = await fetch(`${contextPath}/api/crew/comment/write`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        crewBoardIdx: this.currentPost.crewBoardIdx,
                        content: this.newComment
                    })
                });
                const result = await response.json();
                if (result.status === 'success') {
                    this.newComment = '';
                    this.fetchComments(this.currentPost.crewBoardIdx);
                } else {
                    alert('댓글 등록 실패: ' + result.message);
                }
            } catch (error) {
                console.error('submitComment Error:', error);
                alert('통신 오류가 발생했습니다.');
            }
        },
		
		toggleReplyForm(commentId) {
            this.activeReplyId = this.activeReplyId === commentId ? null : commentId;
            this.replyContent = '';
        },
		
		async submitReply(parentId) {
            if (!this.replyContent.trim()) return;
            try {
                const response = await fetch(`${contextPath}/api/crew/comment/write`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        crewBoardIdx: this.currentPost.crewBoardIdx,
                        content: this.replyContent,
                        parentId: parentId
                    })
                });
                const result = await response.json();
                if (result.status === 'success') {
                    this.activeReplyId = null;
                    this.replyContent = '';
                    this.fetchComments(this.currentPost.crewBoardIdx);
                } else {
                    alert('답글 등록 실패: ' + result.message);
                }
            } catch (error) {
                console.error('submitReply Error:', error);
            }
        },
		
		async deleteComment(commentId) {
            if (!confirm('이 댓글을 삭제하시겠습니까?')) return;
            try {
                const response = await fetch(`${contextPath}/api/crew/comment/delete`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ commentId: commentId })
                });
                const result = await response.json();
                if (result.status === 'success') {
                    this.fetchComments(this.currentPost.crewBoardIdx);
                } else {
                    alert('삭제 실패: ' + result.message);
                }
            } catch (error) {
                console.error('deleteComment Error:', error);
            }
        },
		
		editComment(comment) {
            this.editingCommentId = comment.commentId;
            this.editCommentContent = comment.content;
        },
		cancelEditComment() {
            this.editingCommentId = null;
            this.editCommentContent = '';
        },
		
		async submitEditComment(commentId) {
            if (!this.editCommentContent.trim()) return;
            try {
                const response = await fetch(`${contextPath}/api/crew/comment/update`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        commentId: commentId,
                        content: this.editCommentContent
                    })
                });
                const result = await response.json();
                if (result.status === 'success') {
                    this.editingCommentId = null;
                    this.fetchComments(this.currentPost.crewBoardIdx);
                } else {
                    alert('수정 실패: ' + result.message);
                }
            } catch (error) {
                console.error('submitEditComment Error:', error);
            }
        },
		async toggleLike(boardIdx) {
	        try {
	            const response = await fetch(`${contextPath}/api/crew/like/toggle/${boardIdx}`, {
	                method: 'POST',
	                headers: { 'Content-Type': 'application/json' }
	            });
	
	            if (response.status === 401) {
	                alert('로그인이 필요한 기능입니다.');
	                return;
	            }
	
	            if (!response.ok) throw new Error('서버 응답 오류');
	            const result = await response.json();
	
	            if (this.currentPost && this.currentPost.crewBoardIdx === boardIdx) {
	                if (result.status === 'added') {
	                    this.currentPost.liked = true;
	                } else if (result.status === 'removed') {
	                    this.currentPost.liked = false;
	                }
	                this.currentPost.likeCount = result.totalLikes;
	            }
	
	            const listPostIndex = this.posts.findIndex(p => p.crewBoardIdx === boardIdx);
	            if (listPostIndex !== -1) {
	                this.posts[listPostIndex].liked = this.currentPost.liked;
	                this.posts[listPostIndex].likeCount = this.currentPost.likeCount;
	            }
	
	        } catch (error) {
	            console.error('toggleLike Error:', error);
	            alert('좋아요 처리 중 통신 오류가 발생했습니다.');
	        }
	    }
    }
};