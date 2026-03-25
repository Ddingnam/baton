<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
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
			            <div class="cdb-detail-actions" v-if="currentPost.userIdx == ${sessionScope.member.userIdx}">
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
                
                <div class="cdb-comment-container cdb-glass-card">
				    <div class="cdb-comment-header">
				        <h4 class="cdb-comment-title">댓글 <span class="cdb-highlight">{{ commentTotalCount }}</span></h4>
				    </div>
				
				    <div class="cdb-comment-write cdb-glass-inner">
				        <textarea v-model="newComment" placeholder="따뜻한 댓글을 남겨주세요." class="cdb-glass-input" rows="3"></textarea>
				        <div class="cdb-comment-actions-right">
				            <button class="cdb-btn-primary" @click="submitComment">등록</button>
				        </div>
				    </div>
				
				    <ul class="cdb-comment-list">
				        
				        <template v-for="comment in comments" :key="comment.commentId">
				            <li class="cdb-comment-item cdb-glass-inner">
				                
				                <div class="cdb-comment-top">
				                    <div class="cdb-user-info">
				                        <img :src="comment.authorProfilePhoto || '${pageContext.request.contextPath}/images/default-profile.png'" alt="프로필" class="cdb-profile-img">
				                        <strong class="cdb-nickname">{{ comment.authorNickname || '알 수 없음' }}</strong>
				                    </div>
				                    <div class="cdb-action-btns" v-if="comment.userIdx === ${sessionScope.member.userIdx}">
				                        <button class="cdb-btn-text" @click="editComment(comment)">수정</button>
				                        <button class="cdb-btn-text cdb-danger" @click="deleteComment(comment.commentId)">삭제</button>
				                    </div>
				                </div>
				                
								<div class="cdb-comment-body" v-if="editingCommentId !== comment.commentId">
								    <p>{{ comment.content }}</p>
								</div>

								<div class="cdb-comment-body" v-else>
								    <textarea v-model="editCommentContent" class="cdb-glass-input" rows="2"></textarea>
								    <div class="cdb-comment-actions-right">
								        <button class="cdb-btn-outline" @click="cancelEditComment">취소</button>
								        <button class="cdb-btn-primary" @click="submitEditComment(comment.commentId)">수정 완료</button>
								    </div>
								</div>
				                
				                <div class="cdb-comment-bottom">
				                    <button class="cdb-btn-reply-toggle" @click="toggleReplyForm(comment.commentId)">
				                        <i class="ri-reply-line"></i> 답글
				                    </button>
				                </div>
				
				                <transition name="cdb-slide-fade">
				                    <div v-if="activeReplyId === comment.commentId" class="cdb-reply-form cdb-glass-inner">
				                        <textarea v-model="replyContent" placeholder="답글을 남겨주세요." class="cdb-glass-input" rows="2"></textarea>
				                        <div class="cdb-comment-actions-right">
				                            <button class="cdb-btn-outline" @click="toggleReplyForm(null)">취소</button>
				                            <button class="cdb-btn-primary" @click="submitReply(comment.commentId)">답글 등록</button>
				                        </div>
				                    </div>
				                </transition>
				            </li>
				
				            <li v-for="child in comment.children" :key="child.commentId" class="cdb-comment-item cdb-reply-item cdb-glass-inner">
				                <i class="ri-corner-down-right-line cdb-reply-icon"></i>
				                <div class="cdb-reply-content-wrap">
				                    <div class="cdb-comment-top">
				                        <div class="cdb-user-info">
				                            <img :src="child.authorProfilePhoto || '${pageContext.request.contextPath}/images/default-profile.png'" alt="프로필" class="cdb-profile-img">
				                            <strong class="cdb-nickname">{{ child.authorNickname || '알 수 없음' }}</strong>
				                        </div>
				                        <div class="cdb-action-btns" v-if="child.userIdx === ${sessionScope.member.userIdx}">
				                            <button class="cdb-btn-text" @click="editComment(child)">수정</button>
				                            <button class="cdb-btn-text cdb-danger" @click="deleteComment(child.commentId)">삭제</button>
				                        </div>
				                    </div>
				                    <div class="cdb-comment-body">
				                        <p>{{ child.content }}</p>
				                    </div>
				                </div>
				            </li>
				        </template>
				    </ul>
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