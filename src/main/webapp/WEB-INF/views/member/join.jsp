<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>회원가입 | BATON</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/join.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

<header class="fixed-top shadow-sm bg-white">
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />
</header>

<main class="baton-harmony-canvas" id="registerForm" data-context-path="${pageContext.request.contextPath}">
    <div class="login-auth-frame">
    	<header class="auth-header">
            <div class="baton-accent-dot"></div>
            <h1 class="auth-title">회원가입</h1>
            <p class="auth-subtitle">안전한 중고거래의 시작, <br>바톤 터치를 준비해볼까요?</p>
        </header>

        <form name="registerForm" action="${pageContext.request.contextPath}/member/register" method="post" class="auth-form-body">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <div class="input-sequence item-2">
                <label class="input-label">아이디</label>
                <div class="input-with-btn">
                    <div class="input-glow-wrap" style="flex: 1;">
                        <input type="text" name="userId" placeholder="6~20자 영문, 숫자">
                    </div>
                    <button type="button" class="btn-action" onclick="checkId()">중복 확인</button>
                </div>
            </div>

            <div class="input-sequence item-3">
                <label class="input-label">비밀번호</label>
                <div class="input-glow-wrap">
                    <input type="password" name="pwd" placeholder="8자 이상 (영문, 숫자 포함)">
                </div>
            </div>

            <div class="input-sequence item-4">
                <label class="input-label">비밀번호 확인</label>
                <div class="input-glow-wrap">
                    <input type="password" id="pwdConfirm" placeholder="비밀번호 재입력">
                </div>
            </div>

            <div class="input-sequence item-5">
                <label class="input-label">이름</label>
                <div class="input-glow-wrap">
                    <input type="text" name="name" placeholder="실명 입력">
                </div>
            </div>

            <div class="input-sequence item-6">
                <label class="input-label">닉네임</label>
                <div class="input-with-btn">
                    <div class="input-glow-wrap" style="flex: 1;">
                        <input type="text" name="nickname" placeholder="활동할 닉네임">
                    </div>
                    <button type="button" class="btn-action" onclick="checkNickname()">중복 확인</button>
                </div>
            </div>

            <div class="input-sequence item-reveal" style="animation-delay: 0.7s;">
                <label class="input-label">이메일</label>
                <div class="input-with-btn">
                    <div class="input-glow-wrap" style="flex: 1;">
                        <input type="email" id="email" name="email" placeholder="example@baton.com">
                    </div>
                    <button type="button" id="btnSendAuth" class="btn-action" onclick="sendEmailAuth()">인증번호 전송</button>
                </div>

                <div id="emailAuthRow" class="auth-row-animate">
                    <div class="input-with-btn">
                        <div class="input-glow-wrap" style="flex: 1;">
                            <input type="text" id="authCode" placeholder="인증번호 6자리">
                        </div>
                        <button type="button" class="btn-action" onclick="verifyCode()">확인</button>
                    </div>
				    <span class="auth-timer" id="timer">03:00</span>
                </div>
            </div>

            <div class="input-sequence item-reveal" style="animation-delay: 0.8s;">
                <label class="input-label">휴대폰 번호</label>
                <div class="input-glow-wrap">
                    <input type="tel" name="tel" placeholder="010-0000-0000">
                </div>
            </div>

            <div class="input-sequence item-reveal" style="animation-delay: 0.9s;">
                <label class="input-label">생년월일</label>
                <div class="input-glow-wrap">
                    <input type="date" name="birth">
                </div>
            </div>

            <div class="auth-action" style="margin-top: 40px;">
                <button type="button" class="btn-baton-login" onclick="sendRegister();">
                    <span>가입 완료</span>
                </button>
            </div>
        </form>

        <footer class="auth-footer">
            <div class="footer-links">
                <a href="javascript:history.back();">이전으로</a>
                <span class="bar"></span>
                <a href="${pageContext.request.contextPath}/member/login">이미 계정이 있으신가요?</a>
            </div>
        </footer>
    </div>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>

<script src="${pageContext.request.contextPath}/dist/js/util-async.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/join.js"></script>

</body>
</html>