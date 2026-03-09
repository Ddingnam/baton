<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Baton | 우리 동네 연결의 시작</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css">
<link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/about/about_intro.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<div class="mouse-follower"></div>

<main id="main-web">

    <section class="sec-hero active">
        <div class="hero-bg">
            <div class="orb orb-1"></div>
            <div class="orb orb-2"></div>
        </div>
        <div class="frame centered">
            <h1 class="tit-hero">
                <div class="line-wrap"><span class="slide-up">동네의</span></div>
                <div class="line-wrap"><span class="slide-up delay-1">모든 가능성을</span></div>
                <div class="line-wrap"><span class="slide-up delay-2 txt-point">연결합니다.</span></div>
            </h1>
            <p class="desc-hero fade-in delay-3">
                중고거래, 알바, 소모임까지.<br>
                당신의 생활 반경 3km 안에서 시작되는 놀라운 변화.
            </p>
            <div class="hero-elements fade-in delay-4">
                <div class="floating-item item-1">Local Value</div>
                <div class="floating-item item-2">Trust</div>
                <div class="floating-item item-3">Warm Tech</div>
            </div>
            <div class="scroll-down fade-in delay-3">
                <span class="txt">SCROLL</span>
                <div class="bar"></div>
            </div>
        </div>
    </section>

    <section class="sec-marquee">
        <div class="track-wrapper">
            <div class="track">
                <span>HYPER-LOCAL</span><span>TRUST</span><span>SECONDHAND</span><span>PART-TIME</span><span>CREW</span><span>CONNECTION</span>
                <span>HYPER-LOCAL</span><span>TRUST</span><span>SECONDHAND</span><span>PART-TIME</span><span>CREW</span><span>CONNECTION</span>
            </div>
        </div>
    </section>

    <section class="sec-philosophy">
        <div class="philosophy-sticky">
            <div class="frame">
                <div class="ph-scroll-text">
                    <span class="ph-word" data-index="0">단순한</span>
                    <span class="ph-word" data-index="1">거래가</span>
                    <span class="ph-word" data-index="2">아닙니다.</span>
                    <br>
                    <span class="ph-word accent" data-index="3">이웃과의</span>
                    <span class="ph-word accent" data-index="4">신뢰</span>
                    <span class="ph-word" data-index="5">입니다.</span>
                </div>
                <p class="desc-ph ph-desc-reveal">
                    택배 상자 대신 따뜻한 인사를 나눕니다.<br>
                    바톤은 기술을 통해 단절된 지역 사회를 다시 잇고,<br>
                    가장 안전하고 가까운 로컬 라이프스타일 플랫폼을 만듭니다.
                </p>
            </div>
        </div>
    </section>

    <section class="sec-showcase">
        <div class="sticky-wrap">
            <div class="txt-area">
                <div class="step-txt step-1 active">
                    <span class="tag">01. Secondhand Trade</span>
                    <h2>가장 안전한<br>직거래의 기준</h2>
                    <p>위치 인증을 완료한 진짜 이웃과<br>배송비 걱정 없이 웹에서 거래하세요.</p>
                </div>
                <div class="step-txt step-2">
                    <span class="tag">02. Neighborhood Job</span>
                    <h2>걸어서 10분<br>우리 동네 알바</h2>
                    <p>사장님은 수수료 0원,<br>알바생은 웹에서 빠르고 쉬운 지원.</p>
                </div>
                <div class="step-txt step-3">
                    <span class="tag">03. Local Crew</span>
                    <h2>취미로 하나 되는<br>동네 친구</h2>
                    <p>러닝, 독서, 맛집 탐방까지.<br>우리 동네 크루원들과 웹에서 소통하세요.</p>
                </div>
                <div class="step-txt step-4">
                    <span class="tag">04. Community</span>
                    <h2>동네 소식을<br>함께 나눠요</h2>
                    <p>우리 동네 공지, 맛집 추천, 분실물까지.<br>이웃과 자유롭게 소통하는 커뮤니티.</p>
                </div>
            </div>
            
            <div class="device-area">
                <div class="device-frame">
                    <div class="notch"></div>

                    <div class="screen scr-1 active">
                        <div class="screen-header">Baton Trade</div>
                        <div class="trade-card">
                            <div class="trade-img">🛋️</div>
                            <div class="trade-info">
                                <div class="trade-name">원목 2인 소파</div>
                                <div class="trade-price">85,000원</div>
                                <div class="trade-meta">
                                    <span class="trade-badge">📍 도보 3분</span>
                                    <span class="trade-badge safe">🔒 안전결제</span>
                                </div>
                            </div>
                        </div>
                        <div class="trade-card">
                            <div class="trade-img">📷</div>
                            <div class="trade-info">
                                <div class="trade-name">미러리스 카메라</div>
                                <div class="trade-price">320,000원</div>
                                <div class="trade-meta">
                                    <span class="trade-badge">📍 도보 7분</span>
                                    <span class="trade-badge safe">🔒 안전결제</span>
                                </div>
                            </div>
                        </div>
                        <div class="trade-trust">
                            <span class="trust-icon">✅</span> 위치 인증된 이웃과 거래
                        </div>
                    </div>

                    <div class="screen scr-2">
                        <div class="screen-header">Baton Alba</div>
                        <div class="job-card">
                            <div class="badge-tag">급구</div>
                            <div class="title">카페 주말 오픈</div>
                            <div class="pay">시급 11,000원</div>
                        </div>
                        <div class="job-card">
                            <div class="badge-tag">단기</div>
                            <div class="title">강아지 산책</div>
                            <div class="pay">건당 20,000원</div>
                        </div>
                    </div>

                    <div class="screen scr-3">
                        <div class="screen-header">Baton Crew</div>
                        <div class="crew-card">
                            <div class="icon">🏃</div>
                            <div class="name">한강 러닝 크루</div>
                        </div>
                        <div class="crew-card">
                            <div class="icon">📚</div>
                            <div class="name">심야 책방</div>
                        </div>
                        <div class="chat-bubble">참여하고 싶어요 👋</div>
                    </div>

                    <div class="screen scr-4">
                        <div class="screen-header">Baton 커뮤니티</div>
                        <div class="community-card">
                            <div class="comm-top">
                                <span class="comm-category">📢 동네공지</span>
                                <span class="comm-time">5분 전</span>
                            </div>
                            <div class="comm-title">이번 주말 마포구 플리마켓 열려요!</div>
                            <div class="comm-bottom">
                                <span>❤️ 24</span><span>💬 8</span>
                            </div>
                        </div>
                        <div class="community-card">
                            <div class="comm-top">
                                <span class="comm-category">🍜 맛집추천</span>
                                <span class="comm-time">12분 전</span>
                            </div>
                            <div class="comm-title">성수동 숨은 파스타 맛집 발견했어요</div>
                            <div class="comm-bottom">
                                <span>❤️ 51</span><span>💬 17</span>
                            </div>
                        </div>
                        <div class="community-card">
                            <div class="comm-top">
                                <span class="comm-category">🐾 분실물</span>
                                <span class="comm-time">34분 전</span>
                            </div>
                            <div class="comm-title">회색 고양이 못 보셨나요?</div>
                            <div class="comm-bottom">
                                <span>❤️ 88</span><span>💬 32</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="sec-review-box reveal-item">
        <div class="frame centered">
            <div class="score-container">
                <div class="stars-wrap">
                    <div class="stars-fill">★★★★★</div>
                    <div class="stars-empty">★★★★★</div>
                </div>
                <div class="score-text">
                    <span class="score-num" data-target="4.9">0.0</span><span class="score-total">/ 5.0</span>
                </div>
            </div>
            <h2 class="tit-review">이미 수많은 이웃들이<br>바톤으로 일상을 바꾸고 있어요.</h2>
        </div>
        <div class="review-slider">
            <div class="review-track">
                <div class="r-card">
                    <div class="r-head"><span>⭐⭐⭐⭐⭐</span></div>
                    <p class="r-body">"동네에서 바로 만나서 거래하니까 택배 기다릴 필요도 없고 사기 걱정도 없어서 너무 좋아요!"</p>
                    <div class="r-info">서울 강남구 / 김*수님</div>
                </div>
                <div class="r-card">
                    <div class="r-head"><span>⭐⭐⭐⭐⭐</span></div>
                    <p class="r-body">"집 앞 5분 거리 카페 알바를 바톤에서 찾았습니다. 사장님도 이웃이라 그런지 정말 친절하세요!"</p>
                    <div class="r-info">경기 성남시 / 박*영님</div>
                </div>
                <div class="r-card">
                    <div class="r-head"><span>⭐⭐⭐⭐⭐</span></div>
                    <p class="r-body">"혼자 운동하기 심심했는데 웹에서 크루 가입하고 매주 토요일마다 한강 달려요. 진짜 추천합니다."</p>
                    <div class="r-info">서울 마포구 / 최*민님</div>
                </div>
                <div class="r-card">
                    <div class="r-head"><span>⭐⭐⭐⭐⭐</span></div>
                    <p class="r-body">"안전결제 시스템 덕분에 처음 해보는 중고거래도 안심하고 완료했습니다. 이웃이라 믿음이 가요."</p>
                    <div class="r-info">인천 연수구 / 이*나님</div>
                </div>
                <div class="r-card">
                    <div class="r-head"><span>⭐⭐⭐⭐⭐</span></div>
                    <p class="r-body">"이사 오고 친구가 없었는데 독서 모임 크루 통해서 좋은 분들 많이 만났습니다. 바톤 최고!"</p>
                    <div class="r-info">대구 수성구 / 정*우님</div>
                </div>
            </div>
        </div>
    </section>

    <section class="sec-tech reveal-item">
        <div class="frame centered">
            <h2 class="tit-tech">보이지 않는 곳까지<br>집요하게 설계했습니다.</h2>
            <div class="grid-tech">
                <div class="item-tech">
                    <span class="ico">🔒</span>
                    <h3>Escrow Payment</h3>
                    <p>구매 확정 전까지 결제 대금을 안전하게 보호하여 사기를 원천 차단합니다.</p>
                </div>
                <div class="item-tech">
                    <span class="ico">💬</span>
                    <h3>WebSocket Chat</h3>
                    <p>전화번호 노출 없는 실시간 채팅으로 웹에서도 안전한 소통을 지원합니다.</p>
                </div>
                <div class="item-tech">
                    <span class="ico">📍</span>
                    <h3>Geo-Fencing</h3>
                    <p>정교한 위치 인증 기술로 허위 매물과 비거주자의 접근을 막습니다.</p>
                </div>
                <div class="item-tech">
                    <span class="ico">⚡</span>
                    <h3>Robust Server</h3>
                    <p>Spring Boot와 Oracle DB 기반의 안정적인 아키텍처를 구축했습니다.</p>
                </div>
            </div>
        </div>
    </section>

    <section class="sec-data reveal-item">
        <div class="frame centered">
            <h2 class="tit-data">숫자가 증명하는 신뢰</h2>
            <div class="flex-data box-data">
                <div class="box-data-item">
                    <span class="label">누적 거래액</span>
                    <strong class="num" data-val="245">0</strong><span class="unit">억+</span>
                </div>
                <div class="box-data-item">
                    <span class="label">월간 사용자</span>
                    <strong class="num" data-val="350">0</strong><span class="unit">만+</span>
                </div>
                <div class="box-data-item">
                    <span class="label">동네 인증</span>
                    <strong class="num" data-val="890">0</strong><span class="unit">만건</span>
                </div>
            </div>
        </div>
    </section>

    <section class="sec-cta reveal-item">
        <div class="frame centered">
            <h2 class="tit-cta">오늘, 당신의 동네와 연결되세요.</h2>
            <div class="btns">
                <a href="${pageContext.request.contextPath}/trade/list" class="btn-main">서비스 둘러보기</a>
                <a href="${pageContext.request.contextPath}/member/join" class="btn-sub">회원가입</a>
            </div>
        </div>
    </section>

</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>

<script src="${pageContext.request.contextPath}/dist/js/about/about_intro.js"></script>

</body>
</html>