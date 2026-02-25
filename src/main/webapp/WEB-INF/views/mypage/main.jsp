<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>BATON | 마이페이지</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main.css?v=clean">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage_left.css?v=clean">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage_main.css?v=clean">
</head>
<body>

	<jsp:include page="/WEB-INF/views/layout/header.jsp" />

	<div id="baton-layout-container" class="mypage-mode">
		
		<jsp:include page="/WEB-INF/views/mypage/left.jsp" />

		<main class="mypage-main-content">
			
			<div class="mypage-title">
				<h2>마이페이지</h2>
			</div>

			<div class="mp-card profile-point-card">
				<div class="profile-area">
					<div class="avatar"><i class="ri-user-smile-fill"></i></div>
					<div class="info">
						<span class="greeting">안녕하세요,</span>
						<h3>${sessionScope.member.userName != null ? sessionScope.member.userName : '박바통'}님</h3>
						<div class="manner-temp">
							<span>매너온도</span> <strong>36.5℃</strong>
						</div>
					</div>
				</div>
				<div class="divider"></div>
				<div class="point-area">
					<span class="point-label">보유 바통 포인트</span>
					<div class="point-val">
						<strong>12,500</strong><span>P</span>
					</div>
					<button class="btn-charge">충전하기</button>
				</div>
			</div>

			<div class="mp-grid">
				<div class="mp-stat-card">
					<div class="icon-wrap" style="background: #E8F3FF; color: #3182F6;"><i class="ri-shopping-bag-3-fill"></i></div>
					<div class="stat-text">
						<span class="label">중고거래</span>
						<span class="val"><strong>3</strong>건</span>
					</div>
				</div>
				<div class="mp-stat-card">
					<div class="icon-wrap" style="background: #E6F8F3; color: #00B98D;"><i class="ri-briefcase-4-fill"></i></div>
					<div class="stat-text">
						<span class="label">알바지원</span>
						<span class="val"><strong>5</strong>건</span>
					</div>
				</div>
				<div class="mp-stat-card">
					<div class="icon-wrap" style="background: #FFF0F1; color: #F86D7D;"><i class="ri-team-fill"></i></div>
					<div class="stat-text">
						<span class="label">참여모임</span>
						<span class="val"><strong>2</strong>개</span>
					</div>
				</div>
				<div class="mp-stat-card">
					<div class="icon-wrap" style="background: #F4F0FF; color: #8A63FF;"><i class="ri-chat-smile-3-fill"></i></div>
					<div class="stat-text">
						<span class="label">작성글</span>
						<span class="val"><strong>12</strong>개</span>
					</div>
				</div>
			</div>

			<div class="mp-banner">
				<div class="banner-text">
					<span class="badge">이벤트</span>
					<h4>우리 동네 이웃과 함께하는<br>가을맞이 플로깅 모집</h4>
				</div>
				<div class="banner-img">
					<i class="ri-leaf-fill"></i>
				</div>
			</div>

			<div class="mp-card list-card">
				<div class="card-header">
					<h3>최근 거래 내역</h3>
					<a href="${pageContext.request.contextPath}/mypage/trade/buy" class="link-more">더보기 <i class="ri-arrow-right-s-line"></i></a>
				</div>
				<div class="mp-list">
					<div class="list-item">
						<div class="item-thumb"><i class="ri-image-line"></i></div>
						<div class="item-info">
							<span class="status st-done">거래완료</span>
							<h4>아이폰 15 프로 미개봉 급매</h4>
							<span class="price">1,200,000원</span>
						</div>
					</div>
					<div class="list-item">
						<div class="item-thumb"><i class="ri-image-line"></i></div>
						<div class="item-info">
							<span class="status st-ing">예약중</span>
							<h4>나이키 에어포스 화이트 270</h4>
							<span class="price">85,000원</span>
						</div>
					</div>
				</div>
			</div>

		</main>
	</div>

	<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

	<script src="${pageContext.request.contextPath}/dist/js/header.js"></script>
</body>
</html>