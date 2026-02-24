<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>로그인 | Spring</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style type="text/css">
    .main-content {
        background-color: #f8f9fa;
        min-height: 80vh; /* 헤더 제외하고 화면을 꽉 채우기 위해 */
        display: flex;
        align-items: center;
    }
    .login-box {
        max-width: 420px;
        width: 100%;
        margin: 40px auto;
        padding: 40px;
        background: #ffffff;
        border-radius: 16px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.08);
    }
    .form-control {
        border-radius: 8px;
        padding: 12px;
        border: 1px solid #dee2e6;
    }
    .btn-login {
        background: #0d6efd;
        color: #fff;
        border: none;
        padding: 12px;
        border-radius: 8px;
        font-weight: 600;
        transition: all 0.2s;
    }
    .btn-login:hover { background: #0b5ed7; transform: translateY(-1px); }
    
    .social-group .btn {
        border-radius: 8px;
        padding: 10px;
        font-size: 0.9rem;
        background: #fdfdfd;
        border: 1px solid #eee;
    }
    .divider-text {
        font-size: 0.8rem;
        color: #adb5bd;
        text-align: center;
        margin: 20px 0;
        position: relative;
    }
    .divider-text::before, .divider-text::after {
        content: "";
        position: absolute;
        top: 50%;
        width: 30%;
        height: 1px;
        background: #eee;
    }
    .divider-text::before { left: 0; }
    .divider-text::after { right: 0; }
</style>
</head>
<body>
<!--
<header>
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>
-->

<main class="main-content">
    <div class="container">
        <div class="login-box">
            <h3 class="text-center mb-4 fw-bold">로그인</h3>
            
            <form name="loginForm" action="${pageContext.request.contextPath}/member/login" method="post" class="row g-3">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                
                <div class="col-12">
                    <label class="form-label small fw-semibold text-muted">아이디</label>
                    <input type="text" name="login_id" class="form-control" placeholder="아이디를 입력하세요">
                </div>
                
                <div class="col-12">
                    <label class="form-label small fw-semibold text-muted">패스워드</label>
                    <input type="password" name="password" class="form-control" autocomplete="off" placeholder="패스워드를 입력하세요">
                </div>

                <div class="col-12 d-flex justify-content-between align-items-center mb-2">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="rememberMe">
                        <label class="form-check-label small text-muted" for="rememberMe">자동 로그인</label>
                    </div>
                </div>

                <div class="col-12">
                    <button type="button" class="btn-login w-100" onclick="sendLogin();">로그인</button>
                </div>

                <div class="divider-text">간편 로그인</div>

                <div class="col-12 social-group d-grid gap-2">
                    <button type="button" class="btn btn-light"><i class="bi bi-chat-fill text-warning me-2"></i>카카오 로그인</button>
                    <button type="button" class="btn btn-light"><i class="bi bi-google text-danger me-2"></i>구글 로그인</button>
                </div>
            </form>
            
            <c:if test="${not empty message}">
                <div class="alert alert-danger mt-4 py-2 text-center border-0 small" role="alert">
                    ${message}
                </div>
            </c:if>

            <div class="text-center mt-4 small">
                <a href="${pageContext.request.contextPath}/member/account" class="text-decoration-none me-2">회원가입</a>
                <span class="text-muted">|</span>
                <a href="${pageContext.request.contextPath}/member/pwdFind" class="text-decoration-none ms-2">비밀번호 찾기</a>
            </div>
        </div>
    </div>
</main>

<script type="text/javascript">
function sendLogin() {
    const f = document.loginForm;
	
    if( ! f.login_id.value.trim() ) {
        f.login_id.focus();
        return;
    }

    if( ! f.password.value.trim() ) {
        f.password.focus();
        return;
    }

    f.action = '${pageContext.request.contextPath}/member/login';
    f.submit();
}
</script>

</body>
</html>