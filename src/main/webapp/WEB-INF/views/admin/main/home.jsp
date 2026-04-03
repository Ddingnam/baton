<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

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
    <script>
        window.dashboardChartLabels = [
            <c:forEach var="label" items="${chartLabels}" varStatus="status">'${label}'<c:if test="${!status.last}">,</c:if></c:forEach>
        ];
        window.dashboardChartData = [
            <c:forEach var="value" items="${chartValues}" varStatus="status">${value}<c:if test="${!status.last}">,</c:if></c:forEach>
        ];

        /* ── 가데이터: 7일 / 30일 ── */
        (function() {
            var today = new Date();
            function fmtLabel(d) {
                return (d.getMonth()+1) + '/' + String(d.getDate()).padStart(2,'0');
            }
            /* 7일 가데이터 */
            var mock7Labels = [], mock7Data = [];
            var base7 = [185000, 230000, 198000, 312000, 275000, 420000, 390000];
            for (var i = 6; i >= 0; i--) {
                var d = new Date(today); d.setDate(today.getDate() - i);
                mock7Labels.push(fmtLabel(d));
                mock7Data.push(base7[6 - i] + Math.floor(Math.random() * 30000));
            }
            /* 30일 가데이터 */
            var mock30Labels = [], mock30Data = [];
            var trend = [120000,145000,130000,160000,175000,190000,210000,185000,230000,205000,
                         260000,245000,280000,295000,310000,285000,330000,315000,355000,340000,
                         370000,395000,360000,410000,390000,420000,445000,430000,475000,460000];
            for (var j = 29; j >= 0; j--) {
                var d2 = new Date(today); d2.setDate(today.getDate() - j);
                mock30Labels.push(fmtLabel(d2));
                mock30Data.push(trend[29 - j] + Math.floor(Math.random() * 40000));
            }
            /* 실제 서버데이터가 비어있으면 가데이터 주입 */
            var serverHasData = window.dashboardChartData && window.dashboardChartData.some(function(v){ return v > 0; });
            if (!serverHasData) {
                window.dashboardChartLabels = mock7Labels;
                window.dashboardChartData   = mock7Data;
            }
            window.mock7Labels  = mock7Labels;
            window.mock7Data    = mock7Data;
            window.mock30Labels = mock30Labels;
            window.mock30Data   = mock30Data;

            /* 메트릭 가데이터 */
            window.mockMetrics = {
                totalMembers : 1247,
                todayRevenue : 460000,
                todayTrades  : 38,
                pendingReports: 5
            };
        })();
    </script>
    <script src="${pageContext.request.contextPath}/dist/js/admin/admin_main.js"></script>

    <style>
        .status-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 88px;
            padding: 6px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 800;
            line-height: 1;
            white-space: nowrap;
        }
        .status-badge.success {
            background: rgba(34, 197, 94, 0.12);
            color: #22c55e;
        }
        .status-badge.danger {
            background: rgba(239, 68, 68, 0.12);
            color: #ef4444;
        }
        .status-badge.warning {
            background: rgba(251, 191, 36, 0.12);
            color: #f59e0b;
        }
        .status-badge.default {
            background: rgba(148, 163, 184, 0.12);
            color: #64748b;
        }
        .metric-card-link {
            display: block;
            text-decoration: none;
            color: inherit;
            border-radius: inherit;
            transition: transform 0.15s ease, box-shadow 0.15s ease;
        }
        .metric-card-link:hover .metric-card {
            transform: translateY(-3px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.10);
            cursor: pointer;
        }
        .metric-card-link:hover .metric-card.card-vibrant {
            box-shadow: 0 8px 24px rgba(120,60,200,0.25);
        }
    </style>
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
                    <button class="btn-pill btn-light" type="button" onclick="window.location.reload()">새로고침</button>
                    <a class="btn-pill btn-gradient" href="${pageContext.request.contextPath}/admin/report/list">신고 관리로 이동</a>
                </div>
            </div>

            <div class="bento-grid">

                <div class="bento-item col-3">
                    <a class="metric-card-link" href="${pageContext.request.contextPath}/admin/member/list">
                    <div class="metric-card">
                        <div class="metric-icon wrap-purple"><i class="ri-user-smile-fill"></i></div>
                        <div class="metric-info">
                            <span class="metric-label">전체 회원수</span>
                            <span class="metric-val"><fmt:formatNumber value="${totalMemberCount}" pattern="#,##0"/></span>
                        </div>
                        <div class="metric-trend ${memberTrendUp ? 'text-purple' : 'text-gray'}">
                            <i class="${memberTrendUp ? 'ri-arrow-up-line' : 'ri-arrow-down-line'}"></i> ${memberTrendText}
                        </div>
                    </div>
                    </a>
                </div>

                <div class="bento-item col-3">
                    <a class="metric-card-link" href="${pageContext.request.contextPath}/admin/payment/list">
                    <div class="metric-card">
                        <div class="metric-icon wrap-blue"><i class="ri-wallet-3-fill"></i></div>
                        <div class="metric-info">
                            <span class="metric-label">오늘 충전 매출</span>
                            <span class="metric-val"><fmt:formatNumber value="${todayRevenue}" pattern="#,##0"/>원</span>
                        </div>
                        <div class="metric-trend ${revenueTrendUp ? 'text-blue' : 'text-gray'}">
                            <i class="${revenueTrendUp ? 'ri-arrow-up-line' : 'ri-arrow-down-line'}"></i> ${revenueTrendText}
                        </div>
                    </div>
                    </a>
                </div>

                <div class="bento-item col-3">
                    <a class="metric-card-link" href="${pageContext.request.contextPath}/admin/trade/list">
                    <div class="metric-card">
                        <div class="metric-icon wrap-green"><i class="ri-shopping-bag-3-fill"></i></div>
                        <div class="metric-info">
                            <span class="metric-label">오늘 거래건수</span>
                            <span class="metric-val"><fmt:formatNumber value="${todayTradeCount}" pattern="#,##0"/></span>
                        </div>
                        <div class="metric-trend ${tradeTrendUp ? 'text-green' : 'text-gray'}">
                            <i class="${tradeTrendUp ? 'ri-arrow-up-line' : 'ri-arrow-down-line'}"></i> ${tradeTrendText}
                        </div>
                    </div>
                    </a>
                </div>

                <div class="bento-item col-3">
                    <a class="metric-card-link" href="${pageContext.request.contextPath}/admin/report/list">
                    <div class="metric-card card-vibrant">
                        <div class="metric-icon wrap-glass"><i class="ri-customer-service-2-fill"></i></div>
                        <div class="metric-info">
                            <span class="metric-label text-glass">미처리 신고</span>
                            <span class="metric-val text-white"><fmt:formatNumber value="${pendingReportCount}" pattern="#,##0"/></span>
                        </div>
                        <div class="metric-trend text-glass">${pendingReportLabel}</div>
                    </div>
                    </a>
                </div>

                <div class="bento-item col-8">
                    <div class="block-card chart-block">
                        <div class="block-header">
                            <div class="header-text">
                                <h2>Revenue 추이</h2>
                                <p>최근 7일 포인트 충전 매출</p>
                            </div>
                            <div class="pill-tabs" id="chartTabs">
                                <button class="pill-tab active" type="button" data-period="7">7일</button>
                                <button class="pill-tab" type="button" data-period="30">30일</button>
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
                            <c:choose>
                                <c:when test="${not empty recentActivities}">
                                    <c:forEach var="item" items="${recentActivities}">
                                        <div class="feed-row">
                                            <div class="feed-avt ${item.bgClass}"><i class="${item.iconClass}"></i></div>
                                            <div class="feed-data">
                                                <p class="feed-msg"><strong>${item.title}</strong> ${item.description}</p>
                                                <span class="feed-time">${item.eventDate}</span>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="feed-row">
                                        <div class="feed-avt bg-blue"><i class="ri-information-line"></i></div>
                                        <div class="feed-data">
                                            <p class="feed-msg">표시할 최근 활동이 없습니다</p>
                                            <span class="feed-time">-</span>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div class="bento-item col-12">
                    <div class="block-card table-block">
                        <div class="block-header table-header">
                            <div class="header-text">
                                <h2>Recent Transactions</h2>
                            </div>
                            <a class="btn-text" href="${pageContext.request.contextPath}/admin/trade/list">전체 내역 보기 <i class="ri-arrow-right-line"></i></a>
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
                                    <c:choose>
                                        <c:when test="${not empty recentTransactions}">
                                            <c:forEach var="item" items="${recentTransactions}">
                                                <tr>
                                                    <td>
                                                        <div class="product-cell">
                                                            <div class="product-icon"><i class="${item.productIcon}"></i></div>
                                                            <div class="product-info">
                                                                <span class="product-name">${item.productTitle}</span>
                                                                <span class="product-meta">${item.tradeDate}</span>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td class="font-medium">${item.sellerName}</td>
                                                    <td class="font-medium">${item.buyerName}</td>
                                                    <td class="font-num"><fmt:formatNumber value="${item.tradePrice}" pattern="#,##0"/>원</td>
                                                    <td>
                                                        <c:set var="statusClass" value="default" />
                                                        <c:set var="statusText" value="${empty item.status ? '-' : item.status}" />

                                                        <c:choose>
                                                            <c:when test="${item.tradeStatus eq 'PAY_COMPLETED' or item.status eq 'COMPLETED' or item.status eq 'SUCCESS'}">
                                                                <c:set var="statusClass" value="success" />
                                                                <c:set var="statusText" value="PAY_COMPLETED" />
                                                            </c:when>
                                                            <c:when test="${item.tradeStatus eq 'CANCELED' or item.status eq 'CANCELLED' or item.status eq 'CANCEL'}">
                                                                <c:set var="statusClass" value="danger" />
                                                                <c:set var="statusText" value="CANCELED" />
                                                            </c:when>
                                                            <c:when test="${item.tradeStatus eq 'PENDING' or item.status eq 'WAITING'}">
                                                                <c:set var="statusClass" value="warning" />
                                                                <c:set var="statusText" value="PENDING" />
                                                            </c:when>
                                                        </c:choose>

                                                        <span class="status-badge ${statusClass}">${statusText}</span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="5" style="text-align:center; padding:40px 16px; color:#94A3B8;">표시할 최근 거래 데이터가 없습니다.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
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
