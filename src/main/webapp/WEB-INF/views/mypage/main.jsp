<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
</head>
<body>

	<div id="baton-layout-container" class="mypage-mode">
		<jsp:include page="/WEB-INF/views/mypage/left.jsp" />

		<main class="mypage-main-content">
			<div class="mypage-main-card" style="margin-bottom: 24px;">
				<div class="section-header">
					<h2>활동 요약</h2>
				</div>
				<div
					style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px;">
					<div class="stat-item">
						<span class="label">판매중</span> <span class="value">3</span>
					</div>
					<div class="stat-item">
						<span class="label">참여 모임</span> <span class="value"
							style="color: #F86D7D;">2</span>
					</div>
					<div class="stat-item">
						<span class="label">지원한 알바</span> <span class="value"
							style="color: #00B98D;">5</span>
					</div>
					<div class="stat-item">
						<span class="label">바통 포인트</span> <span class="value"
							style="color: #3182F6;">12,500P</span>
					</div>
				</div>
			</div>

			<div class="mypage-main-card">
				<div class="section-header">
					<h2>최근 구매 내역</h2>
					<a href="/mypage/trade/buy"
						style="font-size: 14px; color: #8B95A1;">더보기 ></a>
				</div>

				<div class="data-list">
					<div class="list-item"
						style="display: flex; gap: 16px; padding: 16px 0; border-bottom: 1px solid #F2F4F6;">
						<div
							style="width: 80px; height: 80px; background: #F2F4F6; border-radius: 12px;"></div>
						<div style="flex: 1;">
							<span style="font-size: 13px; color: #8B95A1;">거래완료</span>
							<h4 style="margin: 4px 0; font-size: 16px;">아이폰 15 프로 미개봉 급매</h4>
							<span style="font-weight: 700;">1,200,000원</span>
						</div>
					</div>
				</div>
			</div>
		</main>
	</div>

</body>
</html>
