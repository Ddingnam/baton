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
				<li><a href="javascript:void(0);" onclick="testRegionInfo()">
						<i class="ri-map-pin-line"></i> 동네 테스트
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
	
	<script>
	function testRegionInfo() {
	    const mainAddr = "${not empty member.userRegionInfo.mainRegion ? member.userRegionInfo.mainRegion.coreAddress : '미등록'}";
	    const subAddr = "${not empty member.userRegionInfo.subRegion ? member.userRegionInfo.subRegion.coreAddress : '미등록'}";
	    const activeAddr = "${not empty member.userRegionInfo.activeRegion ? member.userRegionInfo.activeRegion.coreAddress : '활성 동네 없음'}";
	    const activeType = "${member.userRegionInfo.activeType == 1 ? '주 동네' : (member.userRegionInfo.activeType == 2 ? '부 동네' : '미설정')}";

	    alert(
	        "--- [BATON 동네 정보] ---\n" +
	        "주 동네: " + mainAddr + "\n" +
	        "부 동네: " + subAddr + "\n\n" +
	        "현재 활성: " + activeAddr + " (" + activeType + ")"
	    );
	}
	</script>
</body>
</html>