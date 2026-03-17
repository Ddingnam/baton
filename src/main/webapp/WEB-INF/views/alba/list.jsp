<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ include file="/WEB-INF/views/layout/headerResources.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>동네 알바 | BATON PASS</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css" />
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main/main.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/alba/alba-list.css" />
</head>
<body>

	<jsp:include page="/WEB-INF/views/layout/header.jsp" />

	<main class="alba-main-container">

		<section class="alba-hero-section">
			<div class="container hero-inner">
				<div class="hero-text-box">
					<span class="sub-title">BATON ALBA</span>
					<h1 class="main-title">
						이웃과 함께하는 우리 동네 <span class="highlight">알바</span>
					</h1>
					<p class="desc">가까운 우리 동네 알바, 이웃과 함께 지금 바로 시작해보세요.</p>
				</div>
				<div class="hero-search-box">
					<input type="text" id="searchInput" placeholder="어떤 알바를 찾고 있나요?"
						value="${param.keyword}"
						onkeypress="if(event.keyCode==13) applyFilters();" />
					<button class="search-btn" onclick="applyFilters()">검색</button>
				</div>
			</div>
		</section>

		<div class="content-wrapper">

			<div class="alba-toolbar">
				<div class="toolbar-top">
					<div class="filter-group alba-filter-list filter-section" data-filter-type="category">
						<button class="filter-btn chip active" type="button">전체</button>
						<button class="filter-btn chip" type="button">서빙</button>
						<button class="filter-btn chip" type="button">주방보조</button>
						<button class="filter-btn chip" type="button">매장관리</button>
						<button class="filter-btn chip" type="button">음료제조</button>
						<button class="filter-btn chip" type="button">기타</button>
					</div>
					
					<div class="toolbar-top-actions">
					<c:if test="${resumeCount > 0}">
					    <button class="btn-create-resume" style="background-color: #f3f4f6; color: #333; border: 1px solid #ddd;" 
					            onclick="location.href='${pageContext.request.contextPath}/resume/myList'">
					        <i class="ri-user-smile-line"></i> 나의 이력서 <strong style="color: #ff6b6b;">${resumeCount}개</strong>
					    </button>
					</c:if>
    				
						<button class="btn-create-resume" onclick="location.href='${pageContext.request.contextPath}/resume/write'">
							<i class="ri-file-text-line"></i> 이력서 등록
						</button>
						<button class="btn-create-alba" onclick="location.href='${pageContext.request.contextPath}/alba/write'">
							<i class="ri-add-line"></i> 공고 등록하기
						</button>
					</div>
				</div>

				<div class="advanced-filter-wrap">
					<div class="filter-tab-group">
					
						<label class="filter-tab active"> 
							<input type="radio" name="filterTab" value="area" checked="checked" /> 
							<span>지역 <i class="ri-arrow-down-s-line"></i></span>
						</label> 
						<label class="filter-tab"> 
							<input type="radio" name="filterTab" value="category" /> 
							<span>업직종 <i class="ri-arrow-down-s-line"></i></span>
						</label> 
						<label class="filter-tab"> 
							<input type="radio" name="filterTab" value="period" /> 
							<span>근무기간 <i class="ri-arrow-down-s-line"></i></span>
						</label> 
						<label class="filter-tab"> 
							<input type="radio" name="filterTab" value="detail" /> 
							<span>상세조건 <i class="ri-arrow-down-s-line"></i></span>
						</label>
					</div>

					<div class="filter-body" id="filterAreaPanel">
						<div class="filter-body-header">
							<div class="filter-search-box">
								<i class="ri-search-line"></i> 
								<input type="text" placeholder="지역명 검색 예) 서울, 서초구" />
							</div>
							<div class="filter-options">
								<label class="filter-checkbox"> 
									<input type="checkbox" name="groupSimilar" /> 
									<span>유사동 묶기</span>
								</label>
								<div class="filter-counter">
									<span id="filterCount">0</span>/5
								</div>
							</div>
						</div>

						<div class="filter-columns">
							<div class="filter-col">
								<div class="col-title">시·도</div>
								<ul id="col-sido" class="col-list">
									<li>서울</li><li>경기</li><li>인천</li><li>강원</li>
									<li>대전</li><li>세종</li><li>충남</li><li>충북</li>
									<li>부산</li><li>울산</li><li>경남</li><li>경북</li>
									<li>대구</li><li>광주</li><li>전남</li><li>전북</li>
									<li>제주</li><li>전국</li>
								</ul>
							</div>
							<div class="filter-col">
								<div class="col-title">시·구·군</div>
								<ul class="col-list" id="col-gugun"></ul>
							</div>
							<div class="filter-col">
								<div class="col-title">동·읍·면</div>
								<ul class="col-list empty" id="col-dong"></ul>
							</div>
						</div>

						<div class="filter-footer">
							<button type="button" class="btn-reset" onclick="resetFilters()">
								<i class="ri-refresh-line"></i> 초기화
							</button>
						</div>
					</div>
				</div>

				<div class="toolbar-bottom">
					<div class="price-select-group">
						<input type="number" class="tl-price-input" id="minPayInput" placeholder="최소 시급" value="${param.minPay}" />
						<button class="tl-price-apply" onclick="applyFilters()">적용</button>
					</div>
					<div class="action-group">
						<select class="detail-select sort-select" id="sortSelect" onchange="applyFilters()">
							<option value="latest" ${param.sort == 'latest' ? 'selected' : ''}>최신순</option>
							<option value="pay_high" ${param.sort == 'pay_high' ? 'selected' : ''}>시급 높은순</option>
						</select>
					</div>
				</div>
			</div>

			<div id="alba-layout-container">
				<div class="baton-page">

					<aside class="baton-sidebar">
						<div class="sidebar-header">
							<div class="location-label">
								<i class="ri-map-pin-2-fill"></i> 현재 지역
							</div>
							<div class="location-name">
								<%-- 💡 동네 인증 분기 처리 --%>
								<c:choose>
									<c:when test="${empty sessionScope.member}">
										<a href="${pageContext.request.contextPath}/member/login" style="color: #3182f6; font-size: 15px; font-weight: 700; text-decoration: none;">
											로그인이 필요합니다 <i class="ri-arrow-right-s-line"></i>
										</a>
									</c:when>
									<c:when test="${empty sessionScope.member.userRegionInfo or empty sessionScope.member.userRegionInfo.activeRegion}">
										<a href="${pageContext.request.contextPath}/member/townAuth" style="color: #ff6b6b; font-size: 15px; font-weight: 700; text-decoration: none;">
											동네 인증하기 <i class="ri-map-pin-add-line"></i>
										</a>
									</c:when>
									<c:otherwise>
										${sessionScope.member.userRegionInfo.activeRegion.sido} 
										${sessionScope.member.userRegionInfo.activeRegion.sigungu} 
										<span>${sessionScope.member.userRegionInfo.activeRegion.dong}</span>
										<a href="${pageContext.request.contextPath}/member/townAuth" style="margin-left: 6px; font-size: 11px; color: #adb5bd; text-decoration: underline;">변경</a>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
						<div class="filter-section" data-filter-type="period">
							<div class="filter-title">근무 기간</div>
							<div class="filter-chips">
								<button class="chip active" type="button" data-period="all">전체</button>
								<button class="chip" type="button" data-period="long">1개월 이상</button>
								<button class="chip" type="button" data-period="short">단기</button>
							</div>
						</div>
					</aside>

					<div class="content">
						<div class="content-header">
							<div class="result-count">
								채용정보 <span id="resultCount">0</span>건
							</div>
						</div>

						<div class="list-title-bar">
							<span>지역</span> <span style="text-align: left;">모집제목 / 업체명</span>
							<span>급여</span> <span>근무시간</span> <span>등록일</span>
						</div>

						<div id="listView" class="job-list-container"></div>
						<div class="pagination" id="pagination"></div>
					</div>

				</div>
			</div>

		</div>
	</main>

	<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
const CONTEXT_PATH = "${pageContext.request.contextPath}";
const serverData = [
<c:forEach var="dto" items="${list}" varStatus="status">
{
  postingIdx:  "${dto.postingIdx}",
  title:       `${dto.title}`,
  employer:    `${empty dto.employer ? '업체명' : dto.employer}`,
  payType:     `${dto.payType}`,
  pay:         ${empty dto.pay ? 0 : dto.pay},
  location:    `${dto.location}`,
  createdDate: `${dto.createdDate}`,
  workPeriod:  `${dto.workPeriod}`,
  category:    `${dto.category}`,
  startTime:   `${dto.startTime}`,
  endTime:     `${dto.endTime}`
}${!status.last ? ',' : ''}
</c:forEach>
];
</script>
<script src="${pageContext.request.contextPath}/dist/js/alba/alba-list.js"></script>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const userSido = '${sessionScope.member.userRegionInfo.activeRegion.sido}' || ''; 
    const userGugun = '${sessionScope.member.userRegionInfo.activeRegion.sigungu}' || '';
    const userDong = '${sessionScope.member.userRegionInfo.activeRegion.dong}' || '';

    if (userSido && userGugun && userDong) {
        if (typeof applyAreaFilterAuto === 'function') {
            applyAreaFilterAuto(userSido, userGugun, userDong);
        }
    } else if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
            const lat = position.coords.latitude;
            const lon = position.coords.longitude;
            const geocoder = new kakao.maps.services.Geocoder();

            geocoder.coord2RegionCode(lon, lat, function(result, status) {
                if (status === kakao.maps.services.Status.OK) {
                    const addr = result.find(r => r.region_type === 'B');
                    if (addr && typeof applyAreaFilterAuto === 'function') {
                        applyAreaFilterAuto(addr.region_1depth_name, addr.region_2depth_name, addr.region_3depth_name);
                    }
                }
            });
        });
    }
});
</script>
</body>
</html>