<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="/WEB-INF/views/layout/headerResources.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>이력서 등록 | BATON PASS</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css" />
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main/main.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/resume/resume-write.css" />
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<main class="resume-write-container">
    <div class="page-header">
        <h1 class="page-title">새 이력서 작성</h1>
        <p class="page-desc">사장님께 어필할 수 있는 나만의 이력서를 완성해보세요!</p>
    </div>

    <form action="${pageContext.request.contextPath}/resume/write" method="post" id="resumeForm">
        <section class="form-section">
            <h2 class="section-title">이력서 제목 <span class="required">*</span></h2>
            <div class="input-group">
                <input type="text" name="title" class="form-input text-lg" placeholder="예) 성실하고 책임감 있는 알바생입니다!" required="required" />
            </div>
        </section>

        <section class="form-section">
            <div class="info-grid">
                <div class="input-group">
                    <label>이름</label>
                    <input type="text" name="userName" class="form-input readonly" value="${name}" readonly>
                </div>
                <div class="input-group">
                    <label>연락처</label>
                    <input type="text" name="phone" class="form-input readonly" value="${phone}" readonly>
                </div>
            </div>
        </section>

        <section class="form-section">
            <h2 class="section-title">경력 사항 <span class="required">*</span></h2>
            <div class="radio-chip-group">
                <label class="radio-chip">
                    <input type="radio" name="careerType" value="NEW" checked="checked" onchange="toggleCareerDetails(false)" />
                    <span>신입 (경력 없음)</span>
                </label>
                <label class="radio-chip">
                    <input type="radio" name="careerType" value="EXP" onchange="toggleCareerDetails(true)" />
                    <span>경력 있음</span>
                </label>
            </div>
            
            <div id="careerDetails" class="hidden-field mt-15">
                <div class="input-group">
                    <label>경력 요약 (어떤 일을, 얼마나 했나요?)</label>
                    <input type="text" name="careerDesc" class="form-input" placeholder="예) 카페 음료 제조 및 매장 관리 (6개월)" />
                </div>
            </div>
        </section>

        <section class="form-section">
            <h2 class="section-title">희망 근무 조건</h2>
            <div class="info-grid">
                <div class="input-group">
                    <label>희망 업직종</label>
                    <select name="desiredCategory" class="form-select">
                        <option value="">선택해주세요</option>
                        <option value="서빙">서빙</option>
                        <option value="주방보조">주방보조</option>
                        <option value="매장관리">매장관리</option>
                        <option value="음료제조">음료제조</option>
                    </select>
                </div>
                <div class="input-group">
                    <label>희망 근무지 (구/동)</label>
                    <input type="text" name="desiredLocation" class="form-input" placeholder="예) 서울시 서초구" />
                </div>
            </div>
        </section>

        <section class="form-section">
            <h2 class="section-title">자기소개서</h2>
            <div class="input-group">
                <textarea name="introduce" class="form-textarea" rows="6" placeholder="자신의 장점, 지원 동기, 각오 등을 자유롭게 적어주세요. (최소 20자 이상 작성하시면 합격률이 올라갑니다!)"></textarea>
            </div>
        </section>

        <div class="bottom-action-bar">
            <div class="action-inner">
                <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
                <button type="submit" class="btn-submit">이력서 등록완료</button>
            </div>
        </div>
    </form>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
    function toggleCareerDetails(show) {
        const details = document.getElementById('careerDetails');
        if(show) {
            details.style.display = 'block';
        } else {
            details.style.display = 'none';
        }
    }
</script>
</body>
</html>