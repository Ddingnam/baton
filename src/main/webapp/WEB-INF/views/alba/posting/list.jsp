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
  /* 회원님이 작성해주신 CSS 변수 및 스타일 적용 */
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
  
  /* BATON 메인 컨텐츠 영역 안에서의 레이아웃 조정 */
  .alba-page {
    display: grid;
    grid-template-columns: 240px 1fr;
    gap: 24px;
    align-items: start;
    font-family: 'Noto Sans KR', sans-serif;
  }

  /* ── SIDEBAR (필터) ── */
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
  .filter-title { font-size: 12px; font-weight: 700; color: var(--muted); margin-bottom: 12px; }
  .filter-chips { display: flex; flex-wrap: wrap; gap: 6px; }
  .chip { padding: 5px 11px; border-radius: 20px; border: 1.5px solid var(--border); font-size: 12px; font-weight: 500; color: var(--sub); cursor: pointer; transition: all .15s; }
  .chip:hover, .chip.active { border-color: var(--orange); background: var(--orange-light); color: var(--orange); font-weight: 700; }

  /* ── MAIN CONTENT ── */
  .content-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px; }
  .result-count { font-size: 15px; font-weight: 700; color: var(--text); }
  .result-count span { color: var(--orange); }

  /* ── JOB CARDS ── */
  .job-list { display: flex; flex-direction: column; gap: 12px; }
  .job-card { background: var(--white); border: 1px solid var(--border); border-radius: var(--r); padding: 20px; display: flex; gap: 16px; cursor: pointer; transition: all .18s; text-decoration: none; color: inherit; }
  .job-card:hover { border-color: #d0d0d0; box-shadow: var(--shadow-hover); transform: translateY(-2px); }

  .job-thumb { width: 80px; height: 80px; border-radius: 10px; background: var(--orange-light); border: 1px solid var(--border); flex-shrink: 0; display: flex; align-items: center; justify-content: center; font-size: 28px; }
  .job-info { flex: 1; min-width: 0; }
  .job-title { font-size: 15px; font-weight: 700; line-height: 1.3; margin-bottom: 4px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
  .job-employer { font-size: 12px; color: var(--muted); margin-bottom: 8px; }
  .job-pay { font-size: 14px; font-weight: 700; color: var(--text); margin-bottom: 4px; }
  .job-pay .pay-type { font-size: 12px; font-weight: 500; color: var(--sub); margin-right: 4px; }
  .job-schedule { font-size: 12px; color: var(--sub); margin-bottom: 10px; }
  
  .job-tags { display: flex; flex-wrap: wrap; gap: 5px; }
  .job-tag { padding: 3px 8px; border-radius: 5px; background: var(--tag-bg); font-size: 11px; font-weight: 600; color: var(--sub); }
  .job-tag.orange { background: var(--orange-light); color: var(--orange); }

  .job-meta { display: flex; flex-direction: column; align-items: flex-end; gap: 6px; flex-shrink: 0; }
  .job-location { font-size: 11px; color: var(--muted); text-align: right; }
  .job-date { font-size: 11px; color: var(--muted); }

  /* Write button */
  .fab { position: fixed; bottom: 40px; right: 40px; background: var(--orange); color: white; border: none; border-radius: 50px; padding: 14px 22px; font-size: 15px; font-weight: 700; cursor: pointer; box-shadow: 0 4px 16px rgba(255,111,15,.4); transition: all .2s; z-index: 50; text-decoration: none; }
  .fab:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(255,111,15,.5); color: white; }
</style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <div id="baton-layout-container">
        <main id="baton-main-content">
            
            <div class="alba-page">
                <aside class="alba-sidebar">
                    <div class="sidebar-header">
                        <div class="location-label">📍 현재 지역</div>
                        <div class="location-name">서울 중구 <span>신당동</span></div>
                    </div>
                    <div class="filter-section">
                        <div class="filter-title">근무 유형</div>
                        <div class="filter-chips">
                            <div class="chip active">전체</div>
                            <div class="chip">단기</div>
                            <div class="chip">1개월 이상</div>
                        </div>
                    </div>
                    <div class="filter-section">
                        <div class="filter-title">하는 일</div>
                        <div class="filter-chips">
                            <div class="chip">서빙</div>
                            <div class="chip">주방보조</div>
                            <div class="chip">매장관리</div>
                            <div class="chip">배달</div>
                        </div>
                    </div>
                </aside>

                <div class="content">
                    <div class="content-header">
                        <div class="result-count">신당동 알바 <span>${dataCount}</span>개</div>
                    </div>

                    <div class="job-list">
                        <c:forEach var="item" items="${list}">
                            <a class="job-card" href="${pageContext.request.contextPath}/alba/posting/article?postingIdx=${item.postingIdx}">
                                <div class="job-thumb">🥕</div>
                                <div class="job-info">
                                    <div class="job-title">${item.title}</div>
                                    <div class="job-employer">동네 사장님</div>
                                    <div class="job-pay">
                                        <span class="pay-type">시급</span>
                                        <fmt:formatNumber value="${item.pay}" pattern="#,###"/>원
                                    </div>
                                    <div class="job-schedule">${item.workDays} · ${item.workTime}</div>
                                    <div class="job-tags">
                                        <c:if test="${item.pay >= 13000}">
                                            <span class="job-tag orange">고수익</span>
                                        </c:if>
                                        <span class="job-tag">협의가능</span>
                                    </div>
                                </div>
                                <div class="job-meta">
                                    <div class="job-location">📍 신당동</div>
                                    <div class="job-date">${item.createdDate}</div>
                                </div>
                            </a>
                        </c:forEach>
                        
                        <c:if test="${empty list}">
                            <div style="text-align:center; padding: 50px; color: #9E9E9E;">
                                아직 등록된 알바 공고가 없습니다.
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <a href="${pageContext.request.contextPath}/alba/posting/write" class="fab">✏️ 공고 쓰기</a>

        </main>
    </div>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

    <script>
        // 필터 칩 클릭 시 활성화 토글 효과
        document.querySelectorAll('.chip').forEach(chip => {
            chip.addEventListener('click', function() {
                this.classList.toggle('active');
            });
        });
    </script>
</body>
</html>