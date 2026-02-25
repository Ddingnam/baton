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
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main.css?v=final">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage_left.css?v=final">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage_main.css?v=final">
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
						<h2 class="pb-name">${sessionScope.member.userName != null ? sessionScope.member.userName : '박바통'} 님</h2>
						<span class="pb-desc">서초4동 · 매너온도 <strong class="theme-text">36.5℃</strong></span>
					</div>
				</div>
				<div class="pb-right">
					<div class="pb-point">
						<span>보유 바통 포인트</span>
						<strong>12,500<span class="theme-text">P</span></strong>
					</div>
					<button class="theme-btn">충전하기</button>
				</div>
			</div>

			<div class="mp-tab-container">
				<ul class="mp-tabs" id="domain-tabs">
					<li class="tab-item active" data-target="sec-overview" data-color="#3182F6" data-bg="#E8F3FF">종합 요약</li>
					<li class="tab-item" data-target="sec-trade" data-color="#00B98D" data-bg="#E6F8F3">중고거래</li>
					<li class="tab-item" data-target="sec-club" data-color="#F86D7D" data-bg="#FFF0F1">동네모임</li>
					<li class="tab-item" data-target="sec-alba" data-color="#002C5F" data-bg="#F0F4F8">알바구인</li>
					<li class="tab-item" data-target="sec-comm" data-color="#8A63FF" data-bg="#F4F0FF">커뮤니티</li>
				</ul>
			</div>

			<div class="mp-content-area">
				
				<section id="sec-overview" class="mp-section active">
					<div class="stat-grid">
						<div class="stat-box"><span>판매/구매</span><strong>4 건</strong></div>
						<div class="stat-box"><span>참여 모임</span><strong>2 개</strong></div>
						<div class="stat-box"><span>지원 알바</span><strong>5 건</strong></div>
						<div class="stat-box"><span>작성한 글</span><strong>12 개</strong></div>
					</div>
					<div class="list-card">
						<div class="lc-header">
							<h3>최근 활동 내역</h3>
						</div>
						<div class="lc-list">
							<div class="lc-item">
								<div class="item-icon theme-icon-bg"><i class="ri-shopping-bag-3-fill"></i></div>
								<div class="item-info">
									<h4>아이폰 15 프로 미개봉 급매</h4>
									<p>중고구매 · 1시간 전</p>
								</div>
								<div class="item-status theme-badge">거래완료</div>
							</div>
							<div class="lc-item">
								<div class="item-icon theme-icon-bg"><i class="ri-team-fill"></i></div>
								<div class="item-info">
									<h4>주말 아침 한강 러닝크루</h4>
									<p>동네모임 · 2일 전</p>
								</div>
								<div class="item-status theme-badge">참여중</div>
							</div>
						</div>
					</div>
				</section>

				<section id="sec-trade" class="mp-section">
					<div class="list-card">
						<div class="lc-header">
							<h3>나의 거래 내역</h3>
							<a href="${pageContext.request.contextPath}/mypage/trade/buy" class="theme-link">전체보기</a>
						</div>
						<div class="lc-list">
							<div class="lc-item">
								<div class="item-thumb"><i class="ri-image-line"></i></div>
								<div class="item-info">
									<h4>나이키 에어포스 화이트 270</h4>
									<p>판매내역 · 1일 전</p>
								</div>
								<div class="item-right">
									<span class="theme-badge">예약중</span>
									<strong class="price">85,000원</strong>
								</div>
							</div>
							<div class="lc-item">
								<div class="item-thumb"><i class="ri-image-line"></i></div>
								<div class="item-info">
									<h4>애플워치 프로 2세대</h4>
									<p>관심목록 · 3일 전</p>
								</div>
								<div class="item-right">
									<span class="theme-badge" style="background:#F2F4F6; color:#6B7684;">판매중</span>
									<strong class="price">320,000원</strong>
								</div>
							</div>
						</div>
					</div>
				</section>

				<section id="sec-club" class="mp-section">
					<div class="list-card">
						<div class="lc-header">
							<h3>나의 모임 현황</h3>
							<a href="${pageContext.request.contextPath}/mypage/club/my" class="theme-link">전체보기</a>
						</div>
						<div class="lc-list">
							<div class="lc-item">
								<div class="item-icon theme-icon-bg"><i class="ri-book-open-fill"></i></div>
								<div class="item-info">
									<h4>강남역 직장인 독서모임</h4>
									<p>참여멤버 8명 · 다음주 수요일 모임</p>
								</div>
								<div class="item-right"><span class="theme-badge">주최자</span></div>
							</div>
						</div>
					</div>
				</section>

				<section id="sec-alba" class="mp-section">
					<div class="list-card">
						<div class="lc-header">
							<h3>지원한 알바 내역</h3>
							<a href="${pageContext.request.contextPath}/mypage/alba/apply" class="theme-link">전체보기</a>
						</div>
						<div class="lc-list">
							<div class="lc-item">
								<div class="item-info">
									<span class="corp-name theme-text">스타벅스 강남역점</span>
									<h4>주말 마감 파트타이머 구합니다</h4>
									<p>시급 11,000원 · 2월 24일 지원</p>
								</div>
								<div class="item-right"><span class="theme-badge-outline">열람대기</span></div>
							</div>
						</div>
					</div>
				</section>

				<section id="sec-comm" class="mp-section">
					<div class="list-card">
						<div class="lc-header">
							<h3>작성한 동네 이야기</h3>
							<a href="${pageContext.request.contextPath}/mypage/community/posts" class="theme-link">전체보기</a>
						</div>
						<div class="lc-list text-list">
							<div class="lc-item">
								<div class="item-info">
									<h4>강남역 근처 조용한 노트북 카페 추천해주세요!</h4>
									<p>동네질문 · 2시간 전</p>
								</div>
								<div class="item-right"><span class="reply-cnt theme-icon-bg">댓글 5</span></div>
							</div>
						</div>
					</div>
				</section>

			</div>
		</main>
	</div>

	<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
	
	<script>
		document.addEventListener("DOMContentLoaded", () => {
			const root = document.getElementById('mp-theme-root');
			const tabs = document.querySelectorAll('.tab-item');
			const sections = document.querySelectorAll('.mp-section');

			root.style.setProperty('--mp-theme', '#3182F6');
			root.style.setProperty('--mp-theme-bg', '#E8F3FF');

			tabs.forEach(tab => {
				tab.addEventListener('click', () => {
					tabs.forEach(t => t.classList.remove('active'));
					tab.classList.add('active');

					const color = tab.getAttribute('data-color');
					const bg = tab.getAttribute('data-bg');
					root.style.setProperty('--mp-theme', color);
					root.style.setProperty('--mp-theme-bg', bg);

					const targetId = tab.getAttribute('data-target');
					sections.forEach(sec => {
						sec.classList.remove('active');
						if(sec.id === targetId) {
							sec.classList.add('active');
						}
					});
				});
			});
		});
	</script>
</body>
</html>