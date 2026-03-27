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

<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage/mypage_badge.css?v=final">

<style>
    .mp-profile-banner { background: #fff; border-radius: 28px; padding: 45px 50px; box-shadow: 0 10px 40px rgba(0,0,0,0.03); display: flex; justify-content: space-between; align-items: center; margin-bottom: 35px; position: relative; overflow: hidden; gap: 80px; }
    .pb-left { display: flex; align-items: center; gap: 30px; flex: 1; max-width: 60%; }
    .pb-avatar { width: 90px; height: 90px; border-radius: 28px; background: #F2F4F6; display: flex; justify-content: center; align-items: center; font-size: 45px; color: #D1D6DB; box-shadow: inset 0 2px 6px rgba(0,0,0,0.05); border: 1px solid rgba(0,0,0,0.05); overflow: hidden; }
    .pb-avatar img { width: 100%; height: 100%; object-fit: cover; }
    .pb-info { flex: 1; max-width: 500px; }
    .pb-name-row { display: flex; align-items: center; gap: 12px; margin-bottom: 6px; }
    .pb-name { font-size: 1.6rem; font-weight: 800; color: #191F28; margin: 0; letter-spacing: -0.7px; }
    .rep-badge { padding: 4px 10px; border-radius: 8px; font-size: 0.8rem; font-weight: 800; display: inline-flex; align-items: center; gap: 4px; }
    .pb-desc { font-size: 0.95rem; color: #6B7684; font-weight: 500; display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px; margin-top: 5px; }
    .pb-desc strong { font-weight: 800; font-size: 1.1rem; }
    .baton-track-wrap { width: 100%; position: relative; padding-top: 15px; }
    .baton-track-bg { width: 100%; height: 12px; background: #E5E8EB; border-radius: 12px; position: relative; }
    .baton-track-fill { height: 100%; border-radius: 10px; position: relative; transition: width 1.2s cubic-bezier(0.34, 1.56, 0.64, 1); }
    .runner-icon { position: absolute; right: -18px; top: -14px; width: 38px; height: 38px; background: #fff; border-radius: 50%; display: flex; align-items: center; justify-content: center; border: 3px solid; font-size: 20px; box-shadow: 0 4px 10px rgba(0,0,0,0.15); z-index: 2; }
</style>
</head>
<body>

	<jsp:include page="/WEB-INF/views/layout/header.jsp" />

	<div id="baton-layout-container" class="mypage-mode">

		<jsp:include page="/WEB-INF/views/mypage/left.jsp" />

		<main class="mp-main-wrapper" id="mp-theme-root">

            <c:set var="dist" value="${empty userDto.batonDistance ? 10.0 : userDto.batonDistance}" />
            <c:set var="percent" value="${(dist / 42.195) * 100}" />
            <c:if test="${percent > 100}"><c:set var="percent" value="100" /></c:if>

            <c:choose>
                <c:when test="${dist >= 40.0}">
                    <c:set var="bColor" value="#FFB300"/><c:set var="bName" value="골드 바톤"/><c:set var="bIcon" value="ri-vip-crown-fill"/>
                </c:when>
                <c:when test="${dist >= 30.0}">
                    <c:set var="bColor" value="#3182F6"/><c:set var="bName" value="블루 바톤"/><c:set var="bIcon" value="ri-medal-fill"/>
                </c:when>
                <c:when test="${dist >= 20.0}">
                    <c:set var="bColor" value="#00B98D"/><c:set var="bName" value="그린 바톤"/><c:set var="bIcon" value="ri-leaf-fill"/>
                </c:when>
                <c:when test="${dist >= 10.0}">
                    <c:set var="bColor" value="#9CA3AF"/><c:set var="bName" value="알루미늄 바톤"/><c:set var="bIcon" value="ri-subtract-fill"/> 
                </c:when>
                <c:otherwise>
                    <c:set var="bColor" value="#8B4513"/><c:set var="bName" value="나무 바톤"/><c:set var="bIcon" value="ri-seedling-fill"/>
                </c:otherwise>
            </c:choose>

            <div class="mp-profile-banner">
				<div class="pb-left">
					<div class="pb-avatar">
                        <c:choose>
                            <c:when test="${not empty userDto.profile_photo}">
                                <img src="${pageContext.request.contextPath}/uploads/profile/${userDto.profile_photo}">
                            </c:when>
                            <c:otherwise><i class="ri-user-smile-fill"></i></c:otherwise>
                        </c:choose>
                    </div>                   
					<div class="pb-info">
                        <div class="pb-name-row">
						    <h2 class="pb-name">${userDto.nickname}</h2>
                            <span class="rep-badge" style="background:${bColor}15; color:${bColor}; border: 1px solid ${bColor}30;">
                                <i class="${bIcon}" style="font-weight: 900; transform: rotate(45deg); display: inline-block;"></i> ${bName}
                            </span>
                        </div>
						<span class="pb-desc">
                            <span>${region.dong} 이웃</span>
                            <span>
                                달린 거리 <strong style="color:${bColor};">${dist}km</strong> / 42.195km 
                                <i class="ri-flag-2-fill" style="color:#D1D6DB; font-size:18px; margin-left: 4px; vertical-align: middle;" title="풀코스 완주(42.195km)"></i>
                            </span>
                        </span>
						<div class="baton-track-wrap">
							<div class="baton-track-bg">
								<div class="baton-track-fill" style="width: ${percent}%; background: ${bColor}; box-shadow: 0 0 15px ${bColor}60;">
                                    <div class="runner-icon" style="border-color: ${bColor}; color: ${bColor};"><i class="ri-run-fill"></i></div>
                                </div>
							</div>
						</div>
					</div>					
				</div>
				<div class="pb-right">
					<div class="pb-point">
						<span>보유 바통 포인트</span>
						<strong>
					        <fmt:formatNumber value="${empty userPoint ? 0 : userPoint}" pattern="#,###"/>
					        <span class="theme-text" style="color: #3182F6;">P</span>
					    </strong>
					</div>
					<button class="theme-btn" style="background:#3182F6;" onclick="openChargeModal()">충전하기</button>
				</div>
			</div>

			<div id="mainSummaryContent">
				<div class="mp-tab-container">
					<ul class="mp-tabs" id="domain-tabs">
						<li class="tab-item active" data-target="sec-overview"   data-color="#3182F6" data-bg="#E8F3FF">종합 요약</li>
						<li class="tab-item" data-target="sec-trade" data-color="#00B98D" data-bg="#E6F8F3">중고거래</li>
						<li class="tab-item" data-target="sec-club" data-color="#F86D7D" data-bg="#FFF0F1">동네모임</li>
						<li class="tab-item" data-target="sec-alba" data-color="#002C5F" data-bg="#F0F4F8">알바구인</li>
						<li class="tab-item" data-target="sec-community" data-color="#8A63FF" data-bg="#F4F0FF">커뮤니티</li>
					</ul>
				</div>

				<div class="mp-content-area">

					<section id="sec-overview" class="mp-section active">

                        <div class="list-card mb-24" style="background: transparent; box-shadow: none; padding: 0;">
                            <div class="lc-header" style="margin-bottom: 5px;">
                                <h3>나의 러너 배지 🏅</h3>
                                <a href="javascript:void(0);" onclick="openBadgeModal()" class="theme-link">전체보기 <i class="ri-arrow-right-s-line"></i></a>
                            </div>
                            
                            <c:set var="acquiredCount" value="0" />
                            <c:forEach var="chk" items="${badgeList}">
                                <c:if test="${chk.acquired}"><c:set var="acquiredCount" value="${acquiredCount + 1}" /></c:if>
                            </c:forEach>
                            
                            <c:if test="${acquiredCount == 0}">
                                <div class="badge-empty-box">
                                    <p>현재 획득한 배지가 없습니다.</p>
                                    <span>활동을 시작하고 아래의 배지들을 모아보세요!</span>
                                </div>
                            </c:if>

                            <div class="badge-grid">
                                <c:forEach var="badge" items="${badgeList}" end="2">
                                    <div class="badge-item ${badge.acquired ? 'acquired' : 'locked'}">
                                        <div class="badge-icon" style="${badge.acquired ? 'color: #3182F6; background: #E8F3FF;' : ''}">
                                            <i class="${badge.iconImage}"></i>
                                        </div>
                                        <div class="badge-info">
                                            <h4>${badge.badgeName}</h4>
                                            <p>${badge.description}</p>
                                            <div class="badge-progress-wrap">
                                                <div class="badge-progress-bar">
                                                    <div class="badge-progress-fill" style="width: ${badge.progressPercent}%; ${badge.acquired ? 'background:#00B98D;' : ''}"></div>
                                                </div>
                                                <span class="badge-progress-text">${badge.currentCount}/${badge.targetCount}</span>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

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
							
							    <c:if test="${not empty tradeList}">
							        <div class="lc-item" onclick="location.href='${pageContext.request.contextPath}/trade/main#/article/${tradeList[0].productIdx}'">
							            <div class="item-icon theme-icon-bg">
							                <i class="ri-shopping-bag-3-fill"></i>
							            </div>
							            <div class="item-info">
							                <h4>${tradeList[0].title}</h4>
							                <p class="info-metrics">중고거래 · ${tradeList[0].lastUpDate}</p>
							            </div>
							            <div class="item-right">
							                <span class="theme-badge">${tradeList[0].tradeStatus}</span>
							            </div>
							        </div>
							    </c:if>
							
								<c:if test="${not empty myPosts}">
								    <div class="lc-item" onclick="location.href='${pageContext.request.contextPath}/community/article/${myPosts[0].id}'">
								        <div class="item-icon theme-icon-bg" style="background: #E8F3FF; color: #3182F6;">
								            <i class="ri-chat-3-fill"></i>
								        </div>
								        <div class="item-info">
								            <h4>${myPosts[0].subject}</h4>
								            <p class="info-metrics">커뮤니티 · <fmt:parseDate value="${myPosts[0].regDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedRegDate" type="both" /><fmt:formatDate value="${parsedRegDate}" pattern="MM월 dd일"/></p>
								        </div>
								        <div class="item-right">
								            <span class="theme-badge" style="background: #E8F3FF; color: #3182F6;">작성완료</span>
								        </div>
								    </div>
								</c:if>
							
							    <c:if test="${not empty albaApplyList}">
							        <div class="lc-item">
							            <div class="item-icon theme-icon-bg" style="background: #FFF4E6; color: #FF922B;">
							                <i class="ri-briefcase-fill"></i>
							            </div>
							            <div class="item-info">
							                <h4>${albaApplyList[0].title}</h4>
							                <p class="info-metrics">알바지원 · ${albaApplyList[0].applyDate}</p>
							            </div>
							            <div class="item-right">
							                <span class="theme-badge" style="background: #FFF4E6; color: #FF922B;">지원완료</span>
							            </div>
							        </div>
							    </c:if>
							
							    <c:if test="${empty tradeList && empty myPosts && empty albaApplyList}">
							        <div class="lc-empty">
							            <p>최근 활동 내역이 없습니다.</p>
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
					                            <div class="lc-item" onclick="location.href='${pageContext.request.contextPath}/trade/main#/article/${item.productIdx}'">
					                                <div class="item-thumb">
					                                    <c:choose>
													        <c:when test="${not empty item.imageList}">
													            <img src="${pageContext.request.contextPath}/uploads/trade/${item.imageList[0].saveName}" alt="상품이미지">
													        </c:when>
													        <c:otherwise>
													            <div><i class="ri-image-line"></i></div>
													        </c:otherwise>
													    </c:choose>
					                                </div>
					                                
					                                <div class="item-info">
					                                    <h4>${item.title}</h4>
					                                    <p class="info-metrics"><span class="time-ago" data-time="${item.lastUpDate}">${item.lastUpDate}</span> · 조회 ${item.hitCount} · 찜 ${item.likeCount}</p>
					                                </div>
					                                
					                                <div class="item-right">
					                                	<div class="item-status-row">
														    <span class="${item.tradeStatus == '판매완료' ? 'theme-badge-done' : 'theme-badge'}">${item.tradeStatus}</span>
														    <c:if test="${item.tradeStatus == '판매완료'}">
														        <button class="btn-sm" onclick="event.stopPropagation(); location.href='${pageContext.request.contextPath}/review/write?productIdx=${item.productIdx}&role=SELLER'">후기 쓰기</button>
														    </c:if>
													    </div>
													    <strong class="price">
													        <c:choose>
													            <c:when test="${item.price == 0}">나눔</c:when>
													            <c:otherwise><fmt:formatNumber value="${item.price}" pattern="#,###"/>원</c:otherwise>
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
							                    <div class="lc-item" onclick="location.href='${pageContext.request.contextPath}/trade/main#/article/${item.productIdx}'">
							                        <div class="item-thumb">
							                            <c:if test="${not empty item.imageList}">
							                                <img src="${pageContext.request.contextPath}/uploads/trade/${item.imageList[0].saveName}" alt="상품이미지">
							                            </c:if>
							                        </div>
							                        <div class="item-info">
							                            <h4>${item.title}</h4>
							                            <p class="info-metrics"><span class="time-ago" data-time="${item.tradeDate}">${item.tradeDate} </span> 구매 · 조회 ${item.hitCount} · 찜 ${item.likeCount} </p>
							                        </div>							                        
							                        <div class="item-right">
							                        	<div class="item-status-row">
														    <span class="${item.tradeStatus == 'CANCELED' ? 'theme-badge-done' : 'theme-badge'}">${item.tradeStatus == 'CANCELED' ? '결제취소' : item.tradeStatus == 'PAY_COMPLETED' ? '결제완료' : item.tradeStatus == 'SHIPPING' ? '배송중' : '거래완료'}</span>
														    
														    <c:if test="${item.tradeStatus == 'CONFIRMED' or item.tradeStatus == '거래완료'}">
														        <button class="btn-sm" onclick="event.stopPropagation(); location.href='${pageContext.request.contextPath}/review/write?productIdx=${item.productIdx}&role=BUYER'">후기 쓰기</button>
														    </c:if>
													    </div>
													    <strong class="price">
													        <c:choose>
													            <c:when test="${item.price == 0}">나눔</c:when>
													            <c:otherwise><fmt:formatNumber value="${item.price}" pattern="#,###"/>원</c:otherwise>
													        </c:choose>
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
							                    <div class="lc-item" onclick="location.href='${pageContext.request.contextPath}/trade/main#/article/${item.productIdx}'">
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
							                                <span class="time-ago" data-time="${item.lastUpDate}">${item.lastUpDate}</span> · 조회 ${item.hitCount} · 찜 ${item.likeCount}
							                            </p>
							                        </div>
							                        <div class="item-right">
							                        	<span class="${item.tradeStatus == '판매완료' ? 'theme-badge-done' : 'theme-badge'}">${item.tradeStatus}</span>
							                            <strong class="price">
													        <c:choose>
													            <c:when test="${item.price == 0}">나눔</c:when>
													            <c:otherwise><fmt:formatNumber value="${item.price}" pattern="#,###"/>원</c:otherwise>
													        </c:choose>
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
							        <div class="lc-empty"><p>불러오는 중...</p></div>
							    </div>
							</div>
							
							<div class="inner-section" id="trade-following">
							    <div class="lc-list">
									<div class="lc-empty"><p>불러오는 중...</p></div>
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
										<div class="item-right"><span class="theme-badge">D-3</span></div>
									</div>
									<div class="lc-item">
										<div class="item-icon theme-icon-bg"><i class="ri-camera-line"></i></div>
										<div class="item-info">
											<h4>필름 카메라 산책 모임</h4>
											<p class="info-metrics">참여멤버 6명 · 다음주 일요일 14:00</p>
										</div>
										<div class="item-right"><span class="theme-badge">D-10</span></div>
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
								<a href="${pageContext.request.contextPath}/resume/myList" class="theme-link">이력서 관리 <i class="ri-arrow-right-s-line"></i></a>
							</div>
							<div class="inner-tabs">
								<button class="inner-tab active" data-inner="alba-apply">지원현황</button>
								<button class="inner-tab" data-inner="alba-post">내 공고</button>
								<button class="inner-tab" data-inner="alba-wish">관심 공고</button>
							</div>
							<div class="inner-section active" id="alba-apply">
						    <div class="lc-list">
						        <c:choose>
						            <c:when test="${empty albaApplyList}">
						                <div class="lc-empty">
						                    <i class="ri-briefcase-line"></i>
						                    <p>지원한 공고가 없습니다.</p>
						                </div>
						            </c:when>
						            <c:otherwise>
						                <c:forEach var="apply" items="${albaApplyList}">
						                    <div class="lc-item">
						                        <div class="item-info">
						                            <span class="corp-name theme-text">${apply.employer}</span>
						                            <h4>${apply.title}</h4>
						                            <p class="info-metrics">
													    ${apply.payType} <fmt:formatNumber value="${apply.pay}" pattern="#,###"/>원 · 
													    <fmt:parseDate value="${apply.applyDate}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" type="both" />
													    <fmt:formatDate value="${parsedDate}" pattern="M월 d일"/> 지원
													</p>
						                        </div>
						                        <div class="item-right">
						                            <c:choose>
						                                <c:when test="${apply.status == '열람대기'}"><span class="theme-badge-outline">열람대기</span></c:when>
						                                <c:when test="${apply.status == '서류통과'}"><span class="theme-badge">서류통과</span></c:when>
						                                <c:when test="${apply.status == '불합격'}">
						                                    <span style="background:#F2F4F6;color:#8B95A1;padding:6px 12px;border-radius:8px;font-size:13px;font-weight:700;">불합격</span>
						                                </c:when>
						                            </c:choose>
						                        </div>
						                    </div>
						                </c:forEach>
						            </c:otherwise>
						        </c:choose>
						    </div>
						</div>

							<div class="inner-section" id="alba-post">
								<div class="lc-list">
									<c:choose>
							            <c:when test="${empty albaPostList}">
							                <div class="lc-empty">
							                    <i class="ri-file-list-3-line"></i>
							                    <p>등록한 공고가 없습니다.</p>
							                </div>
							            </c:when>
							            <c:otherwise>
							                <c:forEach var="alba" items="${albaPostList}">
							                    <div class="lc-item" onclick="location.href='${pageContext.request.contextPath}/alba/article/${alba.postingIdx}'">
							                        <div class="item-info">
							                            <h4>${alba.title}</h4>
							                            <p class="info-metrics">
							                                ${alba.payType} <fmt:formatNumber value="${alba.pay}" pattern="#,###"/>원 · 
							                                지원자 ${alba.applyCount}명 · 
							                                <span class="time-ago" data-time="${alba.createdDate}"></span>
							                            </p>
							                        </div>
							                        <div class="item-right">
														<span class="theme-badge-done">
														    <c:choose>
														        <c:when test="${alba.recruitStatus == 'RECRUITING'}">모집중</c:when>
														        <c:when test="${alba.recruitStatus == 'CLOSED'}">마감</c:when>
														        <c:when test="${alba.recruitStatus == 'PRIVATE'}">비공개</c:when>
														    </c:choose>
														</span>
							                            <button class="btn-sm" onclick="event.stopPropagation(); location.href='${pageContext.request.contextPath}/alba/manage?postingIdx=${alba.postingIdx}'">지원자 보기</button>
							                        </div>
							                    </div>
							                </c:forEach>
							            </c:otherwise>
							        </c:choose>
								</div>
							</div>
							
							<div class="inner-section" id="alba-wish">
								<div class="lc-list">
									<c:choose>
										<c:when test="${empty albaScrapList}">
											<div class="lc-empty">
												<i class="ri-heart-line"></i>
												<p>스크랩한 관심 공고가 없습니다.</p>
											</div>
										</c:when>
										<c:otherwise>
											<c:forEach var="alba" items="${albaScrapList}">
												<div class="lc-item" style="cursor:pointer;" onclick="location.href='${pageContext.request.contextPath}/alba/article/${alba.postingIdx}'">
													<div class="item-info">
														<c:if test="${not empty alba.employer}">
															<span class="corp-name theme-text">${alba.employer}</span>
														</c:if>
														<h4>${alba.title}</h4>
														<p class="info-metrics">
															${alba.payType} <fmt:formatNumber value="${alba.pay}" pattern="#,###"/>원 · 
															${alba.location}
														</p>
													</div>
													<div class="item-right">
														<span class="theme-badge-done">
														    <c:choose>
														        <c:when test="${alba.recruitStatus == 'RECRUITING' ? 'theme-badge' : 'theme-badge-done'}'}">모집중</c:when>
														        <c:when test="${alba.recruitStatus == 'CLOSED'}">마감</c:when>
														        <c:when test="${alba.recruitStatus == 'PRIVATE'}">비공개</c:when>
														    </c:choose>
														</span>
													</div>
												</div>
											</c:forEach>
										</c:otherwise>
									</c:choose>
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
																<c:when test="${vote.expired}"><span style="color:#8B95A1;">투표 종료</span></c:when>
																<c:when test="${not empty vote.pollEndDate}"><span class="theme-text">~${vote.pollEndDate} 까지</span></c:when>
																<c:otherwise><span class="theme-text">진행중</span></c:otherwise>
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
			</div>

			<div id="pointHistoryContent" style="display:none; margin-top:30px;">
			    <div style="display:flex; justify-content:space-between; align-items:flex-end; border-bottom:2px solid #333; padding-bottom:15px; margin-bottom:20px;">
			        <h3 style="font-size:20px; font-weight:800; margin:0; color:#333;">포인트 이용 내역</h3>
			        <div>
			            <span style="font-size:12px; color:#888; margin-right:10px;">3일(72시간) 이내 미사용 충전건 환불 가능</span>
			            <button type="button" onclick="requestPointRefund()" style="background:#F86D7D; color:#fff; border:none; padding:8px 16px; border-radius:8px; font-size:13px; font-weight:700; cursor:pointer; transition:0.2s;">
			                <i class="ri-refund-2-line"></i> 결제 취소 (환불)
			            </button>
			        </div>
			    </div>
			    <div id="pointHistoryListContainer" style="background:#fff; border-radius:16px; padding:0 25px; box-shadow:0 4px 15px rgba(0,0,0,0.03);"></div>
			</div>
			
			<div id="tradeHistoryContent" style="display:none; margin-top:30px;">
			    <div style="display:flex; justify-content:space-between; align-items:flex-end; border-bottom:2px solid #333; padding-bottom:15px; margin-bottom:20px;">
			        <h3 style="font-size:20px; font-weight:800; margin:0; color:#333;">거래 내역 보기</h3>
			    </div>
			    <div id="tradeHistoryListContainer" style="background:#fff; border-radius:16px; padding:0 25px; box-shadow:0 4px 15px rgba(0,0,0,0.03);"></div>
			</div>

		</main>
	</div>

    <div id="badgeAllModal" class="premium-modal-overlay">
	    <div class="premium-modal-content">
	        <div class="premium-modal-header">
	            <h3>🏆 바톤터치 전체 배지 컬렉션</h3>
	            <button type="button" onclick="closeBadgeModal()"><i class="ri-close-line"></i></button>
	        </div>
	        
	        <div class="premium-modal-body">
	            <div class="premium-badge-grid">
	                <c:forEach var="badge" items="${badgeList}">
	                    <div class="p-badge-card ${badge.acquired ? 'acquired' : 'locked'}">
	                        
	                        <div class="p-badge-icon">
	                            <i class="${badge.iconImage}"></i>
	                            <c:if test="${badge.acquired}">
	                                <div class="p-badge-check"><i class="ri-checkbox-circle-fill"></i></div>
	                            </c:if>
	                        </div>
	                        
	                        <div style="flex-grow: 1;">
	                            <div class="p-badge-title">${badge.badgeName}</div>
	                            <div class="p-badge-desc">${badge.description}</div>
	                        </div>
	                        
	                        <div class="p-progress-wrap">
	                            <div class="p-progress-bar">
	                                <div class="p-progress-fill" style="width: ${badge.progressPercent}%;"></div>
	                            </div>
	                            <div class="p-progress-text">${badge.currentCount} / ${badge.targetCount}</div>
	                        </div>
	                        
	                    </div>
	                </c:forEach>
	            </div>
	        </div>
	    </div>
	</div>
    
	<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
	<jsp:include page="/WEB-INF/views/payment/chargeModal.jsp" />
	<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
	<script src="${pageContext.request.contextPath}/dist/js/mypage/mypage_main.js"></script>
	<script src="${pageContext.request.contextPath}/dist/js/mypage/mypage_follow.js"></script>
	<script src="${pageContext.request.contextPath}/dist/js/payment/payment.js"></script>
	<script src="${pageContext.request.contextPath}/dist/js/util/timeAgo.js"></script>
	<script>const CONTEXT_PATH = '${pageContext.request.contextPath}';</script>
	<script src="${pageContext.request.contextPath}/dist/js/mypage/mypage_history.js"></script>
	
	<script src="${pageContext.request.contextPath}/dist/js/mypage/mypage_badge.js"></script>
	
</body>
</html>