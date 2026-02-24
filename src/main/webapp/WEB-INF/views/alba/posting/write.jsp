<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>알바 공고 작성 - 바톤터치</title>
<style>
    :root { --main-color: #ff7e36; }
    body { font-family: 'Pretendard', sans-serif; background-color: #f8f9fa; margin: 0; padding: 0; }
    .mobile-container { max-width: 600px; margin: 0 auto; background: #fff; min-height: 100vh; padding: 0 20px 80px 20px; }
    .header { padding: 16px 0; font-size: 20px; font-weight: bold; border-bottom: 1px solid #ebebeb; margin-bottom: 20px; }
    .form-group { margin-bottom: 20px; }
    .form-group label { display: block; font-size: 14px; font-weight: 600; margin-bottom: 8px; color: #333; }
    .form-control { width: 100%; box-sizing: border-box; padding: 14px; border: 1px solid #ddd; border-radius: 8px; font-size: 15px; outline: none; }
    .form-control:focus { border-color: var(--main-color); }
    textarea.form-control { resize: none; height: 200px; }
    .submit-btn { width: 100%; padding: 16px; background-color: var(--main-color); color: #fff; border: none; border-radius: 8px; font-size: 16px; font-weight: bold; cursor: pointer; margin-top: 10px; }
    .submit-btn:hover { background-color: #e66a26; }
</style>
</head>
<body>
<div class="mobile-container">
    <div class="header">알바 구하기</div>
    
    <form action="${pageContext.request.contextPath}/alba/posting/write" method="post" onsubmit="return validateForm()">
        <div class="form-group">
            <label>공고 제목</label>
            <input type="text" name="title" id="title" class="form-control" placeholder="예) 홀서빙 알바 구합니다" required>
        </div>
        <div class="form-group">
            <label>시급</label>
            <input type="number" name="pay" id="pay" class="form-control" placeholder="9860" required>
        </div>
        <div class="form-group">
            <label>근무 요일</label>
            <input type="text" name="workDays" class="form-control" placeholder="예) 월~금, 주말 등" required>
        </div>
        <div class="form-group">
            <label>근무 시간</label>
            <input type="text" name="workTime" class="form-control" placeholder="예) 10:00 ~ 14:00" required>
        </div>
        <div class="form-group">
            <label>모집 마감일</label>
            <input type="datetime-local" name="deadlineDate" class="form-control" required>
        </div>
        <div class="form-group">
            <label>상세 내용</label>
            <textarea name="content" class="form-control" placeholder="상세 업무 내용과 우대사항 등을 적어주세요." required></textarea>
        </div>
        
        <button type="submit" class="submit-btn">공고 올리기</button>
    </form>
</div>
<script>
    function validateForm() {
        const pay = document.getElementById("pay").value;
        if(pay < 9860) {
            alert("최저시급(9,860원) 이상 입력해주세요.");
            return false;
        }
        return true;
    }
</script>
</body>
</html>