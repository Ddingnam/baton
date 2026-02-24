<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${dto.title} - 바톤터치</title>
<style>
    :root { --main-color: #ff7e36; }
    body { font-family: 'Pretendard', sans-serif; background-color: #f8f9fa; margin: 0; padding: 0; }
    .mobile-container { max-width: 600px; margin: 0 auto; background: #fff; min-height: 100vh; padding-bottom: 90px; box-shadow: 0 0 10px rgba(0,0,0,0.05); }
    .article-header { padding: 24px 20px; border-bottom: 1px solid #ebebeb; }
    .title { font-size: 22px; font-weight: bold; color: #222; margin-bottom: 12px; }
    .pay { font-size: 20px; font-weight: bold; color: var(--main-color); margin-bottom: 20px; }
    .meta-info { display: flex; flex-wrap: wrap; gap: 10px; font-size: 14px; color: #555; }
    .meta-info div { background: #f1f3f5; padding: 6px 12px; border-radius: 4px; }
    .article-content { padding: 24px 20px; font-size: 16px; line-height: 1.6; color: #333; white-space: pre-wrap; min-height: 300px; }
    
    /* 하단 고정 바 */
    .bottom-bar { position: fixed; bottom: 0; left: 50%; transform: translateX(-50%); width: 100%; max-width: 600px; background: #fff; padding: 12px 20px; box-sizing: border-box; border-top: 1px solid #ddd; display: flex; gap: 10px; z-index: 10; }
    .apply-btn { flex: 1; padding: 16px; background-color: var(--main-color); color: #fff; border: none; border-radius: 8px; font-size: 16px; font-weight: bold; cursor: pointer; text-align: center; text-decoration: none; }
    .back-btn { width: 60px; padding: 16px; background-color: #fff; color: #333; border: 1px solid #ddd; border-radius: 8px; font-weight: bold; cursor: pointer; text-align: center; text-decoration: none; }
</style>
</head>
<body>
<div class="mobile-container">
    <div class="article-header">
        <div class="title">${dto.title}</div>
        <div class="pay">시급 <fmt:formatNumber value="${dto.pay}" pattern="#,###"/>원</div>
        <div class="meta-info">
            <div>요일: ${dto.workDays}</div>
            <div>시간: ${dto.workTime}</div>
            <div>조회수: ${dto.hitCount}</div>
        </div>
    </div>
    
    <div class="article-content">${dto.content}</div>

    <div class="bottom-bar">
        <a href="${pageContext.request.contextPath}/alba/posting/list" class="back-btn">목록</a>
        <a href="javascript:alert('지원하기 기능은 다음 단계에서 개발됩니다!');" class="apply-btn">지원하기</a>
    </div>
</div>
</body>
</html>