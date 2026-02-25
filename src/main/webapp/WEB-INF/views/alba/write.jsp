<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>알바 공고 쓰기 | 바통터치</title>
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
    --border-focus: #0057FF;
    --error: #E53935;
    --r: 14px;
    --r-sm: 8px;
    --shadow-sm: 0 1px 3px rgba(0,0,0,.06);
    --shadow-md: 0 4px 16px rgba(0,0,0,.08);
  }
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
  body { background: var(--bg); font-family: 'Pretendard', 'Noto Sans KR', sans-serif; color: var(--text); }

  .write-page {
    max-width: 720px;
    margin: 0 auto;
    padding: 28px 20px 100px;
  }

  /* ── Header ── */
  .page-header {
    display: flex; align-items: center; gap: 14px; margin-bottom: 28px;
  }
  .back-btn {
    width: 38px; height: 38px;
    border: 1.5px solid var(--border);
    border-radius: 50%;
    background: var(--white);
    display: flex; align-items: center; justify-content: center;
    cursor: pointer; font-size: 18px; color: var(--sub);
    transition: all .15s; text-decoration: none; flex-shrink: 0;
    box-shadow: var(--shadow-sm);
  }
  .back-btn:hover { border-color: var(--blue); color: var(--blue); }
  .page-title-wrap {}
  .page-title { font-size: 22px; font-weight: 800; color: var(--text); letter-spacing: -.3px; }
  .page-subtitle { font-size: 13px; color: var(--muted); font-weight: 500; margin-top: 2px; }

  /* ── Progress ── */
  .progress-bar {
    display: flex; gap: 6px; margin-bottom: 24px;
  }
  .progress-step {
    flex: 1; height: 4px; border-radius: 2px; background: var(--border);
    transition: background .3s;
  }
  .progress-step.done { background: var(--blue); }

  /* ── Preview Panel ── */
  .preview-panel {
    background: var(--white);
    border: 2px solid var(--blue-mid);
    border-radius: var(--r);
    padding: 20px;
    margin-bottom: 16px;
    display: none;
    animation: fadeDown .3s ease;
  }
  .preview-panel.show { display: block; }
  @keyframes fadeDown {
    from { opacity: 0; transform: translateY(-8px); }
    to   { opacity: 1; transform: translateY(0); }
  }
  .preview-label {
    font-size: 11px; font-weight: 700; color: var(--blue);
    letter-spacing: .08em; text-transform: uppercase; margin-bottom: 12px;
    display: flex; align-items: center; gap: 6px;
  }
  .preview-card {
    display: flex; gap: 14px; padding: 14px;
    border: 1px solid var(--border); border-radius: 10px; background: var(--bg);
  }
  .preview-thumb {
    width: 64px; height: 64px; border-radius: 8px;
    background: var(--blue-light); border: 1px solid var(--border);
    display: flex; align-items: center; justify-content: center;
    font-size: 22px; flex-shrink: 0; overflow: hidden;
  }
  .preview-thumb img { width: 100%; height: 100%; object-fit: cover; }
  .preview-info .ptitle { font-size: 14px; font-weight: 700; margin-bottom: 3px; color: var(--text); }
  .preview-info .pemployer { font-size: 12px; color: var(--muted); margin-bottom: 5px; }
  .preview-info .ppay { font-size: 13px; font-weight: 800; color: var(--blue); margin-bottom: 3px; }
  .preview-info .pschedule { font-size: 12px; color: var(--sub); }

  /* ── Form Cards ── */
  .form-card {
    background: var(--white);
    border: 1px solid var(--border);
    border-radius: var(--r);
    padding: 24px 26px;
    margin-bottom: 14px;
    box-shadow: var(--shadow-sm);
    transition: box-shadow .2s;
  }
  .form-card:focus-within { box-shadow: var(--shadow-md); }
  .form-card-title {
    font-size: 14px; font-weight: 800; color: var(--text);
    margin-bottom: 20px; padding-bottom: 14px;
    border-bottom: 1px solid var(--border);
    display: flex; align-items: center; gap: 8px;
    letter-spacing: -.1px;
  }
  .form-card-title .card-step {
    width: 22px; height: 22px; border-radius: 50%;
    background: var(--blue); color: white;
    font-size: 11px; font-weight: 800;
    display: flex; align-items: center; justify-content: center;
    flex-shrink: 0;
  }
  .form-group { margin-bottom: 20px; }
  .form-group:last-child { margin-bottom: 0; }

  label {
    display: block; font-size: 13px; font-weight: 700;
    color: var(--text); margin-bottom: 8px;
  }
  label .required { color: var(--blue); margin-left: 2px; }
  label .optional { color: var(--muted); font-weight: 400; font-size: 12px; margin-left: 4px; }

  input[type="text"],
  input[type="number"],
  input[type="tel"],
  input[type="time"],
  textarea,
  select {
    width: 100%; padding: 12px 14px;
    border: 1.5px solid var(--border);
    border-radius: var(--r-sm);
    font-family: inherit; font-size: 14px;
    color: var(--text); background: var(--white);
    transition: border-color .15s, box-shadow .15s;
    appearance: none; outline: none;
  }
  input:focus, textarea:focus, select:focus {
    border-color: var(--border-focus);
    box-shadow: 0 0 0 3px rgba(0,87,255,.1);
  }
  input::placeholder, textarea::placeholder { color: var(--muted); }
  textarea { resize: vertical; min-height: 130px; line-height: 1.7; }
  select {
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%239AA3B0' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
    background-repeat: no-repeat; background-position: right 14px center;
    padding-right: 38px; cursor: pointer;
  }

  .input-with-suffix { position: relative; display: flex; align-items: center; }
  .input-with-suffix input { padding-right: 48px; }
  .input-suffix {
    position: absolute; right: 14px; font-size: 14px;
    color: var(--sub); font-weight: 700; pointer-events: none;
  }
  .input-row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
  .char-count { font-size: 11px; color: var(--muted); text-align: right; margin-top: 5px; }

  /* Pay type */
  .pay-type-group { display: flex; gap: 8px; margin-bottom: 12px; flex-wrap: wrap; }
  .pay-type-btn {
    padding: 8px 16px; border-radius: var(--r-sm);
    border: 1.5px solid var(--border); background: var(--white);
    font-family: inherit; font-size: 13px; font-weight: 700;
    color: var(--sub); cursor: pointer; transition: all .15s;
  }
  .pay-type-btn:hover { border-color: var(--blue-mid); color: var(--blue); }
  .pay-type-btn.active { border-color: var(--blue); background: var(--blue); color: white; }

  /* Day selector */
  .day-selector { display: flex; gap: 6px; flex-wrap: wrap; }
  .day-btn {
    width: 44px; height: 44px; border-radius: 50%;
    border: 1.5px solid var(--border); background: var(--white);
    font-family: inherit; font-size: 13px; font-weight: 700;
    color: var(--sub); cursor: pointer; transition: all .15s;
    display: flex; align-items: center; justify-content: center;
  }
  .day-btn:hover { border-color: var(--blue-mid); color: var(--blue); }
  .day-btn.active { border-color: var(--blue); background: var(--blue); color: white; box-shadow: 0 2px 8px rgba(0,87,255,.3); }
  .day-extra { display: flex; gap: 6px; margin-top: 10px; }
  .day-extra-btn {
    padding: 6px 13px; border-radius: 20px;
    border: 1.5px solid var(--border); background: var(--white);
    font-family: inherit; font-size: 12px; font-weight: 600;
    color: var(--sub); cursor: pointer; transition: all .15s;
  }
  .day-extra-btn:hover { border-color: var(--blue); color: var(--blue); background: var(--blue-light); }

  /* Time row */
  .time-row { display: flex; align-items: center; gap: 10px; }
  .time-row input { max-width: 130px; }
  .time-sep { color: var(--muted); font-weight: 600; flex-shrink: 0; font-size: 18px; }
  .time-check { display: flex; align-items: center; gap: 7px; margin-top: 10px; }
  .time-check input[type="checkbox"] { width: 16px; height: 16px; accent-color: var(--blue); cursor: pointer; }
  .time-check label { font-size: 13px; color: var(--sub); font-weight: 500; cursor: pointer; margin-bottom: 0; }

  /* Image upload */
  .image-upload-area {
    border: 2px dashed var(--border); border-radius: 10px; padding: 28px 20px;
    text-align: center; cursor: pointer; transition: all .15s; background: var(--bg);
  }
  .image-upload-area:hover { border-color: var(--blue); background: var(--blue-light); }
  .image-upload-area .upload-icon { font-size: 32px; margin-bottom: 8px; }
  .image-upload-area p { font-size: 14px; font-weight: 600; color: var(--sub); }
  .image-upload-area small { font-size: 12px; color: var(--muted); margin-top: 4px; display: block; }
  #imageInput { display: none; }
  .image-preview-grid { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 12px; }
  .preview-item { position: relative; width: 80px; height: 80px; border-radius: 8px; overflow: hidden; border: 1px solid var(--border); }
  .preview-item img { width: 100%; height: 100%; object-fit: cover; }
  .preview-remove {
    position: absolute; top: 3px; right: 3px; width: 20px; height: 20px; border-radius: 50%;
    background: rgba(0,0,0,.65); color: white; border: none; cursor: pointer; font-size: 11px;
    display: flex; align-items: center; justify-content: center;
  }

  /* Badge group */
  .badge-group { display: flex; flex-wrap: wrap; gap: 8px; }
  .badge-toggle {
    padding: 7px 14px; border-radius: 20px;
    border: 1.5px solid var(--border); background: var(--white);
    font-family: inherit; font-size: 13px; font-weight: 600;
    color: var(--sub); cursor: pointer; transition: all .15s;
  }
  .badge-toggle:hover { border-color: var(--border); background: var(--bg); }
  .badge-toggle.active { border-color: var(--blue); background: var(--blue-light); color: var(--blue); }

  /* Info box */
  .info-box {
    background: var(--blue-light); border: 1px solid var(--blue-mid);
    border-radius: var(--r-sm); padding: 11px 14px; font-size: 12px;
    color: var(--sub); line-height: 1.6; margin-top: 8px;
  }
  .info-box strong { color: var(--blue); font-weight: 700; }

  /* Submit bar */
  .submit-bar {
    position: fixed; bottom: 0; left: 0; right: 0;
    background: rgba(255,255,255,.95); backdrop-filter: blur(12px);
    border-top: 1px solid var(--border);
    padding: 14px 24px; display: flex; gap: 10px; justify-content: flex-end; z-index: 80;
    box-shadow: 0 -4px 20px rgba(0,0,0,.06);
  }
  .btn-preview {
    padding: 13px 20px; border-radius: var(--r-sm);
    border: 1.5px solid var(--border); background: var(--white);
    font-family: inherit; font-size: 14px; font-weight: 700; color: var(--sub);
    cursor: pointer; transition: all .15s;
  }
  .btn-preview:hover { border-color: var(--blue); color: var(--blue); }
  .btn-submit {
    padding: 13px 32px; border-radius: var(--r-sm); border: none;
    background: var(--blue); color: white;
    font-family: inherit; font-size: 15px; font-weight: 800; cursor: pointer;
    transition: all .15s; box-shadow: 0 2px 10px rgba(0,87,255,.35);
    letter-spacing: -.1px;
  }
  .btn-submit:hover { background: var(--blue-hover); transform: translateY(-1px); box-shadow: 0 4px 16px rgba(0,87,255,.45); }
  .btn-submit:disabled { opacity: .45; cursor: not-allowed; transform: none; box-shadow: none; }

  @keyframes fadeUp {
    from { opacity:0; transform: translateY(8px); }
    to   { opacity:1; transform: translateY(0); }
  }

  @media (max-width: 600px) {
    .input-row { grid-template-columns: 1fr; }
    .write-page { padding: 18px 14px 100px; }
    .form-card { padding: 20px 18px; }
    .submit-bar { padding: 12px 16px; }
  }
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp" />
<div id="baton-layout-container">
  <main id="baton-main-content">
    <div class="write-page">

      <div class="page-header">
        <a href="${pageContext.request.contextPath}/alba/posting/list" class="back-btn" title="목록으로">←</a>
        <div class="page-title-wrap">
          <div class="page-title">✏️ 알바 공고 쓰기</div>
          <div class="page-subtitle">바통터치에 공고를 등록하고 알바생을 찾아보세요</div>
        </div>
      </div>

      <!-- 진행 표시 -->
      <div class="progress-bar" id="progressBar">
        <div class="progress-step done" id="step1"></div>
        <div class="progress-step" id="step2"></div>
        <div class="progress-step" id="step3"></div>
        <div class="progress-step" id="step4"></div>
      </div>

      <!-- 미리보기 패널 -->
      <div class="preview-panel" id="previewPanel">
        <div class="preview-label">👀 미리보기</div>
        <div class="preview-card">
          <div class="preview-thumb" id="prevThumb">🏃</div>
          <div class="preview-info">
            <div class="ptitle" id="prevTitle">공고 제목이 여기 표시됩니다</div>
            <div class="pemployer" id="prevEmployer">업체명</div>
            <div class="ppay" id="prevPay">시급 0원</div>
            <div class="pschedule" id="prevSchedule">요일 · 시간</div>
          </div>
        </div>
      </div>

      <form id="writeForm" action="${pageContext.request.contextPath}/alba/posting/write" method="post" enctype="multipart/form-data">

        <!-- 카드 1: 기본 정보 -->
        <div class="form-card">
          <div class="form-card-title">
            <span class="card-step">1</span>
            기본 정보
          </div>
          <div class="form-group">
            <label for="title">공고 제목 <span class="required">*</span></label>
            <input type="text" id="title" name="title" maxlength="50"
                   placeholder="예) 주말 카페 서빙 알바 구합니다" required
                   oninput="updatePreview(); updateCharCount('title','titleCount',50)">
            <div class="char-count"><span id="titleCount">0</span>/50자</div>
          </div>
          <div class="form-group">
            <label for="employer">업체명 <span class="optional">(선택)</span></label>
            <input type="text" id="employer" name="employer" maxlength="30"
                   placeholder="예) 약수상회, 이웃알바"
                   oninput="updatePreview()">
          </div>
          <div class="form-group">
            <label>카테고리 <span class="required">*</span></label>
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
            <label for="description">공고 내용 <span class="required">*</span></label>
            <textarea id="description" name="description" rows="6" maxlength="1000"
                      placeholder="업무 내용, 자격 요건, 우대 사항 등을 자세히 적어주세요."
                      required oninput="updateCharCount('description','descCount',1000)"></textarea>
            <div class="char-count"><span id="descCount">0</span>/1000자</div>
          </div>
        </div>

        <!-- 카드 2: 급여 -->
        <div class="form-card">
          <div class="form-card-title">
            <span class="card-step">2</span>
            💰 급여
          </div>
          <div class="form-group">
            <label>급여 유형 <span class="required">*</span></label>
            <div class="pay-type-group" id="payTypeGroup">
              <button type="button" class="pay-type-btn active" data-val="시급" onclick="selectPayType(this)">시급</button>
              <button type="button" class="pay-type-btn" data-val="일급" onclick="selectPayType(this)">일급</button>
              <button type="button" class="pay-type-btn" data-val="월급" onclick="selectPayType(this)">월급</button>
              <button type="button" class="pay-type-btn" data-val="건당" onclick="selectPayType(this)">건당</button>
            </div>
            <input type="hidden" name="payType" id="payTypeHidden" value="시급">
          </div>
          <div class="form-group">
            <label for="pay">급여 <span class="required">*</span></label>
            <div class="input-with-suffix">
              <input type="number" id="pay" name="pay" min="0" step="100"
                     placeholder="예) 12000" required oninput="updatePreview()">
              <span class="input-suffix">원</span>
            </div>
            <div class="info-box" style="margin-top:10px">
              <strong>2025년 최저시급: 10,030원</strong> — 최저임금 이상으로 설정해주세요.
            </div>
          </div>
        </div>

        <!-- 카드 3: 근무 조건 -->
        <div class="form-card">
          <div class="form-card-title">
            <span class="card-step">3</span>
            📅 근무 조건
          </div>
          <div class="form-group">
            <label>근무 유형 <span class="required">*</span></label>
            <div class="pay-type-group">
              <button type="button" class="pay-type-btn active" data-val="MORE_THAN_A_MONTH" onclick="selectWorkType(this)">1개월 이상</button>
              <button type="button" class="pay-type-btn" data-val="LESS_THAN_A_MONTH" onclick="selectWorkType(this)">단기</button>
            </div>
            <input type="hidden" name="workPeriod" id="workPeriodHidden" value="MORE_THAN_A_MONTH">
          </div>
          <div class="form-group">
            <label>근무 요일 <span class="required">*</span></label>
            <div class="day-selector" id="daySelector">
              <button type="button" class="day-btn" data-val="MON" onclick="toggleDay(this)">월</button>
              <button type="button" class="day-btn" data-val="TUE" onclick="toggleDay(this)">화</button>
              <button type="button" class="day-btn" data-val="WED" onclick="toggleDay(this)">수</button>
              <button type="button" class="day-btn" data-val="THU" onclick="toggleDay(this)">목</button>
              <button type="button" class="day-btn" data-val="FRI" onclick="toggleDay(this)">금</button>
              <button type="button" class="day-btn" data-val="SAT" onclick="toggleDay(this)">토</button>
              <button type="button" class="day-btn" data-val="SUN" onclick="toggleDay(this)">일</button>
            </div>
            <div class="day-extra">
              <button type="button" class="day-extra-btn" onclick="selectAllDays()">평일 전체</button>
              <button type="button" class="day-extra-btn" onclick="selectWeekend()">주말</button>
              <button type="button" class="day-extra-btn" onclick="selectAllDays2()">매일</button>
            </div>
            <input type="hidden" name="workDays" id="workDaysHidden" value="">
          </div>
          <div class="form-group">
            <label>근무 시간 <span class="required">*</span></label>
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
            <label>근무 기간 <span class="optional">(선택)</span></label>
            <div class="input-row">
              <div>
                <input type="text" id="startDate" name="startDate" placeholder="시작일 예) 3월 3일">
              </div>
              <div>
                <input type="text" id="endDate" name="endDate" placeholder="종료일 예) 3월 26일">
              </div>
            </div>
          </div>
        </div>

        <!-- 카드 4: 상세 정보 -->
        <div class="form-card">
          <div class="form-card-title">
            <span class="card-step">4</span>
            📌 상세 정보
          </div>
          <div class="form-group">
            <label for="location">근무 지역 <span class="required">*</span></label>
            <input type="text" id="location" name="location" placeholder="예) 서울 중구 신당동" required>
          </div>
          <div class="form-group">
            <label for="contact">연락처 <span class="required">*</span></label>
            <input type="tel" id="contact" name="contact" placeholder="예) 010-1234-5678" required>
          </div>
          <div class="form-group">
            <label>특이사항 / 혜택 <span class="optional">(선택)</span></label>
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

        <!-- 사진 카드 -->
        <div class="form-card">
          <div class="form-card-title">📸 사진 <span style="font-size:12px;color:var(--muted);font-weight:400;text-transform:none">(최대 5장, 선택)</span></div>
          <div class="image-upload-area" onclick="document.getElementById('imageInput').click()">
            <div class="upload-icon">📷</div>
            <p>사진을 눌러 추가하세요</p>
            <small>JPG, PNG · 장당 최대 10MB · 첫 번째 사진이 대표 이미지</small>
          </div>
          <input type="file" id="imageInput" name="images" multiple accept="image/*" onchange="handleImageUpload(this)">
          <div class="image-preview-grid" id="imagePreviewGrid"></div>
        </div>

      </form>
    </div>

    <div class="submit-bar">
      <button type="button" class="btn-preview" onclick="togglePreview()">👁 미리보기</button>
      <button type="button" class="btn-submit" id="submitBtn" onclick="submitForm()">공고 등록하기 →</button>
    </div>
  </main>
</div>
<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
<script>
function selectPayType(btn) {
  document.querySelectorAll('#payTypeGroup .pay-type-btn').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
  document.getElementById('payTypeHidden').value = btn.dataset.val;
  updatePreview();
}
function selectWorkType(btn) {
  btn.closest('.form-group').querySelectorAll('.pay-type-btn').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
  document.getElementById('workPeriodHidden').value = btn.dataset.val;
}
function toggleDay(btn) {
  btn.classList.toggle('active');
  syncDays(); updatePreview(); updateProgress();
}
function selectAllDays() {
  ['MON','TUE','WED','THU','FRI'].forEach(val => {
    const btn = document.querySelector(`.day-btn[data-val="${val}"]`);
    if (btn) btn.classList.add('active');
  });
  ['SAT','SUN'].forEach(val => {
    const btn = document.querySelector(`.day-btn[data-val="${val}"]`);
    if (btn) btn.classList.remove('active');
  });
  syncDays(); updatePreview();
}
function selectWeekend() {
  ['MON','TUE','WED','THU','FRI'].forEach(val => {
    const btn = document.querySelector(`.day-btn[data-val="${val}"]`);
    if (btn) btn.classList.remove('active');
  });
  ['SAT','SUN'].forEach(val => {
    const btn = document.querySelector(`.day-btn[data-val="${val}"]`);
    if (btn) btn.classList.add('active');
  });
  syncDays(); updatePreview();
}
function selectAllDays2() {
  document.querySelectorAll('.day-btn').forEach(b => b.classList.add('active'));
  syncDays(); updatePreview();
}
function syncDays() {
  const vals = [...document.querySelectorAll('.day-btn.active')].map(b => b.dataset.val);
  document.getElementById('workDaysHidden').value = vals.join(',');
}
const DAY_MAP = {MON:'월',TUE:'화',WED:'수',THU:'목',FRI:'금',SAT:'토',SUN:'일'};
function daysText() {
  const vals = [...document.querySelectorAll('.day-btn.active')].map(b => b.dataset.val);
  if (!vals.length) return '';
  if (vals.length === 7) return '매일';
  if (JSON.stringify(vals) === JSON.stringify(['MON','TUE','WED','THU','FRI'])) return '월~금';
  if (JSON.stringify(vals) === JSON.stringify(['SAT','SUN'])) return '토,일';
  return vals.map(v => DAY_MAP[v]).join(', ');
}
function toggleTimeInput(cb) {
  const st = document.getElementById('startTime');
  const et = document.getElementById('endTime');
  st.disabled = et.disabled = cb.checked;
  if (cb.checked) { st.value = ''; et.value = ''; }
  updatePreview();
}
function toggleBadge(btn) {
  btn.classList.toggle('active');
  const vals = [...document.querySelectorAll('#badgeGroup .badge-toggle.active')].map(b => b.dataset.val);
  document.getElementById('benefitsHidden').value = vals.join(',');
}
const uploadedFiles = [];
function handleImageUpload(input) {
  const grid = document.getElementById('imagePreviewGrid');
  const files = [...input.files];
  const remain = 5 - uploadedFiles.length;
  files.slice(0, remain).forEach(file => {
    if (!file.type.startsWith('image/')) return;
    uploadedFiles.push(file);
    const reader = new FileReader();
    reader.onload = e => {
      const item = document.createElement('div');
      item.className = 'preview-item';
      item.innerHTML = `<img src="${e.target.result}" alt="preview">
        <button type="button" class="preview-remove" onclick="removeImage(this)">✕</button>`;
      grid.appendChild(item);
      if (uploadedFiles.length === 1) {
        document.getElementById('prevThumb').innerHTML = `<img src="${e.target.result}" alt="thumb">`;
      }
    };
    reader.readAsDataURL(file);
  });
  input.value = '';
}
function removeImage(btn) {
  const item = btn.closest('.preview-item');
  const grid = document.getElementById('imagePreviewGrid');
  const idx = [...grid.children].indexOf(item);
  uploadedFiles.splice(idx, 1);
  item.remove();
  if (uploadedFiles.length === 0) document.getElementById('prevThumb').innerHTML = '🏃';
}
function updateCharCount(inputId, countId, max) {
  document.getElementById(countId).textContent = document.getElementById(inputId).value.length;
}
function updatePreview() {
  const title    = document.getElementById('title').value || '공고 제목이 여기 표시됩니다';
  const employer = document.getElementById('employer').value || '업체명';
  const pay      = document.getElementById('pay').value;
  const payType  = document.getElementById('payTypeHidden').value;
  const st       = document.getElementById('startTime').value;
  const et       = document.getElementById('endTime').value;
  const negotiable = document.getElementById('timeNegotiable').checked;
  document.getElementById('prevTitle').textContent = title;
  document.getElementById('prevEmployer').textContent = employer;
  document.getElementById('prevPay').innerHTML =
    `<span style="color:var(--sub);font-weight:500;font-size:12px">${payType}</span> ${pay ? Number(pay).toLocaleString() + '원' : '0원'}`;
  const days = daysText();
  const time = negotiable ? '협의' : (st && et ? `${st}~${et}` : '');
  document.getElementById('prevSchedule').textContent = [days, time].filter(Boolean).join(' · ');
  updateProgress();
}
function updateProgress() {
  const title   = document.getElementById('title').value.trim();
  const pay     = document.getElementById('pay').value;
  const days    = document.getElementById('workDaysHidden').value;
  const loc     = document.getElementById('location').value.trim();
  const steps = [
    !!title,
    !!pay,
    !!days,
    !!loc
  ];
  steps.forEach((done, i) => {
    const el = document.getElementById('step' + (i+1));
    if (el) el.classList.toggle('done', done);
  });
}
function togglePreview() {
  updatePreview();
  const panel = document.getElementById('previewPanel');
  panel.classList.toggle('show');
  if (panel.classList.contains('show')) {
    panel.scrollIntoView({ behavior: 'smooth', block: 'start' });
  }
}
function submitForm() {
  const title   = document.getElementById('title').value.trim();
  const pay     = document.getElementById('pay').value;
  const loc     = document.getElementById('location').value.trim();
  const contact = document.getElementById('contact').value.trim();
  const days    = document.getElementById('workDaysHidden').value;
  if (!title)   { alert('공고 제목을 입력해주세요.'); document.getElementById('title').focus(); return; }
  if (!pay)     { alert('급여를 입력해주세요.'); document.getElementById('pay').focus(); return; }
  if (!days)    { alert('근무 요일을 선택해주세요.'); return; }
  if (!loc)     { alert('근무 지역을 입력해주세요.'); document.getElementById('location').focus(); return; }
  if (!contact) { alert('연락처를 입력해주세요.'); document.getElementById('contact').focus(); return; }
  const btn = document.getElementById('submitBtn');
  btn.disabled = true; btn.textContent = '등록 중...';
  document.getElementById('writeForm').submit();
}
updatePreview();
</script>
</body>
</html>
