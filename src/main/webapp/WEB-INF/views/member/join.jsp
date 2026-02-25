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
    align-items: center;
    justify-content: center;
    min-height: 100vh;
}

.register-box {
    max-width: 800px; 
    width: 100%;
    background: var(--baton-white);
    padding: 60px;
    border-radius: 32px;
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.06);
}

.register-header {
    margin-bottom: 40px;
    text-align: center;
}

.verified-badge-box {
    background-color: #F2F7FF;
    border: 1px dashed var(--baton-blue);
    border-radius: 16px;
    padding: 20px;
    margin-bottom: 30px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.verified-info h5 {
    font-size: 14px;
    color: var(--baton-blue);
    margin: 0 0 4px 0;
    font-weight: 700;
}

.verified-town {
    font-size: 18px;
    font-weight: 700;
    color: var(--baton-title);
}

.form-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    column-gap: 32px;
    row-gap: 20px;
}

.full-width { grid-column: span 2; }

.form-label {
    display: block;
    font-weight: 600;
    font-size: 14px;
    color: var(--baton-desc);
    margin-bottom: 8px;
}

.form-control {
    width: 100%;
    border-radius: 12px;
    padding: 14px 18px;
    border: 1px solid #E5E8EB;
    background-color: #F9FAFB;
    transition: 0.2s;
}

.form-control[readonly] {
    background-color: #F2F4F6;
    border-color: #E5E8EB;
    color: #8B95A1;
    cursor: not-allowed;
}

.btn-register {
    background: var(--baton-blue);
    color: #fff;
    border: none;
    padding: 18px;
    border-radius: 16px;
    font-weight: 700;
    font-size: 18px;
    width: 100%;
    margin-top: 20px;
    cursor: pointer;
}

.divider {
    grid-column: span 2;
    height: 1px;
    background-color: #F2F4F6;
    margin: 10px 0;
}
</style>
</head>
<body>

<header class="fixed-top shadow-sm bg-white">
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main class="register-container">
    <div class="register-box">
        <div class="register-header">
            <h3 class="fw-bold">정보를 입력해주세요</h3>
            <p class="text-muted">거의 다 됐어요! 마지막 단계입니다.</p>
        </div>

			<div class="verified-badge-box">
				<div class="verified-info">
					<h5>
						<i class="bi bi-patch-check-fill"></i> 인증된 내 동네
					</h5>
					<div class="verified-town" id="displayTown">${town}</div>
				</div>
				<a href="${pageContext.request.contextPath}/member/townAuth"
					class="btn btn-sm btn-outline-primary border-0 fw-bold">변경</a>
			</div>

			<form name="registerForm" action="${pageContext.request.contextPath}/member/register" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            
            <input type="hidden" name="userAddr" id="userAddr">

            <div class="form-grid">
                <div class="full-width">
                    <label class="form-label">아이디</label>
                    <input type="text" name="userId" class="form-control" placeholder="6~20자 영문, 숫자">
                </div>
                
                <div>
                    <label class="form-label">비밀번호</label>
                    <input type="password" name="pwd" class="form-control" placeholder="8자 이상 입력">
                </div>
                <div>
                    <label class="form-label">비밀번호 확인</label>
                    <input type="password" id="pwdConfirm" class="form-control" placeholder="재입력">
                </div>

                <div class="divider"></div>

                <div>
                    <label class="form-label">이름</label>
                    <input type="text" name="name" class="form-control" placeholder="실명 입력">
                </div>
                <div>
                    <label class="form-label">닉네임</label>
                    <input type="text" name="nickname" class="form-control" placeholder="활동 닉네임">
                </div>

                <div class="full-width">
                    <label class="form-label">휴대폰 번호</label>
                    <input type="tel" name="tel" class="form-control" placeholder="010-0000-0000">
                </div>

                <div class="full-width">
                    <button type="button" class="btn-register" onclick="sendRegister();">가입하고 바톤 시작하기</button>
                </div>
            </div>
        </form>
    </div>
</main>

<script>
window.onload = function() {
    const urlParams = new URLSearchParams(window.location.search);
    const town = urlParams.get('town');

    if (town) {
        document.getElementById('displayTown').innerText = town;
        document.getElementById('userAddr').value = town;
    } else {
        alert("동네 인증이 필요합니다.");
        location.href = "location-auth.jsp";
    }
}

function sendRegister() {
    const f = document.registerForm;
    const pwdConfirm = document.getElementById('pwdConfirm');
    
    if(!f.userId.value.trim()) { alert('아이디를 입력해주세요.'); f.userId.focus(); return; }
    if(f.pwd.value.length < 8) { alert('비밀번호는 8자 이상이어야 합니다.'); f.pwd.focus(); return; }
    if(f.pwd.value !== pwdConfirm.value) { alert('비밀번호가 일치하지 않습니다.'); pwdConfirm.focus(); return; }
    if(!f.name.value.trim()) { alert('이름을 입력해주세요.'); f.name.focus(); return; }
    if(!f.nickname.value.trim()) { alert('닉네임을 입력해주세요.'); f.nickname.focus(); return; }
    if(!f.tel.value.trim()) { alert('휴대폰 번호를 입력해주세요.'); f.tel.focus(); return; }

    f.submit();
}
</script>

</body>
</html>