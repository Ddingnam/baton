const contextPath = document.getElementById('registerForm').dataset.contextPath;

const checkStatus = {
    isIdVerified: false,
    isNicknameVerified: false,
    isEmailVerified: true
};

document.addEventListener("DOMContentLoaded", function() {
    const pwd = document.querySelector("input[name='pwd']");
    const pwdConfirm = document.getElementById("pwdConfirm");

    [pwd, pwdConfirm].forEach(input => {
        input.addEventListener("blur", function() {
            const pVal = pwd.value.trim();
            const pcVal = pwdConfirm.value.trim();

            if (pVal && pcVal) {
                if (pVal === pcVal) {
                    showStatusMsg(pwdConfirm, "비밀번호가 일치합니다.", false); 
                } else {
                    showStatusMsg(pwdConfirm, "비밀번호가 일치하지 않습니다.");
                }
            }
        });
    });
});
	
function startAuth() {
    const btnText = document.getElementById('btnText');
    const loader = document.getElementById('loader');
    const townNameDisplay = document.getElementById('townName');
    const locationResult = document.getElementById('locationResult');
    const btnRetry = document.getElementById('btnRetry');
    const btnMain = document.getElementById('btnMain');
    const mapContainer = document.getElementById('map');

    btnText.innerText = "위치 확인 중...";
    loader.style.display = "inline-block";
    btnMain.disabled = true;

    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
            const lat = position.coords.latitude;
            const lng = position.coords.longitude;

            const geocoder = new kakao.maps.services.Geocoder();
            geocoder.coord2RegionCode(lng, lat, function(result, status) {
                if (status === kakao.maps.services.Status.OK) {
                    const region = result.find(r => r.region_type === 'B');
					const data = {
						fullAddress: region.address_name,
						coreAddress: region.region_3depth_name,
						regionCode: region.code,
						lat: lat,
						lng: lng
					};

                    loader.style.display = "none";
                    locationResult.style.display = "flex"; 
                    townNameDisplay.innerText = data.fullAddress;
                    btnText.innerText = "가입 계속하기"; 
                    btnMain.disabled = false;
                    btnRetry.style.display = "block"; 

                    setTimeout(() => {
                        const mapOption = { center: new kakao.maps.LatLng(lat, lng), level: 3 };
                        const map = new kakao.maps.Map(mapContainer, mapOption);
                        const marker = new kakao.maps.Marker({ position: new kakao.maps.LatLng(lat, lng) });
                        marker.setMap(map);
                        map.relayout();
                        map.setCenter(new kakao.maps.LatLng(lat, lng));
                    }, 100);

                    btnMain.onclick = function() {
                        showJoinForm(data);
                    };
                }
            });
        }, function(error) {
            loader.style.display = "none";
            btnMain.disabled = false;
            btnText.innerText = "인증 실패";
            btnRetry.style.display = "block";
            alert("위치 정보를 가져오지 못했습니다. 기기의 위치 설정을 확인해주세요.");
        }, { enableHighAccuracy: true, maximumAge: 0, timeout: 10000 });
    } else {
        alert("브라우저가 위치 정보를 지원하지 않습니다.");
    }
}

let timerInterval;

async function sendEmailAuth() {
    const emailField = document.getElementById("email");
    const email = emailField.value.trim();
    
    if(!email) { 
        showBatonToast("이메일을 입력해주세요."); 
        emailField.focus();
        return; 
    }

    const btnSendAuth = document.getElementById("btnSendAuth");

    try {
        btnSendAuth.innerText = "전송 중...";
        btnSendAuth.disabled = true;

        const url = `${contextPath}/member/sendAuthEmail`;
        
        const params = new URLSearchParams();
        params.append('email', email);

        const response = await fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        });

        if (!response.ok) throw new Error('Network response was not ok');

        const data = await response.json();

        if (data.state === "true") {
            showBatonToast("인증번호가 발송되었습니다.");
            
            btnSendAuth.innerText = "재전송";
            btnSendAuth.disabled = false;
            
            document.getElementById("emailAuthRow").classList.add("open");
            startTimer(180);
            
            hideStatusMsg(emailField);
		} else if(data.state === "duplicated") {
			showBatonToast("이미 사용중인 이메일입니다.");
            btnSendAuth.innerText = "인증번호 전송";
            btnSendAuth.disabled = false;
        } else {
            showBatonToast(data.message || "발송에 실패했습니다.");
            btnSendAuth.innerText = "인증번호 전송";
            btnSendAuth.disabled = false;
        }

    } catch (error) {
        console.error("Mail Auth Error:", error);
        showBatonToast("인증 메일 전송 중 오류가 발생했습니다.");
        btnSendAuth.innerText = "인증번호 전송";
        btnSendAuth.disabled = false;
    }
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

async function verifyCode() {
    const userCodeField = document.getElementById("authCode");
    const emailField = document.getElementById("email");
    const userCode = userCodeField.value.trim();
    const email = emailField.value.trim();
    
    if(!userCode) {
    	showStatusMsg(userCodeField, "인증번호를 입력해주세요.");
        userCodeField.focus();
        return;
    }

    const verifyBtn = event ? event.target : document.querySelector("button[onclick='verifyCode()']");
    const originalText = verifyBtn.innerText;

    try {
        verifyBtn.disabled = true;
        verifyBtn.innerText = "확인 중...";

        const url = `${contextPath}/member/chkAuthCode`;
        const params = new URLSearchParams();
        params.append('userCode', userCode);
        params.append('email', email);

        const response = await fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        });

        if (!response.ok) throw new Error('인증 서버 응답 오류');

        const data = await response.json();

        if (data.state === "success") {
            checkStatus.isEmailVerified = true;
            
            document.getElementById("emailAuthRow").classList.remove("open");
            clearInterval(timerInterval);
            
            const sendBtn = document.getElementById("btnSendAuth");
            sendBtn.innerHTML = '인증 완료';
            sendBtn.classList.add("verified");
            sendBtn.disabled = true;
            
            emailField.readOnly = true;
            userCodeField.readOnly = true;
            
            hideStatusMsg(emailField);
        } else {
            if (data.state === "invalidCode") {
                showStatusMsg(userCodeField, "인증번호가 일치하지 않습니다.");
                userCodeField.value = "";
                userCodeField.focus();
            } else {
                let errorMsg = "";
                switch(data.state) {
                    case "timeout": errorMsg = "인증 시간이 만료되었습니다. 다시 시도해주세요."; break;
                    case "expired": errorMsg = "인증 세션이 만료되었습니다. 다시 번호를 요청하세요."; break;
                    case "invalidEmail": errorMsg = "인증 요청 시 이메일과 현재 이메일이 다릅니다."; break;
                    default: errorMsg = "서버 오류가 발생했습니다.";
                }
                showStatusMsg(emailField, errorMsg);
                resetAuthUI();
            }
        }

    } catch (error) {
    	console.error("Verification Error:", error);
        showStatusMsg(emailField, "통신 중 오류가 발생했습니다.");
        resetAuthUI();
    } finally {
        verifyBtn.disabled = false;
        verifyBtn.innerText = originalText;
    }
}

function resetAuthUI() {
    document.getElementById("emailAuthRow").classList.remove("open");
    document.getElementById("authCode").value = "";
    clearInterval(timerInterval);
    
    const sendBtn = document.getElementById("btnSendAuth");
    sendBtn.innerText = "인증번호 재전송";
    sendBtn.disabled = false;
}

async function checkId() {
    const inputField = document.querySelector('input[name="userId"]');
    await checkDuplication("userId", inputField);
}

async function checkNickname() {
    const inputField = document.querySelector('input[name="nickname"]');
    await checkDuplication("nickname", inputField);
}

async function checkDuplication(type, element) {
    const input = element.value.trim();
    
    if (!input) {
        showStatusMsg(element, "필수 입력 항목입니다.");
        element.focus();
        return;
    }

    try {
        const url = `${contextPath}/member/checkDuplicated?type=${type}&input=${encodeURIComponent(input)}`;
        const response = await fetch(url);

        if (!response.ok) throw new Error("네트워크 응답 오류");

        const data = await response.json();
		
		if(data.state === "available") {
			if(type === 'userId') checkStatus.isIdVerified = true;
			if(type === 'nickname') checkStatus.isNicknameVerified = true;
		} else {
			if(type === 'userId') checkStatus.isIdVerified = false;
			if(type === 'nickname') checkStatus.isNicknameVerified = false;
		}

        if (data.state === "available") {
            showStatusMsg(element, `사용 가능한 ${type === 'userId' ? '아이디' : '닉네임'}입니다.`, false);
        } else if (data.state === "duplicated") {
            showStatusMsg(element, `이미 사용 중인 ${type === 'userId' ? '아이디' : '닉네임'}입니다.`);
        } else if (data.state === "null") {
            showStatusMsg(element, "입력값이 올바르지 않습니다.");
        } else {
            showStatusMsg(element, "서버 통신 중 알 수 없는 오류가 발생했습니다.");
        }

    } catch (error) {
        console.error("Duplication Check Error:", error);
        showStatusMsg(element, "중복 검사 중 오류가 발생했습니다.");
    }
}

async function sendRegister() {
	document.querySelector(".btn-baton-login").blur();
	
    const f = document.registerForm;
    
    const userId = f.userId;
    const pwd = f.pwd;
    const pwdConfirm = document.getElementById("pwdConfirm");
	const name = f.name;
    const nickname = f.nickname;
    const email = f.email;
    const tel = f.tel;
    const birth = f.birth;
	const authCode = document.getElementById("authCode");

    if (!userId.value.trim()) { showStatusMsg(userId, "아이디를 입력해주세요."); userId.focus(); return; }
    if (!pwd.value.trim()) { showStatusMsg(pwd, "비밀번호를 입력해주세요."); pwd.focus(); return; }
    if (!pwdConfirm.value.trim()) { showStatusMsg(pwdConfirm, "비밀번호 확인을 입력해주세요."); pwdConfirm.focus(); return; }
    if (!name.value.trim()) { showStatusMsg(name, "이름을 입력해주세요."); name.focus(); return; }
    if (!nickname.value.trim()) { showStatusMsg(nickname, "닉네임을 입력해주세요."); nickname.focus(); return; }
    if (!email.value.trim()) { showStatusMsg(email, "이메일을 입력해주세요."); email.focus(); return; }
    if (!tel.value.trim()) { showStatusMsg(tel, "휴대폰 번호를 입력해주세요."); tel.focus(); return; }
    if (!birth.value.trim()) { showStatusMsg(birth, "생년월일을 입력해주세요."); birth.focus(); return; }

	/*
    const idRegExp = /^[a-zA-Z0-9]{6,20}$/;
    if (!idRegExp.test(userId.value.trim())) {
        showStatusMsg(userId, "아이디는 6~20자의 영문, 숫자만 가능합니다.");
        userId.focus();
        return;
    }

    const pwdRegExp = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,20}$/;
    if (!pwdRegExp.test(pwd.value.trim())) {
        showStatusMsg(pwd, "비밀번호는 8자 이상, 영문/숫자/특수문자를 포함해야 합니다.");
        pwd.focus();
        return;
    }

    const nickRegExp = /^[가-힣a-zA-Z0-9]{2,10}$/;
    if (!nickRegExp.test(nickname.value.trim())) {
        showStatusMsg(nickname, "닉네임은 2~10자의 한글, 영문, 숫자만 가능합니다.");
        nickname.focus();
        return;
    }

    const emailRegExp = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    if (!emailRegExp.test(email.value.trim())) {
        showStatusMsg(email, "올바른 이메일 형식이 아닙니다.");
        email.focus();
        return;
    }
	*/

    if (pwd.value.trim() !== pwdConfirm.value.trim()) {
        showStatusMsg(pwdConfirm, "비밀번호가 일치하지 않습니다.");
        pwdConfirm.focus();
        return;
    }
	
    if (!checkStatus.isIdVerified) {
        showStatusMsg(userId, "아이디 중복 확인을 완료해주세요.");
        userId.focus();
        return;
    }

    if (!checkStatus.isNicknameVerified) {
        showStatusMsg(nickname, "닉네임 중복 확인을 완료해주세요.");
        nickname.focus();
        return;
    }

	/* 임시 비활성화
    if (!checkStatus.isEmailVerified) {
        showStatusMsg(email, "이메일 인증을 완료해주세요.");
        authCode.focus();
        return;
    }
	*/

	const formData = new FormData(f);

    try {
        const response = await fetch(`${contextPath}/member/register`, {
            method: 'POST',
            body: formData
        });

        const result = await response.json();

        if (result.state === "success") {
            location.href = `${contextPath}/member/complete`;
        } else {
            showBatonToast("서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        }
    } catch (error) {
        console.error("Register Error:", error);
        showBatonToast("네트워크 통신 중 오류가 발생했습니다.");
    }
}

function showStatusMsg(element, message, isError = true) {
    if (!element) return;
    
    hideStatusMsg(element);
    if (!message) return;

    const identifier = element.name || element.id;
    const msgId = identifier + "-msg";
    
    const container = element.closest('.input-sequence');
    if (!container) return;

    const msgBox = document.createElement('span');
    msgBox.id = msgId;
    msgBox.className = 'status-msg ' + (isError ? 'error-msg' : 'success-msg');
    msgBox.innerText = message;
    
    msgBox.style.color = isError ? '#F04452' : '#3182F6';
    msgBox.style.fontSize = '13px';
    msgBox.style.marginTop = '8px';
    msgBox.style.display = 'block';

    container.appendChild(msgBox);
    
    if (isError) element.classList.add('input-error');
}

function hideStatusMsg(element) {
    if (!element) return;

    element.classList.remove('input-error');

    const identifier = element.name || element.id;
    const msgId = identifier + "-msg";
    
    const msgBox = document.getElementById(msgId);
    if (msgBox) {
        msgBox.remove();
    }

    const container = element.closest('.input-sequence');
    if (container) {
        const extraBoxes = container.querySelectorAll('.status-msg');
        extraBoxes.forEach(box => box.remove());
    }
}

document.addEventListener("DOMContentLoaded", function() {
    document.addEventListener('input', function(e) {
        if (e.target.tagName !== 'INPUT') return;

        const input = e.target;
        
        hideStatusMsg(input);

        if (input.name === 'userId') checkStatus.isIdVerified = false;
        if (input.name === 'nickname') checkStatus.isNicknameVerified = false;

        if (input.id === 'email') {
            const authRow = document.getElementById("emailAuthRow");
            if (authRow && authRow.classList.contains("open")) {
                authRow.classList.remove("open");
                
                if (window.timerInterval) {
                    clearInterval(window.timerInterval);
                }
                const timerDisp = document.getElementById("timer");
                if (timerDisp) timerDisp.innerText = "03:00";
                
                const sendBtn = document.getElementById("btnSendAuth");
                if (sendBtn) {
                    sendBtn.innerText = "인증번호 전송";
                    sendBtn.disabled = false;
                    sendBtn.classList.remove("verified");
                }
            }
        }
    });
});
