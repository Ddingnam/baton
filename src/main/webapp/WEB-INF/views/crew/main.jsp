<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Baton | 우리 동네 모임</title>
    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/crew/layout.css">
</head>
<body>

<header id="global-header">
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />
</header>

<div id="app" v-cloak>

	<router-view name="hero"></router-view>

    <div class="crew-layout-wrapper">
	    <jsp:include page="/WEB-INF/views/crew/sidebar.jsp" />
		
	    <main class="crew-main-container">
	        <div class="router-view-wrapper">
	            <div class="content-safe-area">
	                <router-view></router-view>
	            </div>
	        </div>
	    </main>
    </div>
    
    <aside class="right-chat-panel" :class="{ 'chat-closed': !isChatOpen }">
        <crew-chat-component
			:is-open="isChatOpen"
			@close-chat="isChatOpen = false"
			:current-user-idx="${sessionScope.member.userIdx}">
		</crew-chat-component>
    </aside>

    <footer id="global-footer">
        <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
    </footer>
    
</div>

<jsp:include page="/WEB-INF/views/crew/components/crewHero.jsp" />
<jsp:include page="/WEB-INF/views/crew/components/crewList.jsp" />
<jsp:include page="/WEB-INF/views/crew/components/crewDetailMain.jsp" />
<jsp:include page="/WEB-INF/views/crew/components/crewDetailDashboard.jsp" />
<jsp:include page="/WEB-INF/views/crew/components/crewDetailBoard.jsp" />
<jsp:include page="/WEB-INF/views/crew/components/crewDetailSchedule.jsp" />
<jsp:include page="/WEB-INF/views/crew/components/crewDetailAdmin.jsp" />
<jsp:include page="/WEB-INF/views/crew/components/crewChat.jsp" />
<jsp:include page="/WEB-INF/views/crew/components/crewForm.jsp" />

<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
<script src="https://unpkg.com/vue-router@4/dist/vue-router.global.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/crew/crew_form.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/crew/crew_detail_dashboard.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/crew/crew_detail_board.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/crew/crew_detail_schedule.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/crew/crew_detail_admin.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/crew/crew_detail_main.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/crew/crew_hero.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/crew/crew_list.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/crew/crew_chat.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/crew/crew_app.js"></script>
</body>
</html>