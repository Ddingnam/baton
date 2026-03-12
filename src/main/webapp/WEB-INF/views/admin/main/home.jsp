<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>BATON Admin</title>

    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_main.css">

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="${pageContext.request.contextPath}/dist/js/admin/admin_main.js" defer></script>

    <style>
        /* ── 대시보드 전용 ── */

        .content-scroll {
            flex: 1;
            overflow-y: auto;
            padding: 36px 40px 48px;
        }
        .content-scroll::-webkit-scrollbar { width: 5px; }
        .content-scroll::-webkit-scrollbar-thumb {
            background: var(--line-border);
            border-radius: 10px;
        }

        .grid-master {
            display: grid;
            grid-template-columns: repeat(12, 1fr);
            gap: 24px;
            max-width: 1600px;
            margin: 0 auto;
        }

        /* ── 카드 베이스 ── */
        .card {
            background: var(--bg-surface);
            border-radius: var(--radius-xl);
            padding: 28px;
            box-shadow: var(--shadow-soft);
            border: 1px solid rgba(255,255,255,0.8);
            transition: box-shadow 0.3s var(--ease-out), transform 0.3s var(--ease-out);
            position: relative;
            overflow: hidden;
        }
        .card:hover {
            box-shadow: 0 12px 40px rgba(0,0,0,0.06);
        }
        .card-hd {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 24px;
        }
        .card-tl {
            font-size: 17px;
            font-weight: 800;
            color: var(--text-primary);
            letter-spacing: -0.3px;
        }
        .card-sub {
            font-size: 13px;
            color: var(--text-secondary);
            font-weight: 500;
            margin-top: 3px;
        }
        .card-opt {
            color: var(--text-secondary);
            cursor: pointer;
            font-size: 22px;
            transition: color 0.2s;
        }
        .card-opt:hover { color: var(--accent-start); }

        /* ── Summary cards ── */
        .summary-card {
            grid-column: span 3;
            display: flex;
            align-items: center;
            gap: 18px;
            padding: 22px 24px;
        }


        .sum-icon {
            width: 56px; height: 56px;
            border-radius: 18px;
            display: flex; align-items: center; justify-content: center;
            font-size: 26px;
            flex-shrink: 0;
            transition: transform 0.3s var(--ease-spring);
        }


        .sum-data { min-width: 0; }
        .sum-data h4 {
            font-size: 12px;
            color: var(--text-secondary);
            font-weight: 600;
            margin-bottom: 4px;
            letter-spacing: 0.3px;
            text-transform: uppercase;
        }
        .sum-data h2 {
            font-size: 28px;
            font-weight: 800;
            color: var(--text-primary);
            line-height: 1;
            letter-spacing: -0.5px;
        }
        .sum-delta {
            display: flex; align-items: center; gap: 3px;
            font-size: 12px; font-weight: 600; margin-top: 5px;
        }
        .delta-up { color: var(--text-secondary); }
        .delta-dn { color: var(--text-secondary); }

        .i-blue   { background: var(--accent-light); color: var(--accent-start); }
        .i-violet { background: var(--accent-light); color: var(--accent-start); }
        .i-green  { background: var(--accent-light); color: var(--accent-start); }
        .i-amber  { background: var(--accent-light); color: var(--accent-start); }

        /* ── 차트 ── */
        .chart-section {
            grid-column: span 8;
            height: 440px;
            display: flex;
            flex-direction: column;
        }
        .tab-btns {
            display: flex; gap: 4px;
            background: var(--bg-app);
            border-radius: 12px; padding: 4px;
        }
        .tab-btn {
            padding: 6px 14px; border-radius: 8px;
            font-size: 12px; font-weight: 700;
            color: var(--text-secondary);
            transition: all 0.2s var(--ease-out);
        }
        .tab-btn.active {
            background: white; color: var(--accent-start);
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }
        .tab-btn:hover:not(.active) { color: var(--text-primary); }

        /* ── 사이드 컬럼 ── */
        .side-col {
            grid-column: span 4;
            display: flex;
            flex-direction: column;
            gap: 24px;
        }

        /* 실시간 피드 */
        .feed-card { flex: 1; display: flex; flex-direction: column; }
        .live-dot { width: 7px; height: 7px; border-radius: 50%; background: #34C759; }
        .activity-list {
            display: flex; flex-direction: column;
            flex: 1; overflow-y: auto;
        }
        .activity-list::-webkit-scrollbar { display: none; }
        .act-item {
            display: flex; align-items: flex-start; gap: 12px;
            padding: 11px 0;
            border-bottom: 1px solid var(--line-border);
        }
        .act-item:last-child { border-bottom: none; }
        .act-icon {
            width: 34px; height: 34px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 16px; flex-shrink: 0;
        }
        .act-body { flex: 1; min-width: 0; }
        .act-txt {
            font-size: 13px; color: var(--text-primary);
            font-weight: 600; line-height: 1.4;
        }
        .act-txt .hl { color: var(--text-primary); }
        .act-time {
            font-size: 11px; color: var(--text-secondary);
            font-weight: 500; margin-top: 2px;
        }

        /* ── 테이블 ── */
        .table-section { grid-column: span 12; }

        .filter-row {
            display: flex; align-items: center; gap: 8px; margin-bottom: 20px;
        }
        .filter-pill {
            padding: 6px 14px; border-radius: 20px;
            font-size: 12px; font-weight: 700;
            color: var(--text-secondary);
            background: var(--bg-app);
            border: 1px solid transparent;
            cursor: pointer; transition: all 0.2s;
        }
        .filter-pill:hover { color: var(--accent-start); background: var(--accent-light); }
        .filter-pill.active {
            background: var(--accent-light); color: var(--accent-start);
            border-color: rgba(49,130,246,0.2);
        }
        .filter-count {
            margin-left: auto;
            font-size: 12px; color: var(--text-secondary); font-weight: 600;
        }

        .fancy-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 6px;
        }
        .fancy-table th {
            text-align: left;
            color: var(--text-secondary);
            font-weight: 700; font-size: 12px;
            text-transform: uppercase; letter-spacing: 0.5px;
            padding: 0 18px 8px;
        }
        .fancy-table td {
            background: var(--bg-surface);
            padding: 14px 18px;
            font-size: 14px; color: var(--text-primary); font-weight: 600;
            border-top: 1px solid transparent;
            border-bottom: 1px solid transparent;
            transition: all 0.15s;
        }
        .fancy-table tr td:first-child {
            border-left: 1px solid transparent;
            border-radius: var(--radius-md) 0 0 var(--radius-md);
        }
        .fancy-table tr td:last-child {
            border-right: 1px solid transparent;
            border-radius: 0 var(--radius-md) var(--radius-md) 0;
        }
        .fancy-table tr:hover td {
            background: var(--bg-app);
            border-color: transparent;
        }

        .item-flex { display: flex; align-items: center; gap: 14px; }
        .item-img {
            width: 42px; height: 42px; border-radius: 12px;
            background: var(--accent-light);
            display: flex; align-items: center; justify-content: center;
            font-size: 20px; color: var(--accent-start); flex-shrink: 0;
        }

        .status-pill {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 5px 12px; border-radius: 20px;
            font-size: 12px; font-weight: 700;
        }
        .status-pill::before {
            content: ''; width: 5px; height: 5px;
            border-radius: 50%; background: currentColor;
        }
        .pill-blue  { background: #F0F4FF; color: #5B8DEF; }
        .pill-green { background: #F0FAF7; color: #4DB89A; }
        .pill-red   { background: #FFF5F5; color: #C97B7B; }
        .pill-amber { background: #FFF9F0; color: #C99A5A; }

        .td-mono { font-family: 'Courier New', monospace; font-weight: 700; }
        .td-muted { font-size: 12px; color: var(--text-secondary); font-weight: 500; }

        /* 진입 애니메이션 */
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(14px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .grid-master > * { animation: fadeUp 0.45s var(--ease-out) both; }
        .grid-master > *:nth-child(1) { animation-delay: 0.04s; }
        .grid-master > *:nth-child(2) { animation-delay: 0.08s; }
        .grid-master > *:nth-child(3) { animation-delay: 0.12s; }
        .grid-master > *:nth-child(4) { animation-delay: 0.16s; }
        .grid-master > *:nth-child(5) { animation-delay: 0.20s; }
        .grid-master > *:nth-child(6) { animation-delay: 0.24s; }
        .grid-master > *:nth-child(7) { animation-delay: 0.28s; }
    </style>
</head>
<body>

<div class="layout-container">
    <jsp:include page="/WEB-INF/views/admin/layout/left.jsp"/>

    <div class="main-body">
        <jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>

        <div class="content-scroll">
            <div class="grid-master">

                <%-- ── Summary 4개 ── --%>
                <div class="card summary-card">
                    <div class="sum-icon i-blue"><i class="ri-user-heart-line"></i></div>
                    <div class="sum-data">
                        <h4>전체 회원수</h4>
                        <h2>24,812</h2>
                        <div class="sum-delta delta-up">2.4% 이번달</div>
                    </div>
                </div>

                <div class="card summary-card">
                    <div class="sum-icon i-violet"><i class="ri-wallet-3-line"></i></div>
                    <div class="sum-data">
                        <h4>이번달 매출</h4>
                        <h2>₩48.2M</h2>
                        <div class="sum-delta delta-up">12.1% 전월比</div>
                    </div>
                </div>

                <div class="card summary-card">
                    <div class="sum-icon i-green"><i class="ri-shopping-bag-3-line"></i></div>
                    <div class="sum-data">
                        <h4>오늘 거래량</h4>
                        <h2>1,429건</h2>
                        <div class="sum-delta delta-dn">−3.2% 어제比</div>
                    </div>
                </div>

                <div class="card summary-card">
                    <div class="sum-icon i-amber"><i class="ri-customer-service-2-line"></i></div>
                    <div class="sum-data">
                        <h4>문의 대기</h4>
                        <h2>05건</h2>
                        <div class="sum-delta"><i class="ri-time-line"></i> 평균 2.3시간</div>
                    </div>
                </div>

                <%-- ── 차트 ── --%>
                <div class="card chart-section">
                    <div class="card-hd">
                        <div>
                            <div class="card-tl">매출 트렌드</div>
                            <div class="card-sub">최근 7일 거래 현황</div>
                        </div>
                        <div style="display:flex; align-items:center; gap:16px;">
                            <div class="tab-btns" id="chartTabs">
                                <button class="tab-btn active">주간</button>
                                <button class="tab-btn">월간</button>
                                <button class="tab-btn">연간</button>
                            </div>
                            <i class="ri-more-fill card-opt"></i>
                        </div>
                    </div>
                    <div style="flex:1; width:100%; min-height:0;">
                        <canvas id="bigChart"></canvas>
                    </div>
                </div>

                <%-- ── 우측: 실시간 피드 ── --%>
                <div class="side-col">
                    <div class="card feed-card">
                        <div class="card-hd" style="margin-bottom:14px;">
                            <div>
                                <div class="card-tl">실시간 활동</div>
                            </div>
                            <div style="display:flex;align-items:center;gap:6px;font-size:12px;font-weight:700;color:#34C759;">
                                <div class="live-dot"></div> LIVE
                            </div>
                        </div>
                        <div class="activity-list">
                            <div class="act-item">
                                <div class="act-icon i-blue"><i class="ri-user-add-line"></i></div>
                                <div class="act-body">
                                    <div class="act-txt"><span class="hl">김바톤</span>님 회원가입</div>
                                    <div class="act-time">방금 전</div>
                                </div>
                            </div>
                            <div class="act-item">
                                <div class="act-icon i-green"><i class="ri-swap-line"></i></div>
                                <div class="act-body">
                                    <div class="act-txt"><span class="hl">아이폰 15 Pro</span> 거래 완료</div>
                                    <div class="act-time">3분 전</div>
                                </div>
                            </div>
                            <div class="act-item">
                                <div class="act-icon i-blue"><i class="ri-error-warning-line"></i></div>
                                <div class="act-body">
                                    <div class="act-txt">커뮤니티 <span >신고</span> 접수</div>
                                    <div class="act-time">7분 전</div>
                                </div>
                            </div>
                            <div class="act-item">
                                <div class="act-icon i-blue"><i class="ri-refund-2-line"></i></div>
                                <div class="act-body">
                                    <div class="act-txt">결제 취소 — 박애플</div>
                                    <div class="act-time">12분 전</div>
                                </div>
                            </div>
                            <div class="act-item">
                                <div class="act-icon i-violet"><i class="ri-question-answer-line"></i></div>
                                <div class="act-body">
                                    <div class="act-txt">1:1 <span class="hl">문의</span> 새 메시지</div>
                                    <div class="act-time">18분 전</div>
                                </div>
                            </div>
                            <div class="act-item">
                                <div class="act-icon i-green"><i class="ri-briefcase-line"></i></div>
                                <div class="act-body">
                                    <div class="act-txt">알바 공고 <span class="hl">3건</span> 신규 등록</div>
                                    <div class="act-time">24분 전</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- ── 테이블 ── --%>
                <div class="card table-section">
                    <div class="card-hd">
                        <div>
                            <div class="card-tl">최근 거래 내역</div>
                            <div class="card-sub">실시간 업데이트</div>
                        </div>
                        <button style="font-weight:700;color:var(--accent-start);font-size:14px;display:flex;align-items:center;gap:4px;">
                            전체보기 <i class="ri-arrow-right-line"></i>
                        </button>
                    </div>
                    <div class="filter-row">
                        <button class="filter-pill active" onclick="setFilter(this)">전체</button>
                        <button class="filter-pill" onclick="setFilter(this)">거래중</button>
                        <button class="filter-pill" onclick="setFilter(this)">완료</button>
                        <button class="filter-pill" onclick="setFilter(this)">취소</button>
                        <span class="filter-count">총 1,429건</span>
                    </div>
                    <table class="fancy-table">
                        <thead>
                            <tr>
                                <th>상품 정보</th>
                                <th>판매자</th>
                                <th>구매자</th>
                                <th>거래 금액</th>
                                <th>상태</th>
                                <th>일시</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><div class="item-flex"><div class="item-img"><i class="ri-smartphone-line"></i></div><span>아이폰 15 Pro Max Titanium</span></div></td>
                                <td>김바톤</td><td>이사용</td>
                                <td class="td-mono">1,450,000원</td>
                                <td><span class="status-pill pill-blue">배송중</span></td>
                                <td class="td-muted">03-12 14:32</td>
                            </tr>
                            <tr>
                                <td><div class="item-flex"><div class="item-img"><i class="ri-macbook-line"></i></div><span>맥북 에어 M2 미개봉</span></div></td>
                                <td>박애플</td><td>최맥북</td>
                                <td class="td-mono">1,200,000원</td>
                                <td><span class="status-pill pill-green">거래완료</span></td>
                                <td class="td-muted">03-12 13:10</td>
                            </tr>
                            <tr>
                                <td><div class="item-flex"><div class="item-img"><i class="ri-gamepad-line"></i></div><span>닌텐도 스위치 OLED</span></div></td>
                                <td>최게임</td><td>정닌텐도</td>
                                <td class="td-mono">320,000원</td>
                                <td><span class="status-pill pill-red">취소됨</span></td>
                                <td class="td-muted">03-12 11:55</td>
                            </tr>
                            <tr>
                                <td><div class="item-flex"><div class="item-img"><i class="ri-bike-line"></i></div><span>삼천리 자전거 21단</span></div></td>
                                <td>한자전</td><td>오라이더</td>
                                <td class="td-mono">85,000원</td>
                                <td><span class="status-pill pill-amber">확인중</span></td>
                                <td class="td-muted">03-12 10:44</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

            </div><%-- /grid-master --%>
        </div><%-- /content-scroll --%>
    </div><%-- /main-body --%>
</div><%-- /layout-container --%>

<script>
    function setFilter(btn) {
        btn.closest('.filter-row').querySelectorAll('.filter-pill').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
    }

    document.addEventListener('DOMContentLoaded', () => {
        /* 차트 탭 */
        document.querySelectorAll('#chartTabs .tab-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                document.querySelectorAll('#chartTabs .tab-btn').forEach(b => b.classList.remove('active'));
                this.classList.add('active');
            });
        });

        /* Chart.js */
        const ctx = document.getElementById('bigChart');
        if (!ctx) return;

        const grd = ctx.getContext('2d').createLinearGradient(0, 0, 0, 320);
        grd.addColorStop(0, 'rgba(49, 130, 246, 0.18)');
        grd.addColorStop(1, 'rgba(49, 130, 246, 0)');

        window.mainChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                datasets: [{
                    label: '매출',
                    data: [2100, 3200, 2800, 4500, 3900, 5800, 6500],
                    borderColor: '#3182F6',
                    borderWidth: 2.5,
                    backgroundColor: grd,
                    fill: true,
                    pointBackgroundColor: '#fff',
                    pointBorderColor: '#3182F6',
                    pointBorderWidth: 2,
                    pointRadius: 5,
                    pointHoverRadius: 8,
                    tension: 0.42
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        backgroundColor: '#fff',
                        borderColor: '#E5E8EB',
                        borderWidth: 1,
                        titleColor: '#8B95A1',
                        bodyColor: '#191F28',
                        bodyFont: { weight: '700', size: 14, family: 'Pretendard' },
                        padding: 14,
                        cornerRadius: 14,
                        callbacks: {
                            label: ctx => ' ₩' + (ctx.raw * 1000).toLocaleString()
                        }
                    }
                },
                scales: {
                    x: {
                        grid: { display: false },
                        border: { display: false },
                        ticks: { color: '#8B95A1', font: { family: 'Pretendard', size: 12, weight: '600' } }
                    },
                    y: {
                        grid: { color: '#F2F4F6', borderDash: [4, 4] },
                        border: { display: false },
                        ticks: {
                            color: '#8B95A1',
                            font: { family: 'Pretendard', size: 11 },
                            callback: v => '₩' + (v / 1000) + 'K'
                        }
                    }
                }
            }
        });
    });
</script>

</body>
</html>
