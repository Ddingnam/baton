<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>${dto.title} - BATON</title>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/main.css">
<style>
    .article-container { max-width: 800px; margin: 0 auto; background: #fff; border: 1px solid #ebebeb; border-radius: 16px; padding: 40px; box-shadow: 0 4px 16px rgba(0,0,0,0.04); }
    .article-header { border-bottom: 1px solid #ebebeb; padding-bottom: 24px; margin-bottom: 30px; }
    .article-title { font-size: 28px; font-weight: 800; color: #191F28; margin: 0 0 16px 0; line-height: 1.4; }
    
    .pay-highlight { font-size: 24px; font-weight: 800; color: #ff7e36; display: flex; align-items: center; gap: 8px; margin-bottom: 24px; }
    .pay-highlight .badge { background: #ff7e36; color: white; font-size: 14px; padding: 4px 8px; border-radius: 6px; }
    
    .info-grid { display: grid; grid-template-columns: 100px 1fr; gap: 12px 0; font-size: 16px; margin-bottom: 20px; }
    .info-grid .label { color: #8B95A1; font-weight: 600; }
    .info-grid .value { color: #333D4B; font-weight: 500; }
    
    .article-body { font-size: 16px; line-height: 1.8; color: #333D4B; white-space: pre-wrap; min-height: 200px; padding: 20px 0; border-bottom: 1px solid #ebebeb; margin-bottom: 30px; }
    
    .btn-group { display: flex; gap: 12px; justify-content: center; }
    .btn { padding: 14px 28px; border-radius: 8px; font-size: 16px; font-weight: 700; cursor: pointer; text-decoration: none; text-align: center; transition: 0.2s; }
    .btn-outline { background: #fff; color: #4E5968; border: 1px solid #D1D6DB; }
    .btn-outline:hover { background: #F2F4F6; }
    .btn-primary { background: #ff7e36; color: #fff; border: none; flex: 1; max-width: 300px; }
    .btn-primary:hover { background: #e66a26; }
</style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <div id="baton-layout-container">
        <jsp:include page="/WEB-INF/views/layout/left.jsp" />

        <main id="baton-main-content">
            <div class="article-container">
                <div class="article-header">
                    <h1 class="article-title">${dto.title}</h1>
                    <div class="pay-highlight">
                        <span class="badge">시급</span> <fmt:formatNumber value="${dto.pay}" pattern="#,###"/>원
                    </div>
                    <div class="info-grid">
                        <div class="label">근무요일</div>
                        <div class="value">${dto.workDays}</div>
                        <div class="label">근무시간</div>
                        <div class="value">${dto.workTime}</div>
                        <div class="label">조회수</div>
                        <div class="value">${dto.hitCount}</div>
                    </div>
                </div>
                
                <div class="article-body">${dto.content}</div>

                <div class="btn-group">
                    <a href="${pageContext.request.contextPath}/alba/posting/list" class="btn btn-outline">목록으로</a>
                    <button class="btn btn-primary" onclick="alert('곧 지원하기 기능이 연결됩니다!');">이 알바 지원하기</button>
                </div>
            </div>
        </main>
    </div>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

</body>
</html>