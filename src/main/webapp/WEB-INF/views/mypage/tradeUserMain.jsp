<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>BATON | 마이페이지</title>
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main/main.css?v=final">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage/mypage_left.css?v=final">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage/mypage_main.css?v=final">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage/mypage_trade_main.css?v=final">
</head>
<body>

	<jsp:include page="/WEB-INF/views/layout/header.jsp" />

	<div id="baton-layout-container" class="mypage-mode">


		<main class="mp-main-wrapper" id="mp-theme-root">

			<div class="mp-profile-banner">
				<div class="pb-left">
					<div class="pb-avatar"><i class="ri-user-smile-fill"></i></div>
					<div class="pb-info">
						<h2 class="pb-name">${dto.nickname} 님</h2>
						<span class="pb-desc">서초4동 · 매너온도 <strong class="theme-text">36.5℃</strong></span>
						<div class="manner-bar-wrap">
							<div class="manner-bar-bg">
								<div class="manner-bar-fill theme-bg" style="width: 36.5%"></div>
							</div>
						</div>
					</div>
				</div>
				<sec:authentication property="principal.member.userIdx" var="loggedInUserId"/>
				<div class="pb-right">
					<c:if test="${loggedInUserId != dto.userIdx}"> 
						<button id="btnFollow" 
						        class="theme-btn ${isFollowing ? 'following' : ''}" 
						        data-following-idx="${dto.userIdx}"
						        onclick="FollowModule.toggle('${dto.userIdx}')"> ${isFollowing ? '팔로잉' : '팔로우'}
						</button>
				    </c:if>
				</div>
			</div>

			<div class="mp-content-area">

				<div class="mp-section active">

					<div class="stat-grid">
						<div class="stat-box">
							<div class="stat-icon theme-icon-bg"><i class="ri-chat-3-line"></i></div>
							<strong>${dto.score} 점</strong>
							<span>평점</span>
						</div>
						<div class="stat-box">
							<div class="stat-icon theme-icon-bg"><i class="ri-bookmark-line"></i></div>
							<strong>0 개</strong>
							<span>거래내역</span>
						</div>
						<div class="stat-box">
							<div class="stat-icon theme-icon-bg"><i class="ri-bar-chart-box-line"></i></div>
							<strong id="followerCount">${empty followerCount ? 0 : followerCount} 명</strong>
							<span>팔로워</span>
						</div>
						<div class="stat-box">
							<div class="stat-icon theme-icon-bg"><i class="ri-edit-2-line"></i></div>
							<strong>${empty followingCount ? 0 : followingCount} 명</strong>
							<span>팔로잉</span>
						</div>
					</div>
					
					<div class="list-card mb-24">
						<div class="lc-header">
							<h3>받은 매너 키워드</h3>
						</div>
						<div class="manner-keyword-list">
							<div class="mk-item"><i class="ri-thumb-up-fill theme-text"></i> 시간 약속을 잘 지켜요 <span class="mk-count">8</span></div>
							<div class="mk-item"><i class="ri-thumb-up-fill theme-text"></i> 친절하고 매너가 좋아요 <span class="mk-count">6</span></div>
							<div class="mk-item"><i class="ri-thumb-up-fill theme-text"></i> 상품 설명이 자세해요 <span class="mk-count">4</span></div>
							<div class="mk-item"><i class="ri-thumb-up-fill theme-text"></i> 응답이 빨라요 <span class="mk-count">3</span></div>
						</div>
					</div>

					<div class="list-card mb-24">
						<div class="lc-header">
							<h3>판매 물품 내역</h3>
						</div>
						<div class="lc-list">
							<c:choose>
					            <c:when test="${not empty tradeList}">
					                <c:forEach var="item" items="${tradeList}">
					                    <div class="lc-item" style="cursor:pointer" 
					                         onclick="location.href='${pageContext.request.contextPath}/trade/main?productIdx=${item.productIdx}'">
					                        
					                        <div class="item-icon theme-icon-bg">
					                            <i class="ri-shopping-bag-3-fill"></i>
					                        </div>
					                        
					                        <div class="item-info">
					                            <h4>${item.title}</h4>
					                            <p class="info-metrics">
					                            	<c:choose>
					                            		<c:when test="${item.price > 0}">
					                            			<fmt:formatNumber value="${item.price}" type="number"/>원 ·
					                            		</c:when>
					                            		<c:otherwise>
					                            			나눔 ·
					                            		</c:otherwise>
					                            	</c:choose>
					                                 
					                                <span class="time-ago" data-time="${item.lastUpDate}">
													    ${item.lastUpDate}
													</span>
					                            </p>
					                        </div>
					                        
					                        <div class="item-right">
					                            <c:choose>
					                                <c:when test="${item.tradeStatus eq '판매중'}">
					                                    <span class="theme-badge">${item.tradeStatus}</span>
					                                </c:when>
					                                <c:when test="${item.tradeStatus eq '예약중'}">
					                                    <span class="badge-disabled">${item.tradeStatus}</span>
					                                </c:when>
					                                <c:otherwise>
					                                    <span class="badge-disabled">
					                                        ${item.tradeStatus}
					                                    </span>
					                                </c:otherwise>
					                            </c:choose>
					                            	<strong class="price">
					                            <c:choose>
					                            	<c:when test="${item.price > 0}">
					                            		<fmt:formatNumber value="${item.price}" type="number"/>원
					                            	</c:when>
					                            	<c:otherwise>
					                            		나눔
					                            	</c:otherwise>
					                            </c:choose>
					                            	</strong>
					                            
					                        </div>
					                    </div>
					                </c:forEach>
					            </c:when>
					            
					            <c:otherwise>
					                <div class="lc-empty">
					                    <i class="ri-shopping-bag-line"></i>
					                    <p>아직 판매중인 물품이 없어요</p>
					                </div>
					            </c:otherwise>
					        </c:choose>
						</div>
					</div>
					
				</div>
			</div>
		</main>
	</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
<jsp:include page="/WEB-INF/views/payment/chargeModal.jsp" />
<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/mypage/mypage_follow.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/mypage/mypage_main.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/util/timeAgo.js"></script>

</body>
</html>
