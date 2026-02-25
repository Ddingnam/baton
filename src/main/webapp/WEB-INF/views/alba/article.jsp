<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${dto.title} - 바통터치</title>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/main.css">
<style>
  :root {
    --blue: #0057FF;
    --blue-hover: #0047D9;
    --blue-light: #EBF2FF;
    --blue-mid: #C0D7FF;
    --bg: #F4F6FA;
    --white: #ffffff;
    --text: #0F1724;
    --sub: #525E6E;
    --muted: #9AA3B0;
    --border: #E4E9F0;
    --shadow-sm: 0 1px 3px rgba(0,0,0,.06);
    --shadow-md: 0 4px 20px rgba(0,0,0,.08);
    --r: 16px;
    --r-sm: 8px;
  }
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
  body { background: var(--bg); font-family: 'Pretendard', 'Noto Sans KR', sans-serif; color: var(--text); }

  .article-wrap {
    max-width: 780px;
    margin: 0 auto;
    padding: 28px 20px 100px;
  }

  /* ── 뒤로가기 ── */
  .back-nav {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 20px;
    text-decoration: none;
    color: var(--sub);
    font-size: 13px;
    font-weight: 600;
    width: fit-content;
    transition: color .15s;
  }
  .back-nav:hover { color: var(--blue); }
  .back-icon {
    width: 32px; height: 32px;
    border: 1.5px solid var(--border);
    border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
    font-size: 16px;
    background: var(--white);
    transition: all .15s;
  }
  .back-nav:hover .back-icon { border-color: var(--blue); color: var(--blue); }

  /* ── 메인 카드 ── */
  .article-card {
    background: var(--white);
    border-radius: var(--r);
    border: 1px solid var(--border);
    box-shadow: var(--shadow-md);
    overflow: hidden;
  }

  /* 헤더 영역 */
  .article-top {
    padding: 32px 36px 28px;
    border-bottom: 1px solid var(--border);
  }
  .article-category {
    display: inline-flex;
    align-items: center;
    gap: 5px;
    background: var(--blue-light);
    color: var(--blue);
    font-size: 12px;
    font-weight: 700;
    padding: 4px 10px;
    border-radius: 20px;
    margin-bottom: 14px;
    letter-spacing: .02em;
  }
  .article-title {
    font-size: 26px;
    font-weight: 800;
    color: var(--text);
    line-height: 1.4;
    margin-bottom: 20px;
    letter-spacing: -.4px;
  }

  /* 급여 강조 박스 */
  .pay-box {
    display: flex;
    align-items: center;
    justify-content: space-between;
    background: linear-gradient(135deg, #0057FF 0%, #3A8BFF 100%);
    border-radius: 12px;
    padding: 18px 22px;
    margin-bottom: 24px;
    color: white;
  }
  .pay-label { font-size: 12px; font-weight: 600; opacity: .8; margin-bottom: 4px; letter-spacing: .04em; }
  .pay-amount { font-size: 28px; font-weight: 900; letter-spacing: -.5px; }
  .pay-badge {
    background: rgba(255,255,255,.2);
    border: 1px solid rgba(255,255,255,.3);
    border-radius: 8px;
    padding: 6px 12px;
    font-size: 13px;
    font-weight: 700;
    backdrop-filter: blur(4px);
  }

  /* 정보 그리드 */
  .info-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 12px;
  }
  .info-item {
    display: flex;
    align-items: flex-start;
    gap: 10px;
    background: var(--bg);
    border-radius: 10px;
    padding: 14px 16px;
    border: 1px solid var(--border);
  }
  .info-icon {
    width: 34px; height: 34px;
    border-radius: 8px;
    background: var(--white);
    border: 1px solid var(--border);
    display: flex; align-items: center; justify-content: center;
    font-size: 16px;
    flex-shrink: 0;
  }
  .info-content {}
  .info-label { font-size: 11px; font-weight: 600; color: var(--muted); letter-spacing: .04em; margin-bottom: 3px; }
  .info-value { font-size: 14px; font-weight: 700; color: var(--text); }

  /* ── 본문 ── */
  .article-body {
    padding: 28px 36px;
    border-bottom: 1px solid var(--border);
  }
  .body-title {
    font-size: 13px;
    font-weight: 700;
    color: var(--muted);
    letter-spacing: .06em;
    text-transform: uppercase;
    margin-bottom: 16px;
    display: flex; align-items: center; gap: 8px;
  }
  .body-title::after {
    content: ''; flex: 1; height: 1px; background: var(--border);
  }
  .body-text {
    font-size: 15px;
    line-height: 1.85;
    color: var(--sub);
    white-space: pre-wrap;
    min-height: 120px;
  }

  /* ── 하단 액션 ── */
  .article-footer {
    padding: 24px 36px;
    display: flex;
    align-items: center;
    gap: 12px;
  }
  .btn {
    padding: 14px 24px;
    border-radius: 10px;
    font-size: 15px;
    font-weight: 700;
    cursor: pointer;
    text-decoration: none;
    text-align: center;
    transition: all .18s;
    display: inline-flex; align-items: center; justify-content: center; gap: 6px;
    font-family: inherit;
    letter-spacing: -.1px;
  }
  .btn-outline {
    background: var(--white);
    color: var(--sub);
    border: 1.5px solid var(--border);
    flex-shrink: 0;
  }
  .btn-outline:hover { background: var(--bg); border-color: var(--border-strong, #C8D2DF); color: var(--text); }
  .btn-primary {
    background: var(--blue);
    color: white;
    border: none;
    flex: 1;
    box-shadow: 0 2px 10px rgba(0,87,255,.3);
  }
  .btn-primary:hover { background: var(--blue-hover); transform: translateY(-1px); box-shadow: 0 4px 16px rgba(0,87,255,.4); }

  /* 하트 */
  .btn-heart {
    width: 50px; height: 50px; padding: 0;
    background: var(--white);
    color: var(--muted);
    border: 1.5px solid var(--border);
    border-radius: 10px;
    flex-shrink: 0;
    font-size: 18px;
  }
  .btn-heart:hover { border-color: #FF4B4B; color: #FF4B4B; }
  .btn-heart.liked { border-color: #FF4B4B; color: #FF4B4B; background: #FFF5F5; }

  /* 조회수 */
  .article-meta {
    display: flex; align-items: center; gap: 14px;
    padding: 0 36px 20px;
  }
  .meta-item {
    display: flex; align-items: center; gap: 5px;
    font-size: 12px; color: var(--muted); font-weight: 500;
  }

  @media (max-width: 600px) {
    .article-top, .article-body, .article-footer, .article-meta { padding-left: 20px; padding-right: 20px; }
    .article-title { font-size: 20px; }
    .pay-amount { font-size: 22px; }
    .info-grid { grid-template-columns: 1fr; }
  }
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp" />
<div id="baton-layout-container">
  <jsp:include page="/WEB-INF/views/layout/left.jsp" />
  <main id="baton-main-content">
    <div class="article-wrap">

      <a href="${pageContext.request.contextPath}/alba/posting/list" class="back-nav">
        <span class="back-icon">←</span>
        목록으로 돌아가기
      </a>

      <div class="article-card">

        <!-- 헤더 -->
        <div class="article-top">
          <div class="article-category">📋 알바 공고</div>
          <h1 class="article-title">${dto.title}</h1>

          <div class="pay-box">
            <div>
              <div class="pay-label">💰 시급</div>
              <div class="pay-amount"><fmt:formatNumber value="${dto.pay}" pattern="#,###"/>원</div>
            </div>
            <div class="pay-badge">지금 지원하기 →</div>
          </div>

          <div class="info-grid">
            <div class="info-item">
              <div class="info-icon">📅</div>
              <div class="info-content">
                <div class="info-label">근무 요일</div>
                <div class="info-value">${dto.workDays}</div>
              </div>
            </div>
            <div class="info-item">
              <div class="info-icon">🕐</div>
              <div class="info-content">
                <div class="info-label">근무 시간</div>
                <div class="info-value">${dto.workTime}</div>
              </div>
            </div>
          </div>
        </div>

        <!-- 본문 -->
        <div class="article-body">
          <div class="body-title">공고 내용</div>
          <div class="body-text">${dto.content}</div>
        </div>

        <!-- 메타 -->
        <div class="article-meta">
          <div class="meta-item">👁 조회 ${dto.hitCount}회</div>
        </div>

        <!-- 하단 버튼 -->
        <div class="article-footer">
          <a href="${pageContext.request.contextPath}/alba/posting/list" class="btn btn-outline">← 목록</a>
          <button class="btn btn-heart" id="heartBtn" onclick="toggleHeart(this)" title="찜하기">♡</button>
          <button class="btn btn-primary" onclick="alert('곧 지원하기 기능이 연결됩니다!');">
            ✉️ 이 알바 지원하기
          </button>
        </div>

      </div>
    </div>
  </main>
</div>
<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
<script>
function toggleHeart(btn) {
  btn.classList.toggle('liked');
  btn.textContent = btn.classList.contains('liked') ? '♥' : '♡';
  if (btn.classList.contains('liked')) {
    btn.style.transform = 'scale(1.3)';
    setTimeout(() => btn.style.transform = '', 200);
  }
}
</script>
</body>
</html>
