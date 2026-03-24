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
			  <div class="resume-dashboard">
			    <a href="${pageContext.request.contextPath}/resume/myList"
			       class="resume-dashboard__count">
			      나의 이력서 <span class="resume-dashboard__number">${resumeCount}</span>개
			    </a>
			
			    <c:choose>
			      <c:when test="${resumeCount > 0}">
			        <a href="${pageContext.request.contextPath}/resume/myList"
			           class="resume-dashboard__state open">
			          이력서 관리하기
			        </a>
			      </c:when>
			      <c:otherwise>
			        <a href="${pageContext.request.contextPath}/resume/write"
			           class="resume-dashboard__state">
			          이력서 등록하기
			        </a>
			      </c:otherwise>
			    </c:choose>
			  </div>
			
			  <button class="btn-create-alba"
			          onclick="location.href='${pageContext.request.contextPath}/alba/write'">
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
                <input type="text" placeholder="지역명 검색  예) 서울, 서초구" />
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
                <ul class="col-list" id="col-dong"></ul>
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
            <input type="number" class="tl-price-input" id="minPayInput"
                   placeholder="최소 시급" value="${param.minPay}" />
            <button class="tl-price-apply" onclick="applyFilters()">적용</button>
          </div>
          <div class="action-group">
            <select class="detail-select sort-select" id="sortSelect" onchange="applyFilters()">
              <option value="latest"   ${param.sort == 'latest'   ? 'selected' : ''}>최신순</option>
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
                <c:choose>
                  <c:when test="${empty loginMember}">
                    로그인 필요
                  </c:when>
                  <c:when test="${not empty loginMember.userRegionInfo.activeRegion.sido}">
                    ${loginMember.userRegionInfo.activeRegion.sido}
                    ${loginMember.userRegionInfo.activeRegion.sigungu}
                    <span>${loginMember.userRegionInfo.activeRegion.dong}</span>
                  </c:when>
                  <c:when test="${not empty loginMember.userRegionInfo.mainRegion.sido}">
                    ${loginMember.userRegionInfo.mainRegion.sido}
                    ${loginMember.userRegionInfo.mainRegion.sigungu}
                    <span>${loginMember.userRegionInfo.mainRegion.dong}</span>
                  </c:when>
                  <c:otherwise>
                    <a href="${pageContext.request.contextPath}/member/regionAuth/main"
                       style="color:#ff6b6b; text-decoration:underline;">동네 인증하기</a>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>

            <div class="range-section">
              <div class="range-label-row">
                <span class="range-title">동네 범위</span>
                <span class="range-value" id="rangeValueLabel">내 동네</span>
              </div>
              <input type="range" class="range-slider" id="rangeSlider"
                     min="0" max="2" value="0" step="1" />
              <div class="range-steps">
                <span class="range-step active" data-step="0">내 동네</span>
                <span class="range-step" data-step="1">가까운 동네</span>
                <span class="range-step" data-step="2">먼 동네</span>
              </div>
            </div>

            <div class="filter-section" data-filter-type="period">
              <div class="filter-title">근무 기간</div>
              <div class="filter-chips">
                <button class="chip active" type="button" data-period="all">
                  <span class="chip-icon">📋</span> 전체
                </button>
                <button class="chip" type="button" data-period="long">
                  <span class="chip-icon">📅</span> 1개월 이상
                </button>
                <button class="chip" type="button" data-period="short">
                  <span class="chip-icon">⚡</span> 단기
                </button>
              </div>
            </div>

            <div class="sidebar-stat-box">
              <div class="stat-row">
                <span>모집 중</span>
				<strong><span id="sidebarResultCount">0</span>건</strong>
              </div>
            </div>

          </aside>

          <div class="content">
            <div class="content-header">
              <div class="result-count">
                채용정보 <span id="resultCount">0</span>건
              </div>
            </div>

            <div id="listView"></div>
            <div class="pagination" id="pagination"></div>
          </div>

        </div>
      </div>

    </div>
  </main>

  <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

  <script>
    const myRegion = {
      sido:  "${loginMember.userRegionInfo.activeRegion.sido}",
      gugun: "${loginMember.userRegionInfo.activeRegion.sigungu}",
      dong:  "${loginMember.userRegionInfo.activeRegion.dong}"
    };
  </script>

  <script>
    const CONTEXT_PATH = "${pageContext.request.contextPath}";
    
    let myScrapIds = [
        <c:forEach var="scrapId" items="${userScrapList}" varStatus="st">
          ${scrapId}${!st.last ? ',' : ''}
        </c:forEach>
      ];
    
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
        endTime:     `${dto.endTime}`,
        
        recruitStatus: `${dto.recruitStatus}`, 
        recruitStatusKor: `${dto.recruitStatusKor}`,
        
        isScrapped:  ${userScrapList != null && userScrapList.contains(dto.postingIdx) ? 1 : 0}        
      }${!status.last ? ',' : ''}
      </c:forEach>
    ];
  </script>

  <script src="${pageContext.request.contextPath}/dist/js/alba/alba-list.js"></script>
  
</body>
</html>
