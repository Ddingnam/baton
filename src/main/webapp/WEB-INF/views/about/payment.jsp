<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>안심결제 가이드 | BATON</title>
    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
    <link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/about/service_intro.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<main class="service-wrapper">
    
    <section class="sec-hero">
        <div class="hero-bg-glow"></div> 
        <div class="hero-inner">
            <div class="hero-badge" data-aos="fade-down" data-aos-delay="100">
                <i class="ri-shield-check-fill"></i> 100% 사기 방지 안심결제
            </div>
            <h1 class="hero-title" data-aos="fade-up" data-aos-delay="200">
                이웃과의 거래,<br>
                <span class="accent">끝까지 안전하게</span>
            </h1>
            <p class="hero-desc" data-aos="fade-up" data-aos-delay="300">
                바톤 포인트 시스템으로 결제 대금을 안전하게 보호하세요.<br>
                구매확정 전까지 판매자에게 돈이 전달되지 않습니다. 
            </p>
            <div class="hero-chips" data-aos="fade-up" data-aos-delay="400">
                <span class="chip chip-trade"><i class="ri-kakao-talk-fill"></i>카카오페이 충전</span>
                <span class="chip chip-home"><i class="ri-lock-line"></i>에스크로 보관</span>
                <span class="chip chip-alba"><i class="ri-history-line"></i>72시간 환불</span>
                <span class="chip chip-comm"><i class="ri-hand-coin-line"></i>즉시 정산</span>
            </div>
        </div>
    </section>

    <section class="sec-services" id="process">
        <div class="frame">
            <div class="section-header" data-aos="fade-up">
                <div class="section-label">SAFE PROCESS</div>
                <h2 class="section-title">이렇게 진행돼요</h2>
                <p class="section-desc">바톤이 중간에서 꼼꼼하게 확인하고 전달해드려요. </p>
            </div>

            <div class="services-grid">
                <div class="svc-card trade" data-aos="fade-up" data-aos-delay="100">
                    <div class="svc-icon"><i class="ri-bank-card-line"></i></div>
                    <div class="svc-name">01. 포인트 충전</div>
                    <div class="svc-desc">카카오페이로 포인트를 충전합니다. 결제 시 2%의 수수료가 포함되어 충전돼요.</div>
                    <div class="svc-tags">
                        <span class="svc-tag">카카오페이</span>
                        <span class="svc-tag">수수료 2%</span>
                    </div>
                </div>

                <div class="svc-card home" data-aos="fade-up" data-aos-delay="200">
                    <div class="svc-icon"><i class="ri-safe-2-line"></i></div>
                    <div class="svc-name">02. 안전 보관</div>
                    <div class="svc-desc">구매자가 물건값을 결제하면, 해당 포인트는 바톤 시스템에 안전하게 묶이게 됩니다.</div>
                    <div class="svc-tags">
                        <span class="svc-tag">사기 예방</span>
                        <span class="svc-tag">안전 보관</span>
                    </div>
                </div>

                <div class="svc-card alba" data-aos="fade-up" data-aos-delay="300">
                    <div class="svc-icon"><i class="ri-checkbox-circle-line"></i></div>
                    <div class="svc-name">03. 구매 확정</div>
                    <div class="svc-desc">물건을 받고 이상이 없다면 '구매확정'을 눌러주세요. 판매자에게 포인트가 전송됩니다.</div>
                    <div class="svc-tags">
                        <span class="svc-tag">물건 확인 후</span>
                        <span class="svc-tag">최종 승인</span>
                    </div>
                </div>

                <div class="svc-card comm" data-aos="fade-up" data-aos-delay="400">
                    <div class="svc-icon"><i class="ri-wallet-3-line"></i></div>
                    <div class="svc-name">04. 판매 정산</div>
                    <div class="svc-desc">거래가 완료되면 판매자의 '바톤 포인트'로 즉시 합산되어 언제든 출금 가능합니다.</div>
                    <div class="svc-tags">
                        <span class="svc-tag">즉시 합산</span>
                        <span class="svc-tag">수익 관리</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="sec-highlight">
        <div class="frame">
            <div class="highlight-row">
                <div class="hl-content" data-aos="fade-right">
                    <span class="hl-badge alba-badge">환불 정책</span>
                    <h3 class="hl-title">사용하지 않았다면<br>언제든 환불 가능</h3>
                    <p class="hl-desc">포인트를 충전하고 72시간 내에 거래에 사용하지 않았다면, 결제 취소 및 환불을 신청할 수 있어요. </p>
                    <div class="hl-features">
                        <div class="hl-feat"><i class="ri-check-line alba-icon"></i> 72시간 내 미사용 포인트 환불</div>
                        <div class="hl-feat"><i class="ri-check-line alba-icon"></i> 카카오페이 결제 취소 연동</div>
                    </div>
                </div>
                <div class="hl-visual alba-v" data-aos="zoom-in-left">
                    <div class="hl-visual-inner parallax-layer">
                        <div class="hl-main-icon pulse-anim"><i class="ri-refresh-line"></i></div>
                        <div class="hl-mini-cards float-anim">
                            <div class="hl-mini">⏳ 72시간 남음</div>
                            <div class="hl-mini">↩️ 환불 신청</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="highlight-row reverse">
                <div class="hl-content" data-aos="fade-left">
                    <span class="hl-badge trade-badge">정산 안내</span>
                    <h3 class="hl-title">거래 완료 즉시<br>포인트가 쏙!</h3>
                    <p class="hl-desc">택배 수령 후 구매자가 확정 버튼을 누르면, 바톤이 보관하던 금액이 판매자 포인트로 즉시 전환됩니다. </p>
                    <div class="hl-features">
                        <div class="hl-feat"><i class="ri-check-line trade-icon"></i> 판매자 포인트 즉시 합산</div>
                        <div class="hl-feat"><i class="ri-check-line trade-icon"></i> 현금처럼 사용 가능한 포인트</div>
                    </div>
                </div>
                <div class="hl-visual trade-v" data-aos="zoom-in-right">
                    <div class="hl-visual-inner parallax-layer">
                        <div class="hl-main-icon pulse-anim"><i class="ri-coins-line"></i></div>
                        <div class="hl-mini-cards float-anim-delayed">
                            <div class="hl-mini">✅ 거래 완료</div>
                            <div class="hl-mini">💰 포인트 입금</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="sec-cta" id="cta">
        <div class="cta-inner" data-aos="zoom-in">
            <h2 class="cta-title">지금 바로 <span class="gradient-text">충전</span>해보세요</h2>
            <p class="cta-desc">안전한 이웃 거래의 시작, 바톤 포인트와 함께하세요.</p>
            <div class="cta-btns">
                <button class="btn-primary" onclick="location.href='${pageContext.request.contextPath}/'">
                    포인트 충전하기
                </button>
                <button class="btn-secondary" onclick="location.href='${pageContext.request.contextPath}/trade/main#/'">
                    상품 둘러보기
                </button>
            </div>
        </div>
    </section>

</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script src="${pageContext.request.contextPath}/dist/js/about/service_intro.js"></script>
</body>
</html>