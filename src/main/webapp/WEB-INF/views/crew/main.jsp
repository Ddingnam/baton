<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Baton | 우리 동네 모임</title>
    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/crew/layout.css">
</head>
<body>

<header id="global-header">
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />
</header>

<div id="app" v-cloak>
    
    <jsp:include page="/WEB-INF/views/crew/sidebar.jsp" />

    <aside class="right-chat-panel" :class="{ 'chat-closed': !isChatOpen }">
        <crew-chat-component></crew-chat-component>
    </aside>

    <main class="crew-main-container">
        <div class="router-view-wrapper">
            <div class="content-safe-area">
                <router-view></router-view>
            </div>
        </div>
    </main>

    <footer id="global-footer">
        <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
    </footer>
    

</div>

<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
<script src="https://unpkg.com/vue-router@4/dist/vue-router.global.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/crew/crew_app.js"></script>
</body>
</html>