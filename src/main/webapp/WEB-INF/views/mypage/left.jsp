<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<aside class="mp-sidebar">
	<div class="sb-header">
		<h2>MY PAGE</h2>
	</div>

	<nav class="sb-nav">
		<div class="sb-group">
			<span class="sb-label">관심 및 보관함</span> 
			<a href="${pageContext.request.contextPath}/mypage/trade/wish" class="sb-link"><i class="ri-heart-3-line"></i> 찜한 상품</a> 
			<a href="#" class="sb-link"><i class="ri-bookmark-line"></i> 저장한 글</a>
		</div>

		<div class="sb-group">
			<span class="sb-label">내 활동 관리</span> 
			<a href="#" class="sb-link"><i class="ri-coin-line"></i> 포인트 이용 내역</a> 
			<a href="#" class="sb-link"><i class="ri-star-line"></i> 받은 거래 후기</a> 
			<a href="#" class="sb-link"><i class="ri-star-line"></i> 보낸 거래 후기</a> 
			<a href="#" class="sb-link"><i class="ri-user-forbid-line"></i> 차단 사용자 관리</a>
		</div>

		<div class="sb-group">
			<span class="sb-label">알림 및 채팅</span> 
			<a href="#" class="sb-link"><i class="ri-notification-3-line"></i> 키워드 알림</a> 
			<a href="#" class="sb-link"><i class="ri-chat-1-line"></i> 채팅 내역</a>
		</div>

		<div class="sb-group">
			<span class="sb-label">내 정보 관리</span> 
			<a href="${pageContext.request.contextPath}/member/pwd" class="sb-link"><i class="ri-settings-4-line"></i> 회원정보 수정</a> 
			<a href="#" class="sb-link"><i class="ri-map-pin-line"></i> 동네 인증 설정</a>
		</div>
	</nav>
</aside>