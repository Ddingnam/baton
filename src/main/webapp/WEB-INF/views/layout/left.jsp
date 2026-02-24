<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BATON | Left</title>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/left.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

    <aside id="baton-left">
        <div class="sidebar-menu">
            <p class="menu-label">카테고리</p>
            <ul id="left-menu-list">
                <li class="active"><a href="/main"><i class="ri-home-smile-2-line"></i> 홈</a></li>
                <li><a href="/market/list"><i class="ri-shopping-bag-3-line"></i> 중고거래</a></li>
                <li><a href="/club/list"><i class="ri-group-line"></i> 동네모임</a></li>
                <li><a href="/job/list"><i class="ri-briefcase-4-line"></i> 알바·구인</a></li>
            </ul>
        </div>
    </aside>

    <script src="${pageContext.request.contextPath}/dist/js/left.js"></script>
</body>
</html>