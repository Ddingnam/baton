<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="_csrf"        content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>중고거래 | BATON</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css" rel="stylesheet">
<jsp:include page="/WEB-INF/views/api/api.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/trade/trade-list.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/trade/trade-write.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/trade/trade-article.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/report/report-modal.css">
<script>const ContextPath = '${pageContext.request.contextPath}';</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<div id="trade-app" v-cloak>
    <jsp:include page="/WEB-INF/views/trade/trade_list.jsp"/>
    <jsp:include page="/WEB-INF/views/trade/trade_write.jsp"/>
    <jsp:include page="/WEB-INF/views/trade/trade_article.jsp"/>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/vue@3/dist/vue.global.prod.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/trade/write.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/trade/article.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/trade/list.js"></script>
</body>
</html>
