<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>알바 공고 작성 - BATON</title>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/main.css">
<style>
    .write-container { max-width: 700px; margin: 0 auto; background: #fff; border-radius: 16px; padding: 40px; box-shadow: 0 4px 16px rgba(0,0,0,0.04); border: 1px solid #ebebeb; }
    .write-header { border-bottom: 2px solid #191F28; padding-bottom: 16px; margin-bottom: 30px; font-size: 24px; font-weight: 800; color: #191F28; }
    
    .form-group { margin-bottom: 24px; }
    .form-group label { display: block; font-size: 15px; font-weight: 700; color: #333D4B; margin-bottom: 8px; }
    .form-control { width: 100%; padding: 14px 16px; box-sizing: border-box; border: 1px solid #D1D6DB; border-radius: 8px; font-size: 15px; font-family: inherit; transition: border-color 0.2s; background: #f9fafb; }
    .form-control:focus { outline: none; border-color: #ff7e36; background: #fff; }
    textarea.form-control { min-height: 250px; resize: vertical; }
    
    .btn-submit { width: 100%; padding: 16px; background-color: #ff7e36; color: #fff; border: none; border-radius: 8px; font-size: 18px; font-weight: bold; cursor: pointer; transition: 0.2s; margin-top: 20px; }
    .btn-submit:hover { background-color: #e66a26; }
</style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <div id="baton-layout-container">
        <jsp:include page="/WEB-INF/views/layout/left.jsp" />

        <main id="baton-main-content">
            <div class="write-container">
                <div class="write-header">동네 알바 구하기</div>
                
                <form action="${pageContext.request.contextPath}/alba/posting/write" method="post" onsubmit="return validateForm()">
                    <div class="form-group">
                        <label>공고 제목</label>
                        <input type="text" name="title" class="form-control" placeholder="예) 홀서빙 알바 구합니다" required>
                    </div>
                    
                    <div class="form-group">
                        <label>시급 (원)</label>
                        <input type="number" name="pay" id="pay" class="form-control" placeholder="최저시급 9,860원 이상" required>
                    </div>
                    
                    <div class="form-group">
                        <label>근무 요일</label>
                        <input type="text" name="workDays" class="form-control" placeholder="예) 월~금, 주말, 협의 등" required>
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
                        <textarea name="content" class="form-control" placeholder="하는 일, 우대사항, 지원 조건 등을 자세히 적어주세요." required></textarea>
                    </div>
                    
                    <button type="submit" class="btn-submit">공고 등록하기</button>
                </form>
            </div>
        </main>
    </div>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

    <script>
        function validateForm() {
            const pay = document.getElementById("pay").value;
            if(pay < 9860) {
                alert("2024년 최저시급(9,860원) 이상으로 입력해주세요.");
                document.getElementById("pay").focus();
                return false;
            }
            return true;
        }
    </script>
</body>
</html>ㄴ