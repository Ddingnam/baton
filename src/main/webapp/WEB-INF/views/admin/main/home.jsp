<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>BATON Admin Studio</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@500;700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_main.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
    <script src="${pageContext.request.contextPath}/dist/js/admin/admin_main.js" defer></script>
</head>
<body>

<div class="agency-layout">
    <jsp:include page="/WEB-INF/views/admin/layout/left.jsp"/>

    <main class="agency-main">
        <jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>

        <div class="agency-scroll-area">
            <div class="hero-header">
                <div class="hero-titles">
                    <h1 class="hero-title">Dashboard</h1>
                    <p class="hero-subtitle">오늘의 플랫폼 현황을 한눈에 확인하세요.</p>
                </div>
                <div class="hero-actions">
                    <button class="btn-pill btn-light">데이터 내보내기</button>
                    <button class="btn-pill btn-gradient">리포트 생성</button>
                </div>
            </div>

            <div class="bento-grid">

                <div class="bento-item col-3">
                    <div class="metric-card">
                        <div class="metric-icon wrap-purple"><i class="ri-user-smile-fill"></i></div>
                        <div class="metric-info">
                            <span class="metric-label">전체 회원수</span>
                            <span class="metric-val">24,812</span>
                        </div>
                        <div class="metric-trend text-purple"><i class="ri-arrow-up-line"></i> 2.4%</div>
                    </div>
                </div>

                <div class="bento-item col-3">
                    <div class="metric-card">
                        <div class="metric-icon wrap-blue"><i class="ri-wallet-3-fill"></i></div>
                        <div class="metric-info">
                            <span class="metric-label">매출액</span>
                            <span class="metric-val">₩48.2M</span>
                        </div>
                        <div class="metric-trend text-blue"><i class="ri-arrow-up-line"></i> 12.1%</div>
                    </div>
                </div>

                <div class="bento-item col-3">
                    <div class="metric-card">
                        <div class="metric-icon wrap-green"><i class="ri-shopping-bag-3-fill"></i></div>
                        <div class="metric-info">
                            <span class="metric-label">오늘 거래건수</span>
                            <span class="metric-val">1,429</span>
                        </div>
                        <div class="metric-trend text-gray"><i class="ri-arrow-down-line"></i> 3.2%</div>
                    </div>
                </div>

                <div class="bento-item col-3">
                    <div class="metric-card card-vibrant">
                        <div class="metric-icon wrap-glass"><i class="ri-customer-service-2-fill"></i></div>
                        <div class="metric-info">
                            <span class="metric-label text-glass">미처리 문의</span>
                            <span class="metric-val text-white">15</span>
                        </div>
                        <div class="metric-trend text-glass">처리 필요</div>
                    </div>
                </div>

                <div class="bento-item col-8">
                    <div class="block-card chart-block">
                        <div class="block-header">
                            <div class="header-text">
                                <h2>Revenue 추이</h2>
                                <p>플랫폼 주간 거래 규모</p>
                            </div>
                            <div class="pill-tabs" id="chartTabs">
                                <button class="pill-tab active">1주</button>
                                <button class="pill-tab">1달</button>
                                <button class="pill-tab">1년</button>
                            </div>
                        </div>
                        <div class="canvas-wrap">
                            <canvas id="gradientChart"></canvas>
                        </div>
                    </div>
                </div>

                <div class="bento-item col-4">
                    <div class="block-card feed-block">
                        <div class="block-header">
                            <div class="header-text">
                                <h2>Live Feed</h2>
                            </div>
                            <div class="pulse-badge">실시간</div>
                        </div>
                        <div class="feed-wrapper">
                            <div class="feed-row">
                                <div class="feed-avt bg-pink"><i class="ri-user-add-fill"></i></div>
                                <div class="feed-data">
                                    <p class="feed-msg"><strong>김바톤</strong> 님이 BATON에 가입했습니다</p>
                                    <span class="feed-time">방금 전</span>
                                </div>
                            </div>
                            <div class="feed-row">
                                <div class="feed-avt bg-blue"><i class="ri-check-double-line"></i></div>
                                <div class="feed-data">
                                    <p class="feed-msg"><strong>iPhone 15 Pro</strong> 거래 완료</p>
                                    <span class="feed-time">3분 전</span>
                                </div>
                            </div>
                            <div class="feed-row">
                                <div class="feed-avt bg-orange"><i class="ri-error-warning-fill"></i></div>
                                <div class="feed-data">
                                    <p class="feed-msg">커뮤니티 신고가 접수되었습니다</p>
                                    <span class="feed-time">12분 전</span>
                                </div>
                            </div>
                            <div class="feed-row">
                                <div class="feed-avt bg-purple"><i class="ri-refund-2-fill"></i></div>
                                <div class="feed-data">
                                    <p class="feed-msg">결제 환불이 처리되었습니다</p>
                                    <span class="feed-time">28분 전</span>
                                </div>
                            </div>
                            <div class="feed-row">
                                <div class="feed-avt bg-green"><i class="ri-briefcase-4-fill"></i></div>
                                <div class="feed-data">
                                    <p class="feed-msg">새 알바 공고가 등록되었습니다</p>
                                    <span class="feed-time">1시간 전</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="bento-item col-12">
                    <div class="block-card table-block">
                        <div class="block-header table-header">
                            <div class="header-text">
                                <h2>Recent Transactions</h2>
                            </div>
                            <button class="btn-text">전체 내역 보기 <i class="ri-arrow-right-line"></i></button>
                        </div>
                        <div class="modern-table-wrap">
                            <table class="modern-table">
                                <thead>
                                    <tr>
                                        <th>상품</th>
                                        <th>판매자</th>
                                        <th>구매자</th>
                                        <th>거래금액</th>
                                        <th>상태</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>
                                            <div class="product-cell">
                                                <div class="product-icon"><i class="ri-smartphone-line"></i></div>
                                                <div class="product-info">
                                                    <span class="product-name">iPhone 15 Pro Max</span>
                                                    <span class="product-meta">03-12 14:32</span>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="font-medium">김바톤</td>
                                        <td class="font-medium">이사용</td>
                                        <td class="font-num">1,450,000 ₩</td>
                                        <td><span class="tag tag-blue">배송중</span></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="product-cell">
                                                <div class="product-icon"><i class="ri-macbook-line"></i></div>
                                                <div class="product-info">
                                                    <span class="product-name">MacBook Air M2</span>
                                                    <span class="product-meta">03-12 13:10</span>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="font-medium">박애플</td>
                                        <td class="font-medium">최맥북</td>
                                        <td class="font-num">1,200,000 ₩</td>
                                        <td><span class="tag tag-gray">검토중</span></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="product-cell">
                                                <div class="product-icon"><i class="ri-gamepad-line"></i></div>
                                                <div class="product-info">
                                                    <span class="product-name">Nintendo Switch OLED</span>
                                                    <span class="product-meta">03-12 11:55</span>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="font-medium">최게임</td>
                                        <td class="font-medium">정닌텐도</td>
                                        <td class="font-num">320,000 ₩</td>
                                        <td><span class="tag tag-red">취소됨</span></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="product-cell">
                                                <div class="product-icon"><i class="ri-headphone-line"></i></div>
                                                <div class="product-info">
                                                    <span class="product-name">Sony WH-1000XM5</span>
                                                    <span class="product-meta">03-12 10:44</span>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="font-medium">이소니</td>
                                        <td class="font-medium">박뮤직</td>
                                        <td class="font-num">390,000 ₩</td>
                                        <td><span class="tag tag-green">거래완료</span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </main>
</div>

</body>
</html>
