<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>BATON Admin Pro</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin/admin_main.css">
    
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="${pageContext.request.contextPath}/dist/js/admin/admin_main.js" defer></script>
</head>
<body>

<div class="layout-container">
    <jsp:include page="/WEB-INF/views/admin/layout/left.jsp"/>

    <div class="main-body">
        <jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>

        <div class="content-scroll">
            <div class="grid-master">
                
                <div class="card summary-card">
                    <div class="sum-icon i-violet"><i class="ri-user-heart-line"></i></div>
                    <div class="sum-data">
                        <h4>전체 회원수</h4>
                        <h2>24,812</h2>
                    </div>
                </div>
                <div class="card summary-card">
                    <div class="sum-icon i-blue"><i class="ri-wallet-3-line"></i></div>
                    <div class="sum-data">
                        <h4>이번달 매출</h4>
                        <h2>₩48.2M</h2>
                    </div>
                </div>
                <div class="card summary-card">
                    <div class="sum-icon i-green"><i class="ri-shopping-bag-3-line"></i></div>
                    <div class="sum-data">
                        <h4>오늘 거래량</h4>
                        <h2>1,429건</h2>
                    </div>
                </div>
                <div class="card summary-card">
                    <div class="sum-icon i-orange"><i class="ri-customer-service-2-line"></i></div>
                    <div class="sum-data">
                        <h4>문의 대기</h4>
                        <h2 style="color:#FF3B30;">05건</h2>
                    </div>
                </div>

                <div class="card chart-section">
                    <div class="card-hd">
                        <span class="card-tl">주간 매출 트렌드</span>
                        <i class="ri-more-fill card-opt" style="font-size:24px;"></i>
                    </div>
                    <div style="flex:1; width:100%;">
                        <canvas id="bigChart"></canvas>
                    </div>
                </div>

                <div class="side-widgets">
                    <div class="card widget-card">
                        <div class="card-hd">
                            <span class="card-tl" id="calMonth" style="font-size:18px;"></span>
                            <i class="ri-calendar-line card-opt"></i>
                        </div>
                        <div id="calGrid" class="cal-grid"></div>
                    </div>
                    
                    <div class="card widget-card">
                        <div class="memo-header">
                            <span class="card-tl" style="font-size:18px;">메모장</span>
                        </div>
                        <textarea id="colorMemo" class="memo-area" placeholder="메모를 입력해주세요"></textarea>
                    </div>
                </div>

                <div class="card table-section">
                    <div class="card-hd">
                        <span class="card-tl">최근 실시간 거래</span>
                        <button style="color:var(--accent-start); font-weight:700;">전체보기</button>
                    </div>
                    <table class="fancy-table">
                        <thead>
                            <tr>
                                <th>상품 정보</th>
                                <th>판매자</th>
                                <th>거래 금액</th>
                                <th>상태</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <div class="item-flex">
                                        <div class="item-img"><i class="ri-smartphone-line"></i></div>
                                        <span>아이폰 15 Pro Max Titanium</span>
                                    </div>
                                </td>
                                <td>김바톤</td>
                                <td>1,450,000원</td>
                                <td><span class="status-pill" style="background:#E6F7FF; color:#009DFF;">배송중</span></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="item-flex">
                                        <div class="item-img"><i class="ri-macbook-line"></i></div>
                                        <span>맥북 에어 M2 미개봉</span>
                                    </div>
                                </td>
                                <td>박애플</td>
                                <td>1,200,000원</td>
                                <td><span class="status-pill" style="background:#E6FFFA; color:#00C9A7;">거래완료</span></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="item-flex">
                                        <div class="item-img"><i class="ri-gamepad-line"></i></div>
                                        <span>닌텐도 스위치 OLED</span>
                                    </div>
                                </td>
                                <td>최게임</td>
                                <td>320,000원</td>
                                <td><span class="status-pill" style="background:#FFF5F5; color:#FF3B30;">취소됨</span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>

            </div>
        </div>
    </div>
</div>

</body>
</html>