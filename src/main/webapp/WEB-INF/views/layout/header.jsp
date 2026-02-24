<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/header.css">
</head>
<body>
    <header id="baton-header">
        <div class="header-container">
            <div class="header-left">
                <a href="${pageContext.request.contextPath}/" class="baton-logo-link">
                    <div class="logo-symbol">
                        <div class="symbol-dot"></div>
                        <div class="symbol-bar"></div>
                        <div class="symbol-dot"></div>
                    </div>
                    <span class="logo-text">BATON</span>
                </a>
            </div>
            
            <nav class="header-center">
                <ul class="nav-menu">
                    <li><a href="${pageContext.request.contextPath}/trade/list">중고거래</a></li>
                    <li><a href="${pageContext.request.contextPath}/club/list">동네모임</a></li>
                    <li><a href="${pageContext.request.contextPath}/alba/list">알바·구인</a></li>
                    <li><a href="${pageContext.request.contextPath}/community/list">커뮤니티</a></li>
                </ul>
            </nav>

            <div class="header-right">
                <div class="auth-group">
                    <c:choose>
                        <c:when test="${empty sessionScope.member}">
                            <a href="${pageContext.request.contextPath}/member/login" class="login-btn">로그인</a>
                            <a href="${pageContext.request.contextPath}/member/member" class="join-btn">시작하기</a>
                        </c:when>
                        <c:otherwise>
                            <span class="user-name"><strong>${sessionScope.member.userName}</strong>님</span>
                            <a href="${pageContext.request.contextPath}/member/logout" class="logout-link">로그아웃</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </header>

    <div id="baton-chatbot-trigger">
        <div class="chatbot-icon-wrapper">
            <i class="ri-chat-smile-3-fill"></i>
            <span class="notification-dot"></span>
        </div>
    </div>
</body>
</html>