<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>BATON | 마이페이지</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
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
						<strong>12,500<span class="theme-text">P</span></strong>
					</div>
					<button class="theme-btn">충전하기</button>
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
							<div class="stat-icon theme-icon-bg"><i class="ri-shopping-bag-3-line"></i></div>
							<strong>4 건</strong>
							<span>판매/구매</span>
						</div>
						<div class="stat-box">
							<div class="stat-icon theme-icon-bg"><i class="ri-team-line"></i></div>
							<strong>2 개</strong>
							<span>참여 모임</span>
						</div>
						<div class="stat-box">
							<div class="stat-icon theme-icon-bg"><i class="ri-briefcase-4-line"></i></div>
							<strong>5 건</strong>
							<span>지원 알바</span>
						</div>
						<div class="stat-box">
							<div class="stat-icon theme-icon-bg"><i class="ri-edit-2-line"></i></div>
							<strong>12 개</strong>
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
							<div class="lc-item">
								<div class="item-icon theme-icon-bg"><i class="ri-chat-3-fill"></i></div>
								<div class="item-info">
									<h4>강남역 근처 조용한 노트북 카페 추천해주세요!</h4>
									<p class="info-metrics">커뮤니티 · 2시간 전 · 댓글 5</p>
								</div>
								<div class="item-right"><span class="theme-badge">동네질문</span></div>
							</div>
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
							<button class="inner-tab"        data-inner="trade-buy">구매내역</button>
							<button class="inner-tab"        data-inner="trade-wish">찜목록</button>
						</div>

						<div class="inner-section active" id="trade-sell">
							<div class="lc-list">
								<div class="lc-item">
									<div class="item-thumb"><i class="ri-image-line"></i></div>
									<div class="item-info">
										<h4>나이키 에어포스 화이트 270</h4>
										<p class="info-metrics">판매중 · 1일 전 · 조회 42</p>
									</div>
									<div class="item-right">
										<span class="theme-badge">예약중</span>
										<strong class="price">85,000원</strong>
									</div>
								</div>
								<div class="lc-item">
									<div class="item-thumb"><i class="ri-image-line"></i></div>
									<div class="item-info">
										<h4>다이슨 에어랩 스타일러 컴플리트</h4>
										<p class="info-metrics">판매중 · 3일 전 · 조회 128</p>
									</div>
									<div class="item-right">
										<span class="theme-badge">판매중</span>
										<strong class="price">320,000원</strong>
									</div>
								</div>
								<div class="lc-item">
									<div class="item-thumb"><i class="ri-image-line"></i></div>
									<div class="item-info">
										<h4>맥북 에어 M2 스페이스그레이 256GB</h4>
										<p class="info-metrics">거래완료 · 2주 전 · 조회 87</p>
									</div>
									<div class="item-right">
										<span style="background:#F2F4F6;color:#8B95A1;padding:6px 12px;border-radius:8px;font-size:13px;font-weight:700;">거래완료</span>
										<strong class="price">980,000원</strong>
									</div>
								</div>
							</div>
						</div>

						<div class="inner-section" id="trade-buy">
							<div class="lc-list">
								<div class="lc-item">
									<div class="item-thumb"><i class="ri-image-line"></i></div>
									<div class="item-info">
										<h4>아이폰 15 프로 미개봉 급매</h4>
										<p class="info-metrics">거래완료 · 1시간 전</p>
									</div>
									<div class="item-right">
										<span class="theme-badge">거래완료</span>
										<strong class="price">1,050,000원</strong>
									</div>
								</div>
								<div class="lc-item">
									<div class="item-thumb"><i class="ri-image-line"></i></div>
									<div class="item-info">
										<h4>무인양품 오크 협탁</h4>
										<p class="info-metrics">거래완료 · 5일 전</p>
									</div>
									<div class="item-right">
										<span style="background:#F2F4F6;color:#8B95A1;padding:6px 12px;border-radius:8px;font-size:13px;font-weight:700;">거래완료</span>
										<strong class="price">45,000원</strong>
									</div>
								</div>
							</div>
						</div>

						<div class="inner-section" id="trade-wish">
							<div class="lc-list">
								<div class="lc-item">
									<div class="item-thumb"><i class="ri-image-line"></i></div>
									<div class="item-info">
										<h4>애플워치 울트라 2세대</h4>
										<p class="info-metrics">판매중 · 서초동</p>
										<div class="price-drop"><i class="ri-arrow-down-s-fill"></i> 20,000원 인하</div>
									</div>
									<div class="item-right">
										<strong class="price">620,000원</strong>
									</div>
								</div>
								<div class="lc-item">
									<div class="item-thumb"><i class="ri-image-line"></i></div>
									<div class="item-info">
										<h4>소니 WH-1000XM5 노이즈캔슬링</h4>
										<p class="info-metrics">판매중 · 강남동</p>
									</div>
									<div class="item-right">
										<strong class="price">280,000원</strong>
									</div>
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
						</div>

						<div class="inner-section active" id="comm-posts">
							<div class="lc-list">
								<div class="lc-item">
									<div class="item-info">
										<span class="corp-name theme-text">동네질문</span>
										<h4>강남역 근처 조용한 노트북 카페 추천해주세요!</h4>
										<div class="comm-stats">
											<span><i class="ri-eye-line"></i> 234</span>
											<span><i class="ri-chat-3-line"></i> 댓글 5</span>
											<span><i class="ri-heart-3-line"></i> 12</span>
											<span>2시간 전</span>
										</div>
									</div>
								</div>
								<div class="lc-item">
									<div class="item-info">
										<span class="corp-name theme-text">생활정보</span>
										<h4>서초동 새벽 분리수거 요일 변경됐나요?</h4>
										<div class="comm-stats">
											<span><i class="ri-eye-line"></i> 88</span>
											<span><i class="ri-chat-3-line"></i> 댓글 3</span>
											<span><i class="ri-heart-3-line"></i> 4</span>
											<span>1일 전</span>
										</div>
									</div>
								</div>
								<div class="lc-item">
									<div class="item-info">
										<span class="corp-name theme-text">동네맛집</span>
										<h4>교대역 점심 맛집 공유해요 (직접 가본 곳만)</h4>
										<div class="comm-stats">
											<span><i class="ri-eye-line"></i> 512</span>
											<span><i class="ri-chat-3-line"></i> 댓글 22</span>
											<span><i class="ri-heart-3-line"></i> 67</span>
											<span>3일 전</span>
										</div>
									</div>
								</div>
							</div>
						</div>

						<div class="inner-section" id="comm-comments">
							<div class="lc-list">
								<div class="lc-item">
									<div class="item-info">
										<h4>서초동 헬스장 추천 부탁드려요</h4>
										<p class="info-metrics">내 댓글: "더케이 스포렉스 강추예요! 시설도 좋고 가격도 합리적이에요"</p>
										<div class="comm-stats"><span>1일 전</span></div>
									</div>
								</div>
								<div class="lc-item">
									<div class="item-info">
										<h4>한강 러닝 같이 하실 분 구해요</h4>
										<p class="info-metrics">내 댓글: "저도 관심있어요! 쪽지 보내도 될까요?"</p>
										<div class="comm-stats"><span>4일 전</span></div>
									</div>
								</div>
							</div>
						</div>

						<div class="inner-section" id="comm-saved">
							<div class="lc-list">
								<div class="lc-item">
									<div class="item-info">
										<span class="corp-name theme-text">생활정보</span>
										<h4>서초구 복지관 무료 프로그램 총정리 (2025)</h4>
										<div class="comm-stats"><span>2일 전 저장</span></div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</section>

			</div>
		</main>
	</div>

	<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
	<script src="${pageContext.request.contextPath}/dist/js/mypage_main.js"></script>
	<script>
	document.querySelectorAll('.inner-tab').forEach(tab => {
		tab.addEventListener('click', function() {
			const card = this.closest('.list-card');
			card.querySelectorAll('.inner-tab').forEach(t => t.classList.remove('active'));
			card.querySelectorAll('.inner-section').forEach(s => s.classList.remove('active'));
			this.classList.add('active');
			const target = this.getAttribute('data-inner');
			const sec = document.getElementById(target);
			if (sec) sec.classList.add('active');
		});
	});
	</script>
</body>
</html>