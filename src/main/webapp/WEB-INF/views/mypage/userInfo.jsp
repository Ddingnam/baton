<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>BATON | 마이페이지</title>
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main/main.css?v=final">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage/mypage_left.css?v=final">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage/mypage_main.css?v=final">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage/mypage_badge.css?v=final">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage/mypage_userInfo.css">
</head>
<body>

	<jsp:include page="/WEB-INF/views/layout/header.jsp" />

	<div id="baton-layout-container" class="mypage-mode">

		<jsp:include page="/WEB-INF/views/mypage/left.jsp" />

		<main class="mp-main-wrapper" id="mp-theme-root">
			<div class="list-card mb-24 ui-profile-card">
			    <div class="lc-header">
			        <h3>내 정보 관리</h3>
			    </div>

				<form id="ui-userInfoForm" action="${pageContext.request.contextPath}/mypage/updateUserInfo" method="post" enctype="multipart/form-data">
				    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
				    <input type="hidden" name="userIdx" value="${userInfo.userIdx}">

					<div class="ui-photo-section">
					    <input type="hidden" name="deletedPhoto" id="ui-deletedPhoto" value="false">
					    <input type="file" id="ui-profileUpload" name="selectFile" class="ui-hidden-file" accept="image/*">

					    <div class="ui-avatar-container">
					        <label for="ui-profileUpload" class="ui-photo-label" id="ui-photo-wrapper" data-has-original="${not empty userInfo.profile_photo}">
					            <c:choose>
					                <c:when test="${not empty userInfo.profile_photo}">
					                    <i class="ri-user-smile-fill ui-photo-placeholder ui-hidden" id="ui-photo-placeholder"></i>
					                    <img src="${CONTEXT_PATH}/uploads/member/${userInfo.profile_photo}" id="ui-photo-preview" class="ui-photo-img" alt="프로필 이미지">
					                </c:when>
					                <c:otherwise>
					                    <i class="ri-user-smile-fill ui-photo-placeholder" id="ui-photo-placeholder"></i>
					                    <img src="" id="ui-photo-preview" class="ui-photo-img ui-hidden" alt="프로필 이미지">
					                </c:otherwise>
					            </c:choose>
					            <div class="ui-photo-overlay">
					                <i class="ri-edit-2-fill"></i>
					            </div>
					        </label>

					        <button type="button" 
					                class="ui-btn-reset ${empty userInfo.profile_photo ? 'ui-hidden' : ''}" 
					                id="ui-btn-delete"
					                title="기본 이미지로 초기화">
					            <i class="ri-refresh-line"></i>
					        </button>
					    </div>
					</div>

					<div class="ui-form-grid">
					    <div class="ui-form-group">
					        <label class="ui-label">아이디 <span class="ui-required">*</span></label>
					        <input type="text" name="userId" class="ui-input ui-readonly" value="${userInfo.userId}" readonly>
					    </div>
					    <div class="ui-form-group">
					        <label class="ui-label">이메일 <span class="ui-required">*</span></label>
					        <input type="email" name="email" class="ui-input ui-readonly" value="${userInfo.email}" readonly>
					    </div>

					    <div class="ui-form-group">
					        <label class="ui-label">이름</label>
					        <input type="text" name="name" class="ui-input ui-readonly" value="${userInfo.name}" readonly>
					    </div>
					    <div class="ui-form-group">
					        <label class="ui-label">닉네임 <span class="ui-required">*</span></label>
					        <div class="ui-input-btn-group">
					            <input type="text" id="ui-nickname" name="nickname" class="ui-input" value="${userInfo.nickname}" required>
					            <button type="button" class="theme-btn-outline ui-check-btn" onclick="checkNickname()">중복검사</button>
					        </div>
					    </div>

					    <div class="ui-form-row ui-full-width">
					        <div class="ui-form-group">
					            <label class="ui-label">연락처</label>
					            <input type="tel" name="tel" class="ui-input" value="${userInfo.tel}" placeholder="010-0000-0000">
					        </div>
					        <div class="ui-form-group">
					            <label class="ui-label">생년월일</label>
					            <input type="date" name="birth" class="ui-input" value="${userInfo.birthDate}">
					        </div>
					    </div>
					</div>

			        <div class="ui-btn-wrap">
			            <button type="button" class="theme-btn-outline" style="padding: 14px 28px; font-size: 15px;" onclick="history.back()">취소</button>
			            <button type="submit" class="theme-btn" style="padding: 14px 40px; font-size: 15px;">정보 저장</button>
			        </div>
			    </form>
			</div>
		</main>
	</div>
    
	<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
	<script src="${pageContext.request.contextPath}/dist/js/mypage/mypage_main.js"></script>
	<script src="${pageContext.request.contextPath}/dist/js/mypage/mypage_userInfo.js"></script>
	<script>const CONTEXT_PATH = '${pageContext.request.contextPath}';</script>
</body>
</html>