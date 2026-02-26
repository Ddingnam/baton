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
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main.css">
<style>
:root {
  --baton-blue:    #1e3a8a;
  --baton-blue-lt: #eff6ff;
  --baton-blue-dk: #172554;
  --baton-title:   #111827;
  --baton-body:    #374151;
  --baton-muted:   #6b7280;
  --baton-border:  #e5e7eb;
  --baton-bg:      #f3f4f6;
  --baton-white:   #ffffff;
  --baton-green:   #059669;
  --baton-orange:  #ea580c;
  --r:             12px;
  --shadow-sm:     0 1px 4px rgba(0,0,0,.06);
  --shadow-md:     0 4px 20px rgba(0,0,0,.10);
}
* { box-sizing: border-box; margin: 0; padding: 0; }
body { background: var(--baton-bg); font-family: 'Pretendard', sans-serif; color: var(--baton-body); font-size: 15px; }

.baton-page {
  display: grid;
  grid-template-columns: 250px 1fr;
  gap: 30px;
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 20px 120px;
  align-items: start;
}

.baton-sidebar {
  position: sticky;
  top: 80px;
  background: var(--baton-white);
  border-radius: var(--r);
  border: 1px solid var(--baton-border);
  overflow: hidden;
  box-shadow: var(--shadow-sm);
}
.sidebar-header {
  padding: 24px 20px;
  border-bottom: 1px solid var(--baton-border);
  background: var(--baton-blue-lt);
}
.location-label {
  font-size: 13px; font-weight: 600; color: var(--baton-blue);
  letter-spacing: .04em; margin-bottom: 8px;
  display: flex; align-items: center; gap: 4px;
}
.location-name { font-size: 20px; font-weight: 800; color: var(--baton-title); }
.location-name span { color: var(--baton-blue); }
.filter-section { padding: 20px; border-bottom: 1px solid var(--baton-border); }
.filter-section:last-child { border-bottom: none; }
.filter-title { font-size: 13px; font-weight: 700; color: var(--baton-muted); margin-bottom: 12px; letter-spacing: .04em; }
.filter-chips { display: flex; flex-wrap: wrap; gap: 6px; }
.chip {
  padding: 8px 14px; border-radius: 20px;
  border: 1.5px solid var(--baton-border);
  font-size: 14px; font-weight: 600; color: var(--baton-muted);
  cursor: pointer; transition: all .15s; background: var(--baton-white); font-family: inherit;
}
.chip:hover { border-color: var(--baton-blue); color: var(--baton-blue); background: var(--baton-blue-lt); }
.chip.active { border-color: var(--baton-blue); background: var(--baton-blue); color: #fff; }
.day-chips { display: flex; gap: 4px; }
.day-chip {
  flex: 1; text-align: center; padding: 8px 0; border-radius: 8px;
  border: 1.5px solid var(--baton-border); font-size: 14px; font-weight: 700;
  color: var(--baton-muted); cursor: pointer; transition: all .15s;
  background: var(--baton-white); font-family: inherit;
}
.day-chip:hover { border-color: var(--baton-blue); color: var(--baton-blue); }
.day-chip.active { background: var(--baton-blue); border-color: var(--baton-blue); color: #fff; }

.search-bar { margin-bottom: 16px; }
.search-input-wrap {
  position: relative; display: flex; align-items: center;
  background: var(--baton-white); border: 1.5px solid var(--baton-border);
  border-radius: var(--r); overflow: hidden; height: 56px;
  transition: border-color .15s;
}
.search-input-wrap:focus-within { border-color: var(--baton-blue); }
.search-icon { position: absolute; left: 16px; color: var(--baton-muted); font-size: 22px; }
.search-input {
  flex: 1; padding: 12px 40px 12px 46px; border: none; outline: none;
  font-family: inherit; font-size: 16px; background: transparent; color: var(--baton-body);
}
.search-clear {
  position: absolute; right: 12px; background: none; border: none;
  cursor: pointer; color: var(--baton-muted); font-size: 16px; padding: 6px;
}

.popular-section {
  background: var(--baton-white); border: 1px solid var(--baton-border);
  border-radius: var(--r); padding: 20px 24px; margin-bottom: 20px; box-shadow: var(--shadow-sm);
}
.popular-title { font-size: 14px; font-weight: 700; color: var(--baton-muted); margin-bottom: 12px; }
.popular-chips { display: flex; flex-wrap: wrap; gap: 8px; }
.popular-chip {
  padding: 8px 16px; border-radius: 20px; background: var(--baton-blue-lt);
  border: 1.5px solid #dbeafe; font-size: 14px; font-weight: 700; color: var(--baton-blue);
  cursor: pointer; transition: all .15s;
}
.popular-chip:hover { background: var(--baton-blue); color: #fff; border-color: var(--baton-blue); }

.content-header {
  display: flex; align-items: center; justify-content: space-between; margin-bottom: 12px;
}
.result-count { font-size: 18px; font-weight: 800; color: var(--baton-title); }
.result-count span { color: var(--baton-blue); }
.header-right { display: flex; align-items: center; gap: 10px; }
.sort-select {
  border: 1.5px solid var(--baton-border); border-radius: 8px;
  padding: 8px 30px 8px 14px; font-family: inherit; font-size: 14px; height: 40px;
  font-weight: 600; color: var(--baton-muted); background: var(--baton-white)
    url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%236b7280' d='M6 8L1 3h10z'/%3E%3C/svg%3E")
    no-repeat right 10px center; appearance: none; cursor: pointer;
}
.view-toggle { display: flex; gap: 4px; }
.view-btn {
  width: 40px; height: 40px; border-radius: 8px; border: 1.5px solid var(--baton-border);
  background: var(--baton-white); cursor: pointer; display: flex; align-items: center;
  justify-content: center; color: var(--baton-muted); font-size: 18px; transition: all .15s;
}
.view-btn.active { border-color: var(--baton-blue); background: var(--baton-blue-lt); color: var(--baton-blue); }

/* ── 우측 아이콘 공통 버튼 (수정됨: 얇고 연한 회색) ── */
.icon-btn {
  display: inline-flex; align-items: center; justify-content: center;
  background: none; border: none; padding: 4px;
  font-size: 19px; /* 크기를 약간 줄여 얇은 느낌 강조 */
  color: #9ca3af; /* 기존보다 훨씬 연한 회색 */
  cursor: pointer; transition: color .15s, transform .15s; text-decoration: none; outline: none;
}
.icon-btn:hover { color: var(--baton-blue); transform: scale(1.1); }
.icon-btn.scrap.liked { color: #f59e0b; }
.icon-btn.scrap:hover { color: #f59e0b; }

.action-icons { display: flex; gap: 6px; }
.action-icons.vertical { flex-direction: column; gap: 4px; }

/* ════════════════════════════════════════
   TABLE VIEW (수정됨: 테이블 헤더 중앙 정렬 반영)
════════════════════════════════════════ */
.job-table-wrap {
  background: var(--baton-white); border: 1px solid var(--baton-border);
  border-radius: var(--r); overflow: hidden; box-shadow: var(--shadow-sm);
}
.job-table {
  width: 100%; border-collapse: collapse;
}
.job-table thead th {
  background: #f9fafb; padding: 16px 20px;
  font-size: 14px; font-weight: 700; color: var(--baton-muted);
  border-bottom: 1px solid var(--baton-border);
  white-space: nowrap;
}
/* 헤더와 셀 정렬 맞춤 */
.job-table thead th.col-title { width: auto; text-align: left; }
.job-table thead th.col-area { width: 110px; text-align: center; }
.job-table thead th.col-time { width: 130px; text-align: center; }
.job-table thead th.col-pay  { width: 130px; text-align: center; }
.job-table thead th.col-date { width: 140px; text-align: center; }

.job-table tbody tr {
  border-bottom: 1px solid var(--baton-border);
  cursor: pointer; transition: background .12s;
  animation: fadeUp .3s ease both;
}
.job-table tbody tr:last-child { border-bottom: none; }
.job-table tbody tr:hover { background: #f8fafc; }

@keyframes fadeUp {
  from { opacity: 0; transform: translateY(6px); }
  to   { opacity: 1; transform: translateY(0); }
}

.td-date {
  padding: 24px 10px; vertical-align: middle; text-align: center;
  font-size: 14px; color: var(--baton-muted); white-space: nowrap;
}
.date-cell-wrap { display: flex; align-items: center; justify-content: center; gap: 14px; }
.date-col-left { display: flex; flex-direction: column; align-items: center; }
.td-date .new { color: var(--baton-blue); font-weight: 700; }
.td-date .summary-btn {
  display: block; margin: 8px auto 0; font-size: 13px; color: var(--baton-blue);
  background: var(--baton-blue-lt); border: none; border-radius: 4px;
  padding: 4px 10px; cursor: pointer; font-family: inherit; font-weight: 600;
}
.td-date .summary-btn:hover { background: var(--baton-blue); color: #fff; }

.td-title { padding: 24px 20px; vertical-align: middle; text-align: left; }
.title-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 4px; }
.company-nm {
  font-size: 13px; color: var(--baton-muted); margin-bottom: 6px;
  display: flex; align-items: center; gap: 6px; flex-wrap: wrap;
}
.job-title-text {
  font-size: 16px; font-weight: 700; color: var(--baton-title);
  white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 440px;
  display: block; text-decoration: none; margin-bottom: 8px;
  line-height: 1.4;
}
.job-title-text:hover { color: var(--baton-blue); text-decoration: underline; }
.tag-row { display: flex; flex-wrap: wrap; gap: 5px; }
.job-tag {
  padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: 700;
  background: #f3f4f6; color: var(--baton-muted);
}
.job-tag.green  { background: #d1fae5; color: var(--baton-green); }
.job-tag.blue   { background: var(--baton-blue-lt); color: var(--baton-blue); }
.job-tag.orange { background: #ffedd5; color: var(--baton-orange); }

.td-area { padding: 24px 20px; vertical-align: middle; font-size: 15px; color: var(--baton-body); white-space: nowrap; text-align: center; }
.td-time { padding: 24px 20px; vertical-align: middle; font-size: 15px; color: var(--baton-body); line-height: 1.5; text-align: center; }
.time-consult { color: var(--baton-blue); font-weight: 700; }
.td-pay { padding: 24px 20px; vertical-align: middle; white-space: nowrap; text-align: center; }
.pay-type-badge {
  display: inline-block; font-size: 12px; font-weight: 700; padding: 4px 6px;
  border-radius: 4px; margin-right: 6px; vertical-align: middle;
}
.pay-type-badge.hour   { background: #dbeafe; color: var(--baton-blue); }
.pay-type-badge.day    { background: #ffedd5; color: var(--baton-orange); }
.pay-type-badge.week   { background: #d1fae5; color: var(--baton-green); }
.pay-type-badge.month  { background: #f3e8ff; color: #7c3aed; }
.pay-type-badge.year   { background: #fef3c7; color: #b45309; }
.pay-num { font-size: 16px; font-weight: 800; color: var(--baton-title); vertical-align: middle; }

/* ════════════════════════════════════════
   CARD VIEW (그리드형 카드 레이아웃 적용)
════════════════════════════════════════ */
.job-list {
  display: none; 
  grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
  gap: 20px;
}
.job-list.visible { display: grid; }
.job-table-wrap.hidden { display: none; }

.job-card {
  display: flex; flex-direction: column;
  padding: 24px; background: var(--baton-white); 
  border: 1px solid var(--baton-border); border-radius: var(--r); 
  box-shadow: var(--shadow-sm);
  text-decoration: none; color: inherit; cursor: pointer;
  transition: transform .2s, box-shadow .2s, border-color .2s;
  animation: fadeUp .3s ease both;
}
.job-card:hover { 
  transform: translateY(-4px); 
  box-shadow: var(--shadow-md); 
  border-color: var(--baton-blue);
}

.card-header {
  display: flex; justify-content: space-between; align-items: flex-start; width: 100%; margin-bottom: 16px;
}
.card-header-left {
  display: flex; align-items: center; gap: 12px;
}
.job-card .job-thumb {
  width: 48px; height: 48px; border-radius: 8px; background: var(--baton-blue-lt);
  border: 1px solid var(--baton-border); flex-shrink: 0; overflow: hidden;
  display: flex; align-items: center; justify-content: center; font-size: 20px;
}
.job-card .job-thumb img { width: 100%; height: 100%; object-fit: cover; display: block; }
.job-card .job-employer { font-size: 13px; font-weight: 600; color: var(--baton-muted); margin: 0; }
.job-card .job-date { font-size: 12px; color: var(--baton-muted); margin-top: 4px; }

.job-card .job-title-text { 
  font-size: 18px; font-weight: 700; color: var(--baton-title); margin-bottom: 12px;
  line-height: 1.4; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; 
  overflow: hidden; text-overflow: ellipsis; white-space: normal;
}
.job-card .job-pay-row { 
  font-size: 18px; font-weight: 800; color: var(--baton-title); 
  margin-bottom: 8px; display: flex; align-items: center; gap: 6px; 
}
.job-card .job-schedule { 
  font-size: 14px; color: var(--baton-body); margin-bottom: 20px;
  display: flex; align-items: center; gap: 6px; 
}
.card-footer { 
  display: flex; justify-content: space-between; align-items: flex-end; width: 100%; margin-top: auto; 
}

.no-result {
  grid-column: 1 / -1;
  padding: 80px 20px; text-align: center; color: var(--baton-muted);
}
.no-result-icon { font-size: 48px; margin-bottom: 16px; }
.no-result strong { display: block; font-size: 18px; font-weight: 700; color: var(--baton-title); margin-bottom: 8px; }

/* ── FAB 공고쓰기 ── */
.fab {
  position: fixed; bottom: 111px; right: 40px;
  background: var(--baton-blue); color: #ffffff !important;
  border: none; border-radius: 50px; padding: 16px 26px;
  font-family: inherit; font-size: 16px; font-weight: 700;
  cursor: pointer; text-decoration: none; display: flex; align-items: center; gap: 8px;
  box-shadow: 0 4px 18px rgba(30,58,138,.45); transition: all .2s; z-index: 50;
}
.fab:hover { transform: translateY(-3px); box-shadow: 0 8px 28px rgba(30,58,138,.55); color: #fff; color: #ffffff !important;}

.pagination {
  display: flex; align-items: center; justify-content: center;
  gap: 8px; padding: 30px 0;
}
.page-btn {
  min-width: 40px; height: 40px; border-radius: 8px;
  border: 1.5px solid var(--baton-border); background: var(--baton-white);
  font-family: inherit; font-size: 15px; font-weight: 600; color: var(--baton-muted);
  cursor: pointer; display: flex; align-items: center; justify-content: center;
  transition: all .15s; padding: 0 8px;
}
.page-btn:hover { border-color: var(--baton-blue); color: var(--baton-blue); background: var(--baton-blue-lt); }
.page-btn.active { background: var(--baton-blue); border-color: var(--baton-blue); color: #fff; }
.page-btn:disabled { opacity: .4; cursor: not-allowed; }

@media (max-width: 900px) {
  .baton-page { grid-template-columns: 1fr; padding: 20px 16px 80px; }
  .baton-sidebar { position: static; }
  .col-area, .col-time { display: none; }
  .td-area, .td-time { display: none; }
  .job-list { grid-template-columns: 1fr; }
  .fab { bottom: 20px; right: 20px; padding: 14px 20px; font-size: 14px; }
}
</style>
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
const DUMMY_JOBS = [
  { id:1,  title:'서빙 및 간단 조리 매니저 구함',         employer:'약수상회',          payType:'시급', payTypeKey:'hour', payNum:12000, payFmt:'12,000',  days:'월~토',        dayVals:['MON','TUE','WED','THU','FRI','SAT'], time:'18:00~23:00', area:'서울 중구',     date:'오늘',   dateOrder:0, isNew:true,  tags:[{label:'모범구인',cls:'blue'}],                                                         img:'https://images.unsplash.com/photo-1514190051997-0f6f39ca5cde?w=200&q=80', cat:'SERVING',            period:'MORE_THAN_A_MONTH' },
  { id:2,  title:'어린이집 조리보조 단기 근무자 대모집',   employer:'햇살어린이집',      payType:'일급', payTypeKey:'day',  payNum:80000, payFmt:'80,000',  days:'총 18일',      dayVals:['MON','TUE','WED','THU','FRI'],       time:'08:30~15:00', area:'서울 중구',     date:'오늘',   dateOrder:0, isNew:true,  tags:[{label:'당일지급',cls:'green'},{label:'모범구인',cls:'blue'},{label:'후기 24',cls:'blue'}],  img:'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&q=80', cat:'KITCHEN_ASSISTANCE', period:'LESS_THAN_A_MONTH' },
  { id:3,  title:'누존 도매매장 야간 매장 알바 (동대문)',  employer:'주식회사 모즈패션', payType:'시급', payTypeKey:'hour', payNum:15000, payFmt:'15,000',  days:'월~금',        dayVals:['MON','TUE','WED','THU','FRI'],       time:'23:30~03:30', area:'서울 중구',     date:'1일 전', dateOrder:1, isNew:false, tags:[{label:'고수익',cls:'orange'},{label:'모범구인',cls:'blue'}],                              img:'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=200&q=80', cat:'SHOP_MANAGEMENT',    period:'MORE_THAN_A_MONTH' },
  { id:4,  title:'동대문 종합시장 키링매장 1일 단기 알바', employer:'릴리데이지',        payType:'일급', payTypeKey:'day',  payNum:88000, payFmt:'88,000',  days:'2월 28일(토)', dayVals:['SAT'],                               time:'09:00~18:00', area:'서울 중구',     date:'오늘',   dateOrder:0, isNew:true,  tags:[{label:'당일지급',cls:'green'}],                                                         img:'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=200&q=80', cat:'SHOP_MANAGEMENT',    period:'LESS_THAN_A_MONTH' },
  { id:5,  title:'버터앤빈 메인 바리스타 정규직 모집',     employer:'버터앤빈 카페',     payType:'연봉', payTypeKey:'year', payNum:2600,  payFmt:'2,600만', days:'수~일',        dayVals:['WED','THU','FRI','SAT','SUN'],       time:'12:00~21:00', area:'서울 성동구',   date:'5일 전', dateOrder:5, isNew:false, tags:[{label:'모범구인',cls:'blue'}],                                                          img:'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=200&q=80', cat:'BEVERAGE_MAKING',    period:'MORE_THAN_A_MONTH' },
  { id:6,  title:'학교 급식도우미 고정 및 프리랜서 채용',  employer:'이웃알바',          payType:'시급', payTypeKey:'hour', payNum:12570, payFmt:'12,570',  days:'월~금',        dayVals:['MON','TUE','WED','THU','FRI'],       time:'협의',        area:'서울 중구',     date:'2일 전', dateOrder:2, isNew:false, tags:[{label:'후기 13',cls:'blue'}],                                                          img:'https://images.unsplash.com/photo-1567521464027-f127ff144326?w=200&q=80', cat:'KITCHEN_ASSISTANCE', period:'MORE_THAN_A_MONTH' },
  { id:7,  title:'7세 남아 하원도우미 구합니다',           employer:'이웃알바',          payType:'시급', payTypeKey:'hour', payNum:17000, payFmt:'17,000',  days:'월~금',        dayVals:['MON','TUE','WED','THU','FRI'],       time:'협의',        area:'서울 중구',     date:'오늘',   dateOrder:0, isNew:true,  tags:[{label:'고수익',cls:'orange'}],                                                          img:'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=200&q=80', cat:'CHILD_CARE',         period:'MORE_THAN_A_MONTH' },
  { id:8,  title:'뚜레쥬르 신당역점 월·목 마감조 알바',   employer:'뚜레쥬르 신당역점', payType:'시급', payTypeKey:'hour', payNum:12000, payFmt:'12,000',  days:'월, 목',       dayVals:['MON','THU'],                         time:'18:00~22:00', area:'서울 중구',     date:'오늘',   dateOrder:0, isNew:true,  tags:[{label:'후기 1',cls:'blue'}],                                                            img:'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=200&q=80', cat:'SHOP_MANAGEMENT',    period:'MORE_THAN_A_MONTH' },
  { id:9,  title:'성동공업고등학교 주방보조 여사님',       employer:'(주)정오아카데미',  payType:'시급', payTypeKey:'hour', payNum:13000, payFmt:'13,000',  days:'월~금',        dayVals:['MON','TUE','WED','THU','FRI'],       time:'08:00~17:00', area:'서울 성동구',   date:'3일 전', dateOrder:3, isNew:false, tags:[{label:'모범구인',cls:'blue'},{label:'후기 24',cls:'blue'}],                               img:'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=200&q=80', cat:'KITCHEN_ASSISTANCE', period:'MORE_THAN_A_MONTH' },
  { id:10, title:'소셜링 진행자 / 현장 스텝 모집',         employer:'더파티',            payType:'월급', payTypeKey:'month',payNum:100,   payFmt:'100만',   days:'월, 금, 토',   dayVals:['MON','FRI','SAT'],                   time:'18:00~23:30', area:'서울 중구',     date:'오늘',   dateOrder:0, isNew:true,  tags:[],                                                                                       img:'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=200&q=80', cat:'ETC',                period:'MORE_THAN_A_MONTH' },
  { id:11, title:'빽다방 약수시장점 평일 마감파트 구함',   employer:'빽다방',            payType:'시급', payTypeKey:'hour', payNum:10320, payFmt:'10,320',  days:'월~금',        dayVals:['MON','TUE','WED','THU','FRI'],       time:'18:00~20:30', area:'서울 중구',     date:'오늘',   dateOrder:0, isNew:true,  tags:[],                                                                                       img:'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=200&q=80', cat:'BEVERAGE_MAKING',    period:'MORE_THAN_A_MONTH' },
  { id:12, title:'재활용품 수거 및 운반 업무 (야간)',      employer:'사울서울',          payType:'월급', payTypeKey:'month',payNum:4500,  payFmt:'450만',   days:'월~금',        dayVals:['MON','TUE','WED','THU','FRI'],       time:'22:00~05:00', area:'서울 중구',     date:'4일 전', dateOrder:4, isNew:false, tags:[{label:'후기 8',cls:'blue'}],                                                            img:'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=200&q=80', cat:'ETC',                period:'MORE_THAN_A_MONTH' },
];

const CAT_MAP = {
  '서빙':'SERVING','주방보조':'KITCHEN_ASSISTANCE','매장관리':'SHOP_MANAGEMENT',
  '음료제조':'BEVERAGE_MAKING','청소':'CLEANING','편의점':'CONVENIENCE_STORE',
  '돌봄':'CHILD_CARE','과외/레슨':'TUTORING','배달':'ETC','기타':'ETC'
};
const MIN_PAY_MAP = { '무관':0,'1만원+':10000,'1.2만원+':12000,'1.5만원+':15000,'2만원+':20000 };

let liked = new Set();
let currentView = 'table'; 
let currentPage = 1;
const PAGE_SIZE = 10;
let filteredJobs = [];

function switchView(v) {
  currentView = v;
  document.getElementById('tableView').classList.toggle('hidden', v !== 'table');
  document.getElementById('cardView').classList.toggle('visible', v === 'card');
  document.getElementById('btnTable').classList.toggle('active', v === 'table');
  document.getElementById('btnCard').classList.toggle('active', v === 'card');
  renderCurrentPage();
}

function applyFilters() {
  const keyword  = document.getElementById('searchInput').value.trim().toLowerCase();
  document.getElementById('searchClear').style.display = keyword ? 'block' : 'none';

  const periodEl = document.querySelector('.filter-section:nth-child(1) .chip.active');
  const period   = periodEl ? periodEl.textContent.trim() : '전체';
  const catEl    = document.querySelector('.filter-section:nth-child(2) .chip.active');
  const cat      = catEl ? catEl.textContent.trim() : '전체';
  const activeDays = [...document.querySelectorAll('.day-chip.active')].map(c => c.dataset.day);
  const minPayEl = document.querySelector('.filter-section:nth-child(4) .chip.active');
  const minPay   = minPayEl ? (MIN_PAY_MAP[minPayEl.textContent.trim()] ?? 0) : 0;
  const sort     = document.getElementById('sortSelect').value;

  let jobs = [...DUMMY_JOBS];
  if (keyword) jobs = jobs.filter(j =>
    j.title.toLowerCase().includes(keyword) ||
    j.employer.toLowerCase().includes(keyword) ||
    j.tags.some(t => t.label.toLowerCase().includes(keyword))
  );
  if (period === '1개월 이상') jobs = jobs.filter(j => j.period === 'MORE_THAN_A_MONTH');
  if (period === '단기')       jobs = jobs.filter(j => j.period === 'LESS_THAN_A_MONTH');
  if (cat !== '전체' && CAT_MAP[cat]) jobs = jobs.filter(j => j.cat === CAT_MAP[cat]);
  if (activeDays.length > 0) jobs = jobs.filter(j => activeDays.every(d => j.dayVals.includes(d)));
  if (minPay > 0) jobs = jobs.filter(j => j.payTypeKey !== 'hour' || j.payNum >= minPay);

  if (sort === 'pay_high') jobs.sort((a,b) => b.payNum - a.payNum);
  else                     jobs.sort((a,b) => a.dateOrder - b.dateOrder);

  filteredJobs = jobs;
  currentPage = 1;
  document.getElementById('resultCount').textContent = jobs.length;
  renderCurrentPage();
  renderPagination();
}

function renderCurrentPage() {
  const start = (currentPage - 1) * PAGE_SIZE;
  const pageJobs = filteredJobs.slice(start, start + PAGE_SIZE);
  if (currentView === 'table') renderTable(pageJobs);
  else                         renderCards(pageJobs);
}

function renderTable(jobs) {
  const tbody = document.getElementById('tableBody');
  if (!jobs.length) {
    tbody.innerHTML = `<tr><td colspan="5"><div class="no-result">
      <div class="no-result-icon">🔍</div>
      <strong>검색 결과가 없어요</strong>
      조건을 바꿔보거나 검색어를 다시 입력해보세요.
    </div></td></tr>`;
    return;
  }
  tbody.innerHTML = jobs.map((job, idx) => {
    const tagsHtml = job.tags.map(t => `<span class="job-tag \${t.cls}">\${t.label}</span>`).join('');
    const isLiked  = liked.has(job.id);
    const dateHtml = job.isNew
      ? `<strong class="new">\${job.date}</strong>`
      : `<span>\${job.date}</span>`;
    const timeHtml = (job.time === '협의')
      ? `<span class="time-consult">시간협의</span>`
      : job.time;
      
    return `
      <tr style="animation-delay:\${idx * 0.035}s" onclick="location.href='#job-\${job.id}'">
        <td class="td-title">
          <div class="company-nm">\${job.employer}</div>
          <a class="job-title-text" href="#job-\${job.id}" onclick="event.stopPropagation()">\${job.title}</a>
          <div class="tag-row">\${tagsHtml}</div>
        </td>
        <td class="td-area">\${job.area}</td>
        <td class="td-time">\${timeHtml}<br><small style="color:#adb5bd;font-size:13px;margin-top:2px;display:inline-block;">\${job.days}</small></td>
        <td class="td-pay">
          <span class="pay-type-badge \${job.payTypeKey}">\${job.payType}</span>
          <span class="pay-num">\${job.payFmt}원</span>
        </td>
        <td class="td-date">
          <div class="date-cell-wrap">
            <div class="date-col-left">
              \${dateHtml}
              <button class="summary-btn" onclick="event.stopPropagation();alert('요약보기: \${job.title.replace(/'/g,'&#39;')}')">요약보기</button>
            </div>
            <div class="action-icons vertical" onclick="event.stopPropagation()">
              <button class="icon-btn scrap \${isLiked ? 'liked' : ''}" type="button" onclick="toggleLike(event,this,\${job.id})" title="스크랩">
                <i class="\${isLiked ? 'ri-star-fill' : 'ri-star-line'}"></i>
              </button>
              <a href="${pageContext.request.contextPath}/baton/posting/article?postingIdx=\${job.id}" class="icon-btn view" target="_blank" title="새창보기">
                <i class="ri-external-link-line"></i>
              </a>
            </div>
          </div>
        </td>
      </tr>`;
  }).join('');
}

function renderCards(jobs) {
  const list = document.getElementById('cardView');
  if (!jobs.length) {
    list.innerHTML = `<div class="no-result" style="grid-column: 1 / -1;">
      <div class="no-result-icon">🔍</div>
      <strong>검색 결과가 없어요</strong>
      조건을 바꿔보거나 검색어를 다시 입력해보세요.
    </div>`;
    return;
  }
  list.innerHTML = jobs.map((job, idx) => {
    const tagsHtml = job.tags.map(t => `<span class="job-tag \${t.cls}">\${t.label}</span>`).join('');
    const isLiked  = liked.has(job.id);
    
    return `
      <div class="job-card" onclick="location.href='${pageContext.request.contextPath}/baton/posting/article?postingIdx=\${job.id}'" style="animation-delay:\${idx * 0.04}s">
        <div class="card-header">
          <div class="card-header-left">
            <div class="job-thumb">
              <img src="\${job.img}" alt="\${job.title}" onerror="this.parentNode.innerHTML='💼'">
            </div>
            <div>
              <div class="job-employer">\${job.employer}</div>
              <div class="job-date">\${job.date}</div>
            </div>
          </div>
          <div class="action-icons" onclick="event.stopPropagation()">
            <button class="icon-btn scrap \${isLiked ? 'liked' : ''}" type="button" onclick="toggleLike(event,this,\${job.id})" title="스크랩">
              <i class="\${isLiked ? 'ri-star-fill' : 'ri-star-line'}"></i>
            </button>
            <a href="${pageContext.request.contextPath}/baton/posting/article?postingIdx=\${job.id}" class="icon-btn view" target="_blank" title="새창보기">
              <i class="ri-external-link-line"></i>
            </a>
          </div>
        </div>
        <div class="job-title-text">\${job.title}</div>
        <div class="job-pay-row">
          <span class="pay-type-badge \${job.payTypeKey}">\${job.payType}</span>\${job.payFmt}원
        </div>
        <div class="job-schedule"><i class="ri-time-line" style="color:var(--baton-muted)"></i>&nbsp;\${job.area} · \${job.days} · \${job.time}</div>
        <div class="card-footer">
          <div class="tag-row">\${tagsHtml}</div>
        </div>
      </div>`;
  }).join('');
}

function renderPagination() {
  const total = Math.ceil(filteredJobs.length / PAGE_SIZE);
  const pg = document.getElementById('pagination');
  if (total <= 1) { pg.innerHTML = ''; return; }

  let html = `<button class="page-btn" onclick="goPage(\${currentPage-1})" \${currentPage===1?'disabled':''}><i class="ri-arrow-left-s-line"></i></button>`;
  const start = Math.max(1, currentPage-4), end = Math.min(total, start+9);
  for (let i = start; i <= end; i++) {
    html += `<button class="page-btn \${i===currentPage?'active':''}" onclick="goPage(\${i})">\${i}</button>`;
  }
  html += `<button class="page-btn" onclick="goPage(\${currentPage+1})" \${currentPage===total?'disabled':''}><i class="ri-arrow-right-s-line"></i></button>`;
  pg.innerHTML = html;
}

function goPage(p) {
  const total = Math.ceil(filteredJobs.length / PAGE_SIZE);
  if (p < 1 || p > total) return;
  currentPage = p;
  renderCurrentPage();
  renderPagination();
  window.scrollTo({ top: 0, behavior: 'smooth' });
}

function toggleLike(e, btn, id) {
  e.preventDefault(); e.stopPropagation();
  const icon = btn.querySelector('i');
  if (liked.has(id)) {
    liked.delete(id); 
    btn.classList.remove('liked'); 
    icon.className = 'ri-star-line';
  } else {
    liked.add(id); 
    btn.classList.add('liked'); 
    icon.className = 'ri-star-fill';
    btn.style.transform = 'scale(1.1)';
    setTimeout(() => btn.style.transform = '', 150);
  }
}

function clearSearch() {
  document.getElementById('searchInput').value = '';
  document.getElementById('searchClear').style.display = 'none';
  applyFilters();
}

function setSearch(el) {
  document.getElementById('searchInput').value = el.textContent.trim();
  document.getElementById('searchClear').style.display = 'block';
  applyFilters();
  document.getElementById('searchInput').focus();
}

document.querySelectorAll('.filter-section .filter-chips').forEach(group => {
  group.querySelectorAll('.chip').forEach(chip => {
    chip.addEventListener('click', function() {
      group.querySelectorAll('.chip').forEach(c => c.classList.remove('active'));
      this.classList.add('active');
      applyFilters();
    });
  });
});

document.querySelectorAll('.day-chip').forEach(chip => {
  chip.addEventListener('click', function() { this.classList.toggle('active'); applyFilters(); });
});

applyFilters();
</script>
</body>
</html>