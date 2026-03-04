<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${trade.title} | BATON</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/trade-article.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="page-wrap">
	<div class="header-content">
        <button type="button" class="back-btn" onclick="history.back()">
            <i class="ri-arrow-left-s-line" style="font-size: 24px;"></i>
        </button>
        <div class="title-set">
            <h1>우리 동네 물건 보기</h1>
            <p>우리 동네 따뜻한 거래 정보를 확인해보세요.</p>
        </div>
    </div>

    <div class="article-layout">
        <div class="main-side">
            <div class="card gallery-card">
                <div class="main-image-wrap">
                    <c:choose>
                        <c:when test="${not empty imageList}">
				            <img id="mainImage" src="${pageContext.request.contextPath}${imageList[0].imgUrl}" alt="${trade.title}">
				        </c:when>
				        <c:when test="${not empty trade.imgUrl}">
				             <img id="mainImage" src="${pageContext.request.contextPath}${trade.imgUrl}" alt="${trade.title}">
				        </c:when>
				        <c:otherwise>
				            <img id="mainImage" src="${pageContext.request.contextPath}/dist/images/noimage.png" alt="이미지 없음">
				        </c:otherwise>
                    </c:choose>

                    <c:if test="${trade.tradeStatus == '판매완료' || trade.tradeStatus == '예약중'}">
                        <div class="status-overlay">
                            <span class="status-overlay-badge">
                                <c:choose>
                                    <c:when test="${trade.tradeStatus == '판매완료'}">판매완료</c:when>
                                    <c:when test="${trade.tradeStatus == '예약중'}">예약 중</c:when>
                                </c:choose>
                            </span>
                        </div>
                    </c:if>
                </div>

                <c:if test="${not empty imageList && imageList.size() > 1}">
                    <div class="thumb-strip">
                        <c:forEach var="item" items="${imageList}" varStatus="st">
                            <div class="thumb-item ${st.index == 0 ? 'active' : ''}">
                                <img src="${pageContext.request.contextPath}${item.imgUrl}" alt="이미지 ${st.index + 1}">
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
            </div>

            <div class="card">
                <div class="product-badges">
                    <c:if test="${not empty trade.categoryName}">
                        <span class="badge badge-category">${trade.categoryName}</span>
                    </c:if>

                    <c:choose>
                        <c:when test="${trade.productStatus == '새상품'}">
                            <span class="badge badge-status-new">새상품</span>
                        </c:when>
                        <c:when test="${trade.productStatus == '고장/파손'}">
                            <span class="badge badge-status-broken">고장/파손</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-status-used">${trade.productStatus}</span>
                        </c:otherwise>
                    </c:choose>

                    <c:choose>
                        <c:when test="${trade.tradeType == '직거래'}">
                            <span class="badge badge-trade-direct">🤝 직거래</span>
                        </c:when>
                        <c:when test="${trade.tradeType == '택배'}">
                            <span class="badge badge-trade-parcel">📦 택배</span>
                        </c:when>
                        <c:when test="${trade.tradeType == '둘다가능'}">
                            <span class="badge badge-trade-both">✅ 직거래·택배</span>
                        </c:when>
                    </c:choose>
                </div>

                <h2 class="product-title">${trade.title}</h2>

                <p class="product-price ${trade.price == 0 ? 'free' : ''}">
                    <c:choose>
                        <c:when test="${trade.price == 0}">나눔 🎁</c:when>
                        <c:otherwise>
                            <fmt:formatNumber value="${trade.price}" pattern="#,###"/>
                            <span class="product-price-won">원</span>
                        </c:otherwise>
                    </c:choose>
                </p>

                <div class="product-meta">
                    <span> 조회 ${trade.hitCount}</span>
                    <span> 찜 <span id="statWish">${trade.likeCount}</span></span>
                    <span> 채팅 ${trade.chatCount}</span>
                    <span>${trade.createdDate}</span>
                </div>
            </div>

            <div class="card">
                <p class="card-title">상품 설명</p>
                <p class="product-desc">${trade.content}</p>
                
                <c:if test="${not empty tagList}">
                    <div class="tag-list" style="margin-top: 20px;">
                        <c:forEach var="tag" items="${tagList}">
                            <span class="tag-chip-view">#${tag}</span>
                        </c:forEach>
                    </div>
                </c:if>
            </div>

            <div class="card">
                <p class="card-title">거래 정보</p>
                <div class="info-grid">
                
                    <div class="info-item">
                        <p class="info-label">거래 방식</p>
                        <p class="info-value">${trade.tradeType}</p>
                    </div>

                    <div class="info-item">
                        <p class="info-label">판매 상태</p>
                        <p class="info-value">
                            <c:choose>
                                <c:when test="${trade.tradeStatus == '판매중'}">판매 중</c:when>
                                <c:when test="${trade.tradeStatus == '예약중'}">예약 중</c:when>
                                <c:when test="${trade.tradeStatus == '판매완료'}">판매 완료</c:when>
                                <c:otherwise>${trade.tradeStatus}</c:otherwise>
                            </c:choose>
                        </p>
                    </div>

                    <c:if test="${trade.tradeType != '택배' && not empty trade.tradePlace}">
                        <div class="info-item full-width">
                            <p class="info-label">거래 희망 장소</p>
                            <p class="info-value">📍 ${trade.tradePlace}</p>
                        </div>
                    </c:if>
                    
                    <c:if test="${trade.tradeType == '택배' || trade.tradeType == '둘다가능'}">
                        <div class="info-item full-width">
                            <p class="info-label">배송비</p>

                            <c:choose>
                                <c:when test="${not empty trade.shippingFee && trade.shippingFee > 0}">
                                    <p class="info-value">
                                        <fmt:formatNumber value="${trade.shippingFee}" pattern="#,###"/>원
                                    </p>
                                </c:when>
                                 
                                <c:otherwise>
                                    <p class="info-value">추후 협의</p>
                                </c:otherwise>
							</c:choose> 
                            
                        </div>
                        <div class="info-item full-width" style="padding: 0; background: none;">
                            <div class="shipping-notice">
                                <span class="notice-icon">💡</span>
                                <span>결제 시 <strong>착불</strong> 또는 <strong>선불</strong>을 선택할 수 있습니다.
                                착불은 수령 시 택배비를 지불하며, 선불은 발송 전 판매자에게 송금하는 방식입니다.</span>
                            </div>
                        </div>
                    </c:if>

                    <div class="info-item">
                        <p class="info-label">등록일</p>
                        <p class="info-value">${trade.createdDate}</p>
                    </div>

                    <div class="info-item">
                        <p class="info-label">끌어올리기</p>
                        <p class="info-value">${trade.pullCount}회</p>
                    </div>

                </div>
            </div>

        </div>

        <div class="sticky-side">

            <div class="card">
                <p class="card-title">판매자 정보</p>
                <div class="seller-row">
                    <div class="seller-avatar">
                        👤
                    </div>
                    <div class="seller-info">
                        <p class="seller-name">${trade.nickName}</p>
                        <p class="seller-region">
                            📍 <c:choose>
                                <c:when test="${not empty trade.coreAddress}">${trade.coreAddress}</c:when>
                                <c:otherwise>동네 정보 없음</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <button class="seller-profile-btn"
                        onclick="location.href='${pageContext.request.contextPath}/member/profile?userIdx=${sellerUserIdx}'">
                        프로필 보기
                    </button>
                </div>
            </div>

            <div class="card action-card">
			    <div class="stats-row">
			        <div class="stat-item">
			            <p class="stat-value">${trade.hitCount}</p>
			            <p class="stat-label">조회</p>
			        </div>
			        <div class="stat-item">
			            <p class="stat-value" id="statWishSide">${trade.likeCount}</p>
			            <p class="stat-label">찜</p>
			        </div>
			        <div class="stat-item">
			            <p class="stat-value">${trade.chatCount}</p>
			            <p class="stat-label">채팅</p>
			        </div>
			    </div>
			
			    <sec:authorize access="isAnonymous()">
			        <c:choose>
			            <c:when test="${trade.tradeStatus == '판매완료'}">
			                <button class="chat-btn" disabled>판매 완료된 상품입니다</button>
			            </c:when>
			            <c:otherwise>
			                <button class="chat-btn"
			                    onclick="location.href='${pageContext.request.contextPath}/member/login'">
			                    💬 로그인하고 채팅하기
			                </button>
			            </c:otherwise>
			        </c:choose>
			
			        <div class="secondary-actions">
			            <button class="wish-btn-large"
			                onclick="location.href='${pageContext.request.contextPath}/member/login'">
			                🤍 찜하기
			            </button>
			            <button class="share-btn" onclick="ShareModule.share()">🔗 공유</button>
			        </div>
			    </sec:authorize>
			
			
			    <sec:authorize access="isAuthenticated()">
			        <sec:authentication property="principal.member.userIdx" var="loggedInUserId" />
			        
			        <c:choose>
			            <c:when test="${loggedInUserId == trade.userIdx}">
			                <button class="chat-btn"
			                    onclick="window.open('${pageContext.request.contextPath}/chat/tradeList?tradeIdx=${trade.productIdx}', 'chatList', 'width=450, height=850, left=200, top=100, scrollbars=no, resizable=yes')">
			                    💬 채팅 내역 확인하기
			                </button>
			            </c:when>
			            <c:when test="${trade.tradeStatus == '판매완료'}">
			                <button class="chat-btn" disabled>판매 완료된 상품입니다</button>
			            </c:when>
			            <c:otherwise>
			                <button class="chat-btn"
			                    onclick="window.open('${pageContext.request.contextPath}/chat/room?tradeIdx=${trade.productIdx}&toUserIdx=${trade.userIdx}', 'chatRoom', 'width=450, height=850, left=200, top=100, scrollbars=yes, resizable=yes')">
			                    💬 채팅으로 거래하기
			                </button>
			                <c:if test="${trade.price > 0}">
				                <button class="pay-btn"
	                            	onclick="location.href='${pageContext.request.contextPath}/'">
	                            	<i class="ri-wallet-3-line"></i> 안전 결제하기
	                        	</button>
	                        </c:if>
			            </c:otherwise>
			        </c:choose>
			
			        <div class="secondary-actions">
			            <button class="wish-btn-large ${isLiked ? 'active' : ''}"
						    id="wishBtnLarge" onclick="WishModule.toggle()">
						    ${isLiked ? '❤️' : '🤍'} 찜 ${trade.likeCount}
						</button>
			            <button class="share-btn" onclick="ShareModule.share()">🔗 공유</button>
			        </div>
			
			        <c:if test="${loggedInUserId == trade.userIdx}">
			            <div class="owner-actions-group">
					        <p class="manage-label">게시글 관리</p>
					        <div class="owner-actions-grid">
							    <button type="button" class="btn-manage status-style" onclick="StatusModule.open()">
							        <i class="ri-loop-left-line"></i> 상태 변경
							    </button>
							    
							    <button type="button" class="btn-manage pull-style" onclick="PullUpModule.execute(${trade.productIdx})">
							        <i class="ri-rocket-2-line"></i> 끌어올리기
							    </button>
							    
							    <button type="button" class="btn-manage edit-style" 
							        onclick="location.href='${pageContext.request.contextPath}/trade/update?productIdx=${trade.productIdx}&page=${page}'">
							        <i class="ri-edit-line"></i> 수정
							    </button>
							    
							    <button type="button" class="btn-manage delete-style" 
							        onclick="confirmDelete(${trade.productIdx})">
							        <i class="ri-delete-bin-line"></i> 삭제
							    </button>
							</div>
					    </div>
			        </c:if>
			    </sec:authorize>
			</div>

        </div>
    </div>
</div>

<div class="lightbox" id="lightbox">
    <button class="lightbox-close" onclick="Lightbox.close()">✕</button>
    <button class="lightbox-nav lightbox-prev" onclick="Lightbox.prev()">&#8249;</button>
    <img id="lightboxImg" src="" alt="확대 이미지">
    <button class="lightbox-nav lightbox-next" onclick="Lightbox.next()">&#8250;</button>
    <p class="lightbox-count" id="lightboxCount">1 / 1</p>
</div>

<div class="toast" id="toast"></div>

<div id="articleData"
    data-trade-idx="${trade.productIdx}"
    data-wished="${isLiked}"
    data-wish-count="${trade.likeCount}"
    style="display:none">
</div>

<div id="statusModal" class="modal-overlay" onclick="StatusModule.close()">
    <div class="modal-content" onclick="event.stopPropagation()">
        <div class="modal-header">
            <h3>상태 변경</h3>
            <button type="button" class="close-modal" onclick="StatusModule.close()">✕</button>
        </div>
        <div class="status-options">
            <button type="button" class="status-opt ${trade.tradeStatus == '판매중' ? 'active' : ''}" 
                    onclick="StatusModule.update('${trade.productIdx}', '판매중')">판매중</button>
            <button type="button" class="status-opt ${trade.tradeStatus == '예약중' ? 'active' : ''}" 
                    onclick="StatusModule.update('${trade.productIdx}', '예약중')">예약중</button>
            <button type="button" class="status-opt hide-opt" 
                    onclick="StatusModule.update('${trade.productIdx}', '숨기기')">숨기기</button>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/dist/js/trade-article.js"></script>
</body>
</html>
