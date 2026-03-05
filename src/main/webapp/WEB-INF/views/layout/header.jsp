<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/layout/header.css">

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
				<li><a href="${pageContext.request.contextPath}/trade/list" class="nav-link" data-domain="trade">중고거래</a></li>
				<li><a href="${pageContext.request.contextPath}/crew/list" class="nav-link" data-domain="crew">동네모임</a></li>
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
                                <span class="user-name"><sec:authentication property="principal.member.userId" />님</span>
                                <i class="ri-arrow-down-s-line dropdown-arrow"></i>
                            </button>
                            
                            <div class="profile-dropdown-menu" id="profileDropdownMenu">
                                <div class="dropdown-header">
                                    <div class="dh-thumb"><i class="ri-user-smile-fill"></i></div>
                                    <div class="dh-info">
                                        <strong><sec:authentication property="principal.member.userId" /></strong>
                                        <span>환영합니다!</span>
                                    </div>
                                </div>
                                <div class="dropdown-divider"></div>
                                <a href="${pageContext.request.contextPath}/mypage" class="dropdown-item mypage-link">
                                    <i class="ri-user-line"></i> 마이페이지
                                </a>
                                <a href="${pageContext.request.contextPath}/wish/list" class="dropdown-item">
                                    <i class="ri-heart-3-line"></i> 찜 목록
                                </a>
                                <a href="${pageContext.request.contextPath}/chat/list" class="dropdown-item">
                                    <i class="ri-chat-1-line"></i> 채팅 및 알림 <span class="badge-dot-inline" style="display: none;"></span>
                                </a>
                                
                                <div class="dropdown-divider"></div>
                                <a href="${pageContext.request.contextPath}/member/logout" class="dropdown-item text-danger">
                                    <i class="ri-logout-box-r-line"></i> 로그아웃
                                </a>
                            </div>
                        </div>
                        
                        <sec:authorize access="hasAnyRole('ADMIN')">
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

<c:if test="${!hideChatbot}">
	<div id="baton-chatbot-trigger">
		<div class="chatbot-icon-wrapper">
			<i class="ri-chat-smile-3-fill"></i> <span class="notification-dot" style="display: none;"></span>
		</div>
	</div>
</c:if>

<script>
	window.SERVER_MSG = "${msg != null ? msg : ''}";
    window.SERVER_MESSAGE = "${message != null ? message : ''}";
</script>

<c:if test="${not empty msg}">
	<c:remove var="msg" scope="session" />
</c:if>
<c:if test="${not empty message}">
	<c:remove var="message" scope="session" />
</c:if>

<sec:authorize access="isAuthenticated()">
<sec:authentication property="principal.member.userIdx" var="loggedInUserId" />

<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        checkUnreadAlarms();
        connectGlobalAlarm();
        window.addEventListener('focus', checkUnreadAlarms);
    });

    function checkUnreadAlarms() {
        let url = '${pageContext.request.contextPath}/chat/api/unread?_=' + new Date().getTime();
        fetch(url, { cache: 'no-store' })
            .then(response => response.text())
            .then(count => {
                
                if(parseInt(count) > 0) {
                    turnOnAlarmDots();
                } else {
                    turnOffAlarmDots(); 
                }
            })
            .catch(error => console.error('채팅 알림 조회 실패:', error));
    }

    function connectGlobalAlarm() {
        let socket = new SockJS('${pageContext.request.contextPath}/ws/chat');
        let stompClient = Stomp.over(socket);
        stompClient.debug = null; 

        stompClient.connect({}, function (frame) {
            stompClient.subscribe('/topic/alarms/${loggedInUserId}', function (message) {
                if(message.body.includes('new_chat')) {
                    turnOnAlarmDots(); 
                } else if(message.body.includes('read_chat')) {
                    checkUnreadAlarms();
                }
            });
        });
    }

    function turnOnAlarmDots() {
        let dot1 = document.querySelector('.badge-dot-inline');
        let dot2 = document.querySelector('.notification-dot');
        if(dot1) dot1.style.display = 'inline-block';
        if(dot2) dot2.style.display = 'inline-block';
    }

    function turnOffAlarmDots() {
        let dot1 = document.querySelector('.badge-dot-inline');
        let dot2 = document.querySelector('.notification-dot');
        if(dot1) dot1.style.display = 'none';
        if(dot2) dot2.style.display = 'none';
    }
</script>
</sec:authorize>

<script src="${pageContext.request.contextPath}/dist/js/layout/header.js"></script>