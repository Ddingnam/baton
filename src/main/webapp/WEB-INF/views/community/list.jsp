<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>BATON | 커뮤니티</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/left.css">
</head>
<body>

    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <div id="baton-layout-container">
        <jsp:include page="/WEB-INF/views/layout/left.jsp" />

        <main id="baton-main-content">
            <section class="baton-section">
                <h2 class="main-display-title">우리 동네 이웃들의<br><span style="color: #F86D7D;">따뜻한 이야기</span></h2>
                <p class="main-display-subtitle">궁금한 건 묻고, 즐거운 일상은 나누어 보세요.</p>
                
                <div style="text-align: center; padding: 100px; background: #fff; border-radius: 32px; box-shadow: var(--shadow-soft);">
                    <i class="ri-discuss-line" style="font-size: 80px; color: #F86D7D;"></i>
                    <h3 style="font-size: 26px; font-weight: 800; margin-top: 20px;">커뮤니티 게시판 준비 중!</h3>
                    <p style="font-size: 18px; color: var(--baton-muted); margin-top: 15px;">
                        위쪽 로고를 보세요!<br>
                        바톤 막대기와 메뉴 글씨가 <strong>예쁜 핑크색</strong>으로 변해있을 겁니다. 🌸
                    </p>
                </div>
            </section>
        </main>
    </div>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
    
    <div id="baton-sidebar-open" class="sidebar-show-btn" onclick="handleSidebar()">
        <i class="ri-menu-unfold-line"></i>
    </div>

    <script src="${pageContext.request.contextPath}/dist/js/main.js"></script>
</body>
</html>
