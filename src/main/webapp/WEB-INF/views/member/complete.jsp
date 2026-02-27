<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>가입 완료 | Baton</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>

<style type="text/css">
:root {
    --baton-blue: #3182F6;
    --baton-bg: #ffffff;
    --baton-title: #191F28;
    --baton-sub: #4E5968;
}

body {
    background-color: var(--baton-bg);
    font-family: 'Pretendard', -apple-system, sans-serif;
    overflow-x: hidden;
}

body::before {
    content: '';
    position: absolute;
    width: 100%;
    height: 100%;
    top: 0; left: 0;
    background: radial-gradient(circle at 50% -20%, #E8F3FF 0%, #ffffff 50%);
    z-index: -1;
}

.complete-wrapper {
    padding: 100px 20px;
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 85vh;
}

.complete-box {
    max-width: 440px;
    width: 100%;
    text-align: center;
    padding: 20px;
}

.success-icon-wrap {
    width: 100px;
    height: 100px;
    background: #ffffff;
    color: var(--baton-blue);
    border-radius: 30px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 50px;
    margin: 0 auto 32px;
    box-shadow: 0 12px 24px rgba(49, 130, 246, 0.15);
    animation: bounceIn 0.8s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}

@keyframes bounceIn {
    0% { transform: scale(0.3); opacity: 0; }
    100% { transform: scale(1); opacity: 1; }
}

.complete-title {
    font-size: 32px;
    font-weight: 800;
    color: var(--baton-title);
    margin-bottom: 12px;
    letter-spacing: -1px;
}

.complete-desc {
    font-size: 17px;
    color: var(--baton-sub);
    line-height: 1.6;
    margin-bottom: 48px;
}

.info-card {
    background: #F2F4F6;
    border-radius: 24px;
    padding: 24px;
    margin-bottom: 48px;
    display: inline-flex;
    flex-direction: column;
    align-items: center;
    min-width: 200px;
}

.info-label {
    color: #8B95A1;
    font-size: 14px;
    margin-bottom: 4px;
    display: block;
}

.info-value {
    color: var(--baton-title);
    font-weight: 700;
    font-size: 18px;
    display: block;
}

.btn-home {
    background: var(--baton-blue);
    color: #ffffff !important;
    border: none;
    height: 60px;
    border-radius: 18px;
    font-weight: 700;
    font-size: 18px;
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    transition: all 0.2s ease;
    text-decoration: none;
    box-shadow: 0 8px 16px rgba(49, 130, 246, 0.25);
}

.btn-home:hover {
    background: #1B64DA;
    transform: translateY(-2px);
    box-shadow: 0 12px 20px rgba(49, 130, 246, 0.3);
}

.btn-home i {
    font-size: 20px;
}
</style>
</head>
<body>

<header>
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main class="complete-wrapper">
    <div class="complete-box">
        <div class="success-icon-wrap">
            <i class="bi bi-person-check-fill"></i>
        </div>
        
        <h3 class="complete-title">환영합니다, ${nickname}님!</h3>
        <p class="complete-desc">
            바톤의 가족이 되신 것을 축하드려요.<br>
            이웃과 함께하는 즐거운 거래를 경험해보세요.
        </p>

        <div class="info-card">
            <span class="info-label">내 계정 아이디</span>
            <span class="info-value">${userId}</span>
        </div>
        
        <a href="${pageContext.request.contextPath}/" class="btn-home">
            바톤 시작하기 <i class="bi bi-chevron-right"></i>
        </a>
    </div>
</main>

<footer>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/layout/footerResources.jsp"/>

</body>
</html>