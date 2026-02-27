<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ include file="/WEB-INF/views/layout/headerResources.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>회원가입 | Baton</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

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

.page-wrapper {
	padding: 100px 20px 80px;
	display: flex;
	justify-content: center;
	align-items: center;
	min-height: 100vh;
}

/* --- STEP 1: 동네 인증 UI 스타일 --- */
.auth-box {
	max-width: 460px;
	width: 100%;
	background: var(--baton-white);
	padding: 40px 30px;
	border-radius: 32px;
	box-shadow: 0 20px 40px rgba(0, 0, 0, 0.06);
	text-align: center;
}

.icon-circle {
	width: 64px;
	height: 64px;
	background-color: #E8F3FF;
	color: var(--baton-blue);
	font-size: 26px;
	display: flex;
	align-items: center;
	justify-content: center;
	border-radius: 50%;
	margin: 0 auto 20px;
}

.auth-title {
	font-size: 24px;
	font-weight: 800;
	margin-bottom: 10px;
	color: var(--baton-title);
}

.auth-desc {
	color: var(--baton-desc);
	font-size: 15px;
	margin-bottom: 30px;
	line-height: 1.5;
}

.location-display {
	background-color: #F9FAFB;
	border: 1px solid #E5E8EB;
	border-radius: 24px;
	padding: 24px;
	margin-bottom: 24px;
	display: none;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	text-align: center;
}

.location-name {
	font-size: 18px;
	font-weight: 800;
	color: var(--baton-title);
	margin: 10px 0 20px 0;
	word-break: keep-all;
}

.badge-verified {
	display: inline-flex;
	align-items: center;
	gap: 6px;
	color: var(--baton-blue);
	font-size: 14px;
	font-weight: 700;
	background: rgba(49, 130, 246, 0.1);
	padding: 6px 12px;
	border-radius: 20px;
}

#map {
	width: 100%;
	height: 200px;
	border-radius: 16px;
	border: 1px solid #E5E8EB;
	margin-top: 10px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

.btn-auth {
	background: var(--baton-blue);
	color: #fff;
	border: none;
	padding: 16px;
	border-radius: 16px;
	font-weight: 700;
	font-size: 16px;
	width: 100%;
	transition: 0.2s;
	cursor: pointer;
}

.btn-auth:hover {
	background: #1B64DA;
}

.btn-auth:disabled {
	background: #ADCFFF;
	cursor: not-allowed;
}

.btn-retry {
	background: transparent;
	color: var(--baton-desc);
	border: none;
	font-size: 14px;
	text-decoration: underline;
	cursor: pointer;
	margin-top: 12px;
	display: none;
}

/* --- STEP 2: 회원가입 폼 UI 스타일 --- */
.register-box {
	max-width: 520px;
	width: 100%;
	background: var(--baton-white);
	padding: 40px 45px;
	border-radius: 32px;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
}

.register-header {
	text-align: center;
	margin-bottom: 25px;
}

.register-header h3 {
	font-size: 26px;
	font-weight: 800;
	margin-bottom: 6px;
}

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

.verified-town {
	font-size: 16px;
	font-weight: 700;
	color: var(--baton-blue);
}

.form-group {
	margin-bottom: 16px;
}

.form-label {
	display: block;
	font-weight: 600;
	font-size: 14px;
	color: var(--baton-desc);
	margin-bottom: 8px;
}

.input-with-btn {
	display: flex;
	gap: 10px;
	align-items: center;
	width: 100%;
}

/* 부트스트랩을 무력화시키는 input 필드 디자인 강제 적용 (!important) */
.form-control, .register-box input.form-control {
	flex: 1 !important;
	height: 48px !important;
	border-radius: 12px !important;
	padding: 12px 18px !important;
	border: 1px solid #E5E8EB !important;
	background-color: #F9FAFB !important;
	font-size: 15px !important;
	transition: all 0.2s ease-in-out !important;
	box-shadow: none !important;
	color: var(--baton-title) !important;
}

.form-control:focus, .register-box input.form-control:focus {
	outline: none !important;
	border-color: var(--baton-blue) !important;
	background-color: #fff !important;
	box-shadow: 0 0 0 3px rgba(49, 130, 246, 0.1) !important;
}

.form-control::placeholder {
	color: var(--baton-muted) !important;
}

/* 버튼 디자인 */
.btn-action {
	min-width: 90px;
	height: 48px;
	padding: 0 16px;
	border-radius: 12px;
	border: 1px solid #E5E8EB;
	background: #fff;
	font-weight: 600;
	font-size: 13.5px;
	color: var(--baton-blue);
	cursor: pointer;
	display: flex;
	align-items: center;
	justify-content: center;
	flex-shrink: 0;
	white-space: nowrap;
	transition: all 0.2s ease;
}

.btn-action:hover {
	background-color: #F2F4F6;
	border-color: var(--baton-blue);
}

.btn-action:disabled {
	color: var(--baton-muted);
	cursor: not-allowed;
	background-color: #F9FAFB;
	border-color: #E5E8EB;
}

#emailAuthRow {
	max-height: 0;
	overflow: hidden;
	opacity: 0;
	visibility: hidden;
	transition: max-height 0.4s ease, opacity 0.3s ease, margin-top 0.3s
		ease;
}

#emailAuthRow.open {
	max-height: 120px;
	margin-top: 10px;
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

.divider {
	height: 1px;
	background-color: #F2F4F6;
	margin: 24px 0;
}

.btn-register {
	background: var(--baton-blue);
	color: #fff;
	border: none;
	height: 56px;
	border-radius: 16px;
	font-weight: 700;
	font-size: 18px;
	width: 100%;
	margin-top: 14px;
	cursor: pointer;
	transition: 0.2s;
}

.btn-register:hover {
	background-color: #1B64DA;
}

/* --- 유효성 검사 메시지 및 상태 스타일 --- */

/* 메시지가 출력될 공통 박스 */
.status-msg {
    display: block;
    font-size: 13px;
    margin-top: 6px;
    margin-bottom: 2px;
    margin-left: 4px;
    line-height: 1.5;
    transition: all 0.2s ease;
}

/* 에러 상태 메시지 (빨간색) */
.error-msg {
    color: var(--baton-red) !important;
    font-weight: 500;
}

/* 성공 상태 메시지 (파란색) */
.success-msg {
    color: var(--baton-blue) !important;
    font-weight: 500;
}

/* 에러 발생 시 input 필드 스타일 (강제 적용) */
.form-control.input-error {
    border-color: var(--baton-red) !important;
    background-color: #FFF8F8 !important; /* 배경을 살짝 붉게 하여 인지력 상승 */
}

/* 에러 상태에서 포커스 시 효과 변경 */
.form-control.input-error:focus {
    box-shadow: 0 0 0 3px rgba(240, 68, 82, 0.1) !important;
}

/* 타이머와 메시지 간의 간격 조정 */
.status-msg + .timer-container {
    margin-top: 4px;
}

/* 인증 완료 버튼 스타일 */
.btn-action.verified {
    background-color: #00D082 !important; /* 토스 스타일 초록색 */
    color: #ffffff !important;
    border-color: #00D082 !important;
    transition: all 0.4s ease;
    cursor: default;
}

/* 살짝 튕기는 듯한 효과 애니메이션 */
@keyframes successBounce {
    0% { transform: scale(1); }
    50% { transform: scale(1.05); }
    100% { transform: scale(1); }
}

.btn-action.verified {
    animation: successBounce 0.4s ease-out;
}
</style>
</head>
<body>

	<header class="fixed-top shadow-sm bg-white">
		<jsp:include page="/WEB-INF/views/layout/header.jsp" />
	</header>

	<main class="page-wrapper">

		<div id="step-auth" class="auth-box">
			<div class="icon-circle">
				<i class="bi bi-geo-alt-fill"></i>
			</div>

			<h3 class="auth-title">내 동네 인증하기</h3>
			<p class="auth-desc">
				안전한 거래를 위해<br>현재 위치를 확인해주세요.
			</p>

			<div id="locationResult" class="location-display"
				style="display: none;">
				<div class="badge-verified">
					<i class="bi bi-check-circle-fill"></i> <span>인증 완료</span>
				</div>
				<div class="location-name" id="townName">위치 확인 중...</div>
				<div id="map"></div>
			</div>

			<div class="mt-3">
				<button type="button" class="btn-auth" id="btnMain"
					onclick="startAuth()">
					<span class="spinner-border spinner-border-sm me-2" id="loader"
						style="display: none;"></span> <span id="btnText">현재 위치로
						인증하기</span>
				</button>
				<button type="button" class="btn-retry w-100" id="btnRetry"
					onclick="startAuth()">위치 다시 찾기</button>
			</div>
		</div>


		<div id="step-join" class="register-box" style="display: none;">
			<div class="register-header">
				<h3 class="fw-bold">회원가입</h3>
				<p class="text-muted small">안전한 중고거래, 바톤과 함께해요!</p>
			</div>

			<div class="verified-badge-box">
				<div class="verified-info">
					<div class="verified-town" id="displayTown"></div>
				</div>
				<button type="button"
					class="btn btn-sm btn-outline-primary border-0 fw-bold p-0"
					style="font-size: 13px;" onclick="backToAuth()">변경</button>
			</div>

			<form name="registerForm"
				action="${pageContext.request.contextPath}/member/register"
				method="post">
				<input type="hidden" name="${_csrf.parameterName}"
					value="${_csrf.token}" /> <input type="hidden" name="userAddr"
					id="userAddr" value="">

				<div class="form-group">
					<label class="form-label">아이디</label>
					<div class="input-with-btn">
						<input type="text" name="userId" class="form-control"
							placeholder="6~20자 영문, 숫자">
						<button type="button" class="btn-action" onclick="checkId()">중복
							확인</button>
					</div>
				</div>

				<div class="form-group">
					<label class="form-label">비밀번호</label> <input type="password"
						name="pwd" class="form-control" placeholder="8자 이상 (영문, 숫자 포함)">
				</div>

				<div class="form-group">
					<label class="form-label">비밀번호 확인</label> <input type="password"
						id="pwdConfirm" class="form-control" placeholder="비밀번호 재입력">
				</div>

				<div class="divider"></div>

				<div class="form-group">
					<label class="form-label">닉네임</label>
					<div class="input-with-btn">
						<input type="text" name="nickname" class="form-control"
							placeholder="닉네임 입력">
						<button type="button" class="btn-action" onclick="checkNick()">중복
							확인</button>
					</div>
				</div>

				<div class="form-group">
					<label class="form-label">이메일</label>
					<div class="input-with-btn">
						<input type="email" id="email" name="email" class="form-control"
							placeholder="example@baton.com">
						<button type="button" id="btnSendAuth" class="btn-action"
							onclick="sendEmailAuth()">인증번호 전송</button>
					</div>

					<div id="emailAuthRow">
						<div class="input-with-btn">
							<input type="text" id="authCode" class="form-control"
								placeholder="인증번호 6자리">
							<button type="button" class="btn-action" onclick="verifyCode()">확인</button>
						</div>
						
						<div class="timer-container">
							<span class="auth-timer" id="timer">03:00</span>
						</div>
					</div>
				</div>

				<div class="form-group">
					<label class="form-label">휴대폰 번호</label> <input type="tel"
						name="tel" class="form-control" placeholder="010-0000-0000">
				</div>

				<div class="form-group">
					<label class="form-label">생년월일</label> <input type="date"
						name="birth" class="form-control">
				</div>

				<button type="button" class="btn-register" onclick="sendRegister();">가입하고
					바톤 시작하기</button>
			</form>
		</div>

	</main>

	<jsp:include page="/WEB-INF/views/api/api.jsp" />
	
	<script src="${pageContext.request.contextPath}/dist/js/util-async.js"></script>

	<script>
	
document.querySelectorAll('.form-control').forEach(input => {
    input.addEventListener('input', () => {
        showStatusMsg(input, null);
    });
});

document.getElementById("email").addEventListener('input', function() {
    const authRow = document.getElementById("emailAuthRow");
    if(authRow.classList.contains("open")) {
        authRow.classList.remove("open");
        document.getElementById("authCode").value = "";
        clearInterval(timerInterval);
        
        const sendBtn = document.getElementById("btnSendAuth");
        sendBtn.innerText = "인증번호 전송";
        sendBtn.disabled = false;
    }
});
	
/* ==============================================
   동네 인증 관련 로직
============================================== */
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
                    const fullAddress = region.address_name;

                    loader.style.display = "none";
                    locationResult.style.display = "flex"; 
                    townNameDisplay.innerText = fullAddress;
                    btnText.innerText = "가입 계속하기"; 
                    btnMain.disabled = false;
                    btnRetry.style.display = "block"; 

                    // 맵 랜더링
                    setTimeout(() => {
                        const mapOption = { center: new kakao.maps.LatLng(lat, lng), level: 3 };
                        const map = new kakao.maps.Map(mapContainer, mapOption);
                        const marker = new kakao.maps.Marker({ position: new kakao.maps.LatLng(lat, lng) });
                        marker.setMap(map);
                        map.relayout();
                        map.setCenter(new kakao.maps.LatLng(lat, lng));
                    }, 100);

                    // 버튼 클릭 시 화면 전환 로직으로 변경 (쿼리스트링 URL 이동 X)
                    btnMain.onclick = function() {
                        showJoinForm(fullAddress);
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

function showJoinForm(address) {
    document.getElementById('displayTown').innerText = address;
    document.getElementById('userAddr').value = address;
    
    document.getElementById('step-auth').style.display = 'none';
    document.getElementById('step-join').style.display = 'block';
    
    window.scrollTo(0, 0);
}

function backToAuth() {
    document.getElementById('step-join').style.display = 'none';
    document.getElementById('step-auth').style.display = 'block';
    window.scrollTo(0, 0);
}


/* ==============================================
   회원가입 폼 관련 로직
============================================== */
let timerInterval;
let isEmailVerified = false;

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

        const url = "${pageContext.request.contextPath}/member/sendAuthEmail";
        
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
            
            showStatusMsg(emailField, null);
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

        const url = "${pageContext.request.contextPath}/member/chkAuthCode";
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
            isEmailVerified = true;
            
            document.getElementById("emailAuthRow").classList.remove("open");
            clearInterval(timerInterval);
            
            const sendBtn = document.getElementById("btnSendAuth");
            sendBtn.innerHTML = '인증 완료';
            sendBtn.classList.add("verified");
            sendBtn.disabled = true;
            
            emailField.readOnly = true;
            userCodeField.readOnly = true;
            
            showStatusMsg(emailField, null);
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

function checkId() { alert("사용 가능한 아이디입니다."); }
function checkNick() { alert("사용 가능한 닉네임입니다."); }

function sendRegister() {
    const f = document.registerForm;
    if(!isEmailVerified) { alert("이메일 인증을 완료해주세요."); return; }
    
    // 여기에 추가적인 빈값 검증(Validation) 로직을 넣으시면 됩니다.
    
    f.submit();
}

function showStatusMsg(element, message, isError = true) {
    const container = element.parentElement.classList.contains('input-with-btn') 
                      ? element.parentElement.parentElement 
                      : element.parentElement;
                      
    let msgBox = container.querySelector('.status-msg');
    
    if (!msgBox) {
        msgBox = document.createElement('span');
        msgBox.className = 'status-msg';
        
        const timer = container.querySelector('.timer-container');
        if (timer) {
            timer.parentNode.insertBefore(msgBox, timer);
        } else {
            container.appendChild(msgBox);
        }
    }

    if (!message) {
        msgBox.innerText = "";
        msgBox.className = 'status-msg';
        element.classList.remove('input-error');
        return;
    }

    msgBox.innerText = message;
    msgBox.className = isError ? 'status-msg error-msg' : 'status-msg success-msg';
    
    if (isError) {
        element.classList.add('input-error');
    } else {
        element.classList.remove('input-error');
    }
}
</script>

</body>