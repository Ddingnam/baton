<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BATON | Header</title>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/header.css">
</head>
<body>

    <header id="baton-header">
        <div class="header-inner">
            <a href="/main" class="logo">BATON</a>
            <nav class="gnb">
                <a href="/market/list">중고거래</a>
                <a href="/club/list">동네모임</a>
                <a href="/job/list">구인공고</a>
                <a href="/community/list">커뮤니티</a>
            </nav>
            <div class="user-menu">
                <a href="/login" class="btn-login">로그인</a>
            </div>
        </div>
    </header>
    
    <script src="${pageContext.request.contextPath}/js/header.js"></script>
</body>
</html>