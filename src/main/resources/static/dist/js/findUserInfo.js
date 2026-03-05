async function sendIdFind() {
    const f = document.idFindForm;
    const name = f.name.value.trim();
    const email = f.email.value.trim();

    hideError();

    if (!name) { showError("이름을 입력해 주세요."); f.name.focus(); return; }
    if (!email) { showError("이메일을 입력해 주세요."); f.email.focus(); return; }

	try {
		const url = `${contextPath}/member/findId`;

		const params = new URLSearchParams();
		params.append('name', name);
		params.append('email', email);

		const response = await fetch(url, {
			method: 'POST',
			headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
			body: params
		});

		if (!response.ok) throw new Error('Network response was not ok');

		const data = await response.json();

		if (data.state === "success") {
			showResult(data.userId);
		} else {
			showError("일치하는 회원 정보가 없습니다.");
		}

	} catch (error) {
		console.error("sendIdFind Error:", error);
		showBatonToast("통신 중 오류가 발생했습니다.");
	}
}

function showResult(userId) {
    document.getElementById('id-find-form-area').style.display = 'none';
    document.getElementById('id-find-result').style.display = 'block';
    document.getElementById('found-user-id').innerText = userId;
    
    const btn = document.getElementById('main-action-btn');
	btn.blur();
    btn.querySelector('span').innerText = "로그인 하기";
    btn.onclick = function() {
        location.href = `${contextPath}/member/login`;
    };
}

function showError(msg) {
    const errorBox = document.getElementById('auth-error-msg');
    const errorSpan = document.getElementById('error-message-text');
    const serverError = document.querySelector('.server-error');
    
    if(serverError) serverError.style.display = 'none';
    
    errorSpan.innerText = msg;
    errorBox.style.display = 'flex';

    errorBox.classList.remove('shake');
    void errorBox.offsetWidth;
    errorBox.classList.add('shake');
}

function hideError() {
    const errorBox = document.getElementById('auth-error-msg');
    if(errorBox) errorBox.style.display = 'none';
}

let timerInterval;
let isVerified = false;

document.getElementById("email").addEventListener("input", function() {
    isVerified = false;
	
	const authRow = document.getElementById("emailAuthRow");
    authRow.classList.remove("open");    
    document.getElementById("btnMainText").innerText = "인증번호 전송";
    
    const authCodeInput = document.getElementById("authCode");
    authCodeInput.value = "";
    authCodeInput.readOnly = false;
    
    const btnVerify = document.getElementById("btnVerify");
    btnVerify.innerText = "확인";
    btnVerify.disabled = false;
    btnVerify.classList.remove("verified");

    if (timerInterval) clearInterval(timerInterval);
    document.getElementById("timer").innerText = "03:00";
    
    document.getElementById('auth-error-msg').style.display = 'none';
});

function handleMainAction() {
	const btnMain = document.getElementById("btnMain");
    if(btnMain) btnMain.blur();
		
    if (!isVerified) {
        sendEmailAuthForPwd();
    } else {
        location.href = `${contextPath}/member/updatePwd`;
    }
}

async function sendEmailAuthForPwd() {
	const f = document.findPwdForm;
    const userId = f.userId.value.trim();
    const email = f.email.value.trim();
	const btnMain = document.getElementById("btnMain");
	const btnMainText = document.getElementById("btnMainText");

	hideError();
	
	if (!userId) { showError("아이디를 입력해 주세요."); f.userId.focus(); return; }
	if (!email) { showError("이메일을 입력해 주세요."); f.email.focus(); return; }
	
	btnMain.disabled = true;
    btnMainText.innerText = "전송 중...";
    btnMain.style.opacity = "0.7";
	
    const formData = new FormData();
    formData.append("userId", userId);
    formData.append("email", email);

    try {
        const response = await fetch("/member/findPwd", { 
            method: "POST", 
            body: formData 
        });
        const result = await response.json();

        if (result.state === "success") {
            document.getElementById("emailAuthRow").classList.add("open");
            startTimer(180);
            showBatonToast("인증번호가 발송되었습니다.", false);
			
			btnMainText.innerText = "인증번호 재전송";
        } else {
            showError(result.message || "정보가 일치하지 않습니다.");
			btnMainText.innerText = "인증번호 전송";
        }
    } catch (e) {
		console.error("sendEmailAuthForPwd Error:", e);
        showBatonToast("네트워크 통신 중 오류가 발생했습니다.");
		btnMainText.innerText = "인증번호 전송";
	} finally {
        btnMain.disabled = false;
        btnMain.style.opacity = "1";
    }
}

async function verifyCodeForPwd() {
	const authCodeInput = document.getElementById("authCode");
    const userCode = document.getElementById("authCode").value.trim();
    const email = document.getElementById("email").value.trim();

	hideError();
	
    const formData = new FormData();
    formData.append("userCode", userCode);
    formData.append("email", email);

    try {
        const response = await fetch("/member/chkAuthCode", {
			method: "POST",
			body: formData
		});
        const data = await response.json();

        if (data.state === "success") {
            clearInterval(timerInterval);
			isVerified = true;
			
		    const btnVerify = document.getElementById("btnVerify");
		    btnVerify.innerText = "인증됨";
		    btnVerify.classList.add("verified");
		    btnVerify.disabled = true;
		    
		    const authCodeInput = document.getElementById("authCode");
		    const emailInput = document.getElementById("email");
		    authCodeInput.readOnly = true;
		    emailInput.readOnly = true;
			
			setTimeout(() => {
		        const authRow = document.getElementById("emailAuthRow");
		        authRow.classList.remove("open");
		        
		        document.getElementById("btnMainText").innerText = "비밀번호 재설정하기";
		    }, 800);
		} else {
            let errorMsg = "";
            switch (data.state) {
                case "invalidCode": 
                    errorMsg = "인증번호가 일치하지 않습니다."; 
                    authCodeInput.value = "";
                    authCodeInput.focus();
                    break;
                case "timeout":
					errorMsg = "인증 시간이 만료되었습니다."; break;
				case "expired":
					errorMsg = "인증 세션이 만료되었습니다. 다시 번호를 요청하세요."; break;
				case "invalidEmail":
					errorMsg = "인증 요청 시 이메일과 현재 이메일이 다릅니다."; break;
                default:
					errorMsg = "인증에 실패했습니다.";
            }
            showError(errorMsg);
        }
    } catch (e) {
		console.error("verifyCodeForPwd Error:", e);
        showBatonToast("네트워크 통신 중 오류가 발생했습니다.");
	}
}

function startTimer(seconds) {
    const timerDisplay = document.getElementById("timer");
    clearInterval(timerInterval);
    let time = seconds;

    timerInterval = setInterval(() => {
        let min = Math.floor(time / 60);
        let sec = time % 60;
        timerDisplay.innerText = `${min < 10 ? '0' : ''}${min}:${sec < 10 ? '0' : ''}${sec}`;
        if (--time < 0) {
            clearInterval(timerInterval);
            timerDisplay.innerText = "시간 만료";
        }
    }, 1000);
}

async function sendPwdUpdate() {
    const f = document.pwdUpdateForm;
    const pwd = f.userPwd.value.trim();
    const pwdCheck = f.userPwdCheck.value.trim();
	
	const btnSubmit = document.querySelector(".btn-baton-login");
	const btnText = btnSubmit.querySelector("span");
    
    hideError();

    if (!pwd) { 
        showError("새 비밀번호를 입력해 주세요."); 
        f.userPwd.focus(); 
        return; 
    }
    
	/*
    if (!/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/.test(pwd)) {
        showError("비밀번호는 8자 이상, 영문과 숫자를 포함해야 합니다.");
        f.userPwd.focus();
        return;
    }
	*/
	
    if (pwd !== pwdCheck) { 
        showError("비밀번호가 일치하지 않습니다."); 
        f.userPwdCheck.focus(); 
        return; 
    }
	
	btnSubmit.disabled = true;
    btnSubmit.style.opacity = "0.7";
    btnSubmit.style.cursor = "not-allowed";
    btnText.innerText = "변경 중...";

    const url = `${contextPath}/member/updatePassword`;
    const formData = new FormData();
    formData.append("pwd", pwd);

    try {
        const response = await fetch(url, {
            method: "POST",
            body: formData
        });

        if (!response.ok) throw new Error('Network response was not ok');

        const data = await response.json();

        if (data.state === "success") {
            showBatonToast("비밀번호가 성공적으로 변경되었습니다.", false);
			
			btnText.innerText = "변경 완료";
			
			setTimeout(() => {
                location.href = `${contextPath}/member/login`;
            }, 2000);
        } else {
            showError("비밀번호 변경에 실패했습니다.");
			btnSubmit.disabled = false;
            btnSubmit.style.opacity = "1";
            btnSubmit.style.cursor = "pointer";
            btnText.innerText = "비밀번호 변경하기";
        }

    } catch (error) {
        console.error("sendPwdUpdate Error:", error);
        showBatonToast("서버 통신 중 오류가 발생했습니다.");
		
		btnSubmit.disabled = false;
        btnSubmit.style.opacity = "1";
        btnSubmit.style.cursor = "pointer";
        btnText.innerText = "비밀번호 변경하기";
    }
}