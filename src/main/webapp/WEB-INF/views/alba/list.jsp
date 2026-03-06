<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/WEB-INF/views/layout/headerResources.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>동네 알바 | BATON PASS</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main/main.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/alba/alba-list.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<main class="alba-main-container">

    <%-- ===== HERO ===== --%>
    <section class="alba-hero-section">
        <div class="container hero-inner">
            <div class="hero-text-box">
                <span class="sub-title">BATON ALBA</span>
                <h1 class="main-title">이웃과 함께하는 우리 동네 <span class="highlight">알바</span></h1>
                <p class="desc">가까운 우리 동네 알바, 이웃과 함께 지금 바로 시작해보세요.</p>
            </div>
            <div class="hero-search-box">
                <input type="text" id="searchInput"
                       placeholder="어떤 알바를 찾고 있나요?"
                       value="${param.keyword}"
                       onkeypress="if(event.keyCode==13) applyFilters();">
                <button class="search-btn" onclick="applyFilters()">검색</button>
            </div>
        </div>
    </section>

    <div class="content-wrapper">

        <%-- ===== TOOLBAR ===== --%>
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
                <button class="btn-create-alba"
                        onclick="location.href='${pageContext.request.contextPath}/alba/write'">
                    <i class="ri-add-line"></i> 공고 등록하기
                </button>
            </div>

            <div class="toolbar-bottom">
                <div class="price-select-group">
                    <input type="number" class="tl-price-input" id="minPayInput"
                           placeholder="최소 시급" value="${param.minPay}">
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

        <%-- ===== LAYOUT ===== --%>
        <div id="alba-layout-container">
            <div class="baton-page">

                <%-- 사이드바 --%>
                <aside class="baton-sidebar">
                    <div class="sidebar-header">
                        <div class="location-label">
                            <i class="ri-map-pin-2-fill"></i> 현재 지역
                        </div>
                        <div class="location-name">서울 중구 <span>신당동</span></div>
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

                <%-- 메인 콘텐츠 --%>
                <div class="content">
                    <div class="content-header">
                        <div class="result-count">
                            채용정보 <span id="resultCount">0</span>건
                        </div>
                    </div>

                    <div class="list-title-bar">
                        <span>지역</span>
                        <span style="text-align:left;">모집제목 / 업체명</span>
                        <span>급여</span>
                        <span>근무시간</span>
                        <span>등록일</span>
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
  id:         "${dto.postingIdx}",
  title:      `${dto.title}`,
  employer:   `${empty dto.employer ? '업체명' : dto.employer}`,
  payType:    `${dto.payType}`,
  payTypeKey: `${dto.payType == '시급' ? 'hour' : (dto.payType == '월급' ? 'month' : (dto.payType == '일급' ? 'day' : 'case'))}`,
  payNum:     ${empty dto.pay ? 0 : dto.pay},
  payFmt:     new Intl.NumberFormat('ko-KR').format(${empty dto.pay ? 0 : dto.pay}),
  days:       `${dto.workDays}`,
  time:       `${empty dto.workTime ? '시간협의' : dto.workTime}`,
  area:       `${dto.location}`,
  date:       `${dto.createdDate}`,
  img:        `${empty dto.thumbUrl ? '' : dto.thumbUrl}`,
  period:     `${dto.workPeriod}`,
  cat:        `${dto.category}`
}${!status.last ? ',' : ''}
</c:forEach>
];
</script>
<script src="${pageContext.request.contextPath}/dist/js/alba/alba-list.js"></script>
</body>
</html>
