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
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main/main.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/alba/alba-write.css">
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>
<c:set var="hideChatbot" value="true" scope="request" />
<jsp:include page="/WEB-INF/views/layout/header.jsp" />
<div id="baton-layout-container">
  <main id="baton-main-content">
    <div class="baton-page">
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
            <div class="progress-item" id="pi1"><div class="progress-dot">1</div>기본 정보</div>
            <div class="progress-bar-line"><div class="progress-bar-fill" id="pb1"></div></div>
            <div class="progress-item" id="pi2"><div class="progress-dot">2</div>급여</div>
            <div class="progress-bar-line"><div class="progress-bar-fill" id="pb2"></div></div>
            <div class="progress-item" id="pi3"><div class="progress-dot">3</div>근무 조건</div>
            <div class="progress-bar-line"><div class="progress-bar-fill" id="pb3"></div></div>
            <div class="progress-item" id="pi4"><div class="progress-dot">4</div>상세 정보</div>
          </div>
        </div>
      </aside>

      <div class="content">
        <div class="content-header">
          <a href="${pageContext.request.contextPath}/alba/list" class="back-btn">
            <i class="ri-arrow-left-s-line"></i>
          </a>
          <div>
            <div class="page-title">✏️ 알바 공고 쓰기</div>
            <div class="page-subtitle">바통패스에 공고를 등록하고 알바생을 찾아보세요</div>
          </div>
        </div>

        <form id="writeForm" action="${pageContext.request.contextPath}/alba/write" method="post" enctype="multipart/form-data">
          <div class="form-card">
            <div class="form-card-header">
              <span class="form-card-step">1</span>
              <span class="form-card-title">기본 정보</span>
            </div>
            <div class="form-card-body">
              <div class="form-group">
                <label for="title">공고 제목 <span class="req">*</span></label>
                <input type="text" id="title" name="title" maxlength="50" placeholder="예) 주말 카페 서빙 알바 구합니다" required oninput="updatePreview(); updateCharCount('title','titleCount',50)">
                <div class="char-count"><span id="titleCount">0</span>/50자</div>
              </div>
              <div class="form-group">
                <label for="employer">업체명</label>
                <input type="text" id="employer" name="employer" maxlength="30" placeholder="예) 약수상회, 이웃알바" oninput="updatePreview()">
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
                <textarea id="description" name="description" rows="6" maxlength="1000" placeholder="업무 내용 등을 자세히 적어주세요." required oninput="updateCharCount('description','descCount',1000)"></textarea>
                <div class="char-count"><span id="descCount">0</span>/1000자</div>
              </div>
            </div>
          </div>

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
                <input type="number" id="pay" name="pay" min="0" step="100" placeholder="예) 12000" required oninput="onPayInput()">
                <div class="warn-box" id="payWarn">⚠️ 입력하신 시급이 최저임금(10,320원)보다 낮아요!</div>
                <div class="info-box"><strong>2026년 최저시급: 10,320원</strong></div>
              </div>
            </div>
          </div>

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
                  <button type="button" class="shortcut-btn" onclick="selectWeekdays()">평일 전체</button>
                  <button type="button" class="shortcut-btn" onclick="selectWeekend()">주말</button>
                  <button type="button" class="shortcut-btn" onclick="selectAllDays()">매일</button>
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
                  <input type="checkbox" id="timeNegotiable" name="timeNegotiable" value="Y" onchange="toggleTimeInput(this)">
                  <label for="timeNegotiable">시간 협의 가능</label>
                </div>
              </div>
            </div>
          </div>

          <div class="form-card">
            <div class="form-card-header">
              <span class="form-card-step">4</span>
              <span class="form-card-title">📌 상세 정보</span>
            </div>
            <div class="form-card-body">
              <div class="form-group">
                <label for="location">근무 지역 <span class="req">*</span></label>
                <div class="input-with-btn">
                  <input type="text" id="location" name="location" placeholder="주소 검색 버튼을 눌러 검색하세요" required readonly onclick="searchAddress()">
                  <button type="button" class="addr-btn" onclick="searchAddress()"><i class="ri-map-pin-line"></i> 검색</button>
                </div>
                <input type="text" id="locationDetail" name="locationDetail" placeholder="상세 주소 입력" style="margin-top:8px;">
              </div>
              <div class="form-group">
                <label for="contact">연락처 <span class="req">*</span></label>
                <input type="tel" id="contact" name="contact" placeholder="예) 010-1234-5678" required>
              </div>
            </div>
          </div>

          <div class="form-card">
            <div class="form-card-header">
              <span class="form-card-step" style="background:var(--baton-muted)">📸</span>
              <span class="form-card-title">사진</span>
            </div>
            <div class="form-card-body">
              <div class="image-upload-area" onclick="document.getElementById('imageInput').click()">
                <div class="upload-icon">📷</div>
                <p>사진을 눌러 추가하세요</p>
              </div>
              <input type="file" id="imageInput" name="images" multiple accept="image/*" onchange="handleImageUpload(this)" style="display:none;">
              <div class="image-preview-grid" id="imagePreviewGrid"></div>
            </div>
          </div>
        </form>
      </div>
    </div>

    <div class="submit-bar">
      <a href="${pageContext.request.contextPath}/alba/list" class="btn-ghost">목록으로</a>
      <button type="button" class="btn-primary" id="submitBtn" onclick="submitForm()">공고 등록하기</button>
    </div>
  </main>
</div>
<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
<script>const CONTEXT_PATH = "${pageContext.request.contextPath}";</script>
<script src="${pageContext.request.contextPath}/dist/js/alba/alba-write.js"></script>
</body>
</html>