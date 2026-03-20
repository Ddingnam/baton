<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>로그인 | BATON</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/login/login-custom.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
<style>
.auth-withdraw-notice {
    margin-top: 20px;
    background: #FFF9DB;
    border: 1px solid #FFE066;
    border-radius: 14px;
    padding: 16px 18px;
    display: flex;
    align-items: flex-start;
    gap: 12px;
    animation: toastReveal 0.4s ease;
}
.auth-withdraw-notice i {
    color: #F08C00;
    font-size: 18px;
    flex-shrink: 0;
    margin-top: 1px;
}
.auth-withdraw-notice-text {
    font-size: 13px;
    font-weight: 700;
    color: #664D03;
    line-height: 1.6;
}
.auth-withdraw-notice-text span {
    display: block;
    font-size: 12px;
    font-weight: 500;
    color: #9A6700;
    margin-top: 3px;
}
</style>
</head>
<body>

<header class="fixed-top shadow-sm bg-white">
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />
</header>

<main class="baton-harmony-canvas">
    <div class="login-auth-frame">
        <header class="auth-header">
            <div class="baton-accent-dot"></div>
            <h1 class="auth-title">Baton</h1>
            <p class="auth-subtitle">당신의 일상을 잇는 <br>가장 가까운 바톤 터치</p>
        </header>

        <form name="loginForm" action="${pageContext.request.contextPath}/member/login" method="post" class="auth-form-body">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <div class="input-sequence item-1">
                <label class="input-label">아이디</label>
                <div class="input-glow-wrap">
                    <input type="text" name="login_id" placeholder="ID" autofocus>
                </div>
            </div>

            <div class="input-sequence item-2">
                <label class="input-label">비밀번호</label>
                <div class="input-glow-wrap">
                    <input type="password" name="password" autocomplete="off" placeholder="Password">
                </div>
            </div>

            <div class="auth-util item-3">
                <label class="baton-checkbox">
                    <input type="checkbox" id="rememberMe">
                    <span class="checkbox-box"></span>
                    <span class="checkbox-text">로그인 상태 유지</span>
                </label>
            </div>

            <div class="auth-action item-4">
                <button type="button" class="btn-baton-login" onclick="sendLogin();">
                    <span>로그인</span>
                </button>
            </div>

            <div class="auth-social item-5">
                <div class="social-divider">또는 간편 로그인</div>
                <div class="social-orb-group">
                    <a href="javascript:void(0);" onclick="loginWithKakao();" class="social-orb">
                        <i class="ri-kakao-talk-fill"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/oauth2/authorization/google" class="social-orb">
                        <i class="ri-google-fill"></i>
                    </a>
                </div>
            </div>
        </form>

        <c:if test="${not empty loginErrMsg and not isWithdrawPending}">
            <div class="auth-error-toast">
                ${loginErrMsg}
            </div>
        </c:if>

        <c:if test="${isWithdrawPending}">
            <div class="auth-withdraw-notice">
                <i class="ri-time-line"></i>
                <div class="auth-withdraw-notice-text">
                    탈퇴 승인 대기 중인 계정입니다.
                    <span>관리자 검토 후 처리 결과를 안내해 드립니다.</span>
                </div>
            </div>
        </c:if>

        <footer class="auth-footer item-6">
            <div class="join-prompt">
                <span class="prompt-text">아직 회원이 아니신가요?</span>
                <a href="${pageContext.request.contextPath}/member/join" class="btn-link-join">회원가입</a>
            </div>

            <div class="footer-links find-links">
                <a href="${pageContext.request.contextPath}/member/findId">아이디 찾기</a>
                <span class="bar"></span>
                <a href="${pageContext.request.contextPath}/member/findPwd">비밀번호 찾기</a>
            </div>
        </footer>
    </div>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>

<script type="text/javascript">
function sendLogin() {
    const f = document.loginForm;
    if (!f.login_id.value.trim()) { f.login_id.focus(); return; }
    if (!f.password.value.trim()) { f.password.focus(); return; }
    f.submit();
}
</script>

</body>
</html>
