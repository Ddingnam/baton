<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>회원가입 | Baton</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

<style type="text/css">
:root {
    --baton-bg: #F9FAFB;
    --baton-white: #FFFFFF;
    --baton-title: #191F28;
    --baton-desc: #4E5968;
    --baton-muted: #8B95A1;
    --baton-blue: #3182F6;
    --baton-red: #F04452;
}

body { 
    background-color: var(--baton-bg); 
    font-family: 'Pretendard', -apple-system, sans-serif;
    color: var(--baton-title);
    margin: 0;
}

.register-container {
    padding: 100px 20px 80px; 
    display: flex;
    justify-content: center;
    min-height: 100vh;
}

.register-box {
    max-width: 520px;
    width: 100%;
    background: var(--baton-white);
    padding: 40px 45px;
    border-radius: 32px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
}

.register-header { text-align: center; margin-bottom: 25px; }
.register-header h3 { font-size: 26px; font-weight: 800; margin-bottom: 6px; }

.verified-badge-box {
    background-color: #F2F7FF;
    border: 1px dashed var(--baton-blue);
    border-radius: 14px;
    padding: 14px 20px;
    margin-bottom: 25px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.verified-town { font-size: 16px; font-weight: 700; }

.form-group { margin-bottom: 14px; }
.form-label { display: block; font-weight: 600; font-size: 14px; color: var(--baton-desc); margin-bottom: 6px; }

.input-with-btn { display: flex; gap: 10px; align-items: center; }

.form-control {
    flex: 1;
    border-radius: 12px;
    padding: 12px 18px;
    border: 1px solid #E5E8EB;
    background-color: #F9FAFB;
    font-size: 15px;
    transition: 0.2s;
}

.form-control:focus { 
    outline: none; 
    border-color: var(--baton-blue); 
    background-color: #fff; 
    box-shadow: 0 0 0 3px rgba(49, 130, 246, 0.1); 
}

.btn-action {
    min-width: 85px;
    height: 48px;
    padding: 0 16px; 
    border-radius: 12px;
    border: 1px solid #E5E8EB;
    background: #fff;
    font-weight: 600;
    font-size: 13px;
    color: var(--baton-blue);
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    white-space: nowrap;
    transition: all 0.2s ease;
}

.btn-action:hover { background-color: #F2F4F6; border-color: var(--baton-blue); }
.btn-action:disabled { color: var(--baton-muted); cursor: not-allowed; background-color: #F9FAFB; border-color: #E5E8EB; }

#emailAuthRow {
    max-height: 0;
    overflow: hidden;
    opacity: 0;
    visibility: hidden;
    transition: max-height 0.4s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.3s ease, margin-top 0.3s ease;
}

#emailAuthRow.open {
    max-height: 120px; 
    margin-top: 12px;
    opacity: 1;
    visibility: visible;
}

.timer-container {
    text-align: center;
    margin-top: 8px;
}

.auth-timer {
    font-size: 14px;
    color: var(--baton-red);
    font-weight: 700;
}

.divider { height: 1px; background-color: #F2F4F6; margin: 20px 0; }

.btn-register {
    background: var(--baton-blue);
    color: #fff;
    border: none;
    padding: 18px;
    border-radius: 16px;
    font-weight: 700;
    font-size: 18px;
    width: 100%;
    margin-top: 10px;
    cursor: pointer;
    transition: 0.2s;
}

.btn-register:hover { background-color: #1B64DA; }
</style>
</head>
<body>

<header class="fixed-top shadow-sm bg-white">
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main class="register-container">
    <div class="register-box">
        <div class="register-header">
            <h3 class="fw-bold">회원가입</h3>
            <p class="text-muted small">안전한 중고거래, 바톤과 함께해요!</p>
        </div>

        <div class="verified-badge-box">
            <div class="verified-info">
                <div class="verified-town" id="displayTown">${town}</div>
            </div>
            <a href="${pageContext.request.contextPath}/member/townAuth" class="btn btn-sm btn-outline-primary border-0 fw-bold p-0" style="font-size: 13px;">변경</a>
        </div>

        <form name="registerForm" action="${pageContext.request.contextPath}/member/register" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <input type="hidden" name="userAddr" id="userAddr" value="${town}">

            <div class="form-group">
                <label class="form-label">아이디</label>
                <div class="input-with-btn">
                    <input type="text" name="userId" class="form-control" placeholder="6~20자 영문, 숫자">
                    <button type="button" class="btn-action" onclick="checkId()">중복 확인</button>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">비밀번호</label>
                <input type="password" name="pwd" class="form-control" placeholder="8자 이상 (영문, 숫자 포함)">
            </div>
            
            <div class="form-group">
                <label class="form-label">비밀번호 확인</label>
                <input type="password" id="pwdConfirm" class="form-control" placeholder="비밀번호 재입력">
            </div>

            <div class="divider"></div>

            <div class="form-group">
                <label class="form-label">닉네임</label>
                <div class="input-with-btn">
                    <input type="text" name="nickname" class="form-control" placeholder="닉네임 입력">
                    <button type="button" class="btn-action" onclick="checkNick()">중복 확인</button>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">이메일</label>
                <div class="input-with-btn">
                    <input type="email" id="email" name="email" class="form-control" placeholder="example@baton.com">
                    <button type="button" id="btnSendAuth" class="btn-action" onclick="sendEmailAuth()">인증번호 전송</button>
                </div>
                
                <div id="emailAuthRow">
                    <div class="input-with-btn">
                        <input type="text" id="authCode" class="form-control" placeholder="인증번호 6자리">
                        <button type="button" class="btn-action" onclick="verifyCode()">확인</button>
                    </div>
                    <div class="timer-container">
                        <span class="auth-timer" id="timer">03:00</span>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">휴대폰 번호</label>
                <input type="tel" name="tel" class="form-control" placeholder="010-0000-0000">
            </div>

            <div class="form-group">
                <label class="form-label">생년월일</label>
                <input type="date" name="birth" class="form-control">
            </div>

            <button type="button" class="btn-register" onclick="sendRegister();">가입하고 바톤 시작하기</button>
        </form>
    </div>
</main>

<script>
let timerInterval;
let isEmailVerified = false;

function sendEmailAuth() {
    const email = document.getElementById("email").value.trim();
    if(!email) { alert("이메일을 입력해주세요."); return; }

    document.getElementById("btnSendAuth").innerText = "재전송";

    const authRow = document.getElementById("emailAuthRow");
    authRow.classList.add("open");

    startTimer(180); 
    alert("인증번호가 발송되었습니다.");
}

function startTimer(duration) {
    clearInterval(timerInterval);
    let timer = duration;
    const timerDisplay = document.getElementById("timer");

    timerInterval = setInterval(() => {
        let minutes = Math.floor(timer / 60);
        let seconds = timer % 60;
        minutes = minutes < 10 ? "0" + minutes : minutes;
        seconds = seconds < 10 ? "0" + seconds : seconds;

        timerDisplay.innerText = minutes + ":" + seconds;

        if (--timer < 0) {
            clearInterval(timerInterval);
            timerDisplay.innerText = "시간 만료";
            timerDisplay.style.color = "#8B95A1";
        }
    }, 1000);
}

function verifyCode() {
    const code = document.getElementById("authCode").value;
    if(code === "123456") {
        alert("이메일 인증이 완료되었습니다.");
        isEmailVerified = true;
        
        document.getElementById("emailAuthRow").classList.remove("open");
        const sendBtn = document.getElementById("btnSendAuth");
        sendBtn.innerText = "인증 완료";
        sendBtn.disabled = true;
        document.getElementById("email").readOnly = true;
        clearInterval(timerInterval);
    } else {
        alert("인증번호가 일치하지 않습니다.");
    }
}

function checkId() { alert("사용 가능한 아이디입니다."); }
function checkNick() { alert("사용 가능한 닉네임입니다."); }

function sendRegister() {
    const f = document.registerForm;
    if(!isEmailVerified) { alert("이메일 인증을 완료해주세요."); return; }
    f.submit();
}
</script>

</body>
</html>