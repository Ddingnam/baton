<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>BATON | 우리 동네 연결 플랫폼</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/main.css">
</head>
<body>

    <div id="baton-intro">
        <h1 class="intro-logo">BATON</h1>
    </div>

    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <div id="baton-layout-container">
        <jsp:include page="/WEB-INF/views/layout/left.jsp" />

        <main id="baton-main-content">
            
            <section class="toss-section hero-section reveal">
                <h2 class="toss-title">우리가 기다렸던<br>새로운 동네 라이프</h2>
                <p class="toss-subtitle">중고거래부터 동네모임, 구인구직까지.<br>바통 하나로 모든 연결이 시작됩니다.</p>
                
                <div class="hero-search-box">
                    <i class="ri-search-line"></i>
                    <input type="text" placeholder="우리 동네에서 무엇을 찾으시나요?">
                </div>
            </section>

            <section class="toss-section category-section reveal">
                <h3 class="toss-section-title">필요한 모든 것,<br>바통에 다 있어요.</h3>
                <div class="toss-category-grid">
                    <div class="toss-chip">📱 디지털/가전</div>
                    <div class="toss-chip">👗 의류/패션</div>
                    <div class="toss-chip">🏠 가구/인테리어</div>
                    <div class="toss-chip">📚 도서/티켓</div>
                    <div class="toss-chip">🚴 스포츠/레저</div>
                    <div class="toss-chip">🐶 반려동물 용품</div>
                    <div class="toss-chip">💼 동네 알바</div>
                    <div class="toss-chip">🤝 취미 모임</div>
                </div>
            </section>

            <section class="toss-section product-section reveal">
                <div class="toss-flex-header">
                    <h3 class="toss-section-title small">지금 이웃들이<br>주목하는 바통</h3>
                    <a href="#" class="toss-link">전체보기</a>
                </div>
                
                <div class="toss-card-grid">
                    <c:forEach var="i" begin="1" end="4">
                        <div class="toss-card">
                            <div class="card-img"></div>
                            <div class="card-info">
                                <h4>아이폰 15 Pro 256GB 블랙 티타늄</h4>
                                <div class="price">1,100,000원</div>
                                <div class="meta">강남구 · 10분 전</div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </section>

            <section class="toss-section community-section reveal">
                <div class="toss-flex-header">
                    <h3 class="toss-section-title small">동네 이웃들의<br>생생한 이야기</h3>
                </div>
                
                <div class="toss-list-container">
                    <div class="toss-list-item">
                        <div class="text-area">
                            <span class="badge blue">동네모임</span>
                            <h4>이번 주말 한강 러닝 뛸 크루 모집합니다! (현재 4/10명)</h4>
                            <p>러닝초보환영 · 댓글 12</p>
                        </div>
                        <div class="icon-area"><i class="ri-run-line"></i></div>
                    </div>
                    <div class="toss-list-item">
                        <div class="text-area">
                            <span class="badge gray">동네질문</span>
                            <h4>역삼역 근처에 조용하고 일하기 좋은 카페 있을까요?</h4>
                            <p>카페탐험가 · 댓글 8</p>
                        </div>
                        <div class="icon-area"><i class="ri-cup-line"></i></div>
                    </div>
                    <div class="toss-list-item">
                        <div class="text-area">
                            <span class="badge purple">구인공고</span>
                            <h4>(급구) 프론트엔드 개발자 단기 프로젝트 모십니다.</h4>
                            <p>스타트업A · 지원 3</p>
                        </div>
                        <div class="icon-area"><i class="ri-macbook-line"></i></div>
                    </div>
                </div>
            </section>

        </main>
    </div>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>