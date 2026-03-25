<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>BATON 관리자 로그인</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@500;700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_login.css">

    <script>
    (function() {
        var THEME_COLORS = {
            purple:  { c1: '#8B5CF6', c2: '#EC4899', glow: 'rgba(139,92,246,0.4)'  },
            blue:    { c1: '#1D4ED8', c2: '#06B6D4', glow: 'rgba(29,78,216,0.4)'   },
            emerald: { c1: '#059669', c2: '#3B82F6', glow: 'rgba(5,150,105,0.4)'   },
            sunset:  { c1: '#EA580C', c2: '#EF4444', glow: 'rgba(234,88,12,0.4)'   },
            rose:    { c1: '#BE185D', c2: '#F43F5E', glow: 'rgba(190,24,93,0.4)'   },
            slate:   { c1: '#475569', c2: '#64748B', glow: 'rgba(71,85,105,0.4)'   }
        };
        try {
            var savedKey = 'baton-admin-theme-' + (localStorage.getItem('baton-admin-last-user') || '');
            var theme  = localStorage.getItem(savedKey) || localStorage.getItem('baton-admin-theme') || 'purple';
            var colors = THEME_COLORS[theme] || THEME_COLORS.purple;
            var grad   = 'linear-gradient(135deg, ' + colors.c1 + ' 0%, ' + colors.c2 + ' 100%)';
            var root   = document.documentElement;
            root.style.setProperty('--grad-vibe', grad);
            root.style.setProperty('--c-purple',  colors.c1);
            root.style.setProperty('--c-pink',    colors.c2);
            root.style.setProperty('--sh-glow',   '0 12px 32px -8px ' + colors.glow);
        } catch(e) {}
    })();
    </script>

    <style>
    :root {
        --bg-main: #F4F5F8; --card-bg: #FFFFFF;
        --txt-dark: #121417; --txt-base: #525866; --txt-muted: #9CA3AF;
        --c-purple: #8B5CF6; --c-pink: #EC4899; --c-green: #34C759;
        --grad-vibe: linear-gradient(135deg, #8B5CF6 0%, #EC4899 100%);
        --rad-md: 16px; --rad-lg: 32px; --rad-pill: 9999px;
        --sh-glow: 0 12px 32px -8px rgba(139,92,246,0.4);
        --sh-box: 0 15px 35px rgba(0,0,0,0.04);
        --spring: cubic-bezier(0.175, 0.885, 0.32, 1.275);
    }
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; outline: none; }
    body, html { width: 100%; height: 100vh; background-color: var(--bg-main); font-family: 'Pretendard', -apple-system, sans-serif; color: var(--txt-dark); overflow: hidden; }
    a { text-decoration: none; }
    button { border: none; background: none; cursor: pointer; font-family: inherit; }

    .auth-layout { display: flex; justify-content: center; align-items: center; min-height: 100vh; }
    .auth-box {
        position: relative; z-index: 10; width: 100%; max-width: 440px;
        background: var(--card-bg); border: 1px solid #EBECEF;
        border-radius: var(--rad-lg); padding: 56px 48px;
        box-shadow: var(--sh-box);
        animation: springUp 0.8s var(--spring) both;
    }
    @keyframes springUp {
        0%   { opacity: 0; transform: translateY(40px) scale(0.95); }
        100% { opacity: 1; transform: translateY(0)    scale(1);    }
    }
    .auth-brand { font-family: 'Montserrat', sans-serif; font-size: 36px; font-weight: 900; letter-spacing: -0.05em; color: var(--txt-dark); text-align: center; margin-bottom: 40px; }
    .auth-brand .dot { color: var(--c-purple); }
    .auth-header { text-align: center; margin-bottom: 40px; }
    .auth-header h1 { font-size: 26px; font-weight: 800; color: var(--txt-dark); margin-bottom: 8px; letter-spacing: -0.03em; }
    .auth-header p  { font-size: 15px; font-weight: 500; color: var(--txt-base); }
    .auth-form { display: flex; flex-direction: column; gap: 16px; }

    .input-wrap { position: relative; display: flex; align-items: center; }
    .input-wrap .icon { position: absolute; left: 20px; font-size: 20px; color: var(--txt-muted); transition: color 0.3s; pointer-events: none; }
    .input-wrap input { width: 100%; padding: 18px 16px 18px 52px; border: 2px solid transparent; border-radius: var(--rad-md); background: #F9FAFB; font-family: inherit; font-size: 15px; font-weight: 600; color: var(--txt-dark); transition: all 0.3s var(--spring); }
    .input-wrap input::placeholder { color: var(--txt-muted); font-weight: 500; }
    .input-wrap:focus-within .icon { color: var(--c-purple); }
    .input-wrap input:focus { background: #FFFFFF; border-color: var(--c-purple); box-shadow: 0 4px 16px rgba(139,92,246,0.15); }

    .auth-tools { display: flex; justify-content: space-between; align-items: center; margin: 8px 0 24px; }
    .remember-me { display: flex; align-items: center; gap: 10px; cursor: pointer; }
    .rem-text { font-size: 14px; font-weight: 600; color: var(--txt-base); }

    .mac-switch { position: relative; display: inline-block; width: 44px; height: 24px; flex-shrink: 0; }
    .mac-switch input { display: none; }
    .mac-slider { position: absolute; cursor: pointer; top:0; left:0; right:0; bottom:0; background-color: #EBECEF; border-radius: 24px; transition: background-color 0.4s ease; }
    .mac-slider::before { position: absolute; content: ""; height: 20px; width: 20px; left: 2px; bottom: 2px; background-color: white; border-radius: 50%; box-shadow: 0 2px 4px rgba(0,0,0,0.2); transition: transform 0.4s var(--spring), width 0.3s var(--spring); }
    .mac-switch input:checked + .mac-slider { background: var(--grad-vibe); }
    .mac-switch input:checked + .mac-slider::before { transform: translateX(20px); }
    .mac-switch:active .mac-slider::before { width: 26px; }
    .mac-switch input:checked:active + .mac-slider::before { transform: translateX(14px); }

    .btn-submit { width: 100%; padding: 18px; border-radius: var(--rad-pill); background: var(--grad-vibe); color: white; font-size: 16px; font-weight: 800; box-shadow: var(--sh-glow); transition: all 0.3s var(--spring); }
    .btn-submit:hover { transform: translateY(-2px) scale(1.02); }

    .error-msg { margin-top: 12px; font-size: 13px; font-weight: 600; color: var(--c-pink); text-align: center; }

    .auth-foot { margin-top: 40px; text-align: center; }
    .auth-foot a { display: inline-flex; align-items: center; gap: 6px; font-size: 14px; font-weight: 700; color: var(--txt-base); transition: all 0.2s; }
    .auth-foot a:hover { color: var(--txt-dark); transform: translateX(-4px); }

    .custom-alert { position: fixed; top: -100px; left: 50%; transform: translateX(-50%); background: rgba(25,31,40,0.95); backdrop-filter: blur(10px); padding: 16px 32px; border-radius: 100px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.1); display: flex; align-items: center; gap: 12px; z-index: 9999; transition: top 0.5s var(--spring), opacity 0.3s; opacity: 0; }
    .custom-alert.show { top: 40px; opacity: 1; }
    .custom-alert i { font-size: 20px; background: var(--grad-vibe); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
    .custom-alert span { font-size: 15px; font-weight: 600; color: #FFFFFF; letter-spacing: -0.5px; }

    .input-wrap.error input { border-color: var(--c-purple); background: #F9F5FF; }
    .input-wrap.error .icon { color: var(--c-purple); }

    @keyframes shakeError {
        0%,100% { transform: translateX(0);   }
        20%     { transform: translateX(-8px); }
        40%     { transform: translateX(8px);  }
        60%     { transform: translateX(-4px); }
        80%     { transform: translateX(4px);  }
    }
    .shake { animation: shakeError 0.4s cubic-bezier(.36,.07,.19,.97) both; }
    </style>
</head>
<body>

<div id="customAlert" class="custom-alert">
    <i class="ri-error-warning-fill"></i>
    <span id="alertMessage">입력란을 작성해 주세요.</span>
</div>

<div class="auth-layout">
    <div class="auth-box">
        <div class="auth-brand">
            BATON<span class="dot">.</span>
        </div>

        <div class="auth-header">
            <h1>관리자 로그인</h1>
            <p>서비스 관리를 위해 로그인해 주세요.</p>
        </div>

        <form id="loginForm" class="auth-form" action="${pageContext.request.contextPath}/member/login" method="post" novalidate>

            <input type="hidden" name="loginType" value="ADMIN">

            <div class="input-wrap">
                <i class="ri-user-3-fill icon"></i>
                <input type="text" name="login_id" placeholder="Admin ID" autocomplete="off">
            </div>

            <div class="input-wrap">
                <i class="ri-lock-password-fill icon"></i>
                <input type="password" name="password" placeholder="PassWord">
            </div>

            <div class="auth-tools">
                <label class="remember-me">
                    <div class="mac-switch">
                        <input type="checkbox" name="remember">
                        <span class="mac-slider"></span>
                    </div>
                    <span class="rem-text">아이디 저장</span>
                </label>
            </div>

            <button type="submit" class="btn-submit">로그인</button>

            <c:if test="${not empty message}">
                <div class="error-msg">${message}</div>
            </c:if>
            <c:if test="${param.error != null}">
                <div class="error-msg">아이디 또는 비밀번호가 일치하지 않습니다.</div>
            </c:if>
        </form>

        <div class="auth-foot">
            <a href="${pageContext.request.contextPath}/"><i class="ri-arrow-left-line"></i> 메인 홈페이지로 돌아가기</a>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const form     = document.getElementById('loginForm');
    const alertBox = document.getElementById('customAlert');
    const alertMsg = document.getElementById('alertMessage');
    const idInput  = document.querySelector('input[name="login_id"]');
    const pwInput  = document.querySelector('input[name="password"]');
    const urlParams = new URLSearchParams(window.location.search);

    if (urlParams.has('authorization_error')) {
        showCustomAlert('관리자 권한이 없습니다. 일반 로그인을 이용해 주세요.');
        history.replaceState({}, null, location.pathname);
    } else if (urlParams.has('error')) {
        let msg = urlParams.get('message') || '아이디 또는 비밀번호가 일치하지 않습니다.';
        showCustomAlert(msg);
        history.replaceState({}, null, location.pathname);
    }

    function showCustomAlert(message) {
        alertMsg.textContent = message;
        alertBox.classList.add('show');
        setTimeout(() => alertBox.classList.remove('show'), 3000);
    }

    let alertTimeout;
    function showError(inputElement, message) {
        alertMsg.textContent = message;
        alertBox.classList.add('show');
        const wrap = inputElement.closest('.input-wrap');
        wrap.classList.add('error', 'shake');
        setTimeout(() => wrap.classList.remove('shake'), 400);
        clearTimeout(alertTimeout);
        alertTimeout = setTimeout(() => alertBox.classList.remove('show'), 3000);
        inputElement.focus();
    }

    [idInput, pwInput].forEach(input => {
        input.addEventListener('input', function() {
            this.closest('.input-wrap').classList.remove('error');
            alertBox.classList.remove('show');
        });
    });

    form.addEventListener('submit', function(e) {
        if (!idInput.value.trim()) {
            e.preventDefault();
            showError(idInput, '아이디를 입력해 주세요.');
            return;
        }
        if (!pwInput.value.trim()) {
            e.preventDefault();
            showError(pwInput, '비밀번호를 입력해 주세요.');
            return;
        }
    });
});
</script>

</body>
</html>
