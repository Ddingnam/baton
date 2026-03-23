<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>이력서 이메일 전송 | BATON</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css"/>
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet"/>
<style>
    :root { --primary: #002C5F; --bg: #F7F9FC; --border: #E2E8F0; --text: #1a202c; }
    body { font-family: 'Pretendard', sans-serif; background: var(--bg); margin: 0; padding: 0; color: var(--text); }
    
    .pop-header { background: var(--primary); color: #fff; padding: 20px; display: flex; align-items: center; gap: 10px; }
    .pop-header h1 { font-size: 18px; margin: 0; font-weight: 700; }
    
    .pop-content { padding: 30px; }
    .info-box { background: #fff; border: 1px solid var(--border); padding: 20px; border-radius: 12px; margin-bottom: 25px; }
    .info-box p { margin: 0 0 8px; font-size: 13px; color: #718096; }
    .info-box h2 { margin: 0; font-size: 16px; font-weight: 700; color: var(--primary); }

    .form-group { margin-bottom: 20px; }
    .form-group label { display: block; font-size: 14px; font-weight: 600; margin-bottom: 8px; color: #4A5568; }
    .input-row { display: flex; gap: 8px; align-items: center; }
    
    input[type="text"], select { 
        width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 8px; font-size: 14px; outline: none; 
    }
    input[type="text"]:focus { border-color: var(--primary); }
    
    .btn-submit { 
        width: 100%; padding: 16px; background: var(--primary); color: #fff; border: none; 
        border-radius: 10px; font-size: 16px; font-weight: 700; cursor: pointer; transition: 0.2s;
    }
    .btn-submit:hover { background: #001b3a; }
</style>
</head>
<body>

<div class="pop-header">
    <i class="ri-mail-send-fill"></i>
    <h1>이력서 이메일 전송</h1>
</div>

<div class="pop-content">
    <div class="info-box">
        <p>선택한 이력서</p>
        <h2>${dto.title}</h2>
    </div>

    <form action="${pageContext.request.contextPath}/resume/email" method="post" onsubmit="return validateForm()">
        <input type="hidden" name="profileIdx" value="${dto.profileIdx}">
        
        <div class="form-group">
            <label>받는 사람 이름</label>
            <input type="text" name="receiverName" id="receiverName" placeholder="성함 또는 담당자명">
        </div>

        <div class="form-group">
            <label>받는 이메일 주소</label>
            <div class="input-row">
                <input type="text" name="emailId" id="emailId" style="flex:1;">
                <span>@</span>
                <input type="text" name="emailDomain" id="emailDomain" style="flex:1;">
                <select style="flex:1;" onchange="changeDomain(this)">
                    <option value="direct">직접입력</option>
                    <option value="naver.com">naver.com</option>
                    <option value="gmail.com">gmail.com</option>
                    <option value="daum.net">daum.net</option>
                </select>
            </div>
        </div>

        <div style="margin-top:40px;">
            <button type="submit" class="btn-submit">메일 발송하기</button>
        </div>
    </form>
</div>

<script>
function changeDomain(obj) {
    const domainInput = document.getElementById('emailDomain');
    if(obj.value === 'direct') {
        domainInput.value = '';
        domainInput.readOnly = false;
        domainInput.focus();
    } else {
        domainInput.value = obj.value;
        domainInput.readOnly = true;
    }
}

function validateForm() {
    if(!document.getElementById('receiverName').value.trim()) {
        alert('받는 사람 이름을 입력해주세요.'); return false;
    }
    if(!document.getElementById('emailId').value || !document.getElementById('emailDomain').value) {
        alert('이메일 주소를 완성해주세요.'); return false;
    }
    return confirm('이력서를 이메일로 발송하시겠습니까?');
}
</script>
</body>
</html>