<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>아이디 찾기 | BATON</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/login-custom.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
</head>
<body>
	
<header class="fixed-top shadow-sm bg-white">
	<jsp:include page="/WEB-INF/views/layout/header.jsp" />
</header>

<main class="baton-harmony-canvas">
    <div class="login-auth-frame">
        <header class="auth-header">
            <div class="baton-accent-dot"></div>
            <h1 class="auth-title">Find Password</h1>
            <p class="auth-subtitle">등록한 아이디와 이메일을 <br>정확히 입력해 주세요.</p>
        </header>

		<form name="findPwdForm" class="auth-form-body">
		    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
		    
		    <div class="input-sequence item-1">
		        <label class="input-label">아이디</label>
		        <div class="input-glow-wrap">
		            <input type="text" id="userId" name="userId" placeholder="아이디를 입력해주세요" autofocus>
		        </div>
		    </div>
		    
		    <div class="input-sequence item-2">
		        <label class="input-label">이메일</label>
		        <div class="input-glow-wrap">
		            <input type="email" id="email" name="email" placeholder="example@baton.com">
		        </div>
		    </div>

		    <div id="emailAuthRow" class="auth-row-animate">
		        <div class="input-sequence" style="margin-top: 20px; margin-bottom: 0px;">
		            <label class="input-label">인증번호</label>
		            <div class="input-with-btn">
		                <div class="input-glow-wrap" style="flex: 1;">
		                    <input type="text" id="authCode" placeholder="인증번호 6자리">
		                </div>
		                <button type="button" id="btnVerify" class="btn-action" onclick="verifyCodeForPwd()">확인</button>
		            </div>
		            <div class="timer-container" style="text-align: center; margin-top: 8px;">
		                <span class="auth-timer" id="timer">03:00</span>
		            </div>
		        </div>
		    </div>

		    <div class="auth-action item-4" style="margin-top: 40px;">
		        <button type="button" id="btnMain" class="btn-baton-login" onclick="handleMainAction()">
		            <span id="btnMainText">인증번호 전송</span>
		        </button>
		        
		        <div class="auth-back-helper item-5">
		            <span class="btn-link-back" onclick="location.href='${pageContext.request.contextPath}/member/login';">
		                돌아가기
		            </span>
		        </div>
		    </div>
		</form>

		<div id="auth-error-msg" class="auth-error-toast" style="display: none;">
		    <span id="error-message-text"></span>
		</div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
<script src="${pageContext.request.contextPath}/dist/js/findUserInfo.js"></script>
</body>
</html>