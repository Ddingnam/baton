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
<style>
    /* 💜 커뮤니티 전용 힙한 보라 테마 스타일 */
    .community-hero {
        background: linear-gradient(135deg, #F4F0FF 0%, #FFFFFF 100%);
        border-radius: 40px;
        padding: 60px 40px;
        margin-bottom: 40px;
        position: relative;
        overflow: hidden;
    }
    
    .community-hero::after {
        content: 'COMMUNITY';
        position: absolute;
        right: -20px;
        bottom: -20px;
        font-size: 120px;
        font-weight: 900;
        color: rgba(138, 99, 255, 0.05); /* 보라색 투명도 */
        letter-spacing: -2px;
    }

    .community-icon-box {
        width: 100px;
        height: 100px;
        background: #FFFFFF;
        border-radius: 30px;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 10px 30px rgba(138, 99, 255, 0.15);
        margin-bottom: 30px;
    }

    .empty-card {
        text-align: center;
        padding: 100px 40px;
        background: #fff;
        border: 2px dashed #EBE4FF;
        border-radius: 40px;
        transition: all 0.3s ease;
    }
    
    .empty-card:hover {
        border-color: #8A63FF;
        background: #F9F7FF;
    }

    .highlight-purple { color: #8A63FF; }
    
    .btn-community {
        background: #8A63FF;
        color: #fff;
        padding: 14px 30px;
        border-radius: 16px;
        font-weight: 700;
        border: none;
        margin-top: 30px;
        box-shadow: 0 8px 20px rgba(138, 99, 255, 0.2);
        cursor: pointer;
        transition: 0.3s;
    }
    
    .btn-community:hover {
        transform: translateY(-3px);
        box-shadow: 0 12px 25px rgba(138, 99, 255, 0.3);
    }
</style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <div id="baton-layout-container">
        <jsp:include page="/WEB-INF/views/layout/left.jsp" />

        <main id="baton-main-content">
            <section class="baton-section">
                
                <div class="community-hero">
                    <div class="community-icon-box">
                        <i class="ri-chat-smile-3-line" style="font-size: 48px; color: #8A63FF;"></i>
                    </div>
                    <h2 class="main-display-title" style="margin-bottom: 15px;">
                        우리 동네 이웃들의<br><span class="highlight-purple">따뜻한 이야기</span>
                    </h2>
                    <p class="main-display-subtitle" style="margin: 0; opacity: 0.8;">궁금한 건 묻고, 즐거운 일상은 나누어 보세요.</p>
                </div>
                
                <div class="empty-card">
                    <i class="ri-quill-pen-line" style="font-size: 60px; color: #8A63FF; opacity: 0.5;"></i>
                    <h3 style="font-size: 24px; font-weight: 800; margin-top: 25px; color: #191F28;">커뮤니티 공간을 꾸미고 있어요</h3>
                    <p style="font-size: 17px; color: #8B95A1; margin-top: 15px; line-height: 1.6;">
                        지금 헤더 메뉴와 바톤 로고를 확인해보세요!<br>
                        커뮤니티만의 <strong class="highlight-purple">힙한 보라색</strong> 컬러가 적용되었습니다. 💜
                    </p>
                    <button class="btn-community" onclick="location.href='${pageContext.request.contextPath}/'">홈으로 돌아가기</button>
                </div>
                
            </section>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/dist/js/main.js"></script>
</body>
</html>