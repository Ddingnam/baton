<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>계정 연동 완료 | Baton</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>

<style type="text/css">
:root {
    --baton-blue: #3182F6;
    --baton-bg: #ffffff;
    --baton-title: #191F28;
    --baton-sub: #4E5968;
    --kakao-yellow: #FEE500;
    --gray-bg: #F9FAFB;
    --border-color: #F2F4F6;
}

body {
    background-color: var(--baton-bg);
    font-family: 'Pretendard', -apple-system, sans-serif;
    margin: 0;
    padding: 0;
}

/* 배경 그라데이션 - 더 넓게 퍼지도록 수정 */
body::before {
    content: '';
    position: absolute;
    width: 100%;
    height: 100%;
    top: 0; left: 0;
    background: radial-gradient(circle at 50% -10%, #E8F3FF 0%, #ffffff 60%);
    z-index: -1;
}

.complete-wrapper {
    /* 위아래 간격을 더 넓게 확보 */
    padding: 50px 24px;
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 92vh;
    box-sizing: border-box;
}

.complete-box {
    max-width: 480px;
    width: 100%;
    text-align: center;
}

/* 아이콘 섹션 */
.link-icon-wrap {
    width: 110px;
    height: 110px;
    background: #ffffff;
    color: var(--baton-blue);
    border-radius: 36px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 52px;
    margin: 0 auto 40px;
    box-shadow: 0 20px 40px rgba(49, 130, 246, 0.12);
    position: relative;
    animation: slideUp 0.8s cubic-bezier(0.2, 0.8, 0.2, 1);
}

@keyframes slideUp {
    0% { transform: translateY(30px); opacity: 0; }
    100% { transform: translateY(0); opacity: 1; }
}

.provider-badge {
    position: absolute;
    bottom: -4px;
    right: -4px;
    width: 40px;
    height: 40px;
    background: var(--kakao-yellow);
    border-radius: 15px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 20px;
    border: 4px solid #fff;
    color: #3C1E1E;
}

.welcome-text {
    display: block;
    color: var(--baton-blue);
    font-weight: 700;
    font-size: 19px;
    margin-bottom: 12px;
}

.complete-title {
    font-size: 34px;
    font-weight: 800;
    color: var(--baton-title);
    margin-bottom: 20px;
    letter-spacing: -1.2px;
}

.complete-desc {
    font-size: 18px;
    color: var(--baton-sub);
    line-height: 1.6;
    margin-bottom: 56px;
}

/* 연동 정보 카드 - 깔끔한 리스트 스타일 */
.link-info-card {
    background: var(--gray-bg);
    border-radius: 32px;
    padding: 8px 24px;
    margin-bottom: 60px;
    border: 1px solid var(--border-color);
}

.link-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px 0;
}

.link-item:not(:last-child) {
    border-bottom: 1px solid var(--border-color);
}

.link-label {
    color: #6B7684;
    font-size: 16px;
    font-weight: 500;
}

.link-value-group {
    display: flex;
    align-items: center;
    gap: 8px;
}

.link-value {
    color: var(--baton-title);
    font-weight: 600;
    font-size: 17px;
}

.status-dot {
    width: 8px;
    height: 8px;
    background-color: #00D082;
    border-radius: 50%;
}

/* 버튼 섹션 */
.btn-group {
    display: flex;
    flex-direction: column;
    gap: 16px;
}

.btn-start {
    background: var(--baton-blue);
    color: #ffffff !important;
    border: none;
    height: 68px;
    border-radius: 22px;
    font-weight: 700;
    font-size: 19px;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    transition: all 0.25s ease;
    text-decoration: none;
    box-shadow: 0 12px 24px rgba(49, 130, 246, 0.2);
}

.btn-start:hover {
    background: #1B64DA;
    transform: translateY(-3px);
    box-shadow: 0 16px 30px rgba(49, 130, 246, 0.25);
}

.btn-secondary {
    background: #F2F4F6;
    color: #4E5968 !important;
    border: none;
    height: 68px;
    border-radius: 22px;
    font-weight: 600;
    font-size: 18px;
    display: flex;
    align-items: center;
    justify-content: center;
    text-decoration: none;
    transition: all 0.2s ease;
}

.btn-secondary:hover {
    background: #E5E8EB;
    color: #333D4B !important;
}

@media (max-width: 480px) {
    .complete-wrapper { padding: 100px 20px; }
    .complete-title { font-size: 28px; }
    .complete-desc { font-size: 16px; }
    .link-info-card { padding: 8px 20px; }
}
</style>
</head>
<body>

<header>
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main class="complete-wrapper">
    <div class="complete-box">
        <div class="link-icon-wrap">
            <i class="bi bi-link-45deg"></i>
            <c:if test="${provider == 'Kakao'}">
                <div class="provider-badge">
                    <i class="bi bi-chat-fill"></i>
                </div>
            </c:if>
        </div>
        
        <span class="welcome-text">${nickname}님, 반가워요!</span>
        <h3 class="complete-title">계정 연동 완료</h3>
        <p class="complete-desc">
            기존 바톤 계정과 SNS 계정이 연결되었습니다.<br>
            이제 더 간편하게 로그인하세요.
        </p>

        <div class="link-info-card">
            <div class="link-item">
                <span class="link-label">연결된 아이디</span>
                <span class="link-value">${userId}</span>
            </div>
            <div class="link-item">
                <span class="link-label">연동 플랫폼</span>
                <span class="link-value">${provider}</span>
            </div>
        </div>
        
        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/" class="btn-start">
                바톤 시작하기 <i class="bi bi-chevron-right" style="font-size: 16px; -webkit-text-stroke: 1px;"></i>
            </a>
        </div>
    </div>
</main>

<footer>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

</body>
</html>