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

	<aside class="mypage-sidebar">
		<div class="user-profile-section">
			<div class="user-avatar">
				<i class="ri-user-fill"></i>
			</div>
			<div class="user-meta">
				<span class="user-name">파란하늘 님</span> <span
					class="user-grade">매너온도 36.5℃</span>
			</div>
		</div>

		<nav class="mypage-nav">
			<h4>나의 거래</h4>
			<a href="/mypage/trade/buy" class="active"><i
				class="ri-shopping-bag-line"></i> 구매 내역</a> <a href="/mypage/trade/sell"><i
				class="ri-list-check"></i> 판매 내역</a> <a href="/mypage/trade/wish"><i
				class="ri-heart-line"></i> 관심 목록</a>

			<h4>나의 모임 (Club)</h4>
			<a href="/mypage/club/my"><i class="ri-team-line"></i> 참여 중인 모임</a> <a
				href="/mypage/club/host"><i class="ri-mickey-line"></i> 주최한 모임</a>

			<h4>나의 알바 (Job)</h4>
			<a href="/mypage/alba/apply"><i class="ri-article-line"></i> 지원
				현황</a> <a href="/mypage/alba/post"><i class="ri-building-line"></i>
				공고 관리</a>

			<h4>나의 활동</h4>
			<a href="/mypage/community/posts"><i class="ri-edit-line"></i>
				작성한 게시글</a> <a href="/mypage/community/replies"><i
				class="ri-chat-1-line"></i> 작성한 댓글</a>

			<h4>설정</h4>
			<a href="/member/pwd"><i class="ri-settings-3-line"></i> 내 정보 수정</a>
		</nav>
	</aside>

</body>
</html>
