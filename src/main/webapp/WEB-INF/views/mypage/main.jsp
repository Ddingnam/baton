<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
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
</head>
<body>

	<jsp:include page="/WEB-INF/views/layout/header.jsp" />

	<div id="baton-layout-container" class="mypage-mode">

		<jsp:include page="/WEB-INF/views/mypage/left.jsp" />

		<main class="mp-main-wrapper" id="mp-theme-root">

			<div class="mp-profile-banner">
				<div class="pb-left">
					<div class="pb-avatar"><i class="ri-user-smile-fill"></i></div>
					<div class="pb-info">
						<h2 class="pb-name">${sessionScope.member.name != null ? sessionScope.member.name : '박바통'} 님</h2>
						<span class="pb-desc">서초4동 · 매너온도 <strong class="theme-text">36.5℃</strong></span>
						<div class="manner-bar-wrap">
							<div class="manner-bar-bg">
								<div class="manner-bar-fill theme-bg" style="width: 36.5%"></div>
							</div>
						</div>
					</div>
				</div>
				<div class="pb-right">
					<div class="pb-point">
						<span>보유 바통 포인트</span>
						<strong>
					        <fmt:formatNumber value="${empty userPoint ? 0 : userPoint}" pattern="#,###"/>
					        <span class="theme-text">P</span>
					    </strong>
					</div>
					<button class="theme-btn" onclick="openChargeModal()">충전하기</button>
				</div>
			</div>

			<div class="mp-tab-container">
				<ul class="mp-tabs" id="domain-tabs">
					<li class="tab-item active" data-target="sec-overview"   data-color="#3182F6" data-bg="#E8F3FF">종합 요약</li>
					<li class="tab-item"         data-target="sec-trade"     data-color="#00B98D" data-bg="#E6F8F3">중고거래</li>
					<li class="tab-item"         data-target="sec-club"      data-color="#F86D7D" data-bg="#FFF0F1">동네모임</li>
					<li class="tab-item"         data-target="sec-alba"      data-color="#002C5F" data-bg="#F0F4F8">알바구인</li>
					<li class="tab-item"         data-target="sec-community" data-color="#8A63FF" data-bg="#F4F0FF">커뮤니티</li>
				</ul>
			</div>

			<div class="mp-content-area">

				<section id="sec-overview" class="mp-section active">

					<div class="stat-grid">
						<div class="stat-box">
							<div class="stat-icon theme-icon-bg"><i class="ri-chat-3-line"></i></div>
							<strong>${fn:length(myReplies)} 개</strong>
							<span>작성한 댓글</span>
						</div>
						<div class="stat-box">
							<div class="stat-icon theme-icon-bg"><i class="ri-bookmark-line"></i></div>
							<strong>${fn:length(myScraps)} 개</strong>
							<span>저장한 글</span>
						</div>
						<div class="stat-box">
							<div class="stat-icon theme-icon-bg"><i class="ri-bar-chart-box-line"></i></div>
							<strong>${fn:length(myVotes)} 개</strong>
							<span>참여한 투표</span>
						</div>
						<div class="stat-box">
							<div class="stat-icon theme-icon-bg"><i class="ri-edit-2-line"></i></div>
							<strong>${fn:length(myPosts)} 개</strong>
							<span>작성한 글</span>
						</div>
					</div>

					<div class="list-card mb-24">
						<div class="lc-header">
							<h3>최근 활동 내역</h3>
							<a href="#" class="theme-link">전체보기 <i class="ri-arrow-right-s-line"></i></a>
						</div>
						<div class="lc-list">
							<div class="lc-item">
								<div class="item-icon theme-icon-bg"><i class="ri-shopping-bag-3-fill"></i></div>
								<div class="item-info">
									<h4>아이폰 15 프로 미개봉 급매</h4>
									<p class="info-metrics">중고구매 · 1시간 전</p>
								</div>
								<div class="item-right"><span class="theme-badge">거래완료</span></div>
							</div>
							<div class="lc-item">
								<div class="item-icon theme-icon-bg"><i class="ri-team-fill"></i></div>
								<div class="item-info">
									<h4>주말 아침 한강 러닝크루</h4>
									<p class="info-metrics">동네모임 · 2일 전</p>
								</div>
								<div class="item-right"><span class="theme-badge">참여중</span></div>
							</div>
							<div class="lc-item">
								<div class="item-icon theme-icon-bg"><i class="ri-briefcase-fill"></i></div>
								<div class="item-info">
									<h4>스타벅스 강남역점 주말 파트타임</h4>
									<p class="info-metrics">알바지원 · 3일 전</p>
								</div>
								<div class="item-right"><span class="theme-badge-outline">열람대기</span></div>
							</div>
							
							<c:if test="${not empty myPosts}">
								<div class="lc-item" style="cursor:pointer" onclick="location.href='${pageContext.request.contextPath}/community/article/${myPosts[0].id}'">
									<div class="item-icon theme-icon-bg"><i class="ri-chat-3-fill"></i></div>
									<div class="item-info">
										<h4>${myPosts[0].subject}</h4>
										<p class="info-metrics">커뮤니티 · <c:out value="${fn:substring(myPosts[0].regDate.toString(), 5, 10)}"/></p>
									</div>
									<div class="item-right">
										<c:if test="${not empty myPosts[0].category}">
											<span class="theme-badge">${myPosts[0].category}</span>
										</c:if>
									</div>
								</div>
							</c:if>
						</div>
					</div>

					<div class="list-card mb-24">
						<div class="lc-header">
							<h3>받은 매너 키워드</h3>
							<a href="#" class="theme-link">전체보기 <i class="ri-arrow-right-s-line"></i></a>
						</div>
						<div class="manner-keyword-list">
							<div class="mk-item"><i class="ri-thumb-up-fill theme-text"></i> 시간 약속을 잘 지켜요 <span class="mk-count">8</span></div>
							<div class="mk-item"><i class="ri-thumb-up-fill theme-text"></i> 친절하고 매너가 좋아요 <span class="mk-count">6</span></div>
							<div class="mk-item"><i class="ri-thumb-up-fill theme-text"></i> 상품 설명이 자세해요 <span class="mk-count">4</span></div>
							<div class="mk-item"><i class="ri-thumb-up-fill theme-text"></i> 응답이 빨라요 <span class="mk-count">3</span></div>
						</div>
					</div>

				</section>

				<section id="sec-trade" class="mp-section">
					<div class="list-card">
						<div class="lc-header">
							<h3>나의 거래 내역</h3>
							
							<a href="${pageContext.request.contextPath}/mypage/trade/sell" class="theme-link">전체보기 <i class="ri-arrow-right-s-line"></i></a>
						</div>

						<div class="inner-tabs">
							<button class="inner-tab active" data-inner="trade-sell">판매내역</button>
							<button class="inner-tab" data-inner="trade-buy">구매내역</button>
							<button class="inner-tab" data-inner="trade-wish">찜목록</button>
							<button class="inner-tab" data-inner="trade-follower">팔로워 목록</button>
							<button class="inner-tab" data-inner="trade-following">팔로잉 목록</button>
						</div>
						
						<input type="hidden" id="sessionUserIdx" value="${sessionScope.member.userIdx}">

						<div class="inner-section active" id="trade-sell">
							<div class="lc-list">
								<c:choose>
				                    <c:when test="${empty tradeList}">
				                        <div class="lc-empty">
				                            <i class="ri-shopping-bag-line"></i>
				                            <p>판매 내역이 없습니다.</p>
				                        </div>
				                    </c:when>
				                    <c:otherwise>
				                        <c:forEach var="item" items="${tradeList}">
				                            <div class="lc-item" onclick="location.href='${pageContext.request.contextPath}/trade/article?productIdx=${item.productIdx}'">
				                                <div class="item-thumb">
				                                    <c:choose>
												        <c:when test="${not empty item.imageList}">
												            <img src="${pageContext.request.contextPath}/uploads/trade/${item.imageList[0].saveName}" 
												                 alt="상품이미지">
												        </c:when>
												        <c:otherwise>
												            <div>
												                <i class="ri-image-line"></i>
												            </div>
												        </c:otherwise>
												    </c:choose>
				                                </div>
				                                <div class="item-info">
				                                    <h4>${item.title}</h4>
				                                    <p class="time-ago info-metrics">${item.tradeStatus} · ${item.lastUpDate} · 조회 ${item.hitCount}</p>
				                                </div>
				                                <div class="item-right">
				                                    <span class="${item.tradeStatus == '판매완료' ? 'theme-badge-done' : 'theme-badge'}">${item.tradeStatus}</span>
				                                    <strong class="price">
				                                    	<c:choose>
												            <c:when test="${item.price == 0}">
												                나눔
												            </c:when>
												            <c:otherwise>
												                <fmt:formatNumber value="${item.price}" pattern="#,###"/>원
												            </c:otherwise>
												        </c:choose>
				                                    </strong>
				                                </div>
				                            </div>
				                        </c:forEach>
				                    </c:otherwise>
				                </c:choose>
				            </div>
				        </div>
				
				        <div class="inner-section" id="trade-buy">
						    <div class="lc-list">
						        <c:choose>
						            <c:when test="${empty buyList}">
						                <div class="lc-empty">
						                    <i class="ri-handbag-line"></i>
						                    <p>구매 내역이 없습니다.</p>
						                </div>
						            </c:when>
						            <c:otherwise>
						                <c:forEach var="item" items="${buyList}">
						                    <div class="lc-item" onclick="location.href='${pageContext.request.contextPath}/trade/article?productIdx=${item.productIdx}'">
						                        <div class="item-thumb">
						                            <c:if test="${not empty item.imageList}">
						                                <img src="${pageContext.request.contextPath}/uploads/trade/${item.imageList[0].saveName}" alt="상품이미지">
						                            </c:if>
						                        </div>
						                        <div class="item-info">
						                            <h4>${item.title}</h4>
						                            <p class="info-metrics"> ${item.tradeStatus == 'CANCELED' ? '결제취소' : item.tradeStatus == 'PAY_COMPLETED' ? '결제완료' : item.tradeStatus == 'SHIPPING' ? '배송중' : '거래완료'} · ${item.dong} </p>
						                        </div>
						                        <div class="item-right">
						                        	<span class="${item.tradeStatus == 'CANCELED' ? 'theme-badge-done' : 'theme-badge'}">${item.tradeStatus == 'CANCELED' ? '결제취소' : item.tradeStatus == 'PAY_COMPLETED' ? '결제완료' : item.tradeStatus == 'SHIPPING' ? '배송중' : '거래완료'}</span>
						                            <strong class="price">
						                                <fmt:formatNumber value="${item.price}" pattern="#,###"/>원
						                            </strong>
						                        </div>
						                    </div>
						                </c:forEach>
						            </c:otherwise>
						        </c:choose>
						    </div>
						</div>
				
				        <div class="inner-section" id="trade-wish">
						    <div class="lc-list">
						        <c:choose>
						            <c:when test="${empty wishList}">
						                <div class="lc-empty">
						                    <i class="ri-heart-line"></i>
						                    <p>찜한 상품이 없습니다.</p>
						                </div>
						            </c:when>
						            <c:otherwise>
						                <c:forEach var="item" items="${wishList}">
						                    <div class="lc-item" onclick="location.href='${pageContext.request.contextPath}/trade/article?productIdx=${item.productIdx}'">
						                        <div class="item-thumb">
						                            <c:choose>
						                                <c:when test="${not empty item.imageList}">
						                                    <img src="${pageContext.request.contextPath}/uploads/trade/${item.imageList[0].saveName}" alt="상품이미지">
						                                </c:when>
						                                <c:when test="${not empty item.imgUrl}">
						                                    <img src="${item.imgUrl}" alt="상품이미지">
						                                </c:when>
						                                <c:otherwise>
						                                    <i class="ri-image-line"></i>
						                                </c:otherwise>
						                            </c:choose>
						                        </div>
						
						                        <div class="item-info">
						                            <h4>${item.title}</h4>
						                            <p class="info-metrics">
						                                ${item.tradeStatus} · ${item.dong}
						                            </p>
						                        </div>
						
						                        <div class="item-right">
						                        	<span class="${item.tradeStatus == '판매완료' ? 'theme-badge-done' : 'theme-badge'}">${item.tradeStatus}</span>
						                            <strong class="price">
						                                <fmt:formatNumber value="${item.price}" pattern="#,###"/>원
						                            </strong>
						                        </div>
						                    </div>
						                </c:forEach>
						            </c:otherwise>
						        </c:choose>
						    </div>
						</div>
						
						<div class="inner-section" id="trade-follower">
						    <div class="lc-list">
						        <div class="lc-empty">
						        	<p>불러오는 중...</p>
						        </div>
						    </div>
						</div>
						
						<div class="inner-section" id="trade-following">
						    <div class="lc-list">
								<div class="lc-empty">
									<p>불러오는 중...</p>
								</div>
						    </div>
						</div>
					</div>
				</section>

				<section id="sec-club" class="mp-section">
					<div class="list-card">
						<div class="lc-header">
							<h3>나의 모임 현황</h3>
							<a href="${pageContext.request.contextPath}/mypage/club/joined" class="theme-link">내 모임 관리 <i class="ri-arrow-right-s-line"></i></a>
						</div>

						<div class="inner-tabs">
							<button class="inner-tab active" data-inner="club-joined">참여중</button>
							<button class="inner-tab"        data-inner="club-hosted">내가 만든</button>
						</div>

						<div class="inner-section active" id="club-joined">
							<div class="lc-list">
								<div class="lc-item">
									<div class="item-icon theme-icon-bg"><i class="ri-run-line"></i></div>
									<div class="item-info">
										<h4>주말 아침 한강 러닝크루</h4>
										<p class="info-metrics">참여멤버 12명 · 토요일 07:00 여의도 한강공원</p>
									</div>
									<div class="item-right">
										<span class="theme-badge">D-3</span>
									</div>
								</div>
								<div class="lc-item">
									<div class="item-icon theme-icon-bg"><i class="ri-camera-line"></i></div>
									<div class="item-info">
										<h4>필름 카메라 산책 모임</h4>
										<p class="info-metrics">참여멤버 6명 · 다음주 일요일 14:00</p>
									</div>
									<div class="item-right">
										<span class="theme-badge">D-10</span>
									</div>
								</div>
							</div>
						</div>

						<div class="inner-section" id="club-hosted">
							<div class="lc-list">
								<div class="lc-item">
									<div class="item-icon theme-icon-bg"><i class="ri-book-open-line"></i></div>
									<div class="item-info">
										<h4>강남역 직장인 독서모임</h4>
										<p class="info-metrics">참여멤버 8명 · 매주 수요일 19:30</p>
									</div>
									<div class="item-right">
										<span class="theme-badge">주최자</span>
										<button class="btn-sm">관리</button>
									</div>
								</div>
							</div>
						</div>
					</div>
				</section>

				<section id="sec-alba" class="mp-section">
					<div class="list-card">
						<div class="lc-header">
							<h3>알바 활동 내역</h3>
							<a href="${pageContext.request.contextPath}/mypage/alba/apply" class="theme-link">이력서 관리 <i class="ri-arrow-right-s-line"></i></a>
						</div>

						<div class="inner-tabs">
							<button class="inner-tab active" data-inner="alba-apply">지원현황</button>
							<button class="inner-tab"        data-inner="alba-post">내 공고</button>
						</div>

						<div class="inner-section active" id="alba-apply">
							<div class="lc-list">
								<div class="lc-item">
									<div class="item-info">
										<span class="corp-name theme-text">스타벅스 강남역점</span>
										<h4>주말 마감 파트타이머 구합니다</h4>
										<p class="info-metrics">시급 11,000원 · 2월 24일 지원</p>
									</div>
									<div class="item-right">
										<span class="theme-badge-outline">열람대기</span>
									</div>
								</div>
								<div class="lc-item">
									<div class="item-info">
										<span class="corp-name theme-text">버터앤빈 카페</span>
										<h4>바리스타 모집 (주 3회)</h4>
										<p class="info-metrics">시급 13,000원 · 2월 18일 지원</p>
									</div>
									<div class="item-right">
										<span class="theme-badge">서류통과</span>
									</div>
								</div>
								<div class="lc-item">
									<div class="item-info">
										<span class="corp-name" style="color:#8B95A1;font-size:12px;font-weight:700;margin-bottom:4px;display:block;">컴포즈 두타몰점</span>
										<h4>오전 파트타임 (월~수)</h4>
										<p class="info-metrics">시급 10,400원 · 2월 10일 지원</p>
									</div>
									<div class="item-right">
										<span style="background:#F2F4F6;color:#8B95A1;padding:6px 12px;border-radius:8px;font-size:13px;font-weight:700;">불합격</span>
									</div>
								</div>
							</div>
						</div>

						<div class="inner-section" id="alba-post">
							<div class="lc-list">
								<div class="lc-item">
									<div class="item-info">
										<h4>강남 카페 주말 알바 구합니다</h4>
										<p class="info-metrics">시급 12,000원 · 지원자 3명 · 2월 20일 등록</p>
									</div>
									<div class="item-right">
										<span class="theme-badge">모집중</span>
										<button class="btn-sm">지원자 보기</button>
									</div>
								</div>
							</div>
						</div>
					</div>
				</section>

				<section id="sec-community" class="mp-section">
					<div class="list-card">
						<div class="lc-header">
							<h3>커뮤니티 활동</h3>
							<a href="${pageContext.request.contextPath}/mypage/community/posts" class="theme-link">전체 활동 <i class="ri-arrow-right-s-line"></i></a>
						</div>

						<div class="inner-tabs">
							<button class="inner-tab active" data-inner="comm-posts">작성한 글</button>
							<button class="inner-tab"        data-inner="comm-comments">댓글단 글</button>
							<button class="inner-tab"        data-inner="comm-saved">저장한 글</button>
							<button class="inner-tab"        data-inner="comm-votes">참여한 투표</button>
						</div>

						<div class="inner-section active" id="comm-posts">
							<div class="lc-list">
								<c:choose>
									<c:when test="${empty myPosts}">
										<div class="lc-empty">
											<i class="ri-file-text-line"></i>
											<p>아직 작성한 글이 없어요</p>
											<a href="${pageContext.request.contextPath}/community/list" class="theme-link">커뮤니티 가기 <i class="ri-arrow-right-s-line"></i></a>
										</div>
									</c:when>
									<c:otherwise>
										<c:forEach var="post" items="${myPosts}">
											<div class="lc-item" style="cursor:pointer" onclick="location.href='${pageContext.request.contextPath}/community/article/${post.id}'">
												<div class="item-info">
													<c:if test="${not empty post.category}">
														<span class="corp-name theme-text">${post.category}</span>
													</c:if>
													<h4>${post.subject}</h4>
													<div class="comm-stats">
														<span><i class="ri-eye-line"></i> ${post.hitCount}</span>
														<span><i class="ri-heart-3-line"></i> ${post.likeCount}</span>
														<span><c:out value="${fn:substring(post.regDate.toString(), 5, 10)}"/></span>
													</div>
												</div>
											</div>
										</c:forEach>
									</c:otherwise>
								</c:choose>
							</div>
						</div>

						<div class="inner-section" id="comm-comments">
							<div class="lc-list">
								<c:choose>
									<c:when test="${empty myReplies}">
										<div class="lc-empty">
											<i class="ri-chat-3-line"></i>
											<p>아직 작성한 댓글이 없어요</p>
										</div>
									</c:when>
									<c:otherwise>
										<c:forEach var="reply" items="${myReplies}">
											<div class="lc-item" style="cursor:pointer" onclick="location.href='${pageContext.request.contextPath}/community/article/${reply.communityId}'">
												<div class="item-info">
													<h4>${reply.communitySubject}</h4>
													<p class="info-metrics">내 ${reply.parentReply ? '댓글' : '대댓글'}: "${reply.content}"</p>
													<div class="comm-stats">
														<span><c:out value="${fn:substring(reply.regDate.toString(), 5, 10)}"/></span>
													</div>
												</div>
											</div>
										</c:forEach>
									</c:otherwise>
								</c:choose>
							</div>
						</div>

						<div class="inner-section" id="comm-saved">
							<div class="lc-list">
								<c:choose>
									<c:when test="${empty myScraps}">
										<div class="lc-empty">
											<i class="ri-bookmark-line"></i>
											<p>저장한 글이 없어요</p>
										</div>
									</c:when>
									<c:otherwise>
										<c:forEach var="scrap" items="${myScraps}">
											<div class="lc-item" style="cursor:pointer" onclick="location.href='${pageContext.request.contextPath}/community/article/${scrap.id}'">
												<div class="item-info">
													<c:if test="${not empty scrap.category}">
														<span class="corp-name theme-text">${scrap.category}</span>
													</c:if>
													<h4>${scrap.subject}</h4>
													<div class="comm-stats">
														<span><i class="ri-eye-line"></i> ${scrap.hitCount}</span>
														<span><i class="ri-heart-3-line"></i> ${scrap.likeCount}</span>
														<span><c:out value="${fn:substring(scrap.regDate.toString(), 5, 10)}"/> 저장</span>
													</div>
												</div>
											</div>
										</c:forEach>
									</c:otherwise>
								</c:choose>
							</div>
						</div>

						<div class="inner-section" id="comm-votes">
							<div class="lc-list">
								<c:choose>
									<c:when test="${empty myVotes}">
										<div class="lc-empty">
											<i class="ri-bar-chart-box-line"></i>
											<p>참여한 투표가 없어요</p>
										</div>
									</c:when>
									<c:otherwise>
										<c:forEach var="vote" items="${myVotes}">
											<div class="lc-item" style="cursor:pointer" onclick="location.href='${pageContext.request.contextPath}/community/article/${vote.communityId}'">
												<div class="item-icon theme-icon-bg">
													<i class="ri-bar-chart-box-line"></i>
												</div>
												<div class="item-info">
													<h4>${vote.communitySubject}</h4>
													<p class="info-metrics">투표 제목: ${vote.pollTitle}</p>
													<p class="info-metrics">내 선택: <strong class="theme-text">${vote.myOptions}</strong></p>
													<div class="comm-stats">
														<span><i class="ri-group-line"></i> 총 ${vote.totalVotes}명 참여</span>
														<c:choose>
															<c:when test="${vote.expired}">
																<span style="color:#8B95A1;">투표 종료</span>
															</c:when>
															<c:when test="${not empty vote.pollEndDate}">
																<span class="theme-text">~${vote.pollEndDate} 까지</span>
															</c:when>
															<c:otherwise>
																<span class="theme-text">진행중</span>
															</c:otherwise>
														</c:choose>
													</div>
												</div>
												<div class="item-right">
													<c:choose>
														<c:when test="${vote.expired}">
															<span style="background:#F2F4F6;color:#8B95A1;padding:6px 12px;border-radius:8px;font-size:13px;font-weight:700;">종료</span>
														</c:when>
														<c:otherwise>
															<span class="theme-badge">진행중</span>
														</c:otherwise>
													</c:choose>
												</div>
											</div>
										</c:forEach>
									</c:otherwise>
								</c:choose>
							</div>
						</div>

					</div>
				</section>

			</div>
		</main>
	</div>

	<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
	<jsp:include page="/WEB-INF/views/payment/chargeModal.jsp" />
	<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
	<script src="${pageContext.request.contextPath}/dist/js/mypage/mypage_main.js"></script>
	<script src="${pageContext.request.contextPath}/dist/js/mypage/mypage_follow.js"></script>
	<script src="${pageContext.request.contextPath}/dist/js/payment/payment.js"></script>
	<script src="${pageContext.request.contextPath}/dist/js/util/timeAgo.js"></script>
	

	<script>
	document.querySelectorAll('.inner-tab').forEach(function(tab) {
		tab.addEventListener('click', function() {
			var card = this.closest('.list-card');
			card.querySelectorAll('.inner-tab').forEach(function(t) { t.classList.remove('active'); });
			card.querySelectorAll('.inner-section').forEach(function(s) { s.classList.remove('active'); });
			this.classList.add('active');
			var target = this.getAttribute('data-inner');
			var sec = document.getElementById(target);
			if (sec) sec.classList.add('active');
		});
	});
	</script>
</body>
</html>
