<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>BATON | 연결의 가치를 잇다</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main.css">
</head>
<body>

	<div id="baton-intro">
		<div class="intro-container">
			<div class="relay-visual">
				<div class="baton-pass-bar"></div>
				<div class="node"></div>
				<div class="node"></div>
				<div class="node"></div>
			</div>

			<div class="intro-content">
				<h1 class="brand-name">BATON</h1>
				<p class="brand-slogan">나의 필요가 당신의 일상으로, 가치를 이어주고 마음을 이어받는 따뜻한
					바통 터치</p>
			</div>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <div id="baton-layout-container">
        <jsp:include page="/WEB-INF/views/layout/left.jsp" />

        <main id="baton-main-content">
            
            <section class="baton-section reveal">
                <h2 class="main-display-title">우리가 기다렸던<br>새로운 동네 라이프</h2>
                <p class="main-display-subtitle">중고거래부터 동네모임, 구인구직까지.<br>바통 하나로 동네의 모든 즐거움이 이어집니다.</p>
                
                <div class="search-container">
                    <i class="ri-search-2-line"></i>
                    <input type="text" placeholder="지금 우리 동네의 새로운 소식을 찾아보세요">
                </div>
            </section>

            <section class="baton-section reveal" id="stats-section">
                <div class="premium-stats-card">
                    <h3 class="stats-title">지금 이 순간에도<br>바통은 따뜻하게 오가고 있어요</h3>
                    <p class="stats-description">복잡한 데이터 분석은 저희가 할게요.<br>이웃님은 즐거운 동네 생활에만 집중하세요.</p>
                    <div class="number-box">
                        <div class="counter-group">
                            <span class="counter-number" id="counter">0</span>
                            <span class="counter-unit">번</span>
                        </div>
                        <p style="font-weight: 600; color: #6b7684; margin-top: 15px; font-size: 18px;">누적 연결 횟수</p>
                    </div>
                    <button class="baton-action-btn">나도 바통 이어받기</button>
                </div>
            </section>

            <section class="baton-section reveal">
                <div class="filter-chip-group">
                    <div class="filter-chip active">🔥 전체인기</div>
                    <div class="filter-chip">📱 디지털기기</div>
                    <div class="filter-chip">👗 패션/의류</div>
                    <div class="filter-chip">🏠 가구/인테리어</div>
                    <div class="filter-chip">📚 도서/문구</div>
                    <div class="filter-chip">🚴 스포츠/레저</div>
                    <div class="filter-chip">🐶 반려동물</div>
                </div>
            </section>

			<section class="baton-section reveal">
				<div class="section-header-flex">
					<h3 class="section-display-title">
						지금 이웃들이<br>주목하는 바통
					</h3>
					<a href="#" class="more-link">전체보기 <i
						class="ri-arrow-right-s-line"></i></a>
				</div>

				<div class="product-grid-layout">
					<c:forEach var="i" begin="1" end="8">
						<div class="product-item-card">
							<div class="product-thumb">
								<div class="thumb-placeholder"></div>
								<div class="wish-tab" onclick="toggleWish(this, event)">
									<i class="ri-heart-line"></i>
								</div>
							</div>
							<div class="product-details" style="padding: 24px;">
								<h4
									style="font-size: 18px; font-weight: 700; margin-bottom: 12px;">아이폰
									15 Pro 256GB 블루 티타늄</h4>
								<div
									style="font-size: 20px; font-weight: 800; color: var(--baton-title);">1,100,000원</div>
								<div
									style="font-size: 14px; color: var(--baton-muted); margin-top: 10px;">역삼동
									· 12분 전</div>
							</div>
						</div>
					</c:forEach>
				</div>
			</section>
			<section class="baton-section reveal">
                <div class="safe-relay-banner">
                    <div>
                        <h3 class="banner-title">신뢰를 잇는 기술,<br><span class="blue-text">바통 안전결제</span></h3>
                        <p class="banner-subtitle">이웃 간의 소중한 거래를<br>가장 안전한 방법으로 보호해 드립니다.</p>
                        <button class="banner-action-btn">가이드 확인하기</button>
                    </div>
                    <div class="shield-icon-container">
                        <i class="ri-shield-flash-fill"></i>
                    </div>
                </div>
            </section>

            <section class="baton-section reveal">
                <h3 class="section-display-title" style="margin-bottom: 35px;">동네 이웃들의 이야기</h3>
                <div class="community-list-stack">
                    <div class="community-post-row">
                        <div class="post-text-side">
                            <span class="post-category-tag blue">동네질문</span>
                            <h4 class="post-subject">역삼역 근처 조용하고 일하기 좋은 카페 있을까요?</h4>
                            <div class="post-meta-line">카페탐험가 · 댓글 12 · 34분 전</div>
                        </div>
                        <div class="post-icon-side"><i class="ri-cup-line"></i></div>
                    </div>
                    <div class="community-post-row">
                        <div class="post-text-side">
                            <span class="post-category-tag gray">일상공유</span>
                            <h4 class="post-subject">오늘 한강 노을 진짜 예쁘네요. 다들 퇴근길 하늘 보세요!</h4>
                            <div class="post-meta-line">감성토끼 · 댓글 8 · 1시간 전</div>
                        </div>
                        <div class="post-icon-side"><i class="ri-sun-cloudy-line"></i></div>
                    </div>
                </div>
            </section>

            <section class="baton-section reveal">
                <h3 class="section-display-title" style="margin-bottom: 35px;">함께 할 동네 크루</h3>
                <div class="job-club-grid">
                    <div class="horizontal-action-card">
                        <div class="action-icon-box club-bg">🏃</div>
                        <div class="action-info-box">
                            <span class="tag blue-text">동네모임</span>
                            <div class="title">이번 주말 한강 러닝 크루 모집</div>
                            <div class="meta">참여 4/10명 · 여의도 공원</div>
                        </div>
                    </div>
                    <div class="horizontal-action-card" style="cursor: pointer;" onclick="location.href='${pageContext.request.contextPath}/alba/list'">
                        <div class="action-icon-box job-bg">💼</div>
                        <div class="action-info-box">
                            <span class="tag blue-text" style="color:#00B050;">동네알바</span>
                            <div class="title">(급구) 프론트엔드 단기 프로젝트</div>
                            <div class="meta">시급 25,000원 · 재택가능</div>
                        </div>
                    </div>
                </div>
            </section>

        </main>
    </div>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
    <script src="${pageContext.request.contextPath}/dist/js/main.js"></script>
    
</body>
</html>