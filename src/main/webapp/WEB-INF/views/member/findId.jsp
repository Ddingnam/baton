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

<main class="baton-harmony-canvas" id="findIdForm" data-context-path="${pageContext.request.contextPath}">
    <div class="login-auth-frame">
        <header class="auth-header">
            <div class="baton-accent-dot"></div>
            <h1 class="auth-title">Find ID</h1>
            <p class="auth-subtitle" id="auth-desc">등록한 이름과 이메일로 <br>아이디를 찾을 수 있습니다.</p>
        </header>

        <div id="id-find-form-area">
            <form name="idFindForm" class="auth-form-body">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <div class="input-sequence item-1">
                    <label class="input-label">이름</label>
                    <div class="input-glow-wrap">
                        <input type="text" name="name" placeholder="이름을 입력해주세요" autofocus>
                    </div>
                </div>
                <div class="input-sequence item-2">
                    <label class="input-label">이메일</label>
                    <div class="input-glow-wrap">
                        <input type="email" name="email" placeholder="example@baton.com">
                    </div>
                </div>
            </form>
        </div>

        <div id="id-find-result" style="display: none;" class="item-reveal">
            <div class="result-box">
                <p class="result-label">찾으신 아이디는 다음과 같습니다.</p>
                <div class="result-id-display">
                    <span id="found-user-id"></span>
                </div>
            </div>
        </div>

        <div class="auth-action item-4" style="margin-top: 40px;">
            <button type="button" class="btn-baton-login" id="main-action-btn" onclick="sendIdFind();">
                <span>아이디 찾기</span>
            </button>
            <div class="auth-back-helper item-5">
                <span class="btn-link-back" onclick="location.href='${pageContext.request.contextPath}/member/login';">
                    돌아가기
                </span>
            </div>
        </div>
        
        <div id="auth-error-msg" class="auth-error-toast" style="display: none;">
            <span id="error-message-text"></span>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
<script src="${pageContext.request.contextPath}/dist/js/findUserInfo.js"></script>
</body>
</html>