<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BATON | Left</title>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/layout/left.css">
<link
	href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css"
	rel="stylesheet">
</head>
<body>
	<aside id="baton-left">
		<div class="sidebar-toggle-trigger" onclick="handleSidebar()">
			<i class="ri-arrow-left-s-line"></i>
		</div>

		<div class="sidebar-menu">
			<p class="menu-label">메뉴</p>
			<ul>
				<li class="active"><a
					href="${pageContext.request.contextPath}/"> <i
						class="ri-home-5-line"></i> 홈
				</a></li>
				<li><a href="${pageContext.request.contextPath}/trade/list">
						<i class="ri-shopping-bag-line"></i> 중고거래
				</a></li>
				<li><a href="${pageContext.request.contextPath}/crew/main">
						<i class="ri-team-line"></i> 동네모임
				</a></li>
				<li><a href="${pageContext.request.contextPath}/alba/list">
						<i class="ri-briefcase-line"></i> 알바·구인
				</a></li>
				<li><a href="${pageContext.request.contextPath}/community/list">
						<i class="ri-discuss-line"></i> 커뮤니티
				</a></li>
			</ul>
		</div>
		<div class="sidebar-setting"
			style="margin-top: 24px; padding: 20px 15px; border-top: 1px solid #f2f4f6;">
			<div
				style="display: flex; align-items: center; justify-content: space-between;">
				<span
					style="font-size: 14px; color: #4E5968; font-weight: 700; letter-spacing: -0.3px;">인트로
					효과</span> <label class="premium-switch"> <input type="checkbox"
					id="intro-toggle"> <span class="premium-slider"></span>
				</label>
			</div>
		</div>
	</aside>

	<div id="baton-sidebar-open" class="sidebar-show-btn"
		onclick="handleSidebar()">
		<i class="ri-menu-unfold-line"></i>
	</div>

	<script src="${pageContext.request.contextPath}/dist/js/layout/left.js"></script>
</body>
</html>