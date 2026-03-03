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
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/alba-list.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp" />
<section class="alba-hero">
  <div class="alba-hero-inner">
    <p class="sub-title">BATON PASS · 동네 알바</p>
    <h1 class="main-title">우리 동네 <span class="highlight">알바</span>를<br>한 눈에 찾아보세요</h1>
    <p class="desc">내 근처 단기·장기 알바, 지금 바로 지원해보세요</p>
    <div class="alba-search-box">
      <i class="ri-search-line" style="font-size:20px; color:#B0B8C1; margin-right:4px;"></i>
      <input type="text" id="searchInput" placeholder="업체명 또는 공고 제목 검색" oninput="applyFilters()">
      <button class="search-btn" onclick="applyFilters()">검색</button>
    </div>
    <div class="quick-tags-wrap">
      <span class="tag-label">🔥 많이 찾아요</span>
      <button class="quick-tag" onclick="setQuickSearch('당일지급')">#당일지급</button>
      <button class="quick-tag" onclick="setQuickSearch('초보가능')">#초보가능</button>
      <button class="quick-tag" onclick="setQuickSearch('대학가')">#대학가근처</button>
      <button class="quick-tag" onclick="setQuickSearch('주휴수당')">#주휴수당</button>
    </div>
  </div>
</section>
<div id="baton-layout-container">
  <main id="baton-main-content">
    <div class="baton-page">
      <aside class="baton-sidebar">
        <div class="sidebar-header">
          <div class="location-label"><i class="ri-map-pin-2-fill"></i> 현재 지역</div>
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
        <div class="filter-section" data-filter-type="category">
          <div class="filter-title">직종 카테고리</div>
          <div class="filter-chips">
            <button class="chip active" type="button">전체</button>
            <button class="chip" type="button" data-cat="SERVING">서빙</button>
            <button class="chip" type="button" data-cat="KITCHEN">주방보조</button>
            <button class="chip" type="button" data-cat="SHOP">매장관리</button>
            <button class="chip" type="button" data-cat="BEVERAGE">음료제조</button>
          </div>
        </div>
        <div class="filter-section" data-filter-type="pay">
          <div class="filter-title">최소 시급</div>
          <div class="filter-chips">
            <button class="chip active" type="button">무관</button>
            <button class="chip" type="button">1만원 이상</button>
          </div>
        </div>
      </aside>
      <div class="content">
        <div class="content-header">
          <div class="result-count">채용정보 <span id="resultCount">0</span>건</div>
          <div class="header-right">
            <select class="sort-select" id="sortSelect" onchange="applyFilters()">
              <option value="latest">최신순</option>
              <option value="pay_high">시급 높은순</option>
            </select>
            <div class="view-toggle">
              <button class="view-btn active" id="btnTable" onclick="switchView('table')">
                <i class="ri-list-check"></i>
              </button>
              <button class="view-btn" id="btnCard" onclick="switchView('card')">
                <i class="ri-layout-grid-line"></i>
              </button>
            </div>
          </div>
        </div>
        <div id="tableView" class="job-container">
          <table class="job-table">
            <thead>
              <tr>
                <th>공고내용</th>
                <th>지역 / 근무시간</th>
                <th>급여</th>
                <th>등록일</th>
              </tr>
            </thead>
            <tbody id="tableBody"></tbody>
          </table>
        </div>
        <div id="cardView" class="job-grid hidden"></div>
        <div class="pagination" id="pagination"></div>
      </div>
    </div>
    <a href="${pageContext.request.contextPath}/alba/write" class="fab">
      <i class="ri-pencil-fill"></i> 공고 등록하기
    </a>
  </main>
</div>
<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
<script>
const CONTEXT_PATH = "${pageContext.request.contextPath}";
const serverData = [
<c:forEach var="dto" items="${list}" varStatus="status">
{
  id: "${dto.postingIdx}",
  title: `${dto.title}`,
  employer: `${empty dto.employer ? '업체명' : dto.employer}`,
  payType: "${dto.payType}",
  payTypeKey: "${dto.payType == '시급' ? 'hour' : 'month'}",
  payNum: ${empty dto.pay ? 0 : dto.pay},
  payFmt: new Intl.NumberFormat('ko-KR').format(${empty dto.pay ? 0 : dto.pay}),
  days: "${dto.workDays}",
  time: `${empty dto.workTime ? '시간협의' : dto.workTime}`,
  area: "${dto.location}",
  date: "${dto.createdDate}",
  img: "${empty dto.thumbUrl ? '' : dto.thumbUrl}"
}${!status.last ? ',' : ''}
</c:forEach>
];
</script>
<script src="${pageContext.request.contextPath}/dist/js/alba-list.js"></script>
</body>
</html>