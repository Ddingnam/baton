<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>BATON Admin</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_main.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

    <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
    <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

    <main class="page-main">
        
        <div class="greet-box">
            <h2 class="greet-title">반가워요, 관리자님! 👋</h2>
            <p class="greet-desc">오늘의 Baton 주요 지표를 확인하세요.</p>
        </div>

        <div class="kpi-wrapper">
            <div class="kpi-card">
                <div class="kpi-icon t-blue"><i class="ri-user-follow-line"></i></div>
                <div class="kpi-value">1,420</div>
                <div class="kpi-label">일일 방문자</div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon t-green"><i class="ri-exchange-funds-line"></i></div>
                <div class="kpi-value">86건</div>
                <div class="kpi-label">거래 완료</div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon t-red"><i class="ri-alarm-warning-line"></i></div>
                <div class="kpi-value" style="color:#F04452;">5건</div>
                <div class="kpi-label">신고 대기</div>
            </div>
            <div class="kpi-card">
                <div class="kpi-icon t-warn"><i class="ri-coins-line"></i></div>
                <div class="kpi-value">₩ 3.2M</div>
                <div class="kpi-label">오늘의 매출</div>
            </div>
        </div>

        <div class="dash-row">
            <div class="dash-section">
                <div class="sec-head">
                    <h3 class="sec-title">주간 거래 추이</h3>
                </div>
                <div style="height: 320px;">
                    <canvas id="mainChart"></canvas>
                </div>
            </div>

            <div class="dash-section">
                <div class="sec-head">
                    <h3 class="sec-title">최근 등록된 물품</h3>
                    <a href="${pageContext.request.contextPath}/admin/trade/list" class="btn-more">더보기 +</a>
                </div>
                <table class="pretty-list">
                    <tbody>
                        <tr>
                            <td>
                                <div class="item-main">아이폰 15 프로</div>
                                <div class="item-sub">디지털/가전 · 5분 전</div>
                            </td>
                            <td align="right"><span class="state-badge ing">판매중</span></td>
                        </tr>
                        <tr>
                            <td>
                                <div class="item-main">스타벅스 아메리카노</div>
                                <div class="item-sub">기프티콘 · 12분 전</div>
                            </td>
                            <td align="right"><span class="state-badge alert">신고됨</span></td>
                        </tr>
                        <tr>
                            <td>
                                <div class="item-main">갤럭시 탭 S9 울트라</div>
                                <div class="item-sub">태블릿 · 1시간 전</div>
                            </td>
                            <td align="right"><span class="state-badge done">완료</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

    </main>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/dist/js/admin_main.js"></script>
    
    <script>
        // Chart.js Configuration
        const ctx = document.getElementById('mainChart').getContext('2d');
        const gradient = ctx.createLinearGradient(0, 0, 0, 300);
        gradient.addColorStop(0, 'rgba(49, 130, 246, 0.15)');
        gradient.addColorStop(1, 'rgba(49, 130, 246, 0)');

        new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['월', '화', '수', '목', '금', '토', '일'],
                datasets: [{
                    label: '거래량',
                    data: [12, 19, 13, 25, 22, 30, 45],
                    borderColor: '#3182F6',
                    backgroundColor: gradient,
                    borderWidth: 3,
                    pointBackgroundColor: '#fff',
                    pointBorderColor: '#3182F6',
                    pointRadius: 6,
                    pointHoverRadius: 8,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true, grid: { borderDash: [4, 4], color: '#F0F0F0' }, ticks: { color: '#8B95A1' } },
                    x: { grid: { display: false }, ticks: { color: '#8B95A1' } }
                }
            }
        });
    </script>

</body>
</html>