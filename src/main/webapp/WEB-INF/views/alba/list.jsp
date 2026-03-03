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
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/alba-list.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/alba.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp" />
<div id="baton-layout-container">
  <main id="baton-main-content">
    <div class="baton-page">
      <aside class="baton-sidebar">
        <div class="sidebar-header">
          <div class="location-label"><i class="ri-map-pin-2-fill"></i> 현재 지역</div>
          <div class="location-name">서울 중구 <span>신당동</span></div>
        </div>
        <div class="filter-section">
          <div class="filter-title">근무 유형</div>
          <div class="filter-chips">
            <button class="chip active" type="button">전체</button>
            <button class="chip" type="button">1개월 이상</button>
            <button class="chip" type="button">단기</button>
          </div>
        </div>
        <div class="filter-section">
          <div class="filter-title">하는 일</div>
          <div class="filter-chips">
            <button class="chip" type="button">서빙</button>
            <button class="chip" type="button">주방보조</button>
            <button class="chip" type="button">매장관리</button>
            <button class="chip" type="button">음료제조</button>
            <button class="chip" type="button">청소</button>
            <button class="chip" type="button">편의점</button>
            <button class="chip" type="button">돌봄</button>
            <button class="chip" type="button">과외/레슨</button>
            <button class="chip" type="button">배달</button>
            <button class="chip" type="button">기타</button>
          </div>
        </div>
        <div class="filter-section">
          <div class="filter-title">근무 요일</div>
          <div class="day-chips">
            <button class="day-chip" type="button" data-day="MON">월</button>
            <button class="day-chip" type="button" data-day="TUE">화</button>
            <button class="day-chip" type="button" data-day="WED">수</button>
            <button class="day-chip" type="button" data-day="THU">목</button>
            <button class="day-chip" type="button" data-day="FRI">금</button>
            <button class="day-chip" type="button" data-day="SAT">토</button>
            <button class="day-chip" type="button" data-day="SUN">일</button>
          </div>
        </div>
        <div class="filter-section">
          <div class="filter-title">시급 최소</div>
          <div class="filter-chips">
            <button class="chip active" type="button">무관</button>
            <button class="chip" type="button">1만원+</button>
            <button class="chip" type="button">1.2만원+</button>
            <button class="chip" type="button">1.5만원+</button>
            <button class="chip" type="button">2만원+</button>
          </div>
        </div>
      </aside>

      <div class="content">
        <div class="search-bar">
          <div class="search-input-wrap">
            <i class="ri-search-line search-icon"></i>
            <input type="text" id="searchInput" class="search-input" placeholder="제목, 업체명, 태그 검색..." oninput="applyFilters()">
            <button class="search-clear" id="searchClear" onclick="clearSearch()" style="display:none">✕</button>
          </div>
        </div>

        <div class="popular-section">
          <div class="popular-title"><i class="ri-fire-fill" style="color:#ea580c;"></i> 인기 검색어</div>
          <div class="popular-chips">
            <span class="popular-chip" onclick="setSearch(this)">과외</span>
            <span class="popular-chip" onclick="setSearch(this)">소일거리</span>
            <span class="popular-chip" onclick="setSearch(this)">배달</span>
            <span class="popular-chip" onclick="setSearch(this)">등하원</span>
            <span class="popular-chip" onclick="setSearch(this)">주말알바</span>
            <span class="popular-chip" onclick="setSearch(this)">주방장</span>
            <span class="popular-chip" onclick="setSearch(this)">청소</span>
            <span class="popular-chip" onclick="setSearch(this)">꿀알바</span>
            <span class="popular-chip" onclick="setSearch(this)">당일지급</span>
          </div>
        </div>

        <div class="content-header">
          <div class="result-count">
            신당동 채용정보 <span id="resultCount">0</span>건
          </div>
          <div class="header-right">
            <select class="sort-select" id="sortSelect" onchange="applyFilters()">
              <option value="latest">최신순</option>
              <option value="pay_high">시급 높은순</option>
              <option value="deadline">마감 임박순</option>
            </select>
            <div class="view-toggle">
              <button class="view-btn active" id="btnTable" onclick="switchView('table')" title="리스트형 보기">
                <i class="ri-list-check"></i>
              </button>
              <button class="view-btn" id="btnCard" onclick="switchView('card')" title="카드형 보기">
                <i class="ri-layout-grid-line"></i>
              </button>
            </div>
          </div>
        </div>

        <div class="job-table-wrap" id="tableView">
          <table class="job-table">
            <thead>
              <tr>
                <th class="col-title">기업명 / 공고제목</th>
                <th class="col-area">근무지</th>
                <th class="col-time">근무시간</th>
                <th class="col-pay">급여</th>
                <th class="col-date">등록일</th>
              </tr>
            </thead>
            <tbody id="tableBody">
            </tbody>
          </table>
        </div>

        <div class="job-list" id="cardView">
        </div>

        <div class="pagination" id="pagination"></div>
      </div>
    </div>

    <a href="${pageContext.request.contextPath}/alba/write" class="fab">
      <i class="ri-pencil-line"></i> 공고 쓰기
    </a>
  </main>
</div>
<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
    const CONTEXT_PATH = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/dist/js/alba-list.js"></script>
</body>
</html>