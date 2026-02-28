<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>비밀번호 변경 | BATON</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/login-custom.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
</head>
<body>
	
<header class="fixed-top shadow-sm bg-white">
	<jsp:include page="/WEB-INF/views/layout/header.jsp" />
</header>

<main class="baton-harmony-canvas" id="pwdUpdateForm" data-context-path="${pageContext.request.contextPath}">
    <div class="login-auth-frame">
        <header class="auth-header">
            <div class="baton-accent-dot"></div>
            <h1 class="auth-title">Reset Password</h1>
            <p class="auth-subtitle">새로운 비밀번호를 <br>설정해 주세요.</p>
        </header>

        <form name="pwdUpdateForm" class="auth-form-body">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            
            <div class="input-sequence item-1">
                <label class="input-label">새 비밀번호</label>
                <div class="input-glow-wrap">
                    <input type="password" name="userPwd" placeholder="8~16자 영문, 숫자, 특수문자" autofocus>
                </div>
            </div>
			
            <div class="input-sequence item-2">
                <label class="input-label">비밀번호 확인</label>
                <div class="input-glow-wrap">
                    <input type="password" name="userPwdCheck" placeholder="비밀번호를 한번 더 입력해주세요">
                </div>
            </div>

            <div class="auth-action item-4" style="margin-top: 40px;">
                <button type="button" class="btn-baton-login" onclick="sendPwdUpdate();">
                    <span>비밀번호 변경하기</span>
                </button>
                <div class="auth-back-helper item-5">
                    <span class="btn-link-back" onclick="location.href='${pageContext.request.contextPath}/member/login';">
                        취소하고 돌아가기
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