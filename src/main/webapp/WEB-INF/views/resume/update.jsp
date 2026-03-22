<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/WEB-INF/views/layout/headerResources.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>이력서 수정 | BATON</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css"/>
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main/main.css"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/resume/resume-write.css"/>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<main class="resume-write-container">
  <div class="page-header">
    <h1 class="page-title">이력서 수정</h1>
    <p class="page-desc">내용을 수정하고 저장하세요.</p>
  </div>

  <c:if test="${param.error eq 'true'}">
    <div class="alert-error">수정 중 오류가 발생했습니다. 다시 시도해주세요.</div>
  </c:if>

  <form action="${pageContext.request.contextPath}/resume/update" method="post" id="resumeForm">
    <input type="hidden" name="profileIdx" value="${dto.profileIdx}"/>

    <!-- 이력서 제목 -->
    <section class="form-section">
      <h2 class="section-title">이력서 제목 <span class="required">*</span></h2>
      <input type="text" name="title" class="form-input text-lg"
             value="${dto.title}" maxlength="200" required/>
    </section>

    <!-- 기본 정보 -->
    <section class="form-section">
      <h2 class="section-title">기본 정보</h2>
      <div class="info-grid">
        <div class="input-group">
          <label>이름</label>
          <input type="text" name="userName" class="form-input readonly"
                 value="${dto.userName}" readonly/>
        </div>
        <div class="input-group">
          <label>연락처 <span class="required">*</span></label>
          <input type="tel" name="phone" class="form-input"
                 value="${dto.phone}" maxlength="20" required/>
        </div>
        <div class="input-group">
          <label>이메일</label>
          <input type="email" name="email" class="form-input"
                 value="${dto.email}" maxlength="100"/>
        </div>
        <div class="input-group">
          <label>생년월일</label>
          <input type="date" name="birth" class="form-input" value="${dto.birth}"/>
        </div>
      </div>
      <div class="input-group mt-8">
        <label>성별</label>
        <div class="radio-chip-group">
          <label class="radio-chip">
            <input type="radio" name="gender" value="M"
              <c:if test="${dto.gender eq 'M'}">checked</c:if>/> <span>남성</span>
          </label>
          <label class="radio-chip">
            <input type="radio" name="gender" value="F"
              <c:if test="${dto.gender eq 'F'}">checked</c:if>/> <span>여성</span>
          </label>
          <label class="radio-chip">
            <input type="radio" name="gender" value=""
              <c:if test="${empty dto.gender}">checked</c:if>/> <span>선택 안함</span>
          </label>
        </div>
      </div>
    </section>

    <!-- 자기소개 -->
    <section class="form-section">
      <h2 class="section-title">자기소개</h2>
      <textarea name="introduce" class="form-textarea" rows="6">${dto.introduce}</textarea>
    </section>

    <!-- 나의 장점 -->
    <section class="form-section">
      <h2 class="section-title">나의 장점</h2>
      <input type="text" name="strengths" class="form-input"
             value="${dto.strengths}" maxlength="1000"/>
    </section>

    <!-- 추가 정보 -->
    <section class="form-section">
      <h2 class="section-title">추가 정보 <span class="label-optional">(선택)</span></h2>
      <textarea name="additionalInfo" class="form-textarea" rows="4">${dto.additionalInfo}</textarea>
    </section>

    <div class="bottom-action-bar">
      <div class="action-inner">
        <button type="button" class="btn-cancel"
                onclick="location.href='${pageContext.request.contextPath}/resume/article/${dto.profileIdx}'">
          취소
        </button>
        <button type="submit" class="btn-submit">수정 완료</button>
      </div>
    </div>
  </form>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>

<style>
.alert-error{background:#FEF2F2;color:#DC2626;border:1px solid #FECACA;border-radius:8px;padding:14px 18px;margin-bottom:20px;font-size:14px;}
.label-optional{font-size:13px;font-weight:400;color:#9CA3AF;}
.mt-8{margin-top:8px;}
</style>
</body>
</html>
