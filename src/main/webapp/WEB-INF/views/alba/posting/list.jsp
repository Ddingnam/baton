<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>동네알바 - 바톤터치</title>
<style>
    :root { --main-color: #ff7e36; --bg-color: #f8f9fa; }
    body { font-family: 'Pretendard', sans-serif; background-color: var(--bg-color); margin: 0; padding: 0; }
    .mobile-container { max-width: 600px; margin: 0 auto; background: #fff; min-height: 100vh; position: relative; padding-bottom: 80px; box-shadow: 0 0 10px rgba(0,0,0,0.05); }
    .header { padding: 16px 20px; font-size: 20px; font-weight: bold; border-bottom: 1px solid #ebebeb; position: sticky; top: 0; background: #fff; z-index: 10; }
    .job-list { list-style: none; padding: 0; margin: 0; }
    .job-item { padding: 16px 20px; border-bottom: 1px solid #ebebeb; cursor: pointer; transition: background 0.2s; }
    .job-item:hover { background-color: #f9f9f9; }
    .job-title { font-size: 16px; font-weight: 600; color: #333; margin-bottom: 8px; }
    .job-meta { font-size: 13px; color: #888; margin-bottom: 8px; }
    .job-pay { font-size: 15px; font-weight: bold; color: var(--main-color); }
    .fab-btn { position: fixed; bottom: 30px; right: calc(50% - 280px); width: 60px; height: 60px; background-color: var(--main-color); color: #fff; border-radius: 50%; text-align: center; line-height: 60px; font-size: 28px; font-weight: bold; text-decoration: none; box-shadow: 0 4px 10px rgba(255, 126, 54, 0.4); z-index: 100; transition: transform 0.2s; }
    .fab-btn:hover { transform: scale(1.05); color: #fff; }
    @media (max-width: 600px) { .fab-btn { right: 20px; } }
</style>
</head>
<body>
<div class="mobile-container">
    <div class="header">동네알바</div>
    
    <ul class="job-list">
        <c:forEach var="item" items="${list}">
            <li class="job-item" onclick="location.href='${pageContext.request.contextPath}/alba/posting/article?postingIdx=${item.postingIdx}'">
                <div class="job-title">${item.title}</div>
                <div class="job-meta">
                    <span>${item.workDays}</span> · <span>${item.workTime}</span>
                </div>
                <div class="job-pay">시급 <fmt:formatNumber value="${item.pay}" pattern="#,###"/>원</div>
            </li>
        </c:forEach>
        <c:if test="${empty list}">
            <li class="job-item" style="text-align: center; padding: 50px 0; color: #999;">등록된 알바 공고가 없습니다.</li>
        </c:if>
    </ul>

    <a href="${pageContext.request.contextPath}/alba/posting/write" class="fab-btn">+</a>
</div>
</body>
</html>