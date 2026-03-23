<%@ page contentType="text/html; charset=UTF-8"%>
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/crew/crew_detail_board.css">

<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>

<template id="crew-board-template">
	<div class="cdb-board-wrapper">
	    <div class="cdb-header-card cd-glass-card">
	        <header class="cdb-main-header">
	            <div class="cdb-header-left">
	                <div class="cdb-breadcrumb">
	                    <span>Crew</span>
	                    <i class="ri-arrow-right-s-line"></i>
	                    <strong v-if="viewMode === 'list'">List</strong>
	                    <strong v-else-if="viewMode === 'detail'">Detail</strong>
	                    <strong v-else-if="viewMode === 'write'">New Post</strong>
	                </div>
	                <h2 class="cdb-header-title">
	                    <template v-if="viewMode === 'list'">크루 게시판</template>
	                    <template v-else-if="viewMode === 'detail'">게시글 상세보기</template>
	                    <template v-else-if="viewMode === 'write'">새 글 작성하기</template>
	                </h2>
	            </div>
	
	            <div class="cdb-header-right">
	                <div v-if="viewMode === 'list'" class="cdb-search-wrapper">
	                    <i class="ri-search-line"></i>
	                    <input type="text" placeholder="제목 또는 내용 검색" @keyup.enter="onSearch">
	                </div>
	                
	                <button v-if="viewMode === 'list'" class="cdb-btn-primary" @click="viewMode = 'write'">
	                    <i class="ri-add-line"></i> <span>글쓰기</span>
	                </button>
	                <button v-else class="cdb-btn-outline" @click="viewMode = 'list'">
	                    <i class="ri-list-check"></i> <span>목록으로</span>
	                </button>
	            </div>
	        </header>
	    </div>
	    <div class="cdb-content-card cd-glass-card">
            <div v-if="viewMode === 'list'" key="list" class="cdb-list-view">
			    <div class="cdb-list">
			        <div class="cdb-list-header">
			            <span class="col-id">번호</span>
			            <span class="col-title">제목</span>
			            <span class="col-author">작성자</span>
			            <span class="col-date">등록일</span>
			            <span class="col-view">조회</span>
			        </div>
			        
			        <div v-for="(post, index) in posts" :key="post.crewBoardIdx" class="cdb-list-item" @click="goToDetail(post)">
			            <span class="col-id">{{ totalElements - ((currentPage - 1) * pageSize) - index }}</span>
			            <span class="col-title">
			                <span v-if="post.isNotice === 'Y'" class="cdb-badge-notice">공지</span>
			                {{ post.title }}
			                </span>
			            <span class="col-author">{{ post.authorNickname || '익명' }}</span>
			            <span class="col-date">{{ post.createdDate }}</span>
			            <span class="col-view">{{ post.viewCount }}</span>
			        </div>
			        
			        <div v-if="posts.length === 0" class="cd-no-data">
			            등록된 게시글이 없습니다. 첫 글을 남겨보세요!
			        </div>
			    </div>
			
			    <div class="cdb-pagination" v-if="totalPages > 0">
				    <button @click="changePage(1)" :disabled="currentPage === 1">&lt;&lt;</button>
				    <button @click="changePage(startPage - 1)" :disabled="startPage === 1">이전</button>
				    <span v-for="page in pageNumbers" :key="page"
				          :class="['page-number', { active: page === currentPage }]"
				          @click="changePage(page)">
				        {{ page }}
				    </span>
				    <button @click="changePage(endPage + 1)" :disabled="endPage === totalPages">다음</button>
				    <button @click="changePage(totalPages)" :disabled="currentPage === totalPages">&gt;&gt;</button>
				</div>
			</div>

            <div v-else-if="viewMode === 'detail' && currentPost" key="detail" class="cdb-detail-view">
                <div class="cdb-detail-nav">
                    <div class="cdb-detail-actions" style="margin-left: auto;">
                        <button class="cdb-text-btn">수정</button>
                        <button class="cdb-text-btn danger">삭제</button>
                    </div>
                </div>
                
                <div class="cdb-post-head">
                    <h2>{{ currentPost.title }}</h2>
                    <div class="cdb-post-meta">
                        <span><i class="ri-user-smile-line"></i> {{ currentPost.author }}</span>
                        <span><i class="ri-time-line"></i> {{ currentPost.date }}</span>
                        <span><i class="ri-eye-line"></i> {{ currentPost.views }}</span>
                    </div>
                </div>
                
                <div class="cdb-post-body">
                    {{ currentPost.content }}
                </div>
                
                <div class="cdb-comment-area">
                    <h4>댓글 <span>{{ currentPost.commentCount || 0 }}</span></h4>
                    <ul class="cdb-comment-list">
                        <li v-for="reply in currentPost.comments" :key="reply.id" class="cdb-comment-item">
                            <div class="cdb-comment-info">
                                <strong>{{ reply.author }}</strong>
                                <span>{{ reply.date }}</span>
                            </div>
                            <p>{{ reply.text }}</p>
                        </li>
                    </ul>
                    <div class="cdb-comment-form">
                        <input type="text" v-model="newComment" placeholder="따뜻한 댓글을 남겨주세요." @keyup.enter="submitComment">
                        <button @click="submitComment"><i class="ri-send-plane-fill"></i></button>
                    </div>
                </div>
            </div>

            <div v-else-if="viewMode === 'write'" key="write" class="cdb-write-view">
			    <div class="cdb-form">
			        <div class="cdb-form-item">
			            <input type="text" v-model="writeForm.title" placeholder="제목을 입력하세요" class="cdb-input">
			        </div>
			
			        <div class="cdb-form-item">
					    <div id="quill-editor" ref="quillEditor" class="cdb-quill-container"></div>
					</div>
			
			        <div class="cdb-form-btns">
			            <label class="cdb-checkbox-label" style="margin-right: auto;">
			                <input type="checkbox" v-model="writeForm.isNotice" true-value="Y" false-value="N">
			                <span class="cdb-check-custom"></span>
			                <span class="label-text">공지사항으로 등록</span>
			            </label>
			
			            <button class="cdb-btn-outline" @click="viewMode = 'list'" style="width: auto;">취소</button>
			            <button class="cdb-btn-primary" @click="submitPost" style="width: auto;">
			                <i class="ri-check-line"></i> 등록하기
			            </button>
			        </div>
			    </div>
			</div>
	    </div>
	</div>
</template>