<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/WEB-INF/views/layout/headerResources.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>알바 공고 쓰기 | BATON PASS</title>
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

/* ── 페이지 레이아웃 (list.jsp 동일 구조) ── */
.baton-page {
  display: grid;
  grid-template-columns: 250px 1fr;
  gap: 30px;
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 20px 120px;
  align-items: start;
}

/* ── 좌측 미리보기 패널 (사이드바 역할) ── */
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
.sidebar-title-label {
  font-size: 13px; font-weight: 600; color: var(--baton-blue);
  letter-spacing: .04em; margin-bottom: 8px;
  display: flex; align-items: center; gap: 4px;
}
.sidebar-title-main { font-size: 18px; font-weight: 800; color: var(--baton-title); }

/* 미리보기 카드 */
.preview-section { padding: 20px; border-bottom: 1px solid var(--baton-border); }
.preview-section:last-child { border-bottom: none; }
.preview-section-title {
  font-size: 13px; font-weight: 700; color: var(--baton-muted);
  margin-bottom: 12px; letter-spacing: .04em;
}
.preview-thumb-wrap {
  width: 100%; aspect-ratio: 16/9;
  border-radius: 8px; background: var(--baton-bg);
  border: 1.5px dashed var(--baton-border);
  display: flex; align-items: center; justify-content: center;
  font-size: 28px; overflow: hidden; margin-bottom: 14px;
}
.preview-thumb-wrap img { width: 100%; height: 100%; object-fit: cover; display: block; }
.preview-job-title {
  font-size: 15px; font-weight: 800; color: var(--baton-title);
  margin-bottom: 4px; line-height: 1.4;
  display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
}
.preview-employer { font-size: 13px; color: var(--baton-muted); margin-bottom: 10px; }
.preview-pay {
  display: flex; align-items: center; gap: 6px; margin-bottom: 8px;
}
.pay-badge {
  display: inline-block; font-size: 11px; font-weight: 700; padding: 3px 7px;
  border-radius: 4px;
}
.pay-badge.hour   { background: #dbeafe; color: var(--baton-blue); }
.pay-badge.day    { background: #ffedd5; color: var(--baton-orange); }
.pay-badge.month  { background: #f3e8ff; color: #7c3aed; }
.pay-badge.건당   { background: #d1fae5; color: var(--baton-green); }
.pay-amount { font-size: 17px; font-weight: 800; color: var(--baton-title); }
.preview-meta { font-size: 13px; color: var(--baton-body); line-height: 1.7; }
.preview-meta i { color: var(--baton-muted); margin-right: 4px; }

/* 진행도 */
.progress-section { padding: 20px; border-bottom: 1px solid var(--baton-border); }
.progress-label { font-size: 12px; font-weight: 700; color: var(--baton-muted); margin-bottom: 10px; }
.progress-steps { display: flex; flex-direction: column; gap: 8px; }
.progress-item {
  display: flex; align-items: center; gap: 10px;
  font-size: 13px; font-weight: 600; color: var(--baton-muted);
  transition: color .2s;
}
.progress-item.done { color: var(--baton-title); }
.progress-dot {
  width: 22px; height: 22px; border-radius: 50%;
  background: var(--baton-border); flex-shrink: 0;
  display: flex; align-items: center; justify-content: center;
  font-size: 11px; color: var(--baton-muted); font-weight: 800;
  transition: background .2s, color .2s;
}
.progress-item.done .progress-dot {
  background: var(--baton-blue); color: #fff;
}
.progress-bar-line {
  height: 3px; background: var(--baton-border); border-radius: 2px; overflow: hidden;
  margin: 2px 0 2px 26px;
}
.progress-bar-fill { height: 100%; background: var(--baton-blue); border-radius: 2px; transition: width .4s; width: 0%; }

/* ── 우측 폼 영역 ── */
.content { min-width: 0; }

/* 폼 카드 (list.jsp의 job-table-wrap과 동일 패턴) */
.form-card {
  background: var(--baton-white);
  border: 1px solid var(--baton-border);
  border-radius: var(--r);
  overflow: hidden;
  box-shadow: var(--shadow-sm);
  margin-bottom: 16px;
  transition: box-shadow .2s;
}
.form-card:focus-within { box-shadow: var(--shadow-md); }
.form-card-header {
  padding: 18px 24px;
  border-bottom: 1px solid var(--baton-border);
  background: #f9fafb;
  display: flex; align-items: center; gap: 10px;
}
.form-card-step {
  width: 24px; height: 24px; border-radius: 50%;
  background: var(--baton-blue); color: #fff;
  font-size: 12px; font-weight: 800;
  display: flex; align-items: center; justify-content: center; flex-shrink: 0;
}
.form-card-title {
  font-size: 14px; font-weight: 800; color: var(--baton-title); letter-spacing: -.1px;
}
.form-card-body { padding: 24px; }

/* 폼 그룹 */
.form-group { margin-bottom: 22px; }
.form-group:last-child { margin-bottom: 0; }
label {
  display: block; font-size: 13px; font-weight: 700;
  color: var(--baton-title); margin-bottom: 8px;
}
label .req { color: var(--baton-blue); margin-left: 2px; }
label .opt { color: var(--baton-muted); font-weight: 400; font-size: 12px; margin-left: 4px; }

input[type="text"],
input[type="number"],
input[type="tel"],
input[type="time"],
input[type="date"],
textarea,
select {
  width: 100%; padding: 12px 14px;
  border: 1.5px solid var(--baton-border);
  border-radius: 8px;
  font-family: 'Pretendard', sans-serif; font-size: 14px;
  color: var(--baton-title); background: var(--baton-white);
  transition: border-color .15s, box-shadow .15s;
  appearance: none; outline: none;
}
input:focus, textarea:focus, select:focus {
  border-color: var(--baton-blue);
  box-shadow: 0 0 0 3px rgba(30,58,138,.1);
}
input::placeholder, textarea::placeholder { color: var(--baton-muted); }
textarea { resize: vertical; min-height: 130px; line-height: 1.7; }
select {
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%236b7280' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
  background-repeat: no-repeat; background-position: right 14px center;
  padding-right: 38px; cursor: pointer;
}
input[readonly] { background: var(--baton-bg); cursor: pointer; }
.char-count { font-size: 11px; color: var(--baton-muted); text-align: right; margin-top: 5px; }
.input-row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
.input-with-btn { display: flex; gap: 8px; }
.input-with-btn input { flex: 1; }

/* 칩 (list.jsp .chip 동일) */
.chip-group { display: flex; flex-wrap: wrap; gap: 6px; }
.chip {
  padding: 8px 14px; border-radius: 20px;
  border: 1.5px solid var(--baton-border);
  font-size: 14px; font-weight: 600; color: var(--baton-muted);
  cursor: pointer; transition: all .15s; background: var(--baton-white);
  font-family: 'Pretendard', sans-serif;
}
.chip:hover { border-color: var(--baton-blue); color: var(--baton-blue); background: var(--baton-blue-lt); }
.chip.active { border-color: var(--baton-blue); background: var(--baton-blue); color: #fff; }

/* 요일 칩 (list.jsp .day-chip 동일) */
.day-chips { display: flex; gap: 4px; flex-wrap: wrap; }
.day-chip {
  flex: 1; min-width: 40px; text-align: center; padding: 10px 4px; border-radius: 8px;
  border: 1.5px solid var(--baton-border); font-size: 14px; font-weight: 700;
  color: var(--baton-muted); cursor: pointer; transition: all .15s;
  background: var(--baton-white); font-family: 'Pretendard', sans-serif;
}
.day-chip:hover { border-color: var(--baton-blue); color: var(--baton-blue); }
.day-chip.active { background: var(--baton-blue); border-color: var(--baton-blue); color: #fff; }
.day-shortcut { display: flex; gap: 6px; margin-top: 8px; }
.day-shortcut button {
  padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 600;
  border: 1.5px solid var(--baton-border); background: var(--baton-white);
  color: var(--baton-muted); cursor: pointer; transition: all .15s;
  font-family: 'Pretendard', sans-serif;
}
.day-shortcut button:hover { border-color: var(--baton-blue); color: var(--baton-blue); background: var(--baton-blue-lt); }

/* 시간 행 */
.time-row { display: flex; align-items: center; gap: 10px; }
.time-row input { max-width: 140px; }
.time-sep { color: var(--baton-muted); font-weight: 700; font-size: 18px; flex-shrink: 0; }
.time-check { display: flex; align-items: center; gap: 7px; margin-top: 10px; }
.time-check input[type="checkbox"] { width: 16px; height: 16px; accent-color: var(--baton-blue); cursor: pointer; }
.time-check label { font-size: 13px; color: var(--baton-body); font-weight: 500; cursor: pointer; margin-bottom: 0; }

/* 인포박스 */
.info-box {
  background: var(--baton-blue-lt); border: 1px solid #dbeafe;
  border-radius: 8px; padding: 10px 14px;
  font-size: 12px; color: var(--baton-body); line-height: 1.6; margin-top: 8px;
}
.info-box strong { color: var(--baton-blue); font-weight: 700; }
.warn-box {
  background: #fff7ed; border: 1px solid #fed7aa;
  border-radius: 8px; padding: 10px 14px;
  font-size: 12px; color: var(--baton-orange); line-height: 1.6;
  margin-top: 8px; font-weight: 600; display: none;
}

/* 이미지 업로드 */
.image-upload-area {
  border: 2px dashed var(--baton-border); border-radius: 10px; padding: 28px 20px;
  text-align: center; cursor: pointer; transition: all .15s; background: var(--baton-bg);
}
.image-upload-area:hover { border-color: var(--baton-blue); background: var(--baton-blue-lt); }
.upload-icon { font-size: 32px; margin-bottom: 8px; }
.image-upload-area p { font-size: 14px; font-weight: 600; color: var(--baton-body); }
.image-upload-area small { font-size: 12px; color: var(--baton-muted); margin-top: 4px; display: block; }
#imageInput { display: none; }
.image-preview-grid { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 12px; }
.preview-img-item {
  position: relative; width: 80px; height: 80px;
  border-radius: 8px; overflow: hidden; border: 1px solid var(--baton-border);
}
.preview-img-item img { width: 100%; height: 100%; object-fit: cover; }
.preview-remove {
  position: absolute; top: 4px; right: 4px; width: 20px; height: 20px;
  border-radius: 50%; background: rgba(0,0,0,.65); color: white; border: none;
  cursor: pointer; font-size: 10px; display: flex; align-items: center; justify-content: center;
}

/* 주소 검색 버튼 */
.addr-btn {
  flex-shrink: 0; padding: 12px 16px; border-radius: 8px;
  background: var(--baton-blue); color: white; border: none;
  font-family: 'Pretendard', sans-serif; font-size: 13px; font-weight: 700;
  cursor: pointer; white-space: nowrap; transition: all .15s;
}
.addr-btn:hover { background: var(--baton-blue-dk); }

/* 혜택 배지 */
.badge-group { display: flex; flex-wrap: wrap; gap: 8px; }
.badge-toggle {
  padding: 8px 14px; border-radius: 20px;
  border: 1.5px solid var(--baton-border); background: var(--baton-white);
  font-family: 'Pretendard', sans-serif; font-size: 13px; font-weight: 600;
  color: var(--baton-muted); cursor: pointer; transition: all .15s;
}
.badge-toggle:hover { border-color: var(--baton-blue); color: var(--baton-blue); background: var(--baton-blue-lt); }
.badge-toggle.active { border-color: var(--baton-blue); background: var(--baton-blue-lt); color: var(--baton-blue); }

/* 하단 고정 바 (list.jsp .fab 스타일 참고) */
.submit-bar {
  position: fixed; bottom: 0; left: 0; right: 0;
  background: rgba(255,255,255,.95); backdrop-filter: blur(12px);
  border-top: 1px solid var(--baton-border);
  padding: 14px 24px; display: flex; gap: 10px; justify-content: flex-end; z-index: 80;
  box-shadow: 0 -4px 20px rgba(0,0,0,.06);
}
.btn-ghost {
  padding: 12px 20px; border-radius: 8px;
  border: 1.5px solid var(--baton-border); background: var(--baton-white);
  font-family: 'Pretendard', sans-serif; font-size: 14px; font-weight: 700;
  color: var(--baton-muted); cursor: pointer; transition: all .15s;
  display: flex; align-items: center; gap: 6px;
}
.btn-ghost:hover { border-color: var(--baton-blue); color: var(--baton-blue); }
.btn-primary {
  padding: 12px 28px; border-radius: 8px; border: none;
  background: var(--baton-blue); color: white;
  font-family: 'Pretendard', sans-serif; font-size: 15px; font-weight: 800;
  cursor: pointer; transition: all .2s;
  box-shadow: 0 4px 18px rgba(30,58,138,.35);
  display: flex; align-items: center; gap: 8px;
}
.btn-primary:hover { background: var(--baton-blue-dk); transform: translateY(-2px); box-shadow: 0 6px 24px rgba(30,58,138,.45); }
.btn-primary:disabled { opacity: .45; cursor: not-allowed; transform: none; box-shadow: none; }

/* 페이지 헤더 */
.content-header { display: flex; align-items: center; gap: 14px; margin-bottom: 16px; }
.back-btn {
  width: 40px; height: 40px; border-radius: 50%;
  border: 1.5px solid var(--baton-border); background: var(--baton-white);
  display: flex; align-items: center; justify-content: center;
  font-size: 18px; color: var(--baton-muted); cursor: pointer;
  text-decoration: none; transition: all .15s; box-shadow: var(--shadow-sm); flex-shrink: 0;
}
.back-btn:hover { border-color: var(--baton-blue); color: var(--baton-blue); }
.page-title { font-size: 22px; font-weight: 800; color: var(--baton-title); letter-spacing: -.3px; }
.page-subtitle { font-size: 13px; color: var(--baton-muted); font-weight: 500; margin-top: 3px; }

/* 마감일 박스 */
#deadlineInfo { display: none; margin-top: 8px; }

@keyframes fadeUp {
  from { opacity:0; transform: translateY(6px); }
  to   { opacity:1; transform: translateY(0); }
}
.form-card { animation: fadeUp .3s ease both; }
.form-card:nth-child(1) { animation-delay: .05s; }
.form-card:nth-child(2) { animation-delay: .10s; }
.form-card:nth-child(3) { animation-delay: .15s; }
.form-card:nth-child(4) { animation-delay: .20s; }
.form-card:nth-child(5) { animation-delay: .25s; }

@media (max-width: 900px) {
  .baton-page { grid-template-columns: 1fr; padding: 20px 16px 80px; }
  .baton-sidebar { position: static; }
  .input-row { grid-template-columns: 1fr; }
  .submit-bar { padding: 12px 16px; }
}
</style>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>
<c:set var="hideChatbot" value="true" scope="request" />
<jsp:include page="/WEB-INF/views/layout/header.jsp" />
<div id="baton-layout-container">
  <main id="baton-main-content">
    <div class="baton-page">

      <!-- ══ 좌측: 미리보기 사이드바 ══ -->
      <aside class="baton-sidebar">
        <div class="sidebar-header">
          <div class="sidebar-title-label"><i class="ri-eye-line"></i> 공고 미리보기</div>
          <div class="sidebar-title-main">작성 중인 공고</div>
        </div>

        <div class="preview-section">
          <div class="preview-section-title">미리보기</div>
          <div class="preview-thumb-wrap" id="prevThumb">📋</div>
          <div class="preview-job-title" id="prevTitle">공고 제목이 여기 표시됩니다</div>
          <div class="preview-employer" id="prevEmployer">업체명</div>
          <div class="preview-pay">
            <span class="pay-badge hour" id="prevPayBadge">시급</span>
            <span class="pay-amount" id="prevPayAmt">0원</span>
          </div>
          <div class="preview-meta" id="prevMeta">
            <span><i class="ri-calendar-line"></i>요일 미설정</span><br>
            <span><i class="ri-time-line"></i>시간 미설정</span><br>
            <span><i class="ri-map-pin-line"></i>지역 미설정</span>
          </div>
        </div>

        <div class="progress-section">
          <div class="progress-label">작성 완료도</div>
          <div class="progress-steps">
            <div class="progress-item" id="pi1">
              <div class="progress-dot">1</div>기본 정보
            </div>
            <div class="progress-bar-line"><div class="progress-bar-fill" id="pb1"></div></div>
            <div class="progress-item" id="pi2">
              <div class="progress-dot">2</div>급여
            </div>
            <div class="progress-bar-line"><div class="progress-bar-fill" id="pb2"></div></div>
            <div class="progress-item" id="pi3">
              <div class="progress-dot">3</div>근무 조건
            </div>
            <div class="progress-bar-line"><div class="progress-bar-fill" id="pb3"></div></div>
            <div class="progress-item" id="pi4">
              <div class="progress-dot">4</div>상세 정보
            </div>
          </div>
        </div>

        <div class="preview-section">
          <div class="preview-section-title">등록 팁</div>
          <div style="font-size:12px; color:var(--baton-body); line-height:1.8;">
            <div><i class="ri-check-line" style="color:var(--baton-green)"></i> 사진을 추가하면 지원율 ↑</div>
            <div><i class="ri-check-line" style="color:var(--baton-green)"></i> 혜택 뱃지로 눈길 끌기</div>
            <div><i class="ri-check-line" style="color:var(--baton-green)"></i> 상세한 업무 내용 작성</div>
          </div>
        </div>
      </aside>

      <!-- ══ 우측: 폼 ══ -->
      <div class="content">

        <!-- 페이지 헤더 -->
        <div class="content-header">
          <a href="${pageContext.request.contextPath}/alba/posting/list" class="back-btn" title="목록으로">
            <i class="ri-arrow-left-s-line"></i>
          </a>
          <div>
            <div class="page-title">✏️ 알바 공고 쓰기</div>
            <div class="page-subtitle">바통패스에 공고를 등록하고 알바생을 찾아보세요</div>
          </div>
        </div>

        <form id="writeForm" action="${pageContext.request.contextPath}/alba/posting/write" method="post" enctype="multipart/form-data">

          <!-- ── 카드 1: 기본 정보 ── -->
          <div class="form-card">
            <div class="form-card-header">
              <span class="form-card-step">1</span>
              <span class="form-card-title">기본 정보</span>
            </div>
            <div class="form-card-body">
              <div class="form-group">
                <label for="title">공고 제목 <span class="req">*</span></label>
                <input type="text" id="title" name="title" maxlength="50"
                       placeholder="예) 주말 카페 서빙 알바 구합니다" required
                       oninput="updatePreview(); updateCharCount('title','titleCount',50)">
                <div class="char-count"><span id="titleCount">0</span>/50자</div>
              </div>
              <div class="form-group">
                <label for="employer">업체명 <span class="opt">(선택)</span></label>
                <input type="text" id="employer" name="employer" maxlength="30"
                       placeholder="예) 약수상회, 이웃알바"
                       oninput="updatePreview()">
              </div>
              <div class="form-group">
                <label>카테고리 <span class="req">*</span></label>
                <select name="category" required>
                  <option value="" disabled selected>하는 일 선택</option>
                  <option value="SERVING">서빙</option>
                  <option value="KITCHEN_ASSISTANCE">주방보조/설거지</option>
                  <option value="KITCHEN_COOK">주방장/조리사</option>
                  <option value="BEVERAGE_MAKING">음료 제조</option>
                  <option value="SHOP_MANAGEMENT">매장관리/판매</option>
                  <option value="CONVENIENCE_STORE">편의점</option>
                  <option value="CLEANING">업체청소</option>
                  <option value="TUTORING">과외/레슨</option>
                  <option value="CHILD_CARE">아이돌봄</option>
                  <option value="MOVING_ASSISTANCE">짐 옮기기</option>
                  <option value="LIGHT_WORK">심부름/소일거리</option>
                  <option value="ETC">기타</option>
                </select>
              </div>
              <div class="form-group">
                <label for="description">공고 내용 <span class="req">*</span></label>
                <textarea id="description" name="description" rows="6" maxlength="1000"
                          placeholder="업무 내용, 자격 요건, 우대 사항 등을 자세히 적어주세요."
                          required oninput="updateCharCount('description','descCount',1000)"></textarea>
                <div class="char-count"><span id="descCount">0</span>/1000자</div>
              </div>
            </div>
          </div>

          <!-- ── 카드 2: 급여 ── -->
          <div class="form-card">
            <div class="form-card-header">
              <span class="form-card-step">2</span>
              <span class="form-card-title">💰 급여</span>
            </div>
            <div class="form-card-body">
              <div class="form-group">
                <label>급여 유형 <span class="req">*</span></label>
                <div class="chip-group" id="payTypeGroup">
                  <button type="button" class="chip active" data-val="시급" data-key="hour" onclick="selectPayType(this)">시급</button>
                  <button type="button" class="chip" data-val="일급" data-key="day" onclick="selectPayType(this)">일급</button>
                  <button type="button" class="chip" data-val="월급" data-key="month" onclick="selectPayType(this)">월급</button>
                  <button type="button" class="chip" data-val="건당" data-key="건당" onclick="selectPayType(this)">건당</button>
                </div>
                <input type="hidden" name="payType" id="payTypeHidden" value="시급">
              </div>
              <div class="form-group">
                <label for="pay">급여 금액 <span class="req">*</span></label>
                <input type="number" id="pay" name="pay" min="0" step="100"
                       placeholder="예) 12000" required oninput="onPayInput()">
                <div class="warn-box" id="payWarn">
                  ⚠️ 입력하신 시급이 최저임금(10,030원)보다 낮아요!
                </div>
                <div class="info-box">
                  <strong>2025년 최저시급: 10,030원</strong> — 최저임금 이상으로 설정해주세요.
                </div>
              </div>
            </div>
          </div>

          <!-- ── 카드 3: 근무 조건 ── -->
          <div class="form-card">
            <div class="form-card-header">
              <span class="form-card-step">3</span>
              <span class="form-card-title">📅 근무 조건</span>
            </div>
            <div class="form-card-body">
              <div class="form-group">
                <label>근무 유형 <span class="req">*</span></label>
                <div class="chip-group" id="workTypeGroup">
                  <button type="button" class="chip active" data-val="MORE_THAN_A_MONTH" onclick="selectWorkType(this)">1개월 이상</button>
                  <button type="button" class="chip" data-val="LESS_THAN_A_MONTH" onclick="selectWorkType(this)">단기</button>
                </div>
                <input type="hidden" name="workPeriod" id="workPeriodHidden" value="MORE_THAN_A_MONTH">
              </div>
              <div class="form-group">
                <label>근무 요일 <span class="req">*</span></label>
                <div class="day-chips" id="daySelector">
                  <button type="button" class="day-chip" data-val="MON" onclick="toggleDay(this)">월</button>
                  <button type="button" class="day-chip" data-val="TUE" onclick="toggleDay(this)">화</button>
                  <button type="button" class="day-chip" data-val="WED" onclick="toggleDay(this)">수</button>
                  <button type="button" class="day-chip" data-val="THU" onclick="toggleDay(this)">목</button>
                  <button type="button" class="day-chip" data-val="FRI" onclick="toggleDay(this)">금</button>
                  <button type="button" class="day-chip" data-val="SAT" onclick="toggleDay(this)">토</button>
                  <button type="button" class="day-chip" data-val="SUN" onclick="toggleDay(this)">일</button>
                </div>
                <div class="day-shortcut">
                  <button type="button" onclick="selectWeekdays()">평일 전체</button>
                  <button type="button" onclick="selectWeekend()">주말</button>
                  <button type="button" onclick="selectAllDays()">매일</button>
                </div>
                <input type="hidden" name="workDays" id="workDaysHidden" value="">
              </div>
              <div class="form-group">
                <label>근무 시간 <span class="req">*</span></label>
                <div class="time-row">
                  <input type="time" id="startTime" name="startTime" oninput="updatePreview()">
                  <span class="time-sep">–</span>
                  <input type="time" id="endTime" name="endTime" oninput="updatePreview()">
                </div>
                <div class="time-check">
                  <input type="checkbox" id="timeNegotiable" name="timeNegotiable" value="Y"
                         onchange="toggleTimeInput(this)">
                  <label for="timeNegotiable">시간 협의 가능</label>
                </div>
              </div>
              <div class="form-group">
                <label>근무 기간 <span class="opt">(선택)</span></label>
                <div class="input-row">
                  <input type="text" id="startDate" name="startDate" placeholder="시작일 예) 3월 3일">
                  <input type="text" id="endDate" name="endDate" placeholder="종료일 예) 3월 26일">
                </div>
              </div>
            </div>
          </div>

          <!-- ── 카드 4: 상세 정보 ── -->
          <div class="form-card">
            <div class="form-card-header">
              <span class="form-card-step">4</span>
              <span class="form-card-title">📌 상세 정보</span>
            </div>
            <div class="form-card-body">
              <div class="form-group">
                <label for="location">근무 지역 <span class="req">*</span></label>
                <div class="input-with-btn">
                  <input type="text" id="location" name="location"
                         placeholder="주소 검색 버튼을 눌러 검색하세요" required readonly
                         onclick="searchAddress()">
                  <button type="button" class="addr-btn" onclick="searchAddress()">
                    <i class="ri-map-pin-line"></i> 검색
                  </button>
                </div>
                <input type="text" id="locationDetail" name="locationDetail"
                       placeholder="상세 주소 입력 (예: 3층 302호)" style="margin-top:8px;">
                <input type="hidden" id="locationLat" name="locationLat">
                <input type="hidden" id="locationLng" name="locationLng">
              </div>
              <div class="form-group">
                <label for="deadline">모집 마감일 <span class="opt">(선택)</span></label>
                <input type="date" id="deadline" name="deadline"
                       min="${today}" oninput="updateDeadlineInfo()">
                <div id="deadlineInfo" class="info-box"></div>
              </div>
              <div class="form-group">
                <label for="contact">연락처 <span class="req">*</span></label>
                <input type="tel" id="contact" name="contact" placeholder="예) 010-1234-5678" required>
              </div>
              <div class="form-group">
                <label>특이사항 / 혜택 <span class="opt">(선택)</span></label>
                <div class="badge-group" id="badgeGroup">
                  <button type="button" class="badge-toggle" data-val="당일지급" onclick="toggleBadge(this)">💵 당일지급</button>
                  <button type="button" class="badge-toggle" data-val="주휴수당" onclick="toggleBadge(this)">📋 주휴수당</button>
                  <button type="button" class="badge-toggle" data-val="4대보험" onclick="toggleBadge(this)">🏥 4대보험</button>
                  <button type="button" class="badge-toggle" data-val="식사제공" onclick="toggleBadge(this)">🍱 식사제공</button>
                  <button type="button" class="badge-toggle" data-val="교통비지원" onclick="toggleBadge(this)">🚌 교통비지원</button>
                  <button type="button" class="badge-toggle" data-val="주차가능" onclick="toggleBadge(this)">🅿️ 주차가능</button>
                  <button type="button" class="badge-toggle" data-val="경력무관" onclick="toggleBadge(this)">✅ 경력무관</button>
                  <button type="button" class="badge-toggle" data-val="외국인가능" onclick="toggleBadge(this)">🌏 외국인가능</button>
                </div>
                <input type="hidden" name="benefits" id="benefitsHidden" value="">
              </div>
            </div>
          </div>

          <!-- ── 카드 5: 사진 ── -->
          <div class="form-card">
            <div class="form-card-header">
              <span class="form-card-step" style="background:var(--baton-muted)">📸</span>
              <span class="form-card-title">사진 <span style="font-size:12px;color:var(--baton-muted);font-weight:400">(최대 5장, 선택)</span></span>
            </div>
            <div class="form-card-body">
              <div class="image-upload-area" onclick="document.getElementById('imageInput').click()">
                <div class="upload-icon">📷</div>
                <p>사진을 눌러 추가하세요</p>
                <small>JPG, PNG · 장당 최대 10MB · 첫 번째 사진이 대표 이미지</small>
              </div>
              <input type="file" id="imageInput" name="images" multiple accept="image/*" onchange="handleImageUpload(this)">
              <div class="image-preview-grid" id="imagePreviewGrid"></div>
            </div>
          </div>

        </form>
      </div><!-- /content -->
    </div><!-- /baton-page -->

    <!-- 하단 고정 바 -->
    <div class="submit-bar">
      <a href="${pageContext.request.contextPath}/alba/posting/list" class="btn-ghost">
        <i class="ri-arrow-left-line"></i> 목록으로
      </a>
      <button type="button" class="btn-primary" id="submitBtn" onclick="submitForm()">
        <i class="ri-check-line"></i> 공고 등록하기
      </button>
    </div>

  </main>
</div>
<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
/* ── 주소 검색 ── */
function searchAddress() {
  new daum.Postcode({
    oncomplete: function(data) {
      document.getElementById('location').value = data.roadAddress || data.jibunAddress;
      document.getElementById('locationDetail').focus();
      updateProgress();
      updatePreview();
    }
  }).open();
}

/* ── 급여 유형 ── */
function selectPayType(btn) {
  document.querySelectorAll('#payTypeGroup .chip').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
  document.getElementById('payTypeHidden').value = btn.dataset.val;
  const badge = document.getElementById('prevPayBadge');
  badge.className = 'pay-badge ' + btn.dataset.key;
  badge.textContent = btn.dataset.val;
  onPayInput(); updatePreview();
}

/* ── 근무 유형 ── */
function selectWorkType(btn) {
  document.querySelectorAll('#workTypeGroup .chip').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
  document.getElementById('workPeriodHidden').value = btn.dataset.val;
}

/* ── 요일 ── */
function toggleDay(btn) { btn.classList.toggle('active'); syncDays(); updatePreview(); updateProgress(); }
function selectWeekdays() {
  document.querySelectorAll('.day-chip').forEach(b => {
    const we = ['SAT','SUN'].includes(b.dataset.val);
    b.classList.toggle('active', !we);
  });
  syncDays(); updatePreview();
}
function selectWeekend() {
  document.querySelectorAll('.day-chip').forEach(b => {
    b.classList.toggle('active', ['SAT','SUN'].includes(b.dataset.val));
  });
  syncDays(); updatePreview();
}
function selectAllDays() {
  document.querySelectorAll('.day-chip').forEach(b => b.classList.add('active'));
  syncDays(); updatePreview();
}
function syncDays() {
  document.getElementById('workDaysHidden').value =
    [...document.querySelectorAll('.day-chip.active')].map(b => b.dataset.val).join(',');
}
const DAY_LABEL = {MON:'월',TUE:'화',WED:'수',THU:'목',FRI:'금',SAT:'토',SUN:'일'};
function daysText() {
  const vals = [...document.querySelectorAll('.day-chip.active')].map(b => b.dataset.val);
  if (!vals.length) return '요일 미설정';
  if (vals.length === 7) return '매일';
  if (JSON.stringify(vals) === JSON.stringify(['MON','TUE','WED','THU','FRI'])) return '월~금';
  if (JSON.stringify(vals) === JSON.stringify(['SAT','SUN'])) return '토, 일';
  return vals.map(v => DAY_LABEL[v]).join(', ');
}

/* ── 시간 ── */
function toggleTimeInput(cb) {
  const st = document.getElementById('startTime');
  const et = document.getElementById('endTime');
  st.disabled = et.disabled = cb.checked;
  if (cb.checked) { st.value = ''; et.value = ''; }
  updatePreview();
}

/* ── 급여 입력 ── */
const MIN_WAGE = 10030;
function onPayInput() {
  const payType = document.getElementById('payTypeHidden').value;
  const val = parseInt(document.getElementById('pay').value, 10);
  const warn = document.getElementById('payWarn');
  warn.style.display = (payType === '시급' && val > 0 && val < MIN_WAGE) ? 'block' : 'none';
  updatePreview(); updateProgress();
}

/* ── 마감일 ── */
function updateDeadlineInfo() {
  const val = document.getElementById('deadline').value;
  const box = document.getElementById('deadlineInfo');
  if (!val) { box.style.display = 'none'; return; }
  const diff = Math.ceil((new Date(val) - new Date()) / 86400000);
  if (diff < 0) {
    box.innerHTML = '⚠️ 이미 지난 날짜입니다.';
    box.style.background = '#fff0f0'; box.style.borderColor = '#ffd0d0'; box.style.color = '#e53935';
  } else if (diff === 0) {
    box.innerHTML = '📅 <strong>오늘 마감</strong>입니다.';
    box.style.background = ''; box.style.borderColor = ''; box.style.color = '';
  } else {
    // JSP EL 충돌 방지를 위해 \${...} 사용
    box.innerHTML = `📅 <strong>D-\${diff}</strong> — \${val.replaceAll('-','.')} 마감`;
    box.style.background = ''; box.style.borderColor = ''; box.style.color = '';
  }
  box.style.display = 'block';
}

/* ── 혜택 배지 ── */
function toggleBadge(btn) {
  btn.classList.toggle('active');
  document.getElementById('benefitsHidden').value =
    [...document.querySelectorAll('#badgeGroup .badge-toggle.active')].map(b => b.dataset.val).join(',');
}

/* ── 이미지 ── */
const uploadedFiles = [];
function handleImageUpload(input) {
  const grid = document.getElementById('imagePreviewGrid');
  [...input.files].slice(0, 5 - uploadedFiles.length).forEach(file => {
    if (!file.type.startsWith('image/')) return;
    uploadedFiles.push(file);
    const reader = new FileReader();
    reader.onload = e => {
      const item = document.createElement('div');
      item.className = 'preview-img-item';
      // JSP EL 충돌 방지를 위해 \${...} 사용
      item.innerHTML = `<img src="\${e.target.result}" alt="preview">
        <button type="button" class="preview-remove" onclick="removeImage(this)">✕</button>`;
      grid.appendChild(item);
      if (uploadedFiles.length === 1) {
        const thumb = document.getElementById('prevThumb');
        thumb.innerHTML = `<img src="\${e.target.result}" alt="thumb" style="width:100%;height:100%;object-fit:cover;border-radius:8px;">`;
      }
    };
    reader.readAsDataURL(file);
  });
  input.value = '';
}
function removeImage(btn) {
  const item = btn.closest('.preview-img-item');
  const grid = document.getElementById('imagePreviewGrid');
  uploadedFiles.splice([...grid.children].indexOf(item), 1);
  item.remove();
  if (!uploadedFiles.length) document.getElementById('prevThumb').innerHTML = '📋';
}

/* ── 문자 카운트 ── */
function updateCharCount(inputId, countId, max) {
  document.getElementById(countId).textContent = document.getElementById(inputId).value.length;
}

/* ── 미리보기 업데이트 ── */
function updatePreview() {
  document.getElementById('prevTitle').textContent =
    document.getElementById('title').value || '공고 제목이 여기 표시됩니다';
  document.getElementById('prevEmployer').textContent =
    document.getElementById('employer').value || '업체명';

  const pay = document.getElementById('pay').value;
  document.getElementById('prevPayAmt').textContent = pay ? Number(pay).toLocaleString() + '원' : '0원';

  const st = document.getElementById('startTime').value;
  const et = document.getElementById('endTime').value;
  const negotiable = document.getElementById('timeNegotiable').checked;
  
  // JSP EL 충돌 방지를 위해 \${...} 사용
  const time = negotiable ? '시간협의' : (st && et ? `\${st}~\${et}` : '시간 미설정');
  const loc = document.getElementById('location').value || '지역 미설정';

  document.getElementById('prevMeta').innerHTML = `
    <span><i class="ri-calendar-line"></i>\${daysText()}</span><br>
    <span><i class="ri-time-line"></i>\${time}</span><br>
    <span><i class="ri-map-pin-line"></i>\${loc}</span>
  `;
  updateProgress();
}

/* ── 진행도 업데이트 ── */
function updateProgress() {
  const checks = [
    !!document.getElementById('title').value.trim(),
    !!document.getElementById('pay').value,
    !!document.getElementById('workDaysHidden').value,
    !!document.getElementById('location').value.trim()
  ];
  checks.forEach((done, i) => {
    const pi = document.getElementById('pi' + (i+1));
    const pb = document.getElementById('pb' + (i+1));
    if (pi) pi.classList.toggle('done', done);
    if (pb) pb.style.width = done ? '100%' : '0%';
  });
}

/* ── 제출 ── */
function submitForm() {
  const title   = document.getElementById('title').value.trim();
  const pay     = document.getElementById('pay').value;
  const loc     = document.getElementById('location').value.trim();
  const contact = document.getElementById('contact').value.trim();
  const days    = document.getElementById('workDaysHidden').value;
  const payType = document.getElementById('payTypeHidden').value;
  const deadline = document.getElementById('deadline').value;

  if (!title)   { alert('공고 제목을 입력해주세요.'); document.getElementById('title').focus(); return; }
  if (!pay)     { alert('급여를 입력해주세요.'); document.getElementById('pay').focus(); return; }
  if (payType === '시급' && parseInt(pay,10) < 10030) {
    if (!confirm('최저임금(10,030원)보다 낮은 시급입니다. 그래도 등록하시겠어요?')) return;
  }
  if (!days)    { alert('근무 요일을 선택해주세요.'); return; }
  if (!loc)     { alert('근무 지역을 검색해주세요.'); return; }
  if (!contact) { alert('연락처를 입력해주세요.'); document.getElementById('contact').focus(); return; }
  if (deadline && Math.ceil((new Date(deadline) - new Date()) / 86400000) < 0) {
    alert('마감일이 이미 지났어요. 다시 선택해주세요.');
    document.getElementById('deadline').focus(); return;
  }
  const btn = document.getElementById('submitBtn');
  btn.disabled = true; btn.innerHTML = '<i class="ri-loader-4-line"></i> 등록 중...';
  document.getElementById('writeForm').submit();
}

/* 초기화 */
updatePreview();
</script>
</body>
</html>
