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

function sendIdFind() {
    const f = document.idFindForm;
    hideError();
    if (!f.name.value.trim()) { showError("이름을 입력해 주세요."); f.name.focus(); return; }
    if (!f.email.value.trim()) { showError("이메일을 입력해 주세요."); f.email.focus(); return; }
    f.submit();
}

function sendPwdFind() {
    const f = document.pwdFindForm;
    hideError();
    if (!f.userId.value.trim()) { showError("아이디를 입력해 주세요."); f.userId.focus(); return; }
    if (!f.email.value.trim()) { showError("이메일을 입력해 주세요."); f.email.focus(); return; }
    f.submit();
}