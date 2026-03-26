<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/trade/trade-list.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/trade/trade-write.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/trade/trade-article.css">
    <script>const ContextPath = '${pageContext.request.contextPath}';</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<div id="trade-app" v-cloak>
    <router-view></router-view>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>

<jsp:include page="/WEB-INF/views/trade/trade_list.jsp"/>
<jsp:include page="/WEB-INF/views/trade/trade_write.jsp"/>
<jsp:include page="/WEB-INF/views/trade/trade_article.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/vue@3/dist/vue.global.prod.js"></script>
<script src="https://cdn.jsdelivr.net/npm/vue-router@4"></script>

<script src="${pageContext.request.contextPath}/dist/js/trade/list.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/trade/article.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/trade/write.js"></script>

<script src="${pageContext.request.contextPath}/dist/js/trade/trade_app.js"></script>
</body>
</html>
