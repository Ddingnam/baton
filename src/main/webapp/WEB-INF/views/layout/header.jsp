<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/layout/header.css">
<link rel="stylesheet" href="${ContextPath}/dist/css/chat/chatbotSlide.css">

<header id="baton-header">
	<div class="header-container">
		<div class="header-left">
			<a href="${pageContext.request.contextPath}/" class="baton-logo-link">
				<span class="logo-symbol"> 
                    <span class="symbol-dot"></span> 
                    <span class="symbol-bar"></span> 
                    <span class="symbol-dot"></span>
			    </span> 
                <span class="logo-text">Baton</span>
			</a>
		</div>

		<nav class="header-center">
			<ul class="nav-menu">
				<li><a href="${pageContext.request.contextPath}/" class="nav-link" data-domain="home">홈</a></li>
				<li><a href="${pageContext.request.contextPath}/trade/main" class="nav-link" data-domain="trade">중고거래</a></li>
				<li><a href="${pageContext.request.contextPath}/crew/main" class="nav-link" data-domain="crew">동네모임</a></li>
				<li><a href="${pageContext.request.contextPath}/alba/list" class="nav-link" data-domain="alba">알바구인</a></li>
				<li><a href="${pageContext.request.contextPath}/community/list" class="nav-link" data-domain="community">커뮤니티</a></li>
			</ul>
		</nav>

		<div class="header-right">
			<div class="auth-group">
				<sec:authorize access="isAnonymous()">
					<a href="${pageContext.request.contextPath}/member/login" class="login-btn">로그인</a>
					<a href="${pageContext.request.contextPath}/member/join" class="join-btn">시작하기</a>
				</sec:authorize>
				
                <sec:authorize access="isAuthenticated()">
					<div class="user-action-group">
                        <div class="profile-dropdown-wrapper" id="profileDropdownWrapper">

                            
                            <button type="button" class="action-profile" id="profileDropdownBtn">
                                <div class="profile-thumb">
                                    <i class="ri-user-smile-fill"></i>
                                </div>
                                <span class="user-name"><sec:authentication property="principal.member.nickname" />님</span>
                                <i class="ri-arrow-down-s-line dropdown-arrow"></i>
                            </button>

                            <div class="profile-dropdown-menu" id="profileDropdownMenu">
                                
                                <div class="dropdown-header">
                                    <div class="dh-thumb"><i class="ri-user-smile-fill"></i></div>
                                    <div class="dh-info">
                                        <strong><sec:authentication property="principal.member.nickname" /></strong>
                                        <span>환영합니다!</span>
                                    </div>
                                </div>

                                
                                <div class="dropdown-divider"></div>
                                <div class="dropdown-region-title">
                                    <i class="ri-map-pin-2-fill"></i> 내 동네
                                </div>
                                <c:choose>
                                    <c:when test="${not empty sessionScope.member.userRegionInfo
                                                    && (not empty sessionScope.member.userRegionInfo.mainRegion
                                                        || not empty sessionScope.member.userRegionInfo.subRegion)}">
                                        <div class="region-tab-list">
                                            <c:if test="${not empty sessionScope.member.userRegionInfo.mainRegion}">
                                                <button type="button"
                                                        class="region-tab-item ${sessionScope.member.userRegionInfo.activeType == 1 ? 'active' : ''}"
                                                        onclick="switchRegion(1)">
                                                    <span class="region-tab-name">${sessionScope.member.userRegionInfo.mainRegion.dong}</span>
                                                </button>
                                            </c:if>
                                            <c:if test="${not empty sessionScope.member.userRegionInfo.subRegion}">
                                                <button type="button"
                                                        class="region-tab-item ${sessionScope.member.userRegionInfo.activeType == 2 ? 'active' : ''}"
                                                        onclick="switchRegion(2)">
                                                    <span class="region-tab-name">${sessionScope.member.userRegionInfo.subRegion.dong}</span>
                                                </button>
                                            </c:if>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div style="padding: 8px 20px 10px; font-size: 13px; color: #8B95A1;">인증된 동네가 없어요</div>
                                    </c:otherwise>
                                </c:choose>
                                <a href="${pageContext.request.contextPath}/member/townAuth" class="dropdown-item">
                                    <i class="ri-map-pin-add-line"></i> 동네 설정
                                </a>

                                
                                <div class="dropdown-divider"></div>
                                <a href="${pageContext.request.contextPath}/mypage" class="dropdown-item mypage-link">
                                    <i class="ri-user-line"></i> 마이페이지
                                </a>
                                <a href="${pageContext.request.contextPath}/wish/list" class="dropdown-item">
                                    <i class="ri-heart-3-line"></i> 찜 목록
                                </a>
                                <a href="javascript:void(0);" onclick="window.open('${pageContext.request.contextPath}/chat/list?mode=popup', 'BatonChatPopup', 'width=450,height=650,left='+(window.screen.width/2-225)+',top='+(window.screen.height/2-325)+',resizable=no,scrollbars=no');" class="dropdown-item"><i class="ri-chat-1-line">
                                	</i> 채팅 및 알림 <span class="badge-dot-inline" style="display: none;"></span></a>
                                <div class="dropdown-divider"></div>
                                <a href="${pageContext.request.contextPath}/member/logout" class="dropdown-item text-danger">
                                    <i class="ri-logout-box-r-line"></i> 로그아웃
                                </a>
                            </div>
                        </div>

                        <sec:authorize access="hasAnyRole('ADMIN', 'EMP')">
                            <a href="${pageContext.request.contextPath}/admin" class="action-icon admin-icon" title="관리자 페이지">
                                <i class="ri-settings-3-line"></i>
                            </a>
                        </sec:authorize>
					</div>
				</sec:authorize>
			</div>
		</div>
	</div>
	
</header>

<div id="baton-toast-container" class="baton-toast-container"></div>

<c:set var="currentUri" value="${requestScope['jakarta.servlet.forward.request_uri']}" />
<c:if test="${fn:contains(currentUri, '/crew')}">
    <div id="crew-chat-trigger" title="크루 채팅 열기/닫기">
        <div class="chat-icon-wrapper">
            <i class="ri-team-fill"></i>
            <span class="crew-notification-dot" style="display: none;"></span>
        </div>
    </div>
</c:if>

<c:if test="${!hideChatbot}">
	<div id="baton-chatbot-trigger">
		<div class="chatbot-icon-wrapper">
			<i class="ri-chat-smile-3-fill"></i> <span class="notification-dot" style="display: none;"></span>
		</div>
	</div>
	<jsp:include page="${ContextPath}/WEB-INF/views/chatbot/slidePanel.jsp"/>
</c:if>

<div id="batonAuthLayer" class="bt-overlay" style="display: none;">
    <article class="bt-modal-sheet">
        <header class="bt-modal-visual">
            <div class="bt-visual-track">
                <div class="bt-alert-circle">
                    <i class="ri-map-pin-add-line"></i>
                </div>
            </div>
        </header>
        
        <section class="bt-modal-body">
            <h2 class="bt-text-title"><span class="bt-highlight">바통 터치</span> 준비,<br>아직 한 단계가 남았어요!</h2>
            <p class="bt-text-desc">
                지금 계신 곳을 인증해야 우리 동네 이웃들과<br>
                따뜻한 바통을 이어받을 수 있어요.
            </p>
        </section>

        <footer class="bt-modal-footer">
            <button type="button" class="bt-btn bt-btn-primary" onclick="location.href='${pageContext.request.contextPath}/member/regionAuth/main'">
                지금 바로 인증하기
            </button>
            <button type="button" class="bt-btn bt-btn-ghost" onclick="closeBatonAuthLayer()">
                나중에 할게요
            </button>
        </footer>
    </article>
</div>
<div id="adminTransitionOverlay" class="admin-transition-overlay">
    <div class="admin-loader-box">
        <div class="admin-loader-spinner"></div>
        <div class="admin-loader-text">BATON<span class="dot">.</span> ADMIN</div>
        <p>관리자 환경으로 이동하고 있습니다</p>
    </div>
</div>
<script>
	window.SERVER_MSG = "${msg != null ? msg : ''}";
    window.SERVER_MESSAGE = "${message != null ? message : ''}";
	window.IS_FIRST_LOGIN = ${not empty isFirstLogin ? isFirstLogin : false};
	window.HAS_MAIN_REGION = ${not empty member.userRegionInfo.mainRegion ? true : false};
</script>

<c:if test="${not empty msg}">
	<c:remove var="msg" scope="session" />
</c:if>
<c:if test="${not empty message}">
	<c:remove var="message" scope="session" />
</c:if>
<c:if test="${not empty isFirstLogin}">
	<c:remove var="isFirstLogin" scope="session" />
</c:if>

<sec:authorize access="isAuthenticated()">
<sec:authentication property="principal.member.userIdx" var="loggedInUserId" />

<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<script>
    window.LOGGED_IN_USER_ID = "${loggedInUserId}";
</script>
</sec:authorize>

<script src="${pageContext.request.contextPath}/dist/js/layout/header.js"></script>
<script src="${ContextPath}/dist/js/chat/chatbotSlide.js"></script>