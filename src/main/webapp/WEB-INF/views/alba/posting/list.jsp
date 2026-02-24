<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>신당동 알바 | BATON 동네마켓</title>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/main.css">
<style>
  :root {
    --orange: #FF6F0F;
    --orange-light: #FFF3EB;
    --orange-mid: #FFD6B8;
    --bg: #F7F7F7;
    --white: #ffffff;
    --text: #212121;
    --sub: #636363;
    --muted: #9E9E9E;
    --border: #E8E8E8;
    --tag-bg: #F2F2F2;
    --badge-green: #00B84C;
    --badge-blue: #1A73E8;
    --shadow: 0 1px 4px rgba(0,0,0,.08);
    --shadow-hover: 0 4px 20px rgba(0,0,0,.12);
    --r: 12px;
  }

  * { box-sizing: border-box; margin: 0; padding: 0; }

  .alba-page {
    display: grid;
    grid-template-columns: 240px 1fr;
    gap: 24px;
    align-items: start;
    font-family: 'Noto Sans KR', sans-serif;
    max-width: 1080px;
    margin: 0 auto;
    padding: 28px 20px 80px;
  }

  /* ── SIDEBAR ── */
  .alba-sidebar {
    position: sticky;
    top: 100px;
    background: var(--white);
    border-radius: var(--r);
    border: 1px solid var(--border);
    overflow: hidden;
  }
  .sidebar-header { padding: 20px 20px 14px; border-bottom: 1px solid var(--border); }
  .location-label { font-size: 11px; font-weight: 600; color: var(--muted); letter-spacing: .05em; margin-bottom: 6px; }
  .location-name { font-size: 18px; font-weight: 800; display: flex; align-items: center; gap: 6px; }
  .location-name span { color: var(--orange); }

  .filter-section { padding: 16px 20px; border-bottom: 1px solid var(--border); }
  .filter-section:last-child { border-bottom: none; }
  .filter-title { font-size: 12px; font-weight: 700; color: var(--muted); margin-bottom: 12px; letter-spacing: .04em; }
  .filter-chips { display: flex; flex-wrap: wrap; gap: 6px; }
  .chip {
    padding: 5px 11px; border-radius: 20px; border: 1.5px solid var(--border);
    font-size: 12px; font-weight: 500; color: var(--sub); cursor: pointer;
    transition: all .15s; background: var(--white); font-family: inherit;
  }
  .chip:hover, .chip.active { border-color: var(--orange); background: var(--orange-light); color: var(--orange); font-weight: 700; }

  .day-chips { display: flex; gap: 4px; }
  .day-chip {
    flex: 1; text-align: center; padding: 6px 2px; border-radius: 8px;
    border: 1.5px solid var(--border); font-size: 12px; font-weight: 600;
    color: var(--sub); cursor: pointer; transition: all .15s; background: var(--white); font-family: inherit;
  }
  .day-chip:hover, .day-chip.active { border-color: var(--orange); background: var(--orange-light); color: var(--orange); }

  /* ── POPULAR ── */
  .popular-section {
    background: var(--white); border-radius: var(--r); border: 1px solid var(--border);
    padding: 18px 20px; margin-bottom: 16px;
  }
  .popular-title { font-size: 12px; font-weight: 700; color: var(--muted); margin-bottom: 12px; }
  .popular-chips { display: flex; flex-wrap: wrap; gap: 6px; }
  .popular-chip {
    padding: 5px 12px; border-radius: 20px; border: 1.5px solid var(--orange-mid);
    background: var(--orange-light); font-size: 12px; font-weight: 600;
    color: var(--orange); cursor: pointer; transition: all .15s;
  }
  .popular-chip:hover { background: var(--orange); color: white; }

  /* ── CONTENT HEADER ── */
  .content-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px; }
  .result-count { font-size: 15px; font-weight: 700; color: var(--text); }
  .result-count span { color: var(--orange); }
  .sort-select {
    border: 1.5px solid var(--border); border-radius: 8px; padding: 6px 28px 6px 12px;
    font-family: inherit; font-size: 13px; font-weight: 500; color: var(--sub);
    background: var(--white) url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%239e9e9e' d='M6 8L1 3h10z'/%3E%3C/svg%3E") no-repeat right 10px center;
    appearance: none; cursor: pointer;
  }

  /* ── JOB CARDS ── */
  .job-list { display: flex; flex-direction: column; gap: 12px; }

  .job-card {
    background: var(--white); border: 1px solid var(--border); border-radius: var(--r);
    padding: 20px; display: flex; gap: 16px; cursor: pointer;
    transition: all .18s; text-decoration: none; color: inherit;
    animation: fadeUp .35s ease both;
  }
  .job-card:hover { border-color: #d0d0d0; box-shadow: var(--shadow-hover); transform: translateY(-2px); }

  @keyframes fadeUp {
    from { opacity: 0; transform: translateY(10px); }
    to   { opacity: 1; transform: translateY(0); }
  }

  .job-thumb {
    width: 80px; height: 80px; border-radius: 10px;
    background: var(--orange-light); border: 1px solid var(--border);
    flex-shrink: 0; overflow: hidden;
    display: flex; align-items: center; justify-content: center; font-size: 28px;
  }
  .job-thumb img { width: 100%; height: 100%; object-fit: cover; display: block; }

  .job-info { flex: 1; min-width: 0; }
  .job-title { font-size: 15px; font-weight: 700; line-height: 1.3; margin-bottom: 4px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
  .job-employer { font-size: 12px; color: var(--muted); margin-bottom: 8px; }
  .job-pay { font-size: 14px; font-weight: 700; color: var(--text); margin-bottom: 4px; }
  .job-pay .pay-type { font-size: 12px; font-weight: 500; color: var(--sub); margin-right: 4px; }
  .job-schedule { font-size: 12px; color: var(--sub); margin-bottom: 10px; }
  .job-tags { display: flex; flex-wrap: wrap; gap: 5px; }
  .job-tag { padding: 3px 8px; border-radius: 5px; background: var(--tag-bg); font-size: 11px; font-weight: 600; color: var(--sub); }
  .job-tag.green { background: #E6F7EE; color: var(--badge-green); }
  .job-tag.orange { background: var(--orange-light); color: var(--orange); }
  .job-tag.blue { background: #E8F0FE; color: var(--badge-blue); }

  .job-meta { display: flex; flex-direction: column; align-items: flex-end; gap: 6px; flex-shrink: 0; }
  .job-location { font-size: 11px; color: var(--muted); }
  .job-date { font-size: 11px; color: var(--muted); }
  .heart-btn {
    background: none; border: none; cursor: pointer; font-size: 20px;
    color: #D0D0D0; transition: all .15s; padding: 2px; line-height: 1;
  }
  .heart-btn:hover { transform: scale(1.2); }
  .heart-btn.liked { color: #FF4B4B; }

  /* 빈 상태 */
  .empty-state { text-align: center; padding: 60px 20px; color: var(--muted); }
  .empty-state .empty-icon { font-size: 48px; margin-bottom: 16px; }
  .empty-state p { font-size: 15px; font-weight: 500; }
  .empty-state small { font-size: 13px; margin-top: 8px; display: block; }

  /* FAB */
  .fab {
    position: fixed; bottom: 40px; right: 40px;
    background: var(--orange); color: white; border: none; border-radius: 50px;
    padding: 14px 22px; font-family: inherit; font-size: 15px; font-weight: 700;
    cursor: pointer; box-shadow: 0 4px 16px rgba(255,111,15,.4);
    transition: all .2s; z-index: 50; text-decoration: none;
    display: flex; align-items: center; gap: 8px;
  }
  .fab:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(255,111,15,.5); color: white; }

  /* 더보기 */
  .load-more {
    width: 100%; margin-top: 8px; padding: 14px;
    border: 1.5px solid var(--border); border-radius: var(--r);
    background: var(--white); font-family: inherit; font-size: 14px;
    font-weight: 600; color: var(--sub); cursor: pointer; transition: all .15s;
  }
  .load-more:hover { border-color: var(--orange); color: var(--orange); background: var(--orange-light); }

  @media (max-width: 720px) {
    .alba-page { grid-template-columns: 1fr; padding: 16px; }
    .alba-sidebar { position: static; }
  }
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div id="baton-layout-container">
  <main id="baton-main-content">

    <div class="alba-page">

      <!-- ── 사이드바 필터 ── -->
      <aside class="alba-sidebar">
        <div class="sidebar-header">
          <div class="location-label">📍 현재 지역</div>
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
            <button class="day-chip" type="button">월</button>
            <button class="day-chip" type="button">화</button>
            <button class="day-chip" type="button">수</button>
            <button class="day-chip" type="button">목</button>
            <button class="day-chip" type="button">금</button>
            <button class="day-chip" type="button">토</button>
            <button class="day-chip" type="button">일</button>
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

      <!-- ── 메인 콘텐츠 ── -->
      <div class="content">

        <!-- 인기 검색어 -->
        <div class="popular-section">
          <div class="popular-title">🔥 인기 검색어</div>
          <div class="popular-chips">
            <span class="popular-chip">과외</span>
            <span class="popular-chip">소일거리</span>
            <span class="popular-chip">배달</span>
            <span class="popular-chip">등하원</span>
            <span class="popular-chip">주말알바</span>
            <span class="popular-chip">주방장</span>
            <span class="popular-chip">청소</span>
            <span class="popular-chip">꿀알바</span>
            <span class="popular-chip">당일지급</span>
          </div>
        </div>

        <div class="content-header">
          <div class="result-count">
            신당동 알바
            <%-- 실제 DB 데이터가 있으면 dataCount, 없으면 가데이터 개수 표시 --%>
            <span>
              <c:choose>
                <c:when test="${not empty list}"><c:out value="${dataCount}"/></c:when>
                <c:otherwise>15</c:otherwise>
              </c:choose>
            </span>개
          </div>
          <select class="sort-select">
            <option>최신순</option>
            <option>시급 높은순</option>
            <option>마감 임박순</option>
          </select>
        </div>

        <div class="job-list" id="jobList">

          <%-- ══ 실제 DB 데이터 (list가 있을 때) ══ --%>
          <c:if test="${not empty list}">
            <c:forEach var="item" items="${list}" varStatus="st">
              <a class="job-card"
                 href="${pageContext.request.contextPath}/alba/posting/article?postingIdx=${item.postingIdx}"
                 style="animation-delay:${st.index * 0.05}s">
                <div class="job-thumb">
                  <c:choose>
                    <c:when test="${not empty item.thumbUrl}">
                      <img src="${item.thumbUrl}" alt="${item.title}" onerror="this.parentNode.innerHTML='🥕'">
                    </c:when>
                    <c:otherwise>🥕</c:otherwise>
                  </c:choose>
                </div>
                <div class="job-info">
                  <div class="job-title">${item.title}</div>
                  <div class="job-employer">${not empty item.employer ? item.employer : '동네 사장님'}</div>
                  <div class="job-pay">
                    <span class="pay-type">시급</span>
                    <fmt:formatNumber value="${item.pay}" pattern="#,###"/>원
                  </div>
                  <div class="job-schedule">${item.workDays} · ${item.workTime}</div>
                  <div class="job-tags">
                    <c:if test="${item.pay >= 15000}"><span class="job-tag orange">고수익</span></c:if>
                    <c:if test="${item.sameDay eq 'Y'}"><span class="job-tag green">당일지급</span></c:if>
                    <c:if test="${item.goodEmployer eq 'Y'}"><span class="job-tag blue">모범구인</span></c:if>
                  </div>
                </div>
                <div class="job-meta">
                  <div class="job-location">📍 ${not empty item.location ? item.location : '신당동'}</div>
                  <div class="job-date">${item.createdDate}</div>
                  <button class="heart-btn" type="button" onclick="toggleLike(event, this)">♡</button>
                </div>
              </a>
            </c:forEach>
          </c:if>

          <%-- ══ 가데이터 (list가 비어있을 때) ══ --%>
          <c:if test="${empty list}">
            <!-- 가데이터는 JS로 렌더링 -->
            <div id="dummyMount"></div>
          </c:if>

        </div>

        <%-- 더보기 버튼 --%>
        <c:if test="${empty list}">
          <button class="load-more" id="loadMoreBtn" onclick="loadMore()">더보기 ▼</button>
        </c:if>

      </div>
    </div>

    <a href="${pageContext.request.contextPath}/alba/posting/write" class="fab">✏️ 공고 쓰기</a>

  </main>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
/* ═══════════════════════════════════════════
   가데이터 (실제 DB 연결 전 미리보기용)
   실제 list 데이터가 들어오면 이 블록 전체 불필요
   ═══════════════════════════════════════════ */
const DUMMY_JOBS = [
  {
    id: 1,
    title: '서빙 및 간단 조리',
    employer: '약수상회',
    payType: '시급', pay: '12,000원',
    days: '월~토', time: '18:00~23:00',
    location: '신당동', date: '오늘',
    tags: [{label:'모범구인', cls:'blue'}],
    img: 'https://images.unsplash.com/photo-1514190051997-0f6f39ca5cde?w=200&q=80',
    link: '#'
  },
  {
    id: 2,
    title: '어린이집 조리보조 단기 근무자 모집',
    employer: '햇살어린이집',
    payType: '일급', pay: '80,000원',
    days: '총 18일', time: '08:30~15:00',
    location: '신당동', date: '오늘',
    tags: [{label:'당일지급', cls:'green'}, {label:'모범구인', cls:'blue'}, {label:'후기 24', cls:'orange'}],
    img: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&q=80',
    link: '#'
  },
  {
    id: 3,
    title: '누존 도매매장 야간 매장 알바',
    employer: '주식회사 모즈패션',
    payType: '시급', pay: '15,000원',
    days: '월~금', time: '23:30~03:30',
    location: '신당동', date: '1일 전',
    tags: [{label:'모범구인', cls:'blue'}, {label:'후기 13', cls:'orange'}],
    img: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=200&q=80',
    link: '#'
  },
  {
    id: 4,
    title: '동대문 종합시장 키링매장 1일 알바',
    employer: '릴리데이지',
    payType: '일급', pay: '88,000원',
    days: '2월 28일(토)', time: '09:00~18:00',
    location: '종로6가', date: '오늘',
    tags: [{label:'당일지급', cls:'green'}],
    img: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=200&q=80',
    link: '#'
  },
  {
    id: 5,
    title: '버터앤빈 바리스타 모집',
    employer: '버터앤빈 카페',
    payType: '연봉', pay: '2,600만원',
    days: '수~일', time: '12:00~21:00',
    location: '무학동', date: '5일 전',
    tags: [{label:'모범구인', cls:'blue'}],
    img: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=200&q=80',
    link: '#'
  },
  {
    id: 6,
    title: '학교 급식도우미 고정 및 프리랜서 채용',
    employer: '이웃알바',
    payType: '시급', pay: '12,570원',
    days: '월~금', time: '협의',
    location: '신당동', date: '2일 전',
    tags: [{label:'후기 13', cls:'orange'}],
    img: 'https://images.unsplash.com/photo-1567521464027-f127ff144326?w=200&q=80',
    link: '#'
  },
  {
    id: 7,
    title: '7세 남아 하원도우미',
    employer: '이웃알바',
    payType: '시급', pay: '17,000원',
    days: '월~금', time: '협의',
    location: '금호동2가', date: '오늘',
    tags: [],
    img: 'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=200&q=80',
    link: '#'
  },
  {
    id: 8,
    title: '뚜레쥬르 신당역점 월,목 마감조',
    employer: '뚜레쥬르 신당역점',
    payType: '시급', pay: '12,000원',
    days: '월, 목', time: '18:00~22:00',
    location: '신당동', date: '오늘',
    tags: [{label:'후기 1', cls:'orange'}],
    img: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=200&q=80',
    link: '#'
  },
  {
    id: 9,
    title: '성동공업고등학교 주방보조',
    employer: '(주)정오아카데미',
    payType: '시급', pay: '13,000원',
    days: '월~금', time: '08:00~17:00',
    location: '흥인동', date: '3일 전',
    tags: [{label:'모범구인', cls:'blue'}, {label:'후기 24', cls:'orange'}],
    img: 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=200&q=80',
    link: '#'
  },
  {
    id: 10,
    title: '소셜링 진행자 / 스텝 모집',
    employer: '더파티',
    payType: '월급', pay: '100만원',
    days: '월, 금, 토', time: '18:00~23:30',
    location: '신당동', date: '오늘',
    tags: [],
    img: 'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=200&q=80',
    link: '#'
  },
  {
    id: 11,
    title: '빽다방 약수시장점 평일 마감파트',
    employer: '빽다방',
    payType: '시급', pay: '10,320원',
    days: '월~금', time: '18:00~20:30',
    location: '신당동', date: '오늘',
    tags: [],
    img: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=200&q=80',
    link: '#'
  },
  {
    id: 12,
    title: '월450 재활용품 수거 업무',
    employer: '사울서울',
    payType: '월급', pay: '450만원',
    days: '월~금', time: '22:00~05:00',
    location: '황학동', date: '4일 전',
    tags: [{label:'후기 8', cls:'orange'}],
    img: 'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=200&q=80',
    link: '#'
  },
  {
    id: 13,
    title: '컴포즈커피 두타몰점 오전 파트타임',
    employer: '컴포즈 두타몰점',
    payType: '시급', pay: '10,400원',
    days: '월~수', time: '08:00~14:00',
    location: '을지로6가', date: '오늘',
    tags: [{label:'후기 3', cls:'orange'}],
    img: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=200&q=80',
    link: '#'
  },
  {
    id: 14,
    title: '조갯집 주방보조 직원',
    employer: '신당조갯집',
    payType: '시급', pay: '13,000원',
    days: '화~일', time: '14:00~23:30',
    location: '신당동', date: '2일 전',
    tags: [{label:'모범구인', cls:'blue'}, {label:'후기 12', cls:'orange'}],
    img: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=200&q=80',
    link: '#'
  },
  {
    id: 15,
    title: '신당역 치과의원 청소 알바',
    employer: '더드림치과의원',
    payType: '시급', pay: '12,000원',
    days: '월, 수, 금', time: '09:00~12:00',
    location: '황학동', date: '5일 전',
    tags: [],
    img: 'https://images.unsplash.com/photo-1629909613654-28e377c37b09?w=200&q=80',
    link: '#'
  },
];

/* ─── 가데이터 렌더러 ─── */
const liked = new Set();
let shown = 8;

function renderDummyCard(job, idx) {
  const tagsHtml = job.tags.map(t =>
    `<span class="job-tag ${t.cls}">${t.label}</span>`
  ).join('');
  return `
    <a class="job-card" href="${job.link}" style="animation-delay:${idx*0.05}s" onclick="return false;">
      <div class="job-thumb">
        <img src="${job.img}" alt="${job.title}"
             onerror="this.parentNode.innerHTML='🥕'">
      </div>
      <div class="job-info">
        <div class="job-title">${job.title}</div>
        <div class="job-employer">${job.employer}</div>
        <div class="job-pay"><span class="pay-type">${job.payType}</span>${job.pay}</div>
        <div class="job-schedule">${job.days} · ${job.time}</div>
        <div class="job-tags">${tagsHtml}</div>
      </div>
      <div class="job-meta">
        <div class="job-location">📍 ${job.location}</div>
        <div class="job-date">${job.date}</div>
        <button class="heart-btn" type="button" onclick="toggleLike(event,${job.id},this)">♡</button>
      </div>
    </a>`;
}

function renderDummy() {
  const mount = document.getElementById('dummyMount');
  if (!mount) return;
  mount.innerHTML = DUMMY_JOBS.slice(0, shown).map((j, i) => renderDummyCard(j, i)).join('');
}

function loadMore() {
  shown = Math.min(shown + 4, DUMMY_JOBS.length);
  renderDummy();
  if (shown >= DUMMY_JOBS.length) {
    const btn = document.getElementById('loadMoreBtn');
    if (btn) btn.style.display = 'none';
  }
}

/* ─── 공통 이벤트 ─── */
function toggleLike(e, id, btn) {
  e.preventDefault(); e.stopPropagation();
  if (liked.has(id)) {
    liked.delete(id); btn.classList.remove('liked'); btn.textContent = '♡';
  } else {
    liked.add(id); btn.classList.add('liked'); btn.textContent = '♥';
    btn.style.transform = 'scale(1.4)';
    setTimeout(() => btn.style.transform = '', 200);
  }
}

/* 필터 토글 */
document.querySelectorAll('.chip').forEach(chip => {
  chip.addEventListener('click', function() { this.classList.toggle('active'); });
});
document.querySelectorAll('.day-chip').forEach(chip => {
  chip.addEventListener('click', function() { this.classList.toggle('active'); });
});

/* 초기 렌더 */
renderDummy();
</script>
</body>
</html>
