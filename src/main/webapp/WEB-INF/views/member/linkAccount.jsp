<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>계정 연결하기 | BATON</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
<style type="text/css">
:root {
    --baton-primary: #3182F6;
    --baton-primary-hover: #1B64DA;
    --body-bg: #F2F5F9;
    --card-bg: #FFFFFF;
    --text-dark: #191F28;
    --text-gray: #4E5968;
    --text-muted: #8B95A1;
    --border-light: #EAECEF;
    --harmony-ease: cubic-bezier(0.2, 0.8, 0.2, 1);
}

body {
    background: var(--body-bg) !important;
    font-family: 'Pretendard', sans-serif;
    color: var(--text-dark);
}

.baton-harmony-canvas {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
}

.login-auth-frame { 
    width: 100%; 
    max-width: 460px; 
    padding: 64px 48px; 
    background: var(--card-bg); 
    border-radius: 32px; 
    box-shadow: 0 24px 48px rgba(0, 0, 0, 0.04);
}

/* --- 애니메이션 엔진 (로그인 페이지와 동일) --- */
.reveal-item { 
    opacity: 0; 
    transform: translateY(20px); 
    animation: itemReveal 0.8s var(--harmony-ease) forwards; 
}
@keyframes itemReveal { 
    to { opacity: 1; transform: translateY(0); } 
}

.delay-1 { animation-delay: 0.1s; }
.delay-2 { animation-delay: 0.2s; }
.delay-3 { animation-delay: 0.3s; }
.delay-4 { animation-delay: 0.4s; }
.delay-5 { animation-delay: 0.5s; }
.delay-6 { animation-delay: 0.6s; }

/* 헤더 섹션 */
.auth-header { margin-bottom: 32px; text-align: center; }
.link-icon-visual {
    width: 64px; height: 64px; background: #E8F3FF;
    color: var(--baton-primary); border-radius: 20px;
    display: inline-flex; align-items: center; justify-content: center;
    font-size: 32px; margin-bottom: 24px;
    animation: iconFloat 3s ease-in-out infinite;
}
@keyframes iconFloat {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-10px); }
}

.auth-title { font-size: 26px; font-weight: 800; color: var(--text-dark); letter-spacing: -0.5px; margin-bottom: 12px; }
.auth-subtitle { font-size: 15px; line-height: 1.6; color: var(--text-gray); }

/* 안내 카드 */
.info-summary-card {
    background: #F9FAFB; border-radius: 20px;
    padding: 24px; margin-bottom: 32px;
    border: 1px solid var(--border-light);
}
.summary-item { display: flex; justify-content: space-between; margin-bottom: 10px; }
.summary-item:last-child { margin-bottom: 0; }
.summary-label { font-size: 14px; color: var(--text-muted); }
.summary-value { font-size: 14px; color: var(--text-dark); font-weight: 600; }

/* 입력 폼 */
.input-sequence { margin-bottom: 24px; }
.input-label { display: block; font-size: 13px; font-weight: 700; color: var(--text-gray); margin-bottom: 8px; }
.input-glow-wrap input {
    width: 100%; height: 56px; padding: 0 18px; background: #F9FAFB;
    border: 1px solid transparent; border-radius: 14px; font-size: 16px;
    outline: none; transition: 0.3s;
}
.input-glow-wrap input:focus { 
    background: #FFFFFF; border-color: var(--baton-primary); 
    box-shadow: 0 0 0 4px rgba(49, 130, 246, 0.1);
}

/* 알림 텍스트 */
.policy-notice {
    font-size: 13px; color: var(--text-muted);
    line-height: 1.6; text-align: center;
    margin-bottom: 32px; padding: 0 10px;
}

/* 버튼 */
.btn-baton-link {
    width: 100%; height: 60px; background: var(--text-dark); color: white;
    border: none; border-radius: 16px; font-size: 17px; font-weight: 700;
    cursor: pointer; transition: 0.4s var(--harmony-ease);
}
.btn-baton-link:hover { background: var(--baton-primary); transform: translateY(-4px); }

.auth-footer { margin-top: 24px; text-align: center; }
.btn-link-back {
    font-size: 14px; color: var(--text-muted);
    text-decoration: none; font-weight: 500;
}

/* 에러 쉐이크 */
.input-glow-wrap.error-shake input {
    border-color: #F04452 !important;
    background-color: #FFF1F0 !important;
}
.error-shake { animation: shake 0.4s var(--harmony-ease); }
@keyframes shake {
    0%, 100% { transform: translateX(0); }
    25% { transform: translateX(-8px); }
    50% { transform: translateX(8px); }
    75% { transform: translateX(-8px); }
}
</style>
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
</head>
<body>
	
<header class="fixed-top shadow-sm bg-white">
	<jsp:include page="/WEB-INF/views/layout/header.jsp" />
</header>

<main class="baton-harmony-canvas">
    <div class="login-auth-frame">
        <header class="auth-header reveal-item delay-1">
            <div class="link-icon-visual">
                <i class="ri-link"></i>
            </div>
            <h1 class="auth-title">계정을 찾았습니다!</h1>
            <p class="auth-subtitle">이미 사용 중인 이메일 주소입니다.<br>기존 계정과 연결하여 간편하게 로그인하세요.</p>
        </header>

        <div class="info-summary-card reveal-item delay-2">
            <div class="summary-item">
                <span class="summary-label">가입된 아이디</span>
                <span class="summary-value">${userId}</span>
            </div>
            <div class="summary-item">
                <span class="summary-label">이메일</span>
                <span class="summary-value">${email}</span>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/member/linkAccount" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <div class="input-sequence reveal-item delay-3">
                <label class="input-label">기존 계정 비밀번호</label>
                <div class="input-glow-wrap" id="passwordWrapper">
                    <input type="password" id="confirmPwd" placeholder="비밀번호를 입력해 주세요" required>
                </div>
            </div>

            <p class="policy-notice reveal-item delay-4">
                바톤은 <b>1인 1계정 원칙</b>을 통해 안전한 거래 환경을 만듭니다.<br>
                연동을 원치 않으실 경우 소셜 로그인이 제한됩니다.
            </p>

            <div class="reveal-item delay-5">
                <button type="button" class="btn-baton-link" onclick="processAccountLink();">
                    연결하고 시작하기
                </button>
            </div>
        </form>
        
        <footer class="auth-footer reveal-item delay-6">
            <a href="${pageContext.request.contextPath}/member/login" class="btn-link-back">
                나중에 하기
            </a>
        </footer>
    </div>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>

<script>
async function processAccountLink() {
    const pwdInput = document.getElementById('confirmPwd');
    const pwdWrapper = document.getElementById('passwordWrapper');
    const pwd = pwdInput.value.trim();

    if(!pwd) {
        showBatonToast("비밀번호를 입력해주세요.", "error");
        pwdInput.focus();
        return;
    }

    try {
        const response = await fetch('${pageContext.request.contextPath}/member/linkAccount', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-CSRF-TOKEN': '${_csrf.token}'
            },
            body: new URLSearchParams({ 'pwd': pwd })
        });

        const result = await response.json();
        console.log(result.state);

        if(result.state === "success") {
            location.replace('${pageContext.request.contextPath}/');
        } else if(result.state === "fail") {
        	handleAuthError(pwdInput, pwdWrapper, "비밀번호가 일치하지 않습니다.");       	
        } else {
        	showBatonToast("서버 통신 중 오류가 발생했습니다.", "error");
        }
    } catch (error) {
        showBatonToast("서버 통신 중 오류가 발생했습니다.", "error");
    }
}

function handleAuthError(input, wrapper, message) {
    showBatonToast(message, "error");

    input.value = "";
    input.focus();
    wrapper.classList.add('error-shake');
    
    setTimeout(() => {
        wrapper.classList.remove('error-shake');
    }, 400);
}
</script>

</body>
</html>