<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/header.css">

<header id="baton-header">
    <div class="header-container">
        <div class="header-left">
            <a href="${pageContext.request.contextPath}/" class="baton-logo-link">
                <span class="logo-symbol">
                    <span class="symbol-dot"></span>
                    <span class="symbol-bar"></span> 
                    <span class="symbol-dot"></span>
                </span>
                <span class="logo-text">BATON</span>
            </a>
        </div>

		<nav class="header-center">
			<ul class="nav-menu">
				<li><a href="${pageContext.request.contextPath}/"
					class="nav-link" data-domain="home">홈</a></li>
				<li><a href="${pageContext.request.contextPath}/trade/list"
					class="nav-link" data-domain="trade">중고거래</a></li>
				<li><a href="${pageContext.request.contextPath}/club/list"
					class="nav-link" data-domain="club">동네모임</a></li>
				<li><a href="${pageContext.request.contextPath}/alba/posting/list"
					class="nav-link" data-domain="alba">알바구인</a></li>
				<li><a href="${pageContext.request.contextPath}/community/list"
					class="nav-link" data-domain="community">커뮤니티</a></li>
			</ul>
		</nav>

		<div class="header-right">
            <div class="auth-group">
                <c:choose>
                    <c:when test="${empty sessionScope.member}">
                        <a href="${pageContext.request.contextPath}/member/login" class="login-btn">로그인</a>
                        <a href="${pageContext.request.contextPath}/member/townAuth" class="join-btn">시작하기</a>
                    </c:when>
                    <c:otherwise>
                        <div class="user-action-group">
                            <a href="${pageContext.request.contextPath}/wish/list" class="action-icon" title="찜 목록">
                                <i class="ri-heart-3-line"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/chat/list" class="action-icon" title="채팅 및 알림">
                                <i class="ri-chat-1-line"></i>
                                <span class="badge-dot"></span>
                            </a>
                            <a href="${pageContext.request.contextPath}/mypage" class="action-profile" title="마이페이지">
                                <div class="profile-thumb">
                                    <i class="ri-user-smile-fill"></i>
                                </div>
                                <span class="user-name">${sessionScope.member.userName}님</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/member/logout" class="logout-text">로그아웃</a>
                        </div>
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

<script src="${pageContext.request.contextPath}/dist/js/header.js"></script>