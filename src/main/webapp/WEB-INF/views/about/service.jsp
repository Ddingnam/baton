<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>서비스 소개 | BATON</title>
    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
    <link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/about/service_intro.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<main class="service-wrapper">
    
    <section class="sec-hero">
        <div class="hero-bg-glow"></div> <div class="hero-inner">
            <div class="hero-badge" data-aos="fade-down" data-aos-delay="100">
                <i class="ri-map-pin-2-fill"></i> 우리 동네 라이프 플랫폼
            </div>
            <h1 class="hero-title" data-aos="fade-up" data-aos-delay="200">
                이웃과 함께하는<br>
                <span class="accent">모든 동네 생활</span>
            </h1>
            <p class="hero-desc" data-aos="fade-up" data-aos-delay="300">
                중고거래부터 동네모임, 알바구인, 커뮤니티까지.<br>
                바톤이 이웃 간의 연결을 더 가깝게 만들어드려요.
            </p>
            <div class="hero-chips" data-aos="fade-up" data-aos-delay="400">
                <span class="chip chip-trade"><i class="ri-store-2-line"></i>중고거래</span>
                <span class="chip chip-crew"><i class="ri-team-line"></i>동네모임</span>
                <span class="chip chip-alba"><i class="ri-briefcase-line"></i>알바구인</span>
                <span class="chip chip-comm"><i class="ri-discuss-line"></i>커뮤니티</span>
            </div>
            <div class="hero-scroll" data-aos="fade-in" data-aos-delay="600">
                <div class="scroll-line"></div>
                <span>SCROLL</span>
            </div>
        </div>
    </section>

    <section class="sec-services" id="services">
        <div class="frame">
            <div class="section-header" data-aos="fade-up">
                <div class="section-label">OUR SERVICES</div>
                <h2 class="section-title">필요한 모든 것이<br>동네에 있어요</h2>
                <p class="section-desc">바톤의 4가지 핵심 서비스로 더 풍요로운 동네 생활을 경험하세요.</p>
            </div>

            <div class="services-grid">
                <div class="svc-card trade" data-aos="fade-up" data-aos-delay="100" onclick="location.href='${pageContext.request.contextPath}/trade/list'">
                    <div class="card-glow"></div>
                    <div class="svc-icon"><i class="ri-store-2-line"></i></div>
                    <div class="svc-name">중고거래</div>
                    <div class="svc-desc">AI가 사진을 분석해 상품 정보를 자동으로 입력해드려요. 안전결제 시스템으로 믿을 수 있는 거래를 경험하세요.</div>
                    <div class="svc-tags">
                        <span class="svc-tag">AI 상품 분석</span>
                        <span class="svc-tag">안전결제</span>
                    </div>
                    <div class="svc-arrow"><i class="ri-arrow-right-up-line"></i></div>
                </div>

                <div class="svc-card crew" data-aos="fade-up" data-aos-delay="200" onclick="location.href='${pageContext.request.contextPath}/crew/list'">
                    <div class="card-glow"></div>
                    <div class="svc-icon"><i class="ri-team-line"></i></div>
                    <div class="svc-name">동네모임</div>
                    <div class="svc-desc">관심사가 같은 이웃을 찾아 모임을 만들고, 사이트 내 채팅방에서 바로 소통할 수 있어요.</div>
                    <div class="svc-tags">
                        <span class="svc-tag">단체 채팅</span>
                        <span class="svc-tag">모임 개설</span>
                    </div>
                    <div class="svc-arrow"><i class="ri-arrow-right-up-line"></i></div>
                </div>

                <div class="svc-card alba" data-aos="fade-up" data-aos-delay="300" onclick="location.href='${pageContext.request.contextPath}/alba/list'">
                    <div class="card-glow"></div>
                    <div class="svc-icon"><i class="ri-briefcase-line"></i></div>
                    <div class="svc-name">알바구인</div>
                    <div class="svc-desc">내 근처 알바를 지역·시급·근무기간으로 필터링하세요. 다양한 일자리를 쉽고 빠르게 찾을 수 있어요.</div>
                    <div class="svc-tags">
                        <span class="svc-tag">지역 기반</span>
                        <span class="svc-tag">시급 필터</span>
                    </div>
                    <div class="svc-arrow"><i class="ri-arrow-right-up-line"></i></div>
                </div>

                <div class="svc-card comm" data-aos="fade-up" data-aos-delay="400" onclick="location.href='${pageContext.request.contextPath}/community/list'">
                    <div class="card-glow"></div>
                    <div class="svc-icon"><i class="ri-discuss-line"></i></div>
                    <div class="svc-name">커뮤니티</div>
                    <div class="svc-desc">일상, 동네소식, 맛집 정보, 질문까지. 이웃들과 다양한 이야기를 나누는 우리 동네 게시판이에요.</div>
                    <div class="svc-tags">
                        <span class="svc-tag">카테고리 분류</span>
                        <span class="svc-tag">위치 공유</span>
                    </div>
                    <div class="svc-arrow"><i class="ri-arrow-right-up-line"></i></div>
                </div>
            </div>
        </div>
    </section>

    <section class="sec-highlight" id="highlight">
        <div class="frame">
            <div class="highlight-row">
                <div class="hl-content" data-aos="fade-right">
                    <span class="hl-badge trade-badge">중고거래</span>
                    <h3 class="hl-title">사진 찍으면<br>AI가 알아서 등록</h3>
                    <p class="hl-desc">상품 사진을 업로드하면 AI가 카테고리, 예상 가격, 설명을 자동으로 채워드려요. 등록이 30초면 끝나요.</p>
                    <div class="hl-features">
                        <div class="hl-feat"><i class="ri-check-line trade-icon"></i> AI 자동 카테고리 분류</div>
                        <div class="hl-feat"><i class="ri-check-line trade-icon"></i> 바톤 안심 에스크로 결제</div>
                    </div>
                </div>
                <div class="hl-visual trade-v" data-aos="zoom-in-left">
                    <div class="hl-visual-inner parallax-layer">
                        <div class="hl-main-icon pulse-anim"><i class="ri-store-2-line"></i></div>
                        <div class="hl-mini-cards float-anim">
                            <div class="hl-mini">📸 AI 분석 중...</div>
                            <div class="hl-mini">✅ 등록 완료!</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="highlight-row reverse">
                <div class="hl-content" data-aos="fade-left">
                    <span class="hl-badge crew-badge">동네모임</span>
                    <h3 class="hl-title">모임 만들고<br>바로 채팅 시작</h3>
                    <p class="hl-desc">사이트 내에서 단체 채팅방을 개설하고 이웃들과 실시간으로 소통할 수 있어요. 모임 일정 관리도 한 곳에서 해결하세요.</p>
                    <div class="hl-features">
                        <div class="hl-feat"><i class="ri-check-line crew-icon"></i> 실시간 그룹 채팅 지원</div>
                        <div class="hl-feat"><i class="ri-check-line crew-icon"></i> 관심사 기반 이웃 추천</div>
                    </div>
                </div>
                <div class="hl-visual crew-v" data-aos="zoom-in-right">
                    <div class="hl-visual-inner parallax-layer">
                        <div class="hl-main-icon pulse-anim"><i class="ri-team-line"></i></div>
                        <div class="hl-mini-cards float-anim-delayed">
                            <div class="hl-mini">💬 실시간 채팅</div>
                            <div class="hl-mini">📅 일정 공유</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="highlight-row">
                <div class="hl-content" data-aos="fade-right">
                    <span class="hl-badge alba-badge">알바구인</span>
                    <h3 class="hl-title">내 동네에서 찾는<br>딱 맞는 알바</h3>
                    <p class="hl-desc">최소 시급, 근무 기간 등으로 필터링해서 나에게 맞는 알바를 찾아드려요. 간편하게 지원하고 관리하세요.</p>
                    <div class="hl-features">
                        <div class="hl-feat"><i class="ri-check-line alba-icon"></i> GPS 기반 동네 공고 탐색</div>
                        <div class="hl-feat"><i class="ri-check-line alba-icon"></i> 조건별 맞춤 필터링</div>
                    </div>
                </div>
                <div class="hl-visual alba-v" data-aos="zoom-in-left">
                    <div class="hl-visual-inner parallax-layer">
                        <div class="hl-main-icon pulse-anim"><i class="ri-briefcase-line"></i></div>
                        <div class="hl-mini-cards float-anim">
                            <div class="hl-mini">📍 우리 동네</div>
                            <div class="hl-mini">₩ 15,000/h</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="highlight-row reverse">
                <div class="hl-content" data-aos="fade-left">
                    <span class="hl-badge comm-badge">커뮤니티</span>
                    <h3 class="hl-title">이웃과 나누는<br>진짜 동네 이야기</h3>
                    <p class="hl-desc">일상부터 동네 소식, 맛집 추천까지. 투표 기능과 위치 공유로 이웃들과 더 풍성하게 소통해요.</p>
                    <div class="hl-features">
                        <div class="hl-feat"><i class="ri-check-line comm-icon"></i> 투표 생성 및 실시간 집계</div>
                        <div class="hl-feat"><i class="ri-check-line comm-icon"></i> 카카오맵 연동 장소 공유</div>
                    </div>
                </div>
                <div class="hl-visual comm-v" data-aos="zoom-in-right">
                    <div class="hl-visual-inner parallax-layer">
                        <div class="hl-main-icon pulse-anim"><i class="ri-discuss-line"></i></div>
                        <div class="hl-mini-cards float-anim-delayed">
                            <div class="hl-mini">🗳️ 투표하기</div>
                            <div class="hl-mini">#동네소식</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="sec-stats">
        <div class="frame">
            <div class="stats-grid">
                <div class="stat-item" data-aos="fade-up" data-aos-delay="0">
                    <div class="stat-num">4+</div>
                    <div class="stat-label">핵심 서비스</div>
                </div>
                <div class="stat-item" data-aos="fade-up" data-aos-delay="100">
                    <div class="stat-num">AI</div>
                    <div class="stat-label">상품 자동 등록</div>
                </div>
                <div class="stat-item" data-aos="fade-up" data-aos-delay="200">
                    <div class="stat-num">LIVE</div>
                    <div class="stat-label">실시간 채팅</div>
                </div>
                <div class="stat-item" data-aos="fade-up" data-aos-delay="300">
                    <div class="stat-num">안전</div>
                    <div class="stat-label">에스크로 결제</div>
                </div>
            </div>
        </div>
    </section>

    <section class="sec-cta" id="cta">
        <div class="cta-glow"></div>
        <div class="cta-inner" data-aos="zoom-in" data-aos-duration="1000">
            <h2 class="cta-title">지금 바로 <span class="gradient-text">시작</span>해보세요</h2>
            <p class="cta-desc">
                가입만 하면 모든 서비스를 무료로 이용할 수 있어요.<br>
                우리 동네와 연결되는 첫 걸음을 내딛어보세요.
            </p>
            <div class="cta-btns">
                <button class="btn-primary" onclick="location.href='${pageContext.request.contextPath}/member/join'">
                    무료로 시작하기
                </button>
                <button class="btn-secondary" onclick="location.href='${pageContext.request.contextPath}/trade/main#/'">
                    서비스 둘러보기
                </button>
            </div>
        </div>
    </section>

</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script src="${pageContext.request.contextPath}/dist/js/about/service_intro.js"></script>
</body>
</html>