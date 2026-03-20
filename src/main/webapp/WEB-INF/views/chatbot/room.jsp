<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>바톤 AI 가이드</title>
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/chat/chatbot.css">
</head>
<body>
    <div class="chat-container">
        <div class="chat-header">
            <div class="header-left" onclick="history.back()"><i class="ri-arrow-left-s-line"></i></div>
            <div class="header-center">바톤 AI 가이드</div>
            <div class="header-right"></div>
        </div>
        
        <div class="trade-banner">
            <div class="ai-badge"><i class="ri-customer-service-2-fill"></i></div>
            <div class="trade-info">
                <span class="trade-title">무엇이든 물어보세요!</span>
                <span class="trade-desc">안전거래, 정산, 금지품목 안내 전문 챗봇입니다.</span>
            </div>
        </div>

        <div class="chat-messages" id="chatArea">
            <div class="msg-row msg-other">
                <div class="ai-profile-circle"><i class="ri-robot-line"></i></div>
                <div>
                    <div class="nickname">바톤 가이드</div>
                    <div class="msg-bubble">안녕하세요! 😊<br>바톤 이용에 대해 궁금하신 점이 있다면 말씀해 주세요.</div>
                </div>
            </div>
        </div>

        <div id="typingArea">
            <div class="dots">
                <div class="dot"></div><div class="dot"></div><div class="dot"></div>
            </div>
        </div>

        <div class="chat-input-box">
            <textarea id="chatInput" placeholder="메시지를 입력하세요..." onkeydown="handleEnter(event)"></textarea>
            <button onclick="sendMessage()"><i class="ri-send-plane-fill"></i></button>
        </div>
    </div>

<script type="text/javascript">
    const ContextPath = "${pageContext.request.contextPath}";
</script>

<script src="${pageContext.request.contextPath}/dist/js/chat/chatbot.js"></script>
</body>
</html>