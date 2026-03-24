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
						<strong v-else-if="viewMode === 'edit'">Update Post</strong>
	                </div>
	                <h2 class="cdb-header-title">
	                    <template v-if="viewMode === 'list'">크루 게시판</template>
	                    <template v-else-if="viewMode === 'detail'">게시글 상세보기</template>
	                    <template v-else-if="viewMode === 'write'">새 글 작성하기</template>
	                    <template v-else-if="viewMode === 'edit'">글 수정하기</template>
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
	                <button v-else class="cdb-btn-outline" @click="backToList">
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
					
					<div v-else class="cdb-list-container fade-in-list" :key="currentPage">
				        <div v-for="(post, index) in posts" :key="post.crewBoardIdx" class="cdb-list-item" @click="goToDetail(post)">
				            <span class="col-id">{{ totalElements - ((currentPage - 1) * pageSize) - index }}</span>
				            <span class="col-title">
				                <span v-if="post.isNotice === 'Y'" class="cdb-badge-notice">공지</span>
				                {{ post.title }}
				                </span>
				            <span class="col-author">{{ post.authorNickname || '익명' }}</span>
				            <span class="col-date">{{ post.formattedDate }}</span>
				            <span class="col-view">{{ post.viewCount }}</span>
				        </div>
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
				<header class="cdb-post-header">
			        <div class="cdb-post-info">
			            <h2 class="cdb-post-title">{{ currentPost.title }}</h2>
			            <div class="cdb-post-meta">
			                <span class="meta-item"><i class="ri-user-smile-line"></i> {{ currentPost.authorNickname || '익명' }}</span>
			                <span class="meta-divider"></span>
			                <span class="meta-item"><i class="ri-time-line"></i> {{ currentPost.formattedDate }}</span>
			                <span class="meta-divider"></span>
			                <span class="meta-item"><i class="ri-eye-line"></i> {{ currentPost.viewCount }}</span>
			            </div>
			        </div>
			        
			        <div class="cdb-post-side">
			            <div class="cdb-detail-actions">
			                <button class="cdb-action-btn edit" @click="goToEdit">
			                    <i class="ri-edit-line"></i> 수정
			                </button>
			                <button class="cdb-action-btn delete" @click="deletePost">
			                    <i class="ri-delete-bin-line"></i> 삭제
			                </button>
			            </div>
			        </div>
			    </header>
                
                <div class="cdb-post-body ql-editor" v-html="currentPost.content"></div>
                
                <div class="cdb-comment-card">
				    <h4 class="cdb-comment-title">댓글 <span class="cdb-comment-count">3</span></h4>
				    
				    <ul class="cdb-comment-list">
				        <li class="cdb-comment-item">
				            <div class="cdb-comment-info">
				                <div class="cdb-author-meta">
				                    <img src="https://via.placeholder.com/32" alt="프로필" class="cdb-profile-img">
				                    <strong class="cdb-author-name">김철수</strong>
				                </div>
				                <span class="cdb-comment-date">2026.03.24</span>
				            </div>
				            <p class="cdb-comment-text">정말 유익한 포스팅이네요! 디자인이 깔끔해서 보기 좋습니다.</p>
				        </li>
				
				        <li class="cdb-comment-item cdb-reply-item">
				            <div class="cdb-comment-info">
				                <div class="cdb-author-meta">
				                    <img src="https://via.placeholder.com/32/ffcccc" alt="프로필" class="cdb-profile-img">
				                    <strong class="cdb-author-name">작성자</strong>
				                </div>
				                <span class="cdb-comment-date">2026.03.24</span>
				            </div>
				            <p class="cdb-comment-text">철수님, 좋게 봐주셔서 감사합니다! 😊</p>
				        </li>
				
				        <li class="cdb-comment-item">
				            <div class="cdb-comment-info">
				                <div class="cdb-author-meta">
				                    <img src="https://via.placeholder.com/32/ccccff" alt="프로필" class="cdb-profile-img">
				                    <strong class="cdb-author-name">이영희</strong>
				                </div>
				                <span class="cdb-comment-date">2026.03.23</span>
				            </div>
				            <p class="cdb-comment-text">혹시 사용하신 폰트 정보 좀 알 수 있을까요? 가독성이 너무 좋네요.</p>
				        </li>
				    </ul>
				
				    <div class="cdb-comment-form">
				        <input type="text" class="cdb-comment-input" placeholder="따뜻한 댓글을 남겨주세요.">
				        <button class="cdb-comment-submit"><i class="ri-send-plane-fill"></i></button>
				    </div>
				</div>
            </div>

			<div v-else-if="viewMode === 'write' || viewMode === 'edit'" :key="viewMode" class="cdb-write-view">
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

			            <button class="cdb-btn-outline" @click="cancelWrite" style="width: auto;">취소</button>
			            
			            <button class="cdb-btn-primary" @click="submitPost" style="width: auto;">
			                <i class="ri-check-line"></i> {{ viewMode === 'edit' ? '수정하기' : '등록하기' }}
			            </button>
			        </div>
			    </div>
			</div>
	    </div>
	</div>
</template>