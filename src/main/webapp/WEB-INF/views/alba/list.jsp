<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ include file="/WEB-INF/views/layout/headerResources.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>동네 알바 | BATON PASS</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/alba-list.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<main class="trade-main-container">
    <section class="trade-hero-section">
        <div class="container hero-inner">
            <div class="hero-text-box">
                <span class="sub-title">BATON ALBA</span>
                <h1 class="main-title">우리 동네 <span class="highlight">알바</span></h1>
                <p class="desc">가까운 동네에서 나에게 딱 맞는 일자리를 찾아보세요.</p>
            </div>
            <div class="hero-search-box">
                <input type="text" id="searchInput" placeholder="어떤 알바를 찾으시나요? 업체명 또는 제목 검색" onkeypress="if(event.keyCode==13) applyFilters();">
                <button class="search-btn" onclick="applyFilters()">검색</button>
            </div>
        </div>
    </section>

    <div class="content-wrapper">
        <div class="trade-toolbar">
            <div class="toolbar-top">
                <div class="filter-group" id="categoryFilters">
                    <button class="filter-btn active" data-cat="전체">전체</button>
                    <button class="filter-btn" data-cat="SERVING">서빙</button>
                    <button class="filter-btn" data-cat="KITCHEN">주방보조</button>
                    <button class="filter-btn" data-cat="SHOP">매장관리</button>
                    <button class="filter-btn" data-cat="BEVERAGE">음료제조</button>
                    <button class="filter-btn" data-cat="CLEANING">청소</button>
                    <button class="filter-btn" data-cat="ETC">기타</button>
                </div>
                <button class="btn-create-trade" onclick="location.href='${pageContext.request.contextPath}/alba/write'">
                    <i class="ri-pencil-line"></i> 공고 등록하기
                </button>
            </div>

            <div class="toolbar-bottom">
                <div class="price-select-group">
                    <select class="detail-select" id="periodSelect" onchange="applyFilters()">
                        <option value="전체">근무 기간: 전체</option>
                        <option value="1개월 이상">1개월 이상</option>
                        <option value="단기">단기</option>
                    </select>
                    <select class="detail-select" id="paySelect" onchange="applyFilters()">
                        <option value="무관">시급: 무관</option>
                        <option value="1만원+">1만원 이상</option>
                        <option value="1.2만원+">1.2만원 이상</option>
                        <option value="1.5만원+">1.5만원 이상</option>
                    </select>
                    <button class="tl-reset-btn" onclick="clearFilters()"><i class="ri-refresh-line"></i> 초기화</button>
                </div>

                <div class="action-group">
                    <div style="font-size: 14px; font-weight: 600; color: var(--text-main);">
                        총 <span id="resultCount" style="color: var(--primary);">0</span>건
                    </div>
                    <span class="divider">|</span>
                    <select class="detail-select sort-select" id="sortSelect" onchange="applyFilters()">
                        <option value="latest">최신순</option>
                        <option value="pay_high">시급 높은순</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="trade-grid" id="albaGrid"></div>

        <div class="pagination-container" id="pagination"></div>
    </div>
    
    <button class="tl-fab" onclick="location.href='${pageContext.request.contextPath}/alba/write'">
        <i class="ri-pencil-line"></i>
    </button>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
    const CONTEXT_PATH = "${pageContext.request.contextPath}";
    const serverData = [
        <c:forEach var="dto" items="${list}" varStatus="status">
        {
            id: "${dto.postingIdx}",
            title: "${dto.title}",
            employer: "${dto.employer != null ? dto.employer : '업체명'}",
            payType: "${dto.payType}",
            payTypeKey: "${dto.payType == '시급' ? 'hour' : 'month'}",
            payNum: ${dto.pay != null ? dto.pay : 0},
            payFmt: "<fmt:formatNumber value='${dto.pay}' pattern='#,###'/>",
            days: "${dto.workDays}",
            time: "${dto.workTime != null ? dto.workTime : '시간협의'}",
            area: "${dto.location}",
            date: "${dto.createdDate}", 
            img: "${dto.thumbUrl != null ? dto.thumbUrl : ''}"
        }${!status.last ? ',' : ''}
        </c:forEach>
    ];
    var DUMMY_JOBS = serverData;
</script>
<script src="${pageContext.request.contextPath}/dist/js/alba-list.js"></script>
</body>
</html>