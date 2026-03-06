<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/WEB-INF/views/layout/headerResources.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>공고 등록 | BATON ALBA</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main/main.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/alba/alba-write.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="alba-write-container">
  <div class="alba-write-inner">

    <%-- ===== 사이드바 ===== --%>
    <aside class="alba-write-sidebar">

      <div class="sidebar-header">
        <div class="sidebar-title-label"><i class="ri-briefcase-4-line"></i> 공고 미리보기</div>
        <div class="sidebar-title-main">등록될 공고 모습</div>
      </div>

      <div class="preview-section">
        <div class="preview-section-title">썸네일 미리보기</div>
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
        <div class="progress-label">작성 진행도</div>
        <div class="progress-steps">
          <div class="progress-item" id="pi1">
            <div class="progress-dot">1</div> 공고 제목
          </div>
          <div class="progress-bar-line"><div class="progress-bar-fill" id="pb1"></div></div>
          <div class="progress-item" id="pi2">
            <div class="progress-dot">2</div> 급여 설정
          </div>
          <div class="progress-bar-line"><div class="progress-bar-fill" id="pb2"></div></div>
          <div class="progress-item" id="pi3">
            <div class="progress-dot">3</div> 근무 요일
          </div>
          <div class="progress-bar-line"><div class="progress-bar-fill" id="pb3"></div></div>
          <div class="progress-item" id="pi4">
            <div class="progress-dot">4</div> 근무 위치
          </div>
          <div class="progress-bar-line"><div class="progress-bar-fill" id="pb4"></div></div>
        </div>
      </div>

    </aside>

    <%-- ===== 메인 폼 ===== --%>
    <div class="alba-write-content">

      <div class="content-header">
        <a href="${pageContext.request.contextPath}/alba" class="back-btn">
          <i class="ri-arrow-left-s-line"></i>
        </a>
        <div class="header-text">
          <div class="page-title">알바 공고 등록</div>
          <div class="page-subtitle">정확한 정보를 입력하면 더 빠르게 매칭돼요</div>
        </div>
      </div>

      <form id="writeForm" action="${pageContext.request.contextPath}/alba/write" method="post" enctype="multipart/form-data">

        <%-- STEP 1: 기본 정보 --%>
        <div class="form-card">
          <div class="form-card-header">
            <div class="form-card-step">1</div>
            <div class="form-card-title">기본 정보</div>
          </div>
          <div class="form-card-body">

            <div class="form-group">
              <label>공고 제목 <span class="req">*</span></label>
              <input type="text" id="title" name="title" maxlength="40"
                     placeholder="예) 주말 서빙 알바 구합니다"
                     oninput="updateCharCount('title','titleCount',40); updatePreview();">
              <div class="char-count"><span id="titleCount">0</span> / 40</div>
            </div>

            <div class="form-group">
              <label>업체명</label>
              <input type="text" id="employer" name="employer" maxlength="30"
                     placeholder="업체명을 입력해주세요"
                     oninput="updatePreview();">
            </div>

            <div class="form-group">
              <label>카테고리</label>
              <div class="chip-group">
                <select name="category" style="max-width:220px;">
                  <option value="서빙">서빙</option>
                  <option value="주방보조">주방보조</option>
                  <option value="매장관리">매장관리</option>
                  <option value="음료제조">음료제조</option>
                  <option value="기타">기타</option>
                </select>
              </div>
            </div>

          </div>
        </div>

        <%-- STEP 2: 급여 --%>
        <div class="form-card">
          <div class="form-card-header">
            <div class="form-card-step">2</div>
            <div class="form-card-title">급여 설정</div>
          </div>
          <div class="form-card-body">

            <div class="form-group">
              <label>급여 유형 <span class="req">*</span></label>
              <input type="hidden" id="payTypeHidden" name="payType" value="시급">
              <div class="chip-group" id="payTypeGroup">
                <button class="chip active" type="button" data-val="시급" data-key="hour"  onclick="selectPayType(this)">시급</button>
                <button class="chip"        type="button" data-val="일급" data-key="day"   onclick="selectPayType(this)">일급</button>
                <button class="chip"        type="button" data-val="월급" data-key="month" onclick="selectPayType(this)">월급</button>
                <button class="chip"        type="button" data-val="건당" data-key="case"  onclick="selectPayType(this)">건당</button>
              </div>
            </div>

            <div class="form-group">
              <label>급여 금액 <span class="req">*</span></label>
              <input type="number" id="pay" name="pay" min="0"
                     placeholder="숫자만 입력"
                     oninput="onPayInput();">
              <div class="warn-box" id="payWarn">
                ⚠️ 입력하신 금액이 최저시급(${10300}원)보다 낮아요.
              </div>
              <div class="info-box">
                💡 2026년 최저시급은 10,300원입니다.
              </div>
            </div>

          </div>
        </div>

        <%-- STEP 3: 근무 일정 --%>
        <div class="form-card">
          <div class="form-card-header">
            <div class="form-card-step">3</div>
            <div class="form-card-title">근무 일정</div>
          </div>
          <div class="form-card-body">

            <div class="form-group">
              <label>근무 기간</label>
              <input type="hidden" id="workPeriodHidden" name="workPeriod" value="LESS_THAN_A_MONTH">
              <div class="chip-group" id="workTypeGroup">
                <button class="chip active" type="button" data-val="LESS_THAN_A_MONTH" onclick="selectWorkType(this)">단기 (1개월 미만)</button>
                <button class="chip"        type="button" data-val="MORE_THAN_A_MONTH" onclick="selectWorkType(this)">장기 (1개월 이상)</button>
              </div>
            </div>

            <div class="form-group">
              <label>근무 요일 <span class="req">*</span></label>
              <input type="hidden" id="workDaysHidden" name="workDays">
              <div class="day-chips">
                <button class="day-chip" type="button" data-val="MON" onclick="toggleDay(this)">월</button>
                <button class="day-chip" type="button" data-val="TUE" onclick="toggleDay(this)">화</button>
                <button class="day-chip" type="button" data-val="WED" onclick="toggleDay(this)">수</button>
                <button class="day-chip" type="button" data-val="THU" onclick="toggleDay(this)">목</button>
                <button class="day-chip" type="button" data-val="FRI" onclick="toggleDay(this)">금</button>
                <button class="day-chip" type="button" data-val="SAT" onclick="toggleDay(this)">토</button>
                <button class="day-chip" type="button" data-val="SUN" onclick="toggleDay(this)">일</button>
              </div>
              <div class="day-shortcut">
                <button class="shortcut-btn" type="button" onclick="selectWeekdays()">평일</button>
                <button class="shortcut-btn" type="button" onclick="selectWeekend()">주말</button>
                <button class="shortcut-btn" type="button" onclick="selectAllDays()">매일</button>
              </div>
            </div>

            <div class="form-group">
              <label>근무 시간</label>
              <div class="time-row">
                <input type="time" id="startTime" name="startTime" oninput="updatePreview();">
                <span class="time-sep">~</span>
                <input type="time" id="endTime" name="endTime" oninput="updatePreview();">
              </div>
              <div class="time-check">
                <input type="checkbox" id="timeNegotiable" name="timeNegotiable" onchange="toggleTimeInput(this);">
                <label for="timeNegotiable">시간 협의 가능</label>
              </div>
            </div>

          </div>
        </div>

        <%-- STEP 4: 근무 위치 --%>
        <div class="form-card">
          <div class="form-card-header">
            <div class="form-card-step">4</div>
            <div class="form-card-title">근무 위치</div>
          </div>
          <div class="form-card-body">

            <div class="form-group">
              <label>주소 <span class="req">*</span></label>
              <div class="input-with-btn">
                <input type="text" id="location" name="location" readonly
                       placeholder="주소 검색 버튼을 눌러주세요"
                       oninput="updatePreview();">
                <button type="button" class="addr-btn" onclick="searchAddress()">
                  <i class="ri-map-pin-2-line"></i> 검색
                </button>
              </div>
            </div>

            <div class="form-group">
              <label>상세 주소</label>
              <input type="text" id="locationDetail" name="locationDetail"
                     placeholder="상세 주소 (동, 호수 등)">
            </div>

          </div>
        </div>

        <%-- STEP 5: 상세 내용 --%>
        <div class="form-card">
          <div class="form-card-header">
            <div class="form-card-step">5</div>
            <div class="form-card-title">상세 내용</div>
          </div>
          <div class="form-card-body">

            <div class="form-group">
              <label>공고 내용</label>
              <textarea id="content" name="content" maxlength="2000"
                        placeholder="업무 내용, 지원 자격, 혜택 등을 자유롭게 작성해주세요."
                        oninput="updateCharCount('content','contentCount',2000);"></textarea>
              <div class="char-count"><span id="contentCount">0</span> / 2000</div>
            </div>

            <div class="form-group">
              <label>사진 첨부 <span style="font-weight:400; color:var(--text-muted);">(최대 5장)</span></label>
              <div class="image-upload-area" onclick="document.getElementById('imageInput').click()">
                <div class="upload-icon">📷</div>
                <div>클릭하여 사진을 업로드하세요</div>
                <div style="font-size:12px; margin-top:6px; color:var(--text-muted);">JPG, PNG · 최대 5장</div>
              </div>
              <input type="file" id="imageInput" name="images" multiple accept="image/*"
                     style="display:none;" onchange="handleImageUpload(this);">
              <div class="image-preview-grid" id="imagePreviewGrid"></div>
            </div>

          </div>
        </div>

      </form>
    </div>
  </div>
</div>

<%-- ===== 하단 제출 바 ===== --%>
<div class="submit-bar">
  <a href="${pageContext.request.contextPath}/alba" class="btn-ghost">
    <i class="ri-arrow-left-s-line"></i>&nbsp;취소
  </a>
  <button type="button" class="btn-primary" onclick="submitForm()">
    <i class="ri-check-line"></i>&nbsp;공고 등록하기
  </button>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/alba/alba-write.js"></script>
</body>
</html>
