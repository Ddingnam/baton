<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BATON | 사람을 잇다</title>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/main.css">
</head>
<body>

    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <div id="baton-layout-container">
        
        <jsp:include page="/WEB-INF/views/layout/left.jsp" />

        <main id="baton-main-content">
            <section class="hero-section reveal">
                <div class="hero-text">
                    <h1>중고거래를 넘어<br>사람과 사람을 <span class="text-point">연결하다.</span></h1>
                    <p>지금 내 주변의 따뜻한 바통 터치를 확인해보세요.</p>
                </div>
                <div class="search-bar reveal">
                    <i class="ri-search-2-line"></i>
                    <input type="text" placeholder="어떤 연결을 찾고 계신가요?">
                    <button type="button">검색</button>
                </div>
            </section>

            <section class="content-section">
                <div class="section-header reveal">
                    <h2>🔥 실시간 인기 바통</h2>
                </div>
                <div class="item-grid">
                    <article class="item-card reveal">
                        <div class="card-thumb" style="background:#333;"></div>
                        <div class="card-desc">
                            <h3 class="title">독거미 키보드 AULA 풀박스</h3>
                            <p class="price">45,000원</p>
                        </div>
                    </article>
                    <article class="item-card reveal">
                        <div class="card-thumb" style="background:#333;"></div>
                        <div class="card-desc">
                            <h3 class="title">아이폰 15 프로 256GB</h3>
                            <p class="price">1,150,000원</p>
                        </div>
                    </article>
                    <article class="item-card reveal">
                        <div class="card-thumb" style="background:#333;"></div>
                        <div class="card-desc">
                            <h3 class="title">스프링부트 전공서적</h3>
                            <p class="price">15,000원</p>
                        </div>
                    </article>
                </div>
            </section>
        </main>
    </div>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>