<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>동네 알바 | BATON</title>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main.css">
<style>

:root {
  --baton-blue:    #3182f6;
  --baton-blue-lt: #ebf3ff;
  --baton-title:   #191f28;
  --baton-body:    #333d4b;
  --baton-muted:   #6b7684;
  --baton-border:  #e5e8eb;
  --baton-bg:      #f9fafb;
  --baton-white:   #ffffff;
  --baton-green:   #00B050;
  --r:             14px;
  --shadow-sm:     0 1px 4px rgba(0,0,0,.06);
  --shadow-md:     0 4px 20px rgba(0,0,0,.10);
}
* { box-sizing: border-box; margin: 0; padding: 0; }
body { background: var(--baton-bg); font-family: 'Pretendard', sans-serif; color: var(--baton-body); }


.alba-page {
  display: grid;
  grid-template-columns: 220px 1fr;
  gap: 24px;
  max-width: 1060px;
  margin: 0 auto;
  padding: 32px 20px 100px;
  align-items: start;
}

.alba-sidebar {
  position: sticky;
  top: 88px;
  background: var(--baton-white);
  border-radius: var(--r);
  border: 1px solid var(--baton-border);
  overflow: hidden;
  box-shadow: var(--shadow-sm);
}
.sidebar-header {
  padding: 20px 18px 16px;
  border-bottom: 1px solid var(--baton-border);
  background: var(--baton-blue-lt);
}
.location-label {
  font-size: 11px; font-weight: 600;
  color: var(--baton-blue); letter-spacing: .04em; margin-bottom: 5px;
  display: flex; align-items: center; gap: 4px;
}
.location-name {
  font-size: 17px; font-weight: 800; color: var(--baton-title);
}
.location-name span { color: var(--baton-blue); }

.filter-section { padding: 14px 18px; border-bottom: 1px solid var(--baton-border); }
.filter-section:last-child { border-bottom: none; }
.filter-title {
  font-size: 11px; font-weight: 700;
  color: var(--baton-muted); margin-bottom: 10px; letter-spacing: .04em;
}
.filter-chips { display: flex; flex-wrap: wrap; gap: 6px; }
.chip {
  padding: 5px 11px; border-radius: 20px;
  border: 1.5px solid var(--baton-border);
  font-size: 12px; font-weight: 600; color: var(--baton-muted);
  cursor: pointer; transition: all .15s;
  background: var(--baton-white); font-family: inherit;
}
.chip:hover { border-color: var(--baton-blue); color: var(--baton-blue); background: var(--baton-blue-lt); }
.chip.active { border-color: var(--baton-blue); background: var(--baton-blue); color: #fff; }

.day-chips { display: flex; gap: 4px; }
.day-chip {
  flex: 1; text-align: center; padding: 6px 0; border-radius: 8px;
  border: 1.5px solid var(--baton-border);
  font-size: 12px; font-weight: 700; color: var(--baton-muted);
  cursor: pointer; transition: all .15s; background: var(--baton-white); font-family: inherit;
}
.day-chip:hover { border-color: var(--baton-blue); color: var(--baton-blue); }
.day-chip.active { background: var(--baton-blue); border-color: var(--baton-blue); color: #fff; }


.popular-section {
  background: var(--baton-white);
  border: 1px solid var(--baton-border);
  border-radius: var(--r);
  padding: 18px 20px;
  margin-bottom: 16px;
  box-shadow: var(--shadow-sm);
}
.popular-title {
  font-size: 12px; font-weight: 700;
  color: var(--baton-muted); margin-bottom: 12px;
}
.popular-chips { display: flex; flex-wrap: wrap; gap: 7px; }
.popular-chip {
  padding: 6px 13px; border-radius: 20px;
  background: var(--baton-blue-lt);
  border: 1.5px solid #c3d9fd;
  font-size: 12px; font-weight: 700; color: var(--baton-blue);
  cursor: pointer; transition: all .15s;
}
.popular-chip:hover { background: var(--baton-blue); color: #fff; border-color: var(--baton-blue); }


.content-header {
  display: flex; align-items: center;
  justify-content: space-between; margin-bottom: 12px;
}
.result-count { font-size: 15px; font-weight: 800; color: var(--baton-title); }
.result-count span { color: var(--baton-blue); }
.sort-select {
  border: 1.5px solid var(--baton-border); border-radius: 8px;
  padding: 6px 28px 6px 12px; font-family: inherit;
  font-size: 13px; font-weight: 600; color: var(--baton-muted);
  background: var(--baton-white)
    url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='11' height='11' viewBox='0 0 12 12'%3E%3Cpath fill='%236b7684' d='M6 8L1 3h10z'/%3E%3C/svg%3E")
    no-repeat right 10px center;
  appearance: none; cursor: pointer;
}


.job-list {
  display: flex;
  flex-direction: column;
  background: var(--baton-white);
  border: 1px solid var(--baton-border);
  border-radius: var(--r);
  overflow: hidden;
  box-shadow: var(--shadow-sm);
}

.job-card {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 18px 20px;
  border-bottom: 1px solid var(--baton-border);
  text-decoration: none;
  color: inherit;
  cursor: pointer;
  transition: background .15s;
  animation: fadeUp .3s ease both;
}
.job-card:last-child { border-bottom: none; }
.job-card:hover { background: var(--baton-bg); }

@keyframes fadeUp {
  from { opacity: 0; transform: translateY(8px); }
  to   { opacity: 1; transform: translateY(0); }
}

.job-thumb {
  width: 68px; height: 68px;
  border-radius: 12px;
  background: var(--baton-blue-lt);
  border: 1px solid var(--baton-border);
  flex-shrink: 0;
  overflow: hidden;
  display: flex; align-items: center; justify-content: center;
  font-size: 24px;
}
.job-thumb img { width: 100%; height: 100%; object-fit: cover; display: block; }

.job-info { flex: 1; min-width: 0; }
.job-title {
  font-size: 14px; font-weight: 700; color: var(--baton-title);
  margin-bottom: 3px;
  white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
}
.job-employer { font-size: 12px; color: var(--baton-muted); margin-bottom: 6px; }
.job-pay {
  font-size: 15px; font-weight: 800; color: var(--baton-title);
  margin-bottom: 5px; display: flex; align-items: center; gap: 6px;
}
.pay-badge {
  font-size: 11px; font-weight: 700; color: var(--baton-blue);
  background: var(--baton-blue-lt);
  padding: 2px 7px; border-radius: 6px;
}
.job-schedule { font-size: 12px; color: var(--baton-muted); margin-bottom: 7px; }
.job-tags { display: flex; flex-wrap: wrap; gap: 4px; }
.job-tag {
  padding: 2px 8px; border-radius: 5px;
  font-size: 11px; font-weight: 700;
  background: #f2f4f6; color: var(--baton-muted);
}
.job-tag.green  { background: #e8f9f0; color: var(--baton-green); }
.job-tag.blue   { background: var(--baton-blue-lt); color: var(--baton-blue); }
.job-tag.orange { background: #fff4e5; color: #f07800; }

.job-meta {
  display: flex; flex-direction: column;
  align-items: flex-end; justify-content: space-between;
  gap: 28px; flex-shrink: 0; align-self: stretch;
}
.job-date { font-size: 11px; color: var(--baton-muted); white-space: nowrap; }

.heart-btn {
  width: 34px; height: 34px;
  border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  background: var(--baton-bg); border: 1.5px solid var(--baton-border);
  cursor: pointer; transition: all .15s;
  color: var(--baton-muted); font-size: 17px;
  outline: none; -webkit-tap-highlight-color: transparent;
}
.heart-btn:hover { border-color: #ff4d6d; color: #ff4d6d; background: #fff0f3; }
.heart-btn.liked { border-color: #ff4d6d; background: #ff4d6d; color: #fff; }

/* ────────────────────────────────────
   FAB
──────────────────────────────────── */
.fab {
  position: fixed; bottom: 36px; right: 36px;
  background: var(--baton-blue); color: #fff;
  border: none; border-radius: 50px;
  padding: 14px 22px; font-family: inherit;
  font-size: 14px; font-weight: 700;
  cursor: pointer; text-decoration: none;
  display: flex; align-items: center; gap: 8px;
  box-shadow: 0 4px 18px rgba(49,130,246,.45);
  transition: all .2s; z-index: 50;
}
.fab:hover { transform: translateY(-2px); box-shadow: 0 8px 28px rgba(49,130,246,.55); color: #fff; }

@media (max-width: 760px) {
  .alba-page { grid-template-columns: 1fr; padding: 16px 14px 80px; }
  .alba-sidebar { position: static; }
  .job-thumb { width: 58px; height: 58px; }
  .fab { bottom: 20px; right: 16px; }
}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp" />
<div id="baton-layout-container">
  <main id="baton-main-content">
    <div class="alba-page">

      <aside class="alba-sidebar">
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

      <div class="content">
        <div class="popular-section">
          <div class="popular-title"><i class="ri-fire-fill" style="color:#ff6b35;"></i> 인기 검색어</div>
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
          <c:if test="${not empty list}">
            <c:forEach var="item" items="${list}" varStatus="st">
              <a class="job-card"
                 href="${pageContext.request.contextPath}/alba/posting/article?postingIdx=${item.postingIdx}"
                 style="animation-delay:${st.index * 0.04}s">
                <div class="job-thumb">
                  <c:choose>
                    <c:when test="${not empty item.thumbUrl}">
                      <img src="${item.thumbUrl}" alt="${item.title}" onerror="this.parentNode.innerHTML='💼'">
                    </c:when>
                    <c:otherwise>💼</c:otherwise>
                  </c:choose>
                </div>
                <div class="job-info">
                  <div class="job-title">${item.title}</div>
                  <div class="job-employer">${not empty item.employer ? item.employer : '동네 사장님'}</div>
                  <div class="job-pay">
                    <span class="pay-badge">시급</span>
                    <fmt:formatNumber value="${item.pay}" pattern="#,###"/>원
                  </div>
                  <div class="job-schedule"><i class="ri-time-line" style="margin-right:3px;"></i>${item.workDays} · ${item.workTime}</div>
                  <div class="job-tags">
                    <c:if test="${item.pay >= 15000}"><span class="job-tag orange">고수익</span></c:if>
                    <c:if test="${item.sameDay eq 'Y'}"><span class="job-tag green">당일지급</span></c:if>
                    <c:if test="${item.goodEmployer eq 'Y'}"><span class="job-tag blue">모범구인</span></c:if>
                  </div>
                </div>
                <div class="job-meta">
                  <div class="job-date">${item.createdDate}</div>
                  <button class="heart-btn" type="button" onclick="toggleLike(event,this)" aria-label="찜하기">
                    <i class="ri-heart-line"></i>
                  </button>
                </div>
              </a>
            </c:forEach>
          </c:if>
          <c:if test="${empty list}">
            <div id="dummyMount"></div>
          </c:if>
        </div>
      </div>
    </div>

    <a href="${pageContext.request.contextPath}/alba/posting/write" class="fab">
      <i class="ri-pencil-line"></i> 공고 쓰기
    </a>
  </main>
</div>
<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
const DUMMY_JOBS = [
  { id:1,  title:'서빙 및 간단 조리',                    employer:'약수상회',          payType:'시급', pay:'12,000원', days:'월~토',       time:'18:00~23:00', date:'오늘',   tags:[{label:'모범구인',cls:'blue'}],                                                       img:'https://images.unsplash.com/photo-1514190051997-0f6f39ca5cde?w=200&q=80' },
  { id:2,  title:'어린이집 조리보조 단기 근무자 모집',   employer:'햇살어린이집',      payType:'일급', pay:'80,000원', days:'총 18일',      time:'08:30~15:00', date:'오늘',   tags:[{label:'당일지급',cls:'green'},{label:'모범구인',cls:'blue'},{label:'후기 24',cls:'blue'}], img:'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&q=80' },
  { id:3,  title:'누존 도매매장 야간 매장 알바',         employer:'주식회사 모즈패션', payType:'시급', pay:'15,000원', days:'월~금',        time:'23:30~03:30', date:'1일 전', tags:[{label:'고수익',cls:'orange'},{label:'모범구인',cls:'blue'}],                            img:'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=200&q=80' },
  { id:4,  title:'동대문 종합시장 키링매장 1일 알바',    employer:'릴리데이지',        payType:'일급', pay:'88,000원', days:'2월 28일(토)', time:'09:00~18:00', date:'오늘',   tags:[{label:'당일지급',cls:'green'}],                                                       img:'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=200&q=80' },
  { id:5,  title:'버터앤빈 바리스타 모집',               employer:'버터앤빈 카페',     payType:'연봉', pay:'2,600만원', days:'수~일',        time:'12:00~21:00', date:'5일 전', tags:[{label:'모범구인',cls:'blue'}],                                                        img:'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=200&q=80' },
  { id:6,  title:'학교 급식도우미 고정 및 프리랜서 채용',employer:'이웃알바',          payType:'시급', pay:'12,570원', days:'월~금',        time:'협의',        date:'2일 전', tags:[{label:'후기 13',cls:'blue'}],                                                        img:'https://images.unsplash.com/photo-1567521464027-f127ff144326?w=200&q=80' },
  { id:7,  title:'7세 남아 하원도우미',                  employer:'이웃알바',          payType:'시급', pay:'17,000원', days:'월~금',        time:'협의',        date:'오늘',   tags:[{label:'고수익',cls:'orange'}],                                                        img:'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=200&q=80' },
  { id:8,  title:'뚜레쥬르 신당역점 월·목 마감조',      employer:'뚜레쥬르 신당역점', payType:'시급', pay:'12,000원', days:'월, 목',       time:'18:00~22:00', date:'오늘',   tags:[{label:'후기 1',cls:'blue'}],                                                          img:'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=200&q=80' },
  { id:9,  title:'성동공업고등학교 주방보조',            employer:'(주)정오아카데미',  payType:'시급', pay:'13,000원', days:'월~금',        time:'08:00~17:00', date:'3일 전', tags:[{label:'모범구인',cls:'blue'},{label:'후기 24',cls:'blue'}],                            img:'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=200&q=80' },
  { id:10, title:'소셜링 진행자 / 스텝 모집',            employer:'더파티',            payType:'월급', pay:'100만원',  days:'월, 금, 토',   time:'18:00~23:30', date:'오늘',   tags:[],                                                                                     img:'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=200&q=80' },
  { id:11, title:'빽다방 약수시장점 평일 마감파트',      employer:'빽다방',            payType:'시급', pay:'10,320원', days:'월~금',        time:'18:00~20:30', date:'오늘',   tags:[],                                                                                     img:'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=200&q=80' },
  { id:12, title:'월450 재활용품 수거 업무',             employer:'사울서울',          payType:'월급', pay:'450만원',  days:'월~금',        time:'22:00~05:00', date:'4일 전', tags:[{label:'후기 8',cls:'blue'}],                                                          img:'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=200&q=80' },
  { id:13, title:'컴포즈커피 두타몰점 오전 파트타임',   employer:'컴포즈 두타몰점',   payType:'시급', pay:'10,400원', days:'월~수',        time:'08:00~14:00', date:'오늘',   tags:[{label:'후기 3',cls:'blue'}],                                                          img:'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=200&q=80' },
  { id:14, title:'조갯집 주방보조 직원',                 employer:'신당조갯집',        payType:'시급', pay:'13,000원', days:'화~일',        time:'14:00~23:30', date:'2일 전', tags:[{label:'모범구인',cls:'blue'},{label:'후기 12',cls:'blue'}],                            img:'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=200&q=80' },
  { id:15, title:'신당역 치과의원 청소 알바',            employer:'더드림치과의원',    payType:'시급', pay:'12,000원', days:'월, 수, 금',   time:'09:00~12:00', date:'5일 전', tags:[],                                                                                     img:'https://images.unsplash.com/photo-1629909613654-28e377c37b09?w=200&q=80' },
];

function renderDummyCard(job, idx) {
  const tagsHtml = job.tags.map(t =>
    `<span class="job-tag ${t.cls}">${t.label}</span>`
  ).join('');
  return `
    <a class="job-card" href="#" style="animation-delay:${idx * 0.04}s" onclick="return false;">
      <div class="job-thumb">
        <img src="${job.img}" alt="${job.title}" onerror="this.parentNode.innerHTML='💼'">
      </div>
      <div class="job-info">
        <div class="job-title">${job.title}</div>
        <div class="job-employer">${job.employer}</div>
        <div class="job-pay"><span class="pay-badge">${job.payType}</span>${job.pay}</div>
        <div class="job-schedule"><i class="ri-time-line" style="margin-right:3px;"></i>${job.days} · ${job.time}</div>
        <div class="job-tags">${tagsHtml}</div>
      </div>
      <div class="job-meta">
        <div class="job-date">${job.date}</div>
        <button class="heart-btn" type="button" onclick="toggleLike(event,this)" aria-label="찜하기">
          <i class="ri-heart-line"></i>
        </button>
      </div>
    </a>`;
}

(function() {
  const mount = document.getElementById('dummyMount');
  if (!mount) return;
  mount.outerHTML = DUMMY_JOBS.map((j, i) => renderDummyCard(j, i)).join('');
})();

function toggleLike(e, btn) {
  e.preventDefault();
  e.stopPropagation();
  const icon = btn.querySelector('i');
  btn.classList.toggle('liked');
  icon.className = btn.classList.contains('liked') ? 'ri-heart-fill' : 'ri-heart-line';
}

document.querySelectorAll('.chip').forEach(chip => {
  chip.addEventListener('click', function() {
    this.closest('.filter-chips').querySelectorAll('.chip')
      .forEach(c => c.classList.remove('active'));
    this.classList.add('active');
  });
});
document.querySelectorAll('.day-chip').forEach(chip => {
  chip.addEventListener('click', function() { this.classList.toggle('active'); });
});
</script>
</body>
</html>
