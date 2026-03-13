<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>BATON 관리자 로그인</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@500;700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_login.css">
</head>
<body>

<div class="auth-layout">
    <div class="auth-box">
        <div class="auth-brand">
            BATON<span class="dot">.</span>
        </div>
        
        <div class="auth-header">
            <h1>관리자 로그인</h1>
            <p>서비스 관리를 위해 로그인해 주세요.</p>
        </div>
        
        <form class="auth-form" action="${pageContext.request.contextPath}/member/login" method="post">
            <div class="input-wrap">
                <i class="ri-user-3-fill icon"></i>
                <input type="text" name="login_id" placeholder="아이디" required autocomplete="off">
            </div>
            
            <div class="input-wrap">
                <i class="ri-lock-password-fill icon"></i>
                <input type="password" name="password" placeholder="비밀번호" required>
            </div>
            
            <div class="auth-tools">
                <label class="remember-me">
                    <div class="mac-switch">
                        <input type="checkbox" name="remember">
                        <span class="mac-slider"></span>
                    </div>
                    <span class="rem-text">아이디 저장</span>
                </label>
            </div>
            
            <button type="submit" class="btn-submit">로그인</button>
            
            <c:if test="${not empty message}">
                <div class="error-msg">${message}</div>
            </c:if>
            <c:if test="${param.error != null}">
                <div class="error-msg">아이디 또는 비밀번호가 일치하지 않습니다.</div>
            </c:if>
        </form>
        
        <div class="auth-foot">
            <a href="${pageContext.request.contextPath}/"><i class="ri-arrow-left-line"></i> 메인 홈페이지로 돌아가기</a>
        </div>
    </div>
</div>

</body>
</html>